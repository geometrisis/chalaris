{******************************************************************************
*                        Make Screen                   *
*                  WRITTEN BY G.XALARIS                       *
*                              30-01-1987                                     *
*******************************************************************************}
{$C-,I-,V-.K-}
Program Make_Screen(Input,Output);

Label start_again;

Type string255=string[255];
     rec = ^rec1;
    rec1 = record
             xx : array[0..1839] of integer;
            end;
     aro = array[0..1839] of integer;
Var ch,ch1      : char;
    cc          : string[2];
    fil,tofil   : file of rec1;
    src         : rec;
    ofs1,i,m1x,
    m2x,m1y,m2y,
    oldi        : integer;
    fil1        : file of aro;
    help1,help3,
    help2,help4 : aro;
    filnam      : string[20];
    filename    : string[40];
    file_loaded : boolean;
    scra        : rec1;

Procedure System(CmdLine : string255; var ErrorCode : Integer);
  Const
    EnvironmentPtr : array[1..2] of integer = (0,0);
  Type
    IdentStr = string[8];
    Path     = string[67];
    BytePtr  = ^byte;
    RegPack = record
               Ax    : integer;
               Bx    : integer;
               Cx    : integer;
               Dx    : integer;
               Bp    : integer;
               Si    : integer;
               Di    : integer;
               Ds    : integer;
               Es    : integer;
               Flags : integer;
             end;
    FcbBlk  = record
                Drive     : char;
                FileName  : array[1..8] of char;
                FileExt   : array[1..3] of char;
                CurBlock  : integer;
                RecSize   : integer;
                SizeLo    : integer;
                SizeHi    : integer;
                Creation  : integer;
                Reserved  : array[1..10] of byte;
                CurRecNo  : byte;
                RelSizeLo : integer;
                RelSizeHi : integer
              end;

     ParmBlk = record
                SegAds    : integer;
                CmdPtr    : BytePtr;
                Fcb1Ptr   : BytePtr;
                Fcb2Ptr   : BytePtr
              end;
  Var
      DosReg   : RegPack;
      EnvPtr   : BytePtr absolute EnvironmentPtr;
      EnvSize  : integer;
      BlockValue : ParmBlk;
      Fcb1,Fcb2  : FcbBlk;
      TempPtr    : BytePtr;
      EnvPtr1    : BytePtr;
      NewEnvPtr  : BytePtr;
      CmdLineZ   : String255;
      CmdLen     : integer;
      PSPSeg     : integer;
      PathZ      : Path;
      PathLen    : integer;
      ComSpec    : Path;
      ExecCmd    : String255;

  Begin

     DosReg.AX:=$1900;
     MsDos(DosReg);
     ComSpec := chr(Lo(DosReg.AX)+65)+':\COMMAND.COM';

     ExecCmd := ' /C '+ CmdLine + #13;
     DosReg.Ax := $3000;
     MSDOS(DosReg);
     if Swap(DosReg.Ax) < $0300 then
        TempPtr := Ptr(Cseg,0)
     else
        with DosReg do begin
           Ax := $6200;
           MSDOS(DosReg);
           TempPtr := Ptr(Bx,0)
        end;
     PSPSeg := Seg(TempPtr^);
     EnvPtr1 := NIL;
     if (EnvPtr = NIL) then
        BlockValue.SegAds := MemW[PSPSeg:$2C]
     else if (Ofs(EnvPtr1^) = 0) then
        BlockValue.SegAds := Seg(EnvPtr1^)
     else begin
        GetMem(EnvPtr1,EnvSize + 15);
        if (Ofs(EnvPtr1^) <> 0) then
           NewEnvPtr := Ptr(Seg(EnvPtr1^) + 1,0)
        else
           NewEnvPtr := EnvPtr1;
        Move(EnvPtr^,NewEnvPtr^,EnvSize);
        BlockValue.SegAds := Seg(NewEnvPtr^)
     end;

     BlockValue.CmdPtr := Addr(ExecCmd);

     CmdLen := Length(ExecCmd);
     Move(ExecCmd[1],CmdLineZ,CmdLen);
     CmdLineZ[CmdLen] := #0;
     with DosReg do begin
        Ax := $2901;
        Ds := Seg(CmdLineZ);
        Si := Ofs(CmdLineZ);
        Es := Seg(Fcb1);
        Di := Ofs(Fcb1);
        MSDOS(DosReg);
        Ax := $2901;
        Es := Seg(Fcb2);
        Di := Ofs(Fcb2);
        MSDOS(DosReg);
        BlockValue.Fcb1Ptr := Addr(Fcb1);
        BlockValue.Fcb2Ptr := Addr(Fcb2)
     end;

     with DosReg do begin
        Ax := $4B00;
        Es := Seg(BlockValue);
        Bx := Ofs(BlockValue);
        PathLen := Length(ComSpec);
        Move(ComSpec[1],PathZ,PathLen);
        PathZ[PathLen] := #0;
        Ds := Seg(PathZ);
        Dx := Ofs(PathZ);
        Inline($16/$54);
        MSDOS(DosReg);
        Inline($5C/$17);
        if ((Flags and 1) <> 0) then
           ErrorCode := Ax
        else
           ErrorCode := 0
     end;
     if (EnvPtr1 <> NIL) then
        FreeMem(EnvPtr1,EnvSize + 15)
  end;
Procedure Dos;
var i:Integer;
    command:string255;
    scra : array[1..4000] of byte;
procedure upstring(var s:string255);
var
  i:integer;
begin
   for i:=1 to length(s) do
      s[i]:=upcase(s[i]);
end;
begin
   move(memw[$B000:Ofs1],scra,4000);
   lowvideo;
   window(1,1,80,25);
   clrscr;
   Writeln('Ender your commands. EXIT to return.');
   repeat
      write(': ');   readln(command);
      upstring(command);
      if command='EXIT' then begin
         move(scra,memw[$b000:ofs1],4000);
         highvideo;  window(1,1,80,23);
         exit;
      end;
      system(command,i);
   until false;
end;

Procedure Prt_Scr(Lines:byte);
var i,j:byte;
    ch:char;
  function rdscr(y,x:byte):char;
  var j:integer;
  begin
      j:=((y-1)*160)+((x-1)*2);
      rdscr:=chr(mem[$B000:ofs1+j]);
  end;
begin
    for i:=1 to lines do
    begin
        for j:=1 to 80 do
        begin
            ch:=rdscr(i,j);
            if ch in [#32..#126,#128..#255] then
                write(lst,ch)
            else
                write(lst,' ');
        end;
        writeln(lst);
    end;
    writeln(lst,#10#10);
end;

Procedure Cursor(On,Typ : Boolean);
Type Registers = Record
                     AX,BX,CX,DX,BP,SI,DI,DS,ES,Flags : integer;
                 End;
Var ColorDisplay : Boolean;
    RegPack      : Registers;

Begin
     If Mem[0:1040] And 48 = 48 Then     { Check Display Adaptor }
          ColorDisplay := True
     Else ColorDisplay := True;

     With RegPack do
     Begin
          AX := $0100;                   { Set Cursor Type }
          If On Then
               If ColorDisplay Then
                  if Typ Then
                    CX:=$0407
                  else
                    CX := $0607          { Cursor On for Color Display }
               Else
                  if Typ Then
                    CX:=$070C
                  else
                    CX := $0B0C          { Cursor On for Monochrome Display }
          Else
               CX := $2000;              { Disappear Cursor }
     End;

     Intr($10,RegPack);                  { Call Video Interrupt 10H }

End;

Function repstr(n:integer;s:byte):string255;
var hlp:string255;
begin
     hlp[0]:=chr(n);
     fillchar(hlp[1],n,s);
     repstr:=hlp;
End;

procedure wrt(x,y,k : integer; st : string255);
var i,j : integer;
begin
    j:=((y-1)*160)+((x-1)*2);
    if k > 0  then
    for i:=1 to length(st)  do
    begin
        mem[$B000:ofs1+j]:=ord(st[i]);
        j:=j+2;
        mem[$B000:ofs1+j-1]:=k;
    end
    else
    for i:=1 to ord(st)  do
    begin
        j:=j+2;   mem[$B000:ofs1+j-1]:=abs(k);
    end;
end;

procedure beep(hz,dl : integer);
begin
    sound(hz);
    delay(dl);
    nosound;
end;

procedure box(x1,y1,x2,y2 : byte);
Var   i : byte;
begin
    wrt(x1,y1,15,#218+repstr(x2-x1-1,196)+#191);
    for i:=y1+1 to y2-1 do
    begin
        wrt(x1,i,15,#179);
        wrt(x2,i,15,#179);
    end;
    wrt(x1,y2,15,#192+repstr(x2-x1-1,196)+#217);
end;

procedure box2(x1,y1,x2,y2 : byte);
Var   i : byte;
begin
    wrt(x1,y1,15,#201+repstr(x2-x1-1,205)+#187);
    for i:=y1+1 to y2-1 do
    begin
        wrt(x1,i,15,#186);
        wrt(x2,i,15,#186);
    end;
    wrt(x1,y2,15,#200+repstr(x2-x1-1,205)+#188);
end;

procedure box3(x1,y1,x2,y2 : byte);
Var i : byte;
begin
    wrt(x1+1,y1,15,repstr(x2-x1-1,223));
    for i:=y1 to y2 do
    begin
        wrt(x1,i,15,#219);
        wrt(x2,i,15,#219);
    end;
    wrt(x1+1,y2,15,repstr(x2-x1-1,220));
end;

procedure putin(cn : integer);
begin
    seek(fil,cn-1);
    write(fil,src^);
end;

procedure putout;
begin
    reset(fil);
    if IOresult <> 0  then
    begin
        wrt(20,24,112,'New File.');
        rewrite(fil);
    end
    else
    begin
        seek(fil,0);
        read(fil,src^);
        move(src^.xx[0],memW[$B000:ofs1],3680);
        cc:=' 1';
        wrt(45,24,112,cc);
    End;
end;

procedure edit;
label a1,a2,l1,w;
var  x,y,cd,j,i1,cl : integer;
        ch,ans,ans1 : char;
     ins,del,lr,srl : boolean;
     PgUpDn_flg     : boolean;

procedure check_save;
var ch:char;
begin
     move(memW[$B000:ofs1],scra,3680);
     move(help3,memW[$B000:ofs1],3680);
     cursor(false,true);
     read(kbd,ch);
     if ch in ['y','Y','¬','“'] then
     begin
          with src^ do
               move(scra,xx[0],3680);
          putin(i);
     end;
     if (ch=#27) and keypressed then
         read(kbd,ch);
     if ins then
         cursor(true,true)
     else
         cursor(true,false);
end;

Procedure savetofile;
var recno : integer;
Begin
   move(memw[$B000:ofs1],scra,3680);
   move(help4,memw[$B000:ofs1],3680);
   gotoxy(28,9);    readln(filename);
   Assign(tofil,filename);
   reset(tofil);
   if ioresult=0 then begin
       gotoxy(28,10);    readln(recno);
       if recno=0 then
           seek(tofil,filesize(tofil))
       else
           seek(tofil,recno-1);
       write(tofil,scra);
   end
   else begin
       gotoxy(27,12);    write('New File.');
       rewrite(tofil);
       write(tofil,scra);
   end;
   close(tofil);
   move(scra,memw[$B000:ofs1],3680);
end;

function fend : integer;
var i,j : integer;
begin
     fend:=x;
     for i:=x to 79  do
     begin
         j:=((y-1)*160)+((i-1)*2);
         if (mem[$B000:ofs1+j]<>0) and (mem[$B000:ofs1+j]<>32)  then
             fend:=i;
     end;
end;

procedure copyw(x1,y1,x2,y2 : byte);
var i,j1,j2 : integer;
begin
    if (y+y2-y1 > 23) or (x+x2-x1 > 80)  then
    begin
        beep(450,150);
        exit;
    end;
        for i:=y1 to y2  do
        begin
            j1:=((i-1)*160)+((x1-1)*2);
            j2:=((y-1)*160)+((x-1)*2);
            move(memW[$B000:ofs1+j1],memW[$B000:ofs1+j2],2*(x2-x1+1));
            y:=y+1;
            if y=24  then
                y:=23;
        end;
end;

procedure delete_block(x1,y1,x2,y2 : byte);
var i,j : integer;
begin
    for i:=y1 to y2 do
    begin
        j:=((i-1)*160)+((x1-1)*2);
        fillchar(MemW[$B000:ofs1+j],2*(x2-x1+1),32);
    end;
end;

procedure copyd(x1,y1,x2,y2 : byte);
var i,j : integer;
     mv : array[1..25,1..80] of integer;
begin
    if (y+y2-y1 > 23) or (x+x2-x1 > 80)  then
    begin
        beep(450,150);
        exit;
    end;
    m1x:=x;
    m1y:=y;
    m2x:=x+(x2-x1);
    m2y:=y+(y2-y1);
    for i:=y1 to y2  do
    begin
        j:=((i-1)*160)+((x1-1)*2);
        move(memW[$B000:ofs1+j],mv[i-y1+1,1],2*(x2-x1+1));
{        FillChar(memW[$B000:ofs1+j],2*(x2-x1+1),32);
}
        wrt(x1,i,15,repstr(x2-x1+1,32));
    end;
    for i:=y1 to y2  do
    begin
        j:=((y-1)*160)+((x-1)*2);
        move(mv[i-y1+1,1],memW[$B000:ofs1+j],2*(x2-x1+1));
        y:=y+1;
    end;
    if y=24 then
        y:=23;
end;

procedure inst(var srl : boolean);
label t;
var  j : integer;
begin
    srl:=false;
    if ch=#13  then
    begin
        x:=1;
        y:=succ(y);
        If y>23 then y:=1;
        srl:=true;
        exit;
    end;
    if ins  then
    begin
        j:=((y-1)*160)+((x-1)*2);
        move(memW[$B000:ofs1+j],memW[$B000:ofs1+j+2],2*(fend-x+1));
    end;
    wrt(x,y,15,ch);
end;

procedure delt;
var  j : integer;
begin
        j:=((y-1)*160)+(2*x);
        move(memW[$B000:ofs1+j],memW[$B000:ofs1+j-2],2*(80-x));
        wrt(80,y,15,#32);
end;

procedure curs;
var s1,s2 : string[2];
begin
    str(x:2,s1);
    str(y:2,s2);
    wrt(11,24,112,s1+'-'+s2);
end;

begin
    clrscr;
    gotoxy(1,1);
    x:=1;
    y:=1;
    ins:=false;
    lr:=true;
    crtinit;
    srl:=false;
    wrt(1,24,-112,#80);
    wrt(2,24,112,'CURSOR :');
    curs;
    wrt(17,24,112,#179);
    wrt(35,24,112,#179);
    wrt(67,24,112,#179);
    wrt(37,24,112,'File : [  ]-'+ParamStr(1));
    wrt(1,25,7,#221);
    wrt(80,25,7,#222);
    wrt(67,25,7,#179);
    wrt(69,25,15,'(c) MEMORY ');
    wrt(17,25,7,#179);
    wrt(3,25,15,'F1 - FOR HELP');
    i:=0;
    window(1,1,80,23);
    m1x:=0;
    m2x:=0;
    m1y:=0;       
    m2y:=0;
    PgUpDn_flg:=false;
l1: read(kbd,ch);
    if (ch=#27) and KeyPressed  then
    begin
        read(kbd,ch);
        {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
        case ch of
              #72,#80,#75,#77,#71,#79,#61,#15 :
              begin
                  case ch of
                     {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
                     #72 : begin
                               y:=y-1;               { UArrow }
                               if y=0 then
                                   y:=23;
                           end;
                     {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
                     #80 : begin
                               y:=y+1;               { DArrow }
                               if y=24 then
                               y:=1;
                           end;
                     {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
                     #75 : begin
                               x:=x-1;               { LArrow }
                               if x=0 then
                               x:=80;
                           end;
                     {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
                     #77 : begin
                               x:=x+1;               { RArrow }
                               if x=81 then
                               x:=1;
                           end;
                     {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
                     #71 : y:=1;                     { Home }
                     {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
                     #79 : y:=23;                    { End  }
                     {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
                     #61 : if lr  then
                           begin
                               x:=1;
                               lr:=false;
                           end
                           else                      { F3 }
                           begin
                               x:=fend+1;
                               lr:=true;
                           end;
                     {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
                     #15 : begin                        { Shift Tab }
                               x:=x-5;
                               if x<1 then
                               x:=80;
                           end;
                  end;
                  gotoxy(x,y);
                  curs;
                  goto l1;
              end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #65 : begin                        { F7: 'Ä' }
                        ch:=#196;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #66 : begin                        { F8: '³' }
                        ch:=#179;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #16 : begin                        { Alt Q: 'Ú' }
                        ch:=#218;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #17 : begin                        { Alt W: 'Â' }
                        ch:=#194;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #18 : begin                        { Alt E: '¿' }
                        ch:=#191;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #30 : begin                        { Alt A: 'Ã' }
                        ch:=#195;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #31 : begin                        { Alt S: 'Å' }
                        ch:=#197;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #32 : begin                        { Alt D: '´' }
                        ch:=#180;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #44 : begin                        { Alt Z: 'À' }
                        ch:=#192;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #45 : begin                        { Alt X: 'Á' }
                        ch:=#193;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #46 : begin                        { Alt C: 'Ù' }
                        ch:=#217;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #19 : begin                        { Alt R: 'É' }
                        ch:=#201;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #20 : begin                        { Alt T: 'Ë' }
                        ch:=#203;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #21 : begin                        { Alt Y: '»' }
                        ch:=#187;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #33 : begin                        { Alt F: 'Ì' }
                        ch:=#204;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #34 : begin                        { Alt G: 'Î' }
                        ch:=#206;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #35 : begin                        { Alt H: '¹' }
                        ch:=#185;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #47 : begin                        { Alt V: 'È' }
                        ch:=#200;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #48 : begin                        { Alt B: 'Ê' }
                        ch:=#202;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #49 : begin                        { Alt N: '¼' }
                        ch:=#188;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #90 : begin                        { Shift F7: 'Í' }
                        ch:=#205;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #91 : begin                        { Shift F8: 'º' }
                        ch:=#186;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #120 : begin                        { Alt 1 : 'Õ' }
                        ch:=#213;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #121 : begin                        { Alt 2 : 'Ñ' }
                        ch:=#209;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #122 : begin                        { Alt 3 : '¸' }
                        ch:=#184;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #123 : begin                        { Alt 4 : 'Æ' }
                        ch:=#198;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #124 : begin                        { Alt 5 : 'Ø' }
                        ch:=#216;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #125 : begin                        { Alt 6 : 'µ' }
                        ch:=#181;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #126 : begin                        { Alt 7 : 'Ô' }
                        ch:=#212;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #127 : begin                        { Alt 8 : 'Ï' }
                        ch:=#207;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #128 : begin                        { Alt 9 : '¾' }
                        ch:=#190;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #129 : begin                        { Alt 0 : 'Ö' }
                        ch:=#214;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #130 : begin                        { Alt - : 'Ò' }
                        ch:=#210;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #131 : begin                        { Alt = : '·' }
                        ch:=#183;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #22 : begin                        { Alt U : 'Ç' }
                        ch:=#199;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #23 : begin                        { Alt I : '×' }
                        ch:=#215;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #24 : begin                        { Alt O : '¶' }
                        ch:=#182;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #36 : begin                        { Alt J : 'Ó' }
                        ch:=#211;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #37 : begin                        { Alt K : 'Ð' }
                        ch:=#208;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #38 : begin                        { Alt L : '½' }
                        ch:=#189;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #87 : begin                        { Shift F4 'ß' }
                        ch:=#223;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #88 : begin                        { Shift F5 'Û' }
                        ch:=#219;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #89 : begin                        { Shift F6 'Ü' }
                        ch:=#220;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #92 : begin                        { Shift F9 'Ý' }
                        ch:=#221;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #93 : begin                        { Shift F10 'Þ' }
                        ch:=#222;
                        goto w;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #63 : begin                        { F5 }
                        m1x:=x;
                        m1y:=y;
                        wrt(45,25,7,repstr(18,0));
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #64 : begin                        { F6 }
                        m2x:=x;
                        m2y:=y;
                        wrt(45,25,7,repstr(18,0));
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #104 : if (m2x-m1x < 1) or (m2y-m1y < 1)  then
                    begin                                   { Alt F1 }
                        beep(300,200);
                        wrt(45,25,31,'Box Argument Error');
                    end
                    else
                        box(m1x,m1y,m2x,m2y);
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #85 : if (m2x-m1x < 1) or (m2y-m1y < 1)  then
                    begin                                   { Shift F2 }
                        beep(300,200);
                        wrt(45,25,31,'Box Argument Error');
                    end
                    else
                        box2(m1x,m1y,m2x,m2y);
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
              #86 : if (m2x-m1x < 1) or (m2y-m1y < 1)  then
                    begin                                   { Shift F3 }
                        beep(300,200);
                        wrt(45,25,31,'Box Argument Error');
                    end
                    else
                        box3(m1x,m1y,m2x,m2y);
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #108 : copyd(m1x,m1y,m2x,m2y);      { Alt F5 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #109 : copyw(m1x,m1y,m2x,m2y);      { Alt F6 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #62  : begin
                        oldi:=i;
                        window(1,1,80,25);
                        i:=1;
                        gotoxy(49,24);
                        while i<19  do
                        begin                    { F4 }
                            read(kbd,filnam[i]);
                            if filnam[i]=#27 then
                                goto a2;
                            if filnam[i]=#13 then
                                goto a1;
                            if filnam[i]=#8 then
                            begin
                                if i=1 then
                                    goto a2;
                                i:=i-1;
                                filnam[i]:=#0;
                            end;
                            wrt(48+i,24,112,filnam[i]);
                            filnam[0]:=chr(i);
                            if filnam[i]=#0 then
                                gotoxy(48+i,24)
                            else
                            begin
                                gotoxy(49+i,24);
                                i:=i+1;
                            end;
                        end;
                        i:=oldi;
                a1:     wrt(wherex,24,112,repstr(67-wherex,32));
                        close(fil);

                        if IOresult=0 then;

                        i:=1;
                        Assign(fil,filnam);
                        putout;
                        file_loaded:=true;
                a2:     window(1,1,80,23);
                        gotoxy(1,1);
                        goto l1;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #105 : begin
                        if not file_loaded then
                        begin
                            write(^G);
                            goto l1;     { Alt F2 }
                        end;
                        wrt(20,24,112,'Save to :     ');
                        window(1,1,80,24);
                        gotoxy(30,24);
                        window(1,1,80,23);
                        read(kbd,ch);
                        if ch=#27  then
                        begin
                            wrt(20,24,112,'             ');
                            if KeyPressed then
                                Read(kbd,ch);
                            gotoxy(x,y);
                            goto l1;
                        end
                        else
                        begin
                            read(kbd,ch1);
                            cc:=ch+ch1;
                            val(cc,i,cd);
                            wrt(30,24,112,cc);
                            if (i>0) then
                            begin
                                PgUpDn_flg := false;
                                seek(fil,i-1);
                                with src^ do
                                    move(memW[$B000:ofs1],xx[0],3680);
                                putin(i);
                            end
                            else
                                write(^G);
                        end;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #95  : SaveToFile;           { Ctrl F2 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #60  : begin
                        if not file_loaded then
                        begin
                            write(^G);
                            goto l1;       { F2 }
                        end;
                        wrt(20,24,112,'Load from : ');
                        window(1,1,80,25);
                        gotoxy(32,24);
                        window(1,1,80,23);
                        read(kbd,ch);
                        if ch=#27 then
                        begin
                            wrt(20,24,112,'             ');
                            if KeyPressed then
                                read(kbd,ch);
                            gotoxy(x,y);
                            goto l1;
                        end
                        else
                        begin
                            read(kbd,ch1);
                            cc:=ch+ch1;
                            val(cc,i,cd);
                            wrt(32,24,112,cc);
                            if (i>0) and (i<=filesize(fil)) then
                            begin
                                PgUpDn_flg := false;
                                seek(fil,i-1);
                                read(fil,src^);
                                with src^ do
                                    move(xx[0],memW[$B000:ofs1],3680);
                                wrt(45,24,112,cc);
                            end
                            else
                                write(^G);
                        end;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #81  : begin
                        if PgUpDn_flg then
                            check_save;      { PgDn }
                        PgUpDn_flg := false;
                        i:=i+1;
                        if i>filesize(fil) then
                            i:=1;
                        with src^ do
                        begin
                            seek(fil,i-1); read(fil,src^);
                            move(xx[0],memW[$B000:ofs1],3680);
                        end;
                        str(i:2,cc);
                        wrt(45,24,112,cc);
                        goto l1;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #73  : begin
                        if PgUpDn_flg then
                            check_save;
                        PgUpDn_flg := false;
                        i:=i-1;
                        if i < 1 then
                            i:=filesize(fil);
                        with src^ do
                        begin                                    { PgUp }
                            seek(fil,i-1);
                            read(fil,src^);
                            move(xx[0],memW[$B000:ofs1],3680);
                        end;
                        str(i:2,cc);
                        wrt(45,24,112,cc);
                        goto l1;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #106 : insline;  { Alt F3 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #97  : delline;  { Ctrl F4 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #107 : clreol;   { Alt F4 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #82  : if not ins then
                    begin
                        cursor(true,true);
                        ins:=true;
{                        wrt(69,24,240,'Ins');  }
                    end
                    else                { Ins }
                    begin
                        cursor(true,false);
                        ins:=false;
{                        wrt(69,24,112,'   ');  }
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #59  : begin
                        move(memW[$B000:ofs1],scra,3680);  { F1 }
                        move(help1,memW[$B000:ofs1],3680);
                        read(kbd,ch);
                        if keypressed then
                            read(kbd,ch);
                        move(help2,memW[$B000:ofs1],3680);
                        read(kbd,ch);
                        if keypressed then
                            read(kbd,ch);
                        move(scra,memW[$B000:ofs1],3680);
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #83  : delt;   { Del }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #119 : begin
                        ClrScr;
                        x:=1;
                        y:=1;   { Ctrl Home }
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #110 : begin                                  { Alt F7 }
                        j:=((y-1)*160)+((x-1)*2);
                        FillChar(memW[$B000:ofs1+j],3680-j,32);
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #117 : begin
                        cursor(false,false);
                        beep(3000,50);
                        wrt(19,25,143,'ARE YOU SURE (Y/N) ?');
                        repeat
                            read(kbd,ans);
                            if (ans=#27) and keypressed then read(kbd,ans1);
                        until ans in ['y','Y','n','N'];
                        cursor(true,false);
                        if ans in ['y','Y'] then begin
                            close(fil);
                            Window(1,1,80,25);
                            ClrScr;
                            Halt;                  { Ctrl End }
                        end
                        else begin
                            wrt(19,25,15,repstr(20,32));
                            goto l1;
                        end;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #25  : begin
                        wrt(20,24,112,'Color:       ');
                        window(1,1,80,25);
                        gotoxy(27,24);
                        TextColor(0);
                        TextBackGround(7);
                        read(cl);                         { Alt P }
                        TextColor(7);
                        TextBackGround(0);
                        wrt(20,24,112,'             ');
                        window(1,1,80,23);
                        cl:=-cl;
                        wrt(x,y,cl,chr(81-x));
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #50  : begin
                        prt_scr(23);             { Alt M }
                        goto l1;
                    end;
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #84  : Dos;                     { Shift F1 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #68  : wrt(x,y,-7,chr(81-x));   { F10 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #67  : wrt(x,y,-15,chr(81-x));  { F9 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #112 : wrt(x,y,-0,chr(81-x));   { Alt F9 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #113 : wrt(x,y,-112,chr(81-x)); { Alt F10 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
             #111 : delete_block(m1x,m1y,m2x,m2y);   { Alt F8 }
              {þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
         end;
    end
    else
    begin
        if ch=#8  then                      { Back Space }
        begin
            gotoxy(x-1,y);
            write(#0#8);
            x:=x-1;
            if x=0 then
                x:=1;
        end
        else if ch=#9  then                 { Tab }
        begin
            x:=x+5;
            if x>80 then
                x:=1;
            gotoxy(x,y);
            curs;
            goto l1;
        end
        else
        begin
w:          inst(srl);
            if not srl then
                x:=x+1;
            if x=81 then                    { Something Else }
            begin
                x:=1;
                y:=y+1;
                if y=24 then
                    y:=23;
            end;
        end;
    end;
    PgUpDn_flg := true;
    gotoxy(x,y);
    curs;
    goto l1;
end;


begin
    filename:='c:\turbo\ms.hlp';
    ofs1:=$8000;
    if mem[0:1040] and 48 = 48 then
        ofs1:=$0000;
START_AGAIN:
    Assign(fil1,filename);
    reset(fil1);
    if ioresult<>0 then
    begin
         clrscr;
         gotoxy(1,8);
         textcolor(7);
         write('File: ');
         textcolor(15);
         write(filename);
         textcolor(7);
         write(' not found.');
         textcolor(15);
         gotoxy(1,10);
         write('Please specify a new pathname (# to EXIT) : ');
         readln(filename);
         if filename[1]='#' then
         begin
             clrscr;
             halt(1);
         end
         else
             goto START_AGAIN;
    end;
    read(fil1,help1);
    read(fil1,help2);
    read(fil1,help3);
    read(fil1,help4);
    close(fil1);
    new(src);
    FillChar(src^,SizeOf(src^),0);
    file_loaded:=false;
    if ParamStr(1)<>'' then
    begin
        assign(fil,ParamStr(1));
        putout;
        file_loaded:=true;
    end;
    edit;
    dispose(src);
end.

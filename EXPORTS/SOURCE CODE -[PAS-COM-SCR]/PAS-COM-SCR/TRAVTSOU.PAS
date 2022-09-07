{$C-}
Program  TRAV;
Var __Check1,__Check2,__Check3   : Integer;
    __Check4,__Offset1,__Offset2 : Real;
    __Check7                     : byte;
    __TempResult                 : real;
    __TempMinutes                : byte;
         ExecFile : File;

const    SyntRegSize    = 124;
         MaxDataRecSize = SyntRegSize;
         MaxKeyLen      = 4;
         PageSize       = 16;
         Order          = 8;
         PageStackSize  = 5;
         MaxHeight      = 5;

{******************************************************************************
*                  ÅĞÉËÕÓÇ ÏÄÅÕÓÇÓ ÏĞÏÉÁÓÄÇĞÏÔÅ ÌÏÑÖÇÓ                        *
*                           ÓÕÍÇÈÇÓ ÓÕÍÏÑÈÙÓÇ *
*                  WRITTEN BY G.XALARIS                         *
*                                                                             *
*                       LAST UPDATE AT 28-10-1987                             *
*******************************************************************************}

type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k001=record       { 50 bytes }
           i_o    : integer;
           xa_o,ya_o,xb_o,yb_o,xk_o,yk_o,xl_o,yl_o : real;
         end;
         rec2_k001=record       { 50 bytes }
             kwd_o:string[4];
             b_o  :real;
             s_o  :real;
             dummy:string[32];
         end;

         rec_syntetagmenwn=record        { 124 Bytes }
               status     :integer;
               kwd_syn    :string[4];
               x_syn      :real;
               y_syn      :real;
               h_syn      :real;
               eidos_point:string[3];
               job        :string[20];
               xronol     :string[8];
               who_idrise :string[20];
               axiopistia :string[10];
               comments   :string[32];
         end;

         string40 =string[40];
         string255=string[255];

var      xa,ya,xb,yb,xk,yk,xl,yl : real;
         kwd     :array [1..100] of string[4];
         b       :array [1..100] of real;
         s       :array [1..100] of real;
         a       :array [1..100] of real;
         x       :array [1..100] of real;
         y       :array [1..100] of real;
         ddx     :array [1..100] of real;
         ddy     :array [1..100] of real;

Procedure Halt;
   Begin
      Assign(ExecFile,'TOPO1.COM');
      Execute(ExecFile);
   End;

Procedure ErrorCheck;
   Procedure ErrorTrap(ErrNo,ErrAddr:Integer);
      Type
         Stype = string[255];
      Var
         Ch : Char;
      Function IntegerToHex(Value: integer): stype;
      Begin
         Inline
            ($8B/$46/$04/$BF/$06/$00/$B1/$04/$88/$0B/$8A/$DC/$2A/$FF/$D3/$E3/
             $80/$FF/$0A/$7C/$05/$80/$C7/$37/$EB/$03/$80/$C7/$30/$47/$88/$3B/
             $F7/$C7/$01/$00/$75/$E6/$83/$FF/$08/$75/$04/$8A/$D8/$EB/$DD);
      End;
      Function ByteToHex(Value: byte): stype;
      Begin
         Inline
            ($8A/$5E/$04/$BF/$06/$00/$B1/$02/$88/$0B/$D0/$E1/$2A/$FF/$D3/$E3/
             $80/$FF/$0A/$7C/$05/$80/$C7/$37/$EB/$03/$80/$C7/$30/$47/$88/$3B/
             $F7/$C7/$01/$00/$75/$E6);
      End;
   Begin
      ClrScr;
      Case Hi(ErrNo) of
         $00 : WriteLn(#10#13'*** User Brake ***');
         $01 : Write(#10#13'I/O Error ');
         $02 : Write(#10#13'Run Time Error ');
      End;
      If Hi(ErrNo)<>$00 Then
         WriteLn(ByteToHex(Lo(ErrNo)),' PC = ',IntegerToHex(ErrAddr));
      WriteLn('Program Aborted');
      Write('Press any key to continue...');
      Read(Kbd,Ch);
      If (Ch=#27) And KeyPressed Then
         Read(Kbd,Ch);
      Assign(ExecFile,'TOPO1.COM');
      Execute(ExecFile);
   End;
Begin
   ErrorPtr:=Ofs(ErrorTrap);
End;

     {$I ACCESS3.BOX }
     {$I GETKEY.BOX  }
     {$I ADDKEY.BOX  }
     {$I DELKEY.BOX  }

var      dx,dy,dz,p,pi,a1,az,gab,
         gkl,wb,db,ss,aa,bb,cc  :real;
         OthInp,OthPrint:array[1..3680] of byte;
         k001_scr :file of rec;
         rec1     :rec;
         ofs1,cod :integer;
         i,l,j    :integer;
         ar_gram  :integer;
         buff     :string40;
         bit,okk  :boolean;
         name     :string[14];
         filename :string[14];
         fill     :text;
         f        :text;
         Fodey    :Text;
         Name_odeysis:string[14];
         Code_Odeysis:string[10];

         b1,b2,b3,b4,b5,b6,
         b7,b8,b9,b10,b11,b12:string[10];

         in_k001  :file of rec1_k001;
         in1_rec  :rec1_k001;
         in2_rec  :rec2_k001 absolute in1_rec;
         rec_syn  :rec_syntetagmenwn;
         file_syn :DataFile;
         IndexName:IndexFile;
         DumFile  :file;
         DatRef   :integer;
         sw1,sw3,sw4:byte;
         cha      :char;
         sel,gram :integer;

     {$i WRT-MON.PRC }
     {$i REPSTR.FNC  }
     {$i UDIP.PRC    }
     {$i AD.FNC      }
     {$i CURSOR.PRC  }
     {$i WRTSCR.PRC  }



procedure delete_all_input;
begin
  xa:=0; ya:=0; xb:=0; yb:=0; xk:=0; yk:=0; xl:=0; yl:=0;
  fillchar(kwd,sizeof(kwd),' ');
  fillchar(b,sizeof(b),0);
  fillchar(s,sizeof(s),0);
end;

procedure beep(freq,dur:integer);
begin
  sound(freq);
  delay(dur);
  nosound;
end;

function menu:byte;
label    5;
var      deik,row,col,i_m:byte;
         ch:char;

procedure paint_box(ra,ca,rt,ct,att:byte);
          var rows,cols,i_m:byte;
          begin
            rows:=rt-ra+1;
            cols:=ct-ca+1;
            for i_m:=1 to rows do
              wrt(ca,i_m+ra-1,att,chr(cols));
          end;
begin
     seek(k001_scr,0);
     read(k001_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         close(k001_scr);
         clrscr;
         cursor(true,false);
         halt;
       end;
       menu:=deik;
       exit;
     end;
     if ((ch=#27) and keypressed) or (ch in ['8','6','4','2']) then
     begin
       if ch=#27 then read(kbd,ch);
       case ch of
         #59..#65:begin      { F1,..,F7 }
                    paint_box(4,21,6,38,15);
                    paint_box(4,40,6,57,15);
                    paint_box(8,21,10,38,15);
                    paint_box(8,40,10,57,15);
                    paint_box(12,21,14,38,15);
                    paint_box(12,40,14,57,15);
                    paint_box(16,21,18,38,15);
                    paint_box(16,40,18,57,15);
                    case ch of
                          #59: paint_box(4,21,6,38,112);
                          #60: paint_box(4,40,6,57,112);
                          #61: paint_box(8,21,10,38,112);
                          #62: paint_box(8,40,10,57,112);
                          #63: paint_box(12,21,14,38,112);
                          #64: paint_box(12,40,14,57,112);
                          #65: paint_box(16,21,18,38,112);
                    end;    { case }
                    menu:=ord(ch)-58;
                    exit;
                  end;
              #66:begin      { F8 }
                    clrscr;
                    close(k001_scr);
                    cursor(true,false);
                    halt;
                  end;
  '4','6',#75,#77:begin      { <ÄÄ , ÄÄ> }
                    paint_box(row,col,row+2,col+17,15);
                    if col=21 then col:=40 else col:=21;
                    paint_box(row,col,row+2,col+17,112);
                    deik:=(row div 4) * 2 - 1;
                    if col=40 then deik:=deik+1;
                  end;
  '8','2',#72,#80:begin
                    paint_box(row,col,row+2,col+17,15);
                    if ((ch=#72) or (ch='8')) then
                      if row>4 then row:=row-4
                        else row:=16
                    else
                      if row<16 then row:=row+4 else row:=4;
                    paint_box(row,col,row+2,col+17,112);
                    deik:=(row div 4 * 2) - 1;
                    if col=40 then deik:=deik+1;
                  end;
              else for i_m:=3 to 6 do beep(i*500,50);
       end; {case}
     end {if}
     else
       for i_m:=3 to 6 do beep(i_m*500,50);
     goto 5;
end;

procedure arctan;
begin
  p:=arctan(1) * 4;
  if dx < 0 then
  begin
    if dy < 0 then
    begin
      a1:=arctan(abs(dx / dy));
      az:=p + a1;
    end;
    if dy = 0 then az:= 3 * p / 2;
    if dy > 0 then
    begin
      a1:=arctan(abs(dx / dy));
      az:=2 * p - a1;
    end;
  end;
  if dx = 0 then
  begin
    if dy < 0 then az:=p;
    if dy > 0 then az:=0;
  end;
  if dx > 0 then
  begin
    if dy < 0 then
    begin
      a1:=arctan(abs(dx / dy));
      az:=p - a1;
    end;
    if dy = 0 then az:= p / 2;
    if dy > 0 then
    begin
      a1:=arctan(abs(dx / dy));
      az:=a1;
    end;
  end;
end;

procedure epex;
begin
    pi:=arctan(1) * 4;
    dx:=xb - xa;    dy:=yb - ya;
    arctan;
    az:=az * 200 / pi;
    gab:=az;
    dx:=xl - xk;    dy:=yl - yk;
    arctan;
    az:=az * 200 / pi;
    gkl:=az;
    a[1]:=gab + b[1];
    while (a[1] > 400) do a[1]:=a[1] - 400;
    for l:=2 to i do
    begin
      a[l]:=a[l-1] + 200 + b[l];
      while (a[l] > 400) do a[l]:=a[l] - 400;
    end;
    wb:=gkl - a[i];
    db:=wb / i;
    ss:=0;
    for l:=1 to i do
    begin
      a[l]:=a[l] + l * db;
      ss:=ss + s[l];
    end;
    x[1]:=xa;    y[1]:=ya;    x[i]:=xk;    y[i]:=yk;
    for l:=2 to i do
    begin
      aa:=a[l-1] * pi / 200;
      ddx[l-1]:=s[l-1] * sin(aa);
      x[l]:=x[l-1] + ddx[l-1];
      ddy[l-1]:=s[l-1] * cos(aa);
      y[l]:=y[l-1] + ddy[l-1];
    end;
    dx:=xk - x[i];
    dy:=yk - y[i];
    dz:=sqrt(sqr(dx) + sqr(dy));
    bb:=0;    cc:=0;
    for l:=2 to i do
    begin
      bb:=bb + s[l-1] / ss * dx;
      cc:=cc + s[l-1] / ss * dy;
      x[l]:=x[l] + bb;
      y[l]:=y[l] + cc;
    end;
end;

procedure display_data(l:byte);
begin
    wrt(21,16,15,'     ');
    gotoxy(21,16);    write('(',l:1,')');
    wrt(32,16,15,'    ');
    gotoxy(32,16);    write(kwd[l]);
    wrt(21,18,15,'     ');
    gotoxy(21,18);    write('(',l:1,')');
    wrt(32,18,15,'        ');
    gotoxy(32,18);    write(b[l]:5:4);
    wrt(21,20,15,'         ');
    gotoxy(21,20);    write('(',l:1,'-',l+1:1,')');
    wrt(32,20,15,'            ');
    if (l <> i) then
    begin
      gotoxy(32,20);    write(s[l]:4:3);
    end;
end;

procedure inp;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,ii;
begin
     Code_Odeysis:='';
     if ((sw1 = 1) or (sw3 = 1)) then
     begin
       gotoxy(22,5);    write(i:1);
       gotoxy(6,11);    write(xa:4:3);
       gotoxy(6,14);    write(ya:4:3);
       gotoxy(25,11);    write(xb:4:3);
       gotoxy(25,14);    write(yb:4:3);
       gotoxy(45,11);    write(xk:4:3);
       gotoxy(45,14);    write(yk:4:3);
       gotoxy(64,11);    write(xl:4:3);
       gotoxy(64,14);    write(yl:4:3);
     end;
i1:  input(buff,5,21,4,bit);
     if bit then goto i1 else val(buff,i,cod);
ii:  input(buff,5,66,10.1,bit);
     if bit then goto i1 else Code_Odeysis:=buff;
i2:  input(buff,11,5,12,bit);
     if bit then goto ii
       else val(buff,xa,cod);
i3:  input(buff,14,5,13,bit);
     if bit then goto i2
       else val(buff,ya,cod);
i4:  input(buff,11,24,12,bit);
     if bit then goto i3
       else val(buff,xb,cod);
i5:  input(buff,14,24,13,bit);
     if bit then goto i4
       else val(buff,yb,cod);
     dx:=xb - xa;
     dy:=yb - ya;
     if ((dx = 0) and (dy = 0)) then
     begin
       cursor(false,true);
       wrt(10,23,112,' † €•† ’€“’ˆ…„’€ˆ ‹„ ’†Œ „€’†‘† €•†‘. €’†‘„ „Œ€ Š†‰’.. ');
       repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
       wrt(10,23,15,'                                                               ');
       cursor(true,false);
       goto i2;
     end;
i6:  input(buff,11,44,12,bit);
     if bit then goto i5
       else val(buff,xk,cod);
i7:  input(buff,14,44,13,bit);
     if bit then goto i6
       else val(buff,yk,cod);
i8:  input(buff,11,63,12,bit);
     if bit then goto i7
       else val(buff,xl,cod);
i9:  input(buff,14,63,13,bit);
     if bit then goto i8
       else val(buff,yl,cod);
     dx:=xl - xk;
     dy:=yl - yk;
     if ((dx = 0) and (dy = 0)) then
     begin
       cursor(false,true);
       wrt(8,23,112,' ’ ’„Š‘ ’€“’ˆ…„’€ˆ ‹„ ’†Œ „€’†‘† ’„Š“‘. €’†‘„ „Œ€ Š†‰’.. ');
       repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
       wrt(8,23,15,repstr(66,32));
       cursor(true,false);
       goto i6;
     end;
     l:=1;
     while (l <= i) do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
       wrt(21,16,15,'     ');
       gotoxy(21,16);    write('(',l:1,')');
i10:   input(buff,16,31,5.1,bit);
       if bit then
       begin
         if l = 1 then goto i9
         else
         begin
           l:=pred(l);
           if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
           goto i12;
         end;
       end
       else kwd[l]:=buff;
       wrt(21,18,15,'     ');
       gotoxy(21,18);    write('(',l:1,')');
i11:   input(buff,18,31,9,bit);
       if bit then goto i10
         else val(buff,b[l],cod);
       if l = i then
       begin
         l:=succ(l);
         goto i13;
       end;
       wrt(21,20,15,'         ');
       gotoxy(21,20);    write('(',l:1,'-',l+1:1,')');
i12:   input(buff,20,31,12,bit);
       if bit then goto i11
         else val(buff,s[l],cod);
       wrt(32,16,15,'     ');
       wrt(32,18,15,'            ');
       wrt(32,20,15,'             ');
       l:=succ(l);
i13: end;
     epex;
end;

procedure input_results_in_file;
var   k  :integer;
begin
  rewrite(fill);
  writeln(fill,'’ „ • Œ ˆ ‰   ‚  € ” „ ˆ   ‹ „ Š „ ’ — Œ  ‚ ˆ € Œ Œ † ‘  ’ ‘  “ ’  € ‘ ');
  writeln(fill,'============================================================================');
  Writeln(fill,'‰—ƒˆ‰‘ ƒ„“‘H‘         : ',Code_odeysis);
  writeln(fill,'============================================================================');
  writeln(fill,'‰—ƒˆ‰‘  ‚—Œˆ„‘  €…ˆ‹“‡ˆ€   ‹†‰‘     ƒ•       ƒ“        ‘“Œ’„’€‚‹„Œ„‘');
  writeln(fill,'‘†‹„ˆ“  ‡Š€‘†‘             Š„“—Œ                   ’„’‹†‹„Œ†   ’„’€‚‹„Œ†');
  writeln(fill,'------- -------- --------- -------- -------- -------- ---------- -----------');
               {  ****  ***.****  ***.**** ****.*** -***.*** -***.*** ******.*** *******.***}
  writeln(fill,'„¥˜¨«.˜¨®ª',' ':43,xb:10:3,' ',yb:11:3);
  writeln(fill,' ':18,gab:8:4);
  for k:=1 to i do
  begin
    writeln(fill,'  ',kwd[k],' ':6-length(kwd[k]),b[k]:8:4,' ':38,x[k]:10:3,' ',y[k]:11:3);
    if (k <> i) then
    begin
      writeln(fill,' ':18,a[k]:8:4,' ',s[k]:8:3,' ',ddx[k]:8:3,' ',ddy[k]:8:3);
    end;
  end;
  writeln(fill,' ':18,gkl:8:4);
  writeln(fill,'„¥˜¨«.«œ¢¦¬ª',' ':42,xl:10:3,' ',yl:11:3);
  writeln(fill);
  writeln(fill,'Šˆ‰ ‹†‰‘ ƒ„“‘†‘     : ',ss:4:3);
  writeln(fill,'‚—Œˆ—ƒ„‘ ‘”€Š‹€         : ',wb:5:4);
  writeln(fill,'‚€‹‹ˆ‰ ‘”€Š‹€ ‰€’€ •  : ',dx:4:3);
  writeln(fill,'‚€‹‹ˆ‰ ‘”€Š‹€ ‰€’€ “  : ',dy:4:3);
  writeln(fill,'Šˆ‰ ‚€‹‹ˆ‰ ‘”€Š‹€   : ',dz:6:3);
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(4,grammi);    write(kwd[k]);
  gotoxy(10,grammi);    write(b[k]:8:4);
  gotoxy(57,grammi);    write(x[k]:10:3);
  gotoxy(69,grammi);    write(y[k]:11:3);
  if (k <> i) then
  begin
    gotoxy(20,grammi+1);    write(a[k]:8:4);
    gotoxy(29,grammi+1);    write(s[k]:8:3);
    gotoxy(38,grammi+1);    write(ddx[k]:8:3);
    gotoxy(47,grammi+1);    write(ddy[k]:8:3);
  end;
end;

procedure write_screen(m,scr_line:integer);
var       k:integer;
label     w1;
begin
    clrscr;
    seek(k001_scr,2);    read(k001_scr,rec1);
    move(rec1.xx[0],mem[$b000:ofs1],3680);
    wrt(2,7,15,'„.˜¨®ª');
    gotoxy(57,7);    write(xb:10:3);
    gotoxy(69,7);    write(yb:10:3);
    gotoxy(20,8);    write(gab:8:4);
    GotoXY(19,23);   Write(Code_Odeysis);
    scr_line:=9;
    for k:=1 to m do
    begin
      anal_gr_scr(scr_line,k);
      scr_line:=scr_line + 2;
      if scr_line >= 20 then
      begin
        wrt(24,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
        repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
        move(rec1.xx[0],mem[$b000:ofs1],3680);
        GotoXY(19,23);   Write(Code_Odeysis);
        scr_line:=7;
      end;
    end;
w1: gotoxy(20,scr_line);    write(gkl:8:4);
    scr_line:=scr_line + 1;
    if scr_line = 20 then
    begin
      wrt(24,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      GotoXY(19,23);   Write(Code_Odeysis);
      scr_line:=7;
    end;
    gotoxy(2,scr_line);    write('„.«œ¢¦¬ª');
    gotoxy(57,scr_line);    write(xl:10:3);
    gotoxy(69,scr_line);    write(yl:11:3);
    wrt(24,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    seek(k001_scr,3);    read(k001_scr,rec1);
    move(rec1.xx[0],mem[$b000:ofs1],3680);
    gotoxy(40,8);    write(ss:4:3);
    gotoxy(40,10);    write(wb:5:4);
    gotoxy(40,12);    write(dx:4:3);
    gotoxy(40,14);    write(dy:4:3);
    gotoxy(40,16);    write(dz:6:5);
    wrt(24,24,15,repstr(80,32));
    wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ MENU €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
  writeln(fill,'T E X N I K O  ‚  € ” „ ˆ   ‹ „ Š „ ’ — Œ  ‚ ˆ € Œ Œ † ‘  ’ ‘  “ ’  € ‘ ');
  writeln(fill,'============================================================================');
  Writeln(Fill,'‰—ƒˆ‰‘ ƒ„“‘†‘ : ',Code_Odeysis);
  writeln(fill,'============================================================================');
  writeln(fill);
  writeln(fill,'‰—ƒˆ‰‘  ‚—Œˆ„‘  €…ˆ‹“‡ˆ€   ‹†‰‘      ƒ•       ƒ“       ‘“Œ’„’€‚‹„Œ„‘');
  writeln(fill,'‘†‹„ˆ“  ‡Š€‘†‘             Š„“—Œ                   ’„’‹†‹„Œ†   ’„’€‚‹„Œ†');
  writeln(fill,'------- -------- --------- -------- -------- -------- ---------- -----------');
end;

procedure lprint;
var       k:integer;
begin
  rewrite(fill);
  epikef;
  writeln(fill,'„¥˜¨«.˜¨®ª',' ':43,xb:10:3,' ',yb:11:3);
  writeln(fill,' ':18,gab:8:4);
  gram:=13;
  for k:=1 to i do
  begin
    writeln(fill,'  ',kwd[k],' ':6-length(kwd[k]),b[k]:8:4,' ':38,x[k]:10:3,' ',y[k]:11:3);
    if (k <> i) then
    begin
      writeln(fill,' ':18,a[k]:8:4,' ',s[k]:8:3,' ',ddx[k]:8:3,' ',ddy[k]:8:3);
    end;
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin
      writeln(fill);
      writeln(fill);
      epikef;
      gram:=11;
    end;
  end;
  writeln(fill,' ':18,gkl:8:4);
  gram:=gram + 1;
  if gram >= ar_gram - 2 then
  begin
    writeln(fill);
    writeln(fill);
    epikef;
    gram:=11;
  end;
  writeln(fill,'„¥˜¨«.«œ¢¦¬ª',' ':42,xl:10:3,' ',yl:11:3);
  writeln(fill);
  writeln(fill,'Šˆ‰ ‹†‰‘ ƒ„“‘†‘     : ',ss:4:3);
  gram:=gram + 2;
  if gram >= ar_gram - 2 then
  begin
    writeln(fill);
    writeln(fill);
    writeln(fill);
    sel:=sel + 1;
    writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
    gram:=2;
  end;
  writeln(fill);
  writeln(fill,'‚—Œˆ—ƒ„‘ ‘”€Š‹€         : ',wb:5:4);
  gram:=gram + 2;
  if gram >= ar_gram - 2 then
  begin
    writeln(fill);
    writeln(fill);
    writeln(fill);
    sel:=sel + 1;
    writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
    gram:=2;
  end;
  writeln(fill);
  writeln(fill,'‚€‹‹ˆ‰ ‘”€Š‹€ ‰€’€ •  : ',dx:4:3);
  gram:=gram + 2;
  if gram >= ar_gram - 2 then
  begin
    writeln(fill);
    writeln(fill);
    writeln(fill);
    sel:=sel + 1;
    writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
    gram:=2;
  end;
  writeln(fill);
  writeln(fill,'‚€‹‹ˆ‰ ‘”€Š‹€ ‰€’€ “  : ',dy:4:3);
  gram:=gram + 2;
  if gram >= ar_gram - 2 then
  begin
    writeln(fill);
    writeln(fill);
    writeln(fill);
    sel:=sel + 1;
    writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
    gram:=2;
  end;
  writeln(fill);
  writeln(fill,'Šˆ‰ ‚€‹‹ˆ‰ ‘”€Š‹€ : ',dz:6:3);
  close(fill);
end;

procedure epex_menu;
var  j,k :byte;
     okk :boolean;
label    e1,e2,e3,10,25;
begin
     case menu of
        1:begin
            if ((sw1 = 1) or (sw3 = 1)) then goto e2;
            clrscr;
            cursor(true,false);
            seek(k001_scr,1);     read(k001_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            inp;
            sw1:=1;
            clrscr;
            cursor(false,true);
e2:         epex_menu;
            sw4:=0;
          end;
        2:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1)) then
            begin
              wrt_screen(OthInp,1,20,80,22);
              gotoxy(13,21); read(name);
              assign(in_k001,name);
              {$i-}
              reset(in_k001);
              {$i+}
              okk:=(ioresult=0);
              if okk then
              begin
                wrt(2,23,15,'‘„•„ ! ’ €•„ˆ €“’ “€•„ˆ. '+
                            'Œ€ ‚€–— „€Œ— ’“; (Œ/) ');
                read(kbd,cha);
                if cha in ['O','o','','¦'] then
                begin
                  cursor(false,true);
                  epex_menu;
                end;
              end;
              clrscr;
              cursor(false,true);
              wrt(11,12,240,'  ‰ € ’ € • —  —   ƒ „ ƒ  ‹ „ Œ € '+
                            '  ‘ „   €  • „ ˆ   ');
              if Pos('.',Name)=0 then Name_Odeysis:=Name+'.TRA'
                else Name_Odeysis:=copy(Name,1,Pos('.',Name))+'TRA';
              Assign(Fodey,Name_Odeysis);
              ReWrite(Fodey);
                 Writeln(Fodey,Code_Odeysis);
              Close(Fodey);
              rewrite(in_k001);
              with in1_rec do
              begin
                i_o:=i; xa_o:=xa; ya_o:=ya; xb_o:=xb; yb_o:=yb;
                xk_o:=xk; yk_o:=yk; xl_o:=xl; yl_o:=yl;
              end;
              write(in_k001,in1_rec);
              j:=0;
              repeat
                j:=j+1;
                with in2_rec do
                begin
                  kwd_o:=kwd[j]; b_o:=b[j]; s_o:=s[j];
                  write(in_k001,in1_rec);
                end;
              until j = i;
              close(in_k001);
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ƒEN EKANE‘ EI‘A‚—‚H ƒEƒOMEN—N.'+
                            '  €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
            epex_menu;
          end;
        3:begin
            cursor(true,false);
            wrt(1,20,15,'TO AXEIO AYTO EINAI ƒHMIOY‚†MENO ME '+
                        'EDITOR "H ME TO ŠHKTO F2; (E/F): ');
            gotoxy(73,20);    read(cha);
            wrt_screen(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k001,filename);
              {$i-}
              reset(in_k001);
              {$i+}
              okk:=(ioresult=0);
              if not okk then
              begin
                cursor(false,true);
                wrt(12,23,240,'  O‘EXE !   TO AXEIO AYTO ƒEN YAXEI.'+
                              ' ATH‘E ENA ŠHKTO..  ');
                read(kbd,cha); if (cha=#27) and keypressed then read(kbd,cha);
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..  ');
              Code_Odeysis:='          ';
              if Pos('.',filename)=0 then Name_Odeysis:=filename+'.TRA'
                else Name_Odeysis:=copy(filename,1,Pos('.',filename))+'TRA';
              Assign(Fodey,Name_Odeysis);
            {$i-}
              ReSet(Fodey);
            {$i+}
              if ioresult=0 then begin
                Readln(Fodey,Code_Odeysis);
                Close(Fodey);
              end;
              reset(in_k001);
              seek(in_k001,0);
              with in1_rec do
              begin
                read(in_k001,in1_rec);
                i:=i_o; xa:=xa_o; ya:=ya_o; xb:=xb_o; yb:=yb_o;
                xk:=xk_o; yk:=yk_o; xl:=xl_o; yl:=yl_o;
              end;
              l:=0;
              SS:=0;
              FillChar(S,sizeof(S),0);
              repeat
                l:=l+1;
                read(in_k001,in1_rec);
                with in2_rec do
                begin
                  if (l <> i) then
                  begin
                    kwd[l]:=kwd_o; b[l]:=b_o; s[l]:=s_o;
                  end
                  else
                  begin
                    kwd[l]:=kwd_o; b[l]:=b_o;
                  end
                end;
              until  l = i;
              close(in_k001);
              epex;
            end
            else
            begin
              assign(f,filename);
              {$i-}
              reset(f);
              {$i+}
              okk:=(ioresult=0);
              if not okk then
              begin
                cursor(false,true);
                wrt(12,23,240,'  O‘EXE !   TO AXEIO AYTO ƒEN YAXEI.'+
                              ' ATH‘E ENA ŠHKTO..  ');
                 read(kbd,cha); if (cha=#27) and keypressed then read(kbd,cha);
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..  ');
              Code_Odeysis:='          ';
              if Pos('.',filename)=0 then Name_Odeysis:=filename+'.TRA'
                else Name_Odeysis:=copy(filename,1,Pos('.',filename))+'TRA';
              Assign(fodey,Name_Odeysis);
            {$I-}
              Reset(Fodey);
            {$I+}
              if ioresult=0 then begin
                Readln(Fodey,Code_Odeysis);
                close(Fodey);
              end;
              reset(f);
              readln(f,b1);    val(b1,i,cod);
              readln(f,b2);    val(b2,xa,cod);
              readln(f,b3);    val(b3,ya,cod);
              readln(f,b4);    val(b4,xb,cod);
              readln(f,b5);    val(b5,yb,cod);
              readln(f,b6);    val(b6,xk,cod);
              readln(f,b7);    val(b7,yk,cod);
              readln(f,b8);    val(b8,xl,cod);
              readln(f,b9);    val(b9,yl,cod);
              j:=0;
              SS:=0;
              FillChar(S,sizeof(S),0);
              repeat
                j:=j+1;
                readln(f,b10);    kwd[j]:=b10;
                readln(f,b11);    val(b11,b[j],cod);
                if (j <> i) then
                begin
                  readln(f,b12);    val(b12,s[j],cod);
                end;
              until j = i;
              close(f);
              Close(Fodey);
              epex;
            end;
            epex_menu;
          end;
        4:begin
            if ((sw1 <> 1) and (sw3 <> 1)) then
            begin
              wrt(12,24,240,'  ƒEN EX— ƒEƒOMENA.  €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            cursor(true,false);
            sw4:=1;
            seek(k001_scr,1);    read(k001_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            inp;
            cursor(false,true);
10:         epex_menu;
          end;
        5:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              wrt_screen(OthInp,1,20,80,22);
              gotoxy(13,21); read(filename);
              assign(fill,filename);
              {$i-}
              reset(fill);
              {$i+}
              OKK:=(ioresult=0);
              if OKK then
              begin
                gotoxy(2,23);
                write('O‘EXE ! TO AXEIO AYTO YAXEI.'+
                      ' NA ‚A–— EAN— TOY; (N/O) ');
                repeat
                  read(kbd,cha);
                  if (cha=#27) and keypressed then read(kbd,cha);
                until cha in ['O','o','','¦','N','n','Œ','¤'];
                if cha in ['O','o','','¦'] then
                    goto e1 else input_results_in_file;
              end
              else
              begin
                cursor(false,true);
                input_results_in_file;
              end;
e1:           wrt(1,23,15,repstr(79,32));
              cursor(true,false);
              wrt(3,21,15,repstr(76,32));
              gotoxy(3,21);
              write('‡„Š„ˆ‘ €’„Š„‘‹€’€ ‘„ €•„ˆ ‘“Œ’„’€‚‹„Œ—Œ; (N/O) : ');
              repeat
                read(kbd,cha);
                if (cha=#27) and keypressed then read(kbd,cha);
              until cha in ['O','o','','¦','N','n','Œ','¤'];
              if cha in ['O','o','','¦'] then goto e3
              else
              begin
                assign(DumFile,'POINTS.DAT');
                {$i-}
                reset(DumFile);
                {$i+}
                OKK:=(ioresult=0);
                if OKK then
                begin
                  close(DumFile);
                  OpenFile(file_syn,'POINTS.DAT',sizeof(rec_syn));
                  OpenIndex(IndexName,'POINTS.IDX',4,1);
                end
                else
                begin
                  MakeFile(file_syn,'POINTS.DAT',sizeof(rec_syn));
                  if OK then
                      MakeIndex(IndexName,'POINTS.IDX',4,1);
                end;
                for l:=1 to i do
                begin
                    fillchar(rec_syn,sizeof(rec_syn),0);
                    rec_syn.status:=0;
                    rec_syn.kwd_syn:=kwd[l];
                    rec_syn.x_syn:=x[l];
                    rec_syn.y_syn:=y[l];
                    rec_syn.h_syn:=0;
                    rec_syn.eidos_point:=' ';
                    rec_syn.job:=' ';
                    rec_syn.xronol:=' ';
                    rec_syn.who_idrise:=' ';
                    rec_syn.axiopistia:=' ';
                    rec_syn.comments:=' ';
                  AddRec(file_syn,DatRef,rec_syn);
                  AddKey(IndexName,DatRef,kwd[l]);
                end;
                CloseFile(file_syn);
                CloseIndex(IndexName);
              end;
e3:           cursor(false,true);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
        6:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
25:           wrt_screen(OthPrint,1,4,45,17);
              gotoxy(32,13); read(ar_gram);
              if ad then goto 25;
              cursor(false,true);
              wrt(3,15,15,'„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘');
              wrt(10,16,15,'€’†‘„ RETURN ‚ˆ€ „‰’“—‘†..');
              repeat read(kbd,cha) until cha in [#10,#13];
              assign(fill,'prn');
              clrscr;
              wrt(26,12,240,'   „  ‰  ’  “    —  Œ  —..   ');
              lprint;
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
        7:begin
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              cursor(false,true);
              write_screen(i,7);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
     end; { case }
end; { procedure }

BEGIN
(*ErrorCheck;
  CheckChn;
  __TempResult:=(__Check1*__Check1*__Check1*0.030+__Check2*__Check2*0.051+
                 __Check1*0.831)/ (__Check1*0.351+__Check2*0.524+__Check3);
  __TempMinutes:=Minutes;
  If (Abs(__TempResult-__Check4)>0.000001) or (Abs(__TempMinutes-__Check7)>2)
     then move(mem[DSeg:0],mem[CSeg:0],32000);
*)
clrscr;
     InitIndex;
     ofs1:=$8000;
     if mem[0:1040] and 48 = 48 then ofs1:=$0000;
     assign(k001_scr,'TRAV.SCR');
     reset(k001_scr);
     seek(k001_scr,4); read(k001_scr,rec1);
     for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
     for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
     sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;    gram:=0;
     Code_Odeysis:='          ';
     delete_all_input;
     cursor(false,true);
     epex_menu;
END.

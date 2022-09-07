(********************************************************************)
(***          UDIP : [ Ultra Dynamic Input Proccessing ]          ***)
(***  Version  3.1  -  10/1985  by G. XALARIS  ***)
(********************************************************************)

procedure input(var mixk: string40; mixp,mixn : integer;
                           lfl : real; var bit : boolean);

label
     st;

type
     string8   = string[8];
     string10  = string[10];

var
     mixx,mixf1,mixf2,
     mixt,mixt1,num,cap,grk : integer;
                       mixa : string[40];
                   nm,cp,gr : array[0..2] of string[11];

(* ======================================================================== *)

(* function date : string10;
type
  regpack = record
              ax,bx,cx,dx,bp,si,ds,es,flags: integer;
            end;

var
       regs : regpack;                {record for MsDos call}
       year : string[4];
  month,day : string[2];


begin
  with regs do
  begin
    ax := $2A00;
    MsDos(regs);                          {   call function   }
    str(cx,year);                         { convert to string }
    str(lo(dx),day);                      {         "         }
    str(hi(dx),month);                    {         "         }
  end;
  date := day+'-'+month+'-'+year;
end; *)

(* -------------------------------------------------------------------------*)

(* function time : string8;
type
  regpack = record
              ax,bx,cx,dx,bp,di,si,ds,es,flags: integer;
            end;

var
          regs : regpack;             { assign record }
  hour,min,sec : string[2];

begin
  with regs  do
  begin
    ax := $2C00;
    MsDos(regs);                      {  call interrupt   }
    str(hi(cx),hour);                 { convert to string }
    str(lo(cx),min);                  {         "         }
    str(hi(dx),sec);                  {         "         }
  end;
  if length(min)=1 then min:='0'+min;
  if length(sec)=1 then sec:='0'+sec;
  time := hour+':'+min+':'+sec;
end;  *)

(* -------------------------------------------------------------------------*)

function screen(x,y,p:byte) : char;
type
  regpack = record
               ax,bx,cx,dx,bp,di,si,ds,es,flags:integer;
            end;
var
      recpack : regpack;
          scr : integer;
begin
  gotoxy(x,y);
  with recpack do
  begin
      ax:=8 shl 8;
      bx:=p shl 8;
      intr($10,recpack);
      screen:=chr(lo(ax))
  end;
end;

(* ------------------------------------------------------------------------ *)

procedure SchScr;
var i : 1..80;
begin
   i:= mixn+1;
   while (not (screen(i,mixp,0) in [#0,#32])) and (i<80) do
   Begin
      mixk:=mixk+screen(i,mixp,0);  i:=i+1
   end
end;

(* -------------------------------------------------------------------------*)

procedure subhead;
begin
    if mem[0:1097] in [4,5,6] then
    begin
         gotoxy(1,24);  write(#213,repstr(78,205),#184);
         gotoxy(2,25);  write(' ',#17#196#196#196,' ');
         gotoxy(8,25);  write(' - ƒˆŽ‡—‘†     ');
         gotoxy(67,25); write(' ESC ');
         gotoxy(72,25); write(' - ’„ŠŽ‘');
    end
    else begin
         wrt(1,24,15,#213+repstr(78,205)+#184);
         wrt(2,25,112,' '+#17+#196+#196+#196+' ');
         wrt(8,25,15,' - ƒˆŽ‡—‘†     ');
         wrt(67,25,112,' ESC ');   wrt(72,25,15,' - ’„ŠŽ‘');
    end;
end;

(* -------------------------------------------------------------------------*)

procedure Break;
var
    ch : char;
   i,j : integer;
begin
   for i:=1 to 2 do
   begin
       j:=650;
       while j<1000 do
       begin
           sound(j);   delay(10);  j:=j+20
       end;
       j:=1000;
       while j>650 do
       begin
           sound(j);  delay(10);  j:=j-20
       end;
   end;
   nosound;
   if mem[0:1097] in [4,5,6] then
   begin
        gotoxy(2,25);     write('  T E Š Ž ‘  ');
        gotoxy(15,25);    write(' ; (N/O)');  gotoxy(20,25);
   end
   else begin
        wrt(2,25,240,'  T E Š Ž ‘  ');
        wrt(15,25,15,' ; (N/O)');  gotoxy(20,25);
   end;
   read(Kbd,ch);
   if ch in ['n','N','¤','Œ']  then Halt else SubHead;
end;

(* ======================================================================== *)

begin                 (*---  of input  ---*)
     if screen(1,24,0)<>#213  then  SubHead;
     mixf1:=trunc(lfl);      mixf2:=trunc(100.0*frac(lfl));
     mixk:='';   mixt:=0;    mixt1:=0;    bit:=false;
     mixx:=1;    num:=0;     cap:=0;      grk:=1;
     nm[0]:='          ';    nm[1]:=' Num-Lock ';
     cp[0]:='           ';   cp[1]:=' Caps-Lock ';
     gr[0]:='          ';    gr[1]:=' „ŠŠ†Œˆ‰€ ';
     repeat
st:      GotoXY(mixn+mixx,mixp);
         if mem[0:1097] in [4,5,6] then write('_'#8);
         if mem[0:1097] in [0,1,2,3,7] then
           repeat
             if (mem[0:1047] and 32) <> num  then
             begin
                 num:=(mem[0:1047] and 32);
                 wrt(23,25,112*trunc(num/32),nm[trunc(num/32)]);
             end;
             if (mem[0:1047] and 64) <> cap  then
             begin
                 cap:=(mem[0:1047] and 64);
                 wrt(53,25,112*trunc(cap/64),cp[trunc(cap/64)]);
             end;
             if mem[0:1042] <> grk  then
             begin
                 grk:=mem[0:1042];
                 wrt(38,25,112*trunc(grk/28),gr[trunc(grk/28)]);
             end;
           until KeyPressed;
         GotoXY(mixn+mixx,mixp);
         read(Kbd,mixa[mixx]);
         if (mixa[mixx]=#27) and KeyPressed  then goto st;
         case mixa[mixx] of

            #27 : begin
                      Break;  goto st;
                  end;
            #13 : begin
                      if mixx=1  then SchScr
                                 else write(#0);
                      exit;
                  end;
             #8 : if mixx=1 then
                  begin
                      bit:=true;  exit;
                  end
                  else
                  begin
                      mixx:=mixx-1;    mixk:=copy(mixk,1,mixx-1);
                      if (mixa[mixx] = #46)  then mixt:=0;
                      if UpCase(mixa[mixx]) in [ #68, #69 ] then mixt1:=0;
                      gotoxy(mixn+mixx,mixp);  write(#0);
                      goto  st;
                  end;
         else if mixf2=0  then
              case mixa[mixx] of

                        #46 : if mixt = 1   then
                              begin
                                  write(#7);  goto st;
                              end
                              else   mixt:=1;

          #68,#69,#100,#101 : if mixt1 = 1   then
                              begin
                                   write(#7);  goto st;
                              end
                              else  mixt1:=1;

                        #45 : if (mixx <> 1) and
                              not (UpCase(mixa[mixx-1]) in [ #68, #69 ])  then
                              begin
                                  write(#7);  goto st;
                              end;
                   #48..#57 : ;
                       else   begin
                                  write(#7);  goto st;
                              end;
              end;
         end;
         mixk:=copy(mixk,1,mixx-1)+mixa[mixx];
         TextColor(15);   gotoxy(mixn+mixx,mixp);      write(mixa[mixx]);
         if mixx=1  then  write(repstr(mixf1-1,0));    mixx:=mixx+1;

     until mixx > mixf1;
end;

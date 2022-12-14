{******************************************************************************
*               K010  ??????? ????????                        *
*                    (B ??????????)                                   *
*                  WRITTEN BY G.HALARIS                          *
*                              12-11-1986                                *
*******************************************************************************}
program  k010;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec_k010=record
           xaa,yaa,azz,sab:real;
         end;
         string40=string[40];
         string255=string[255];

var      xa,ya,az,s,xb,yb,azim:array [1..500] of real;
         OthInp:array [1..3680] of byte;
         k010_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,j     :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[14];
         pii     :real;
         fill    :text;

         f       :text;
         a1      :string[10];
         a2      :string[11];
         a3      :string[8];
         a4      :string[10];

         in_k010 :file of rec_k010;
         in_rec  :rec_k010;
         rec2    :rec_k010;
         sw1,sw3,sw4:byte;
         cha:char;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure beep(freq,dur:integer);
begin sound(freq); delay(dur); nosound; end;
function menu:byte;
label    5;
var      deik,row,col,i:byte;
         ch:char;
procedure paint_box(ra,ca,rt,ct,att:byte);
          var rows,cols,i:byte;
          begin
            rows:=rt-ra+1;
            cols:=ct-ca+1;
            for i:=1 to rows do
              wrt(ca,i+ra-1,att,chr(cols));
          end;
begin
     seek(k010_scr,0);
     read(k010_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         cursor(true,false);
         close(k010_scr);
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
                    menu:=ord(ch)-58;
                    exit;
                  end;
              #66:begin      { F8 }
                    clrscr;
                    cursor(true,false);
                    close(k010_scr);
                    halt;
                  end;
  '4','6',#75,#77:begin      { <?? , ??> }
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
              else for i:=3 to 6 do beep(i*500,50);
       end; {case}
     end {if}
     else
       for i:=3 to 6 do beep(i*500,50);
     goto 5;
end;

procedure delete_all_input;
begin
  fillchar(xa,sizeof(xa),0); fillchar(ya,sizeof(ya),0);
  fillchar(az,sizeof(az),0); fillchar(s,sizeof(s),0);
  fillchar(xb,sizeof(xb),0); fillchar(yb,sizeof(yb),0);
  fillchar(azim,sizeof(azim),0);
end;

procedure epex(j:byte);
begin
  pii:=3.141592654/200; azim[j]:=az[j]*pii;
  xb[j]:=xa[j]+s[j]*sin(azim[j]); yb[j]:=ya[j]+s[j]*cos(azim[j]);
end;

procedure inp(j:byte);
label    10,20,30,40;
begin
10:  input(buff,5,42,10,bit);
     val(buff,xa[j],cod);
20:  input(buff,9,42,11,bit);
     if bit then goto 10 else val(buff,ya[j],cod);
30:  input(buff,13,42,8,bit);
     if bit then goto 20 else val(buff,az[j],cod);
40:  input(buff,17,42,10,bit);
     if bit then goto 30 else val(buff,s[j],cod);
     if ad then goto 40 else epex(j);
end;

procedure input_results_in_file;
var   k:integer;
begin
  wrt_screen(OthInp,1,20,80,22);
  gotoxy(13,21); read(filename);
  assign(fill,filename);
  {$i-}
  reset(fill);
  {$i+}
  ok:=(ioresult=0);
  if ok then
  begin
    GOTOXY(2,23);
    write('??O?EXE ! TO A?XEIO AYTO Y?A?XEI. NA ??A?? E?AN? TOY; (N/O) ');
    read(kbd,cha);
    if cha in ['O','o','?','?'] then exit;
  end;
  rewrite(fill);
  writeln(fill,'==============================================================');
  writeln(fill,'          ??O?O?I?MO? ?YN/N?N ME ?E?OMENH THN ??NIA');
  writeln(fill,'                 ?IE???N?E?? KAI THN A?O?TA?H');
  writeln(fill,'==============================================================');
  writeln(fill);
  writeln(fill);
  for k:=1 to i do
  begin
    writeln(fill,'    TETMHMENH ?HMEIOY A    XA       : ',xa[k]:5:3);
    writeln(fill,'    TETA?MENH ?HMEIOY A    YA       : ',ya[k]:5:3);
    writeln(fill,'    AZIMOY?IO A ??O? B (????o?s) AZ : ',az[k]:5:4);
    writeln(fill,'    A?O?TA?H   SAB                  : ',s[k]:5:3);
    writeln(fill);
    writeln(fill,'    A ? O T E ? E ? M A T A');
    writeln(fill);
    writeln(fill,'           XB = ',xb[k]:5:3);
    writeln(fill,'           YB = ',yb[k]:5:3);
    writeln(fill);
    writeln(fill,'**************************************************************');
    writeln(fill);
  end;
  close(fill);
end;

procedure write_screen;
var   k:integer;
begin
  clrscr;
  seek(k010_scr,2);    read(k010_scr,rec1);
  for k:=1 to i do
  begin
    move(rec1.xx[0],mem[$b000:ofs1],3680);
    gotoxy(43,5);  write(xa[k]:5:3); gotoxy(43,9);  write(ya[k]:5:3);
    gotoxy(43,13); write(az[k]:2:4); gotoxy(43,17); write(s[k]:2:3);
    gotoxy(43,20); write(xb[k]:5:3); gotoxy(43,22); write(yb[k]:5:3);
    gotoxy(1,24);  write('?AT??? ENA ??HKT?O ?IA ?YNEXEIA..');
    repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
    clrscr;
  end;
end;

procedure lprint;
var   k:integer;
begin
  rewrite(fill);
  writeln(fill,'==============================================================');
  writeln(fill,'          Y?O?O?I?MO? ?YN/N?N ME ?E?OMENH THN ??NIA');
  writeln(fill,'                 ?IE???N?E?? KAI THN A?O?TA?H');
  writeln(fill,'==============================================================');
  writeln(fill);
  writeln(fill);
  for k:=1 to i do
  begin
    writeln(fill,'    TETMHMENH ?HMEIOY A    XA       : ',xa[k]:5:3);
    writeln(fill,'    TETA?MENH ?HMEIOY A    YA       : ',ya[k]:5:3);
    writeln(fill,'    AZIMOY?IO A ??O? B (????o?s) AZ : ',az[k]:5:4);
    writeln(fill,'    A?O?TA?H   SAB                  : ',s[k]:5:3);
    writeln(fill);
    writeln(fill,'    A ? O T E ? E ? M A T A');
    writeln(fill);
    writeln(fill,'           XB = ',xb[k]:5:3);
    writeln(fill,'           YB = ',yb[k]:5:3);
    writeln(fill);
    writeln(fill,'**************************************************************');
    writeln(fill);
  end;
  close(fill);
end;

procedure epex_menu;
var   k:byte;
     ok:boolean;
label  10;
begin
     case menu of
        1:begin
            if((sw1=1) or (sw3=1)) then epex_menu;
            cursor(true,false);
            sw1:=1;    i:=0;
            seek(k010_scr,1);     read(k010_scr,rec1);
            repeat
              move(rec1.xx[0],mem[$b000:ofs1],3680);
              gotoxy(22,2);
              writeln('E I ? A ? ? ? H  ? E ? O M E N ? N');
              i:=i+1;
              inp(i);
              gotoxy(21,23);
              write('?YNEXIZEI? ;  (N/O): ');
              read(kbd,cha);
            until cha in ['O','o','?','?'];
            clrscr;
            cursor(false,true);
            epex_menu;
          end;
        2:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1)) then
            begin
              wrt_screen(OthInp,1,20,80,22);
              gotoxy(13,21); read(name);
              assign(in_k010,name);
              {$i-}
              reset(in_k010);
              {$i+}
              ok:=(ioresult=0);
              if ok then
              begin
                gotoxy(2,23);
                write('??????? ! ?? ?????? ???? ???????. ?? ????? ????? ???; (?/?) ');
                read(kbd,cha);
                if cha in ['O','o','?','?'] then
                begin
                  cursor(false,true);
                  epex_menu;
                end;
              end;
              rewrite(in_k010);
              with in_rec do
              begin
                for k:=1 to i do
                begin
                  xaa:=xa[k]; yaa:=ya[k]; azz:=az[k]; sab:=s[k];
                  write(in_k010,in_rec);
                end;
              end;
              close(in_k010);
            end
            else
            begin
              gotoxy(14,21);
              write('?EN EKANE? EI?A???H ?E?OMEN?N.  ?????? ??? ???????..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
            gotoxy(1,21);     writeln;
            cursor(false,true);
            epex_menu;
          end;
        3:begin
            cursor(true,false);
            gotoxy(1,20);
            write('TO A?XEIO AYTO EINAI ?HMIOY???MENO ME EDITOR "H ME TO ??HKT?O F2; (E/F): ');
            read(cha);
            wrt_screen(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            if cha in ['F','f','?','?'] then
            begin
              assign(in_k010,filename);
              {$i-}
              reset(in_k010);
              {$i+}
              ok:=(ioresult=0);
              if not ok then
              begin
                gotoxy(2,23);
                write('??O?EXE !   TO A?XEIO AYTO ?EN Y?A?XEI. ?ATH?E ENA ??HKT?O..');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                cursor(false,true);
                epex_menu;
              end;
              i:=0;    sw3:=1;
              reset(in_k010);
              seek(in_k010,0);
              with rec2 do
              begin
                repeat
                  i:=i+1;
                  read(in_k010,rec2);
                  xa[i]:=xaa; ya[i]:=yaa; az[i]:=azz; s[i]:=sab;
                  epex(i);
                until eof(in_k010);
              end;
              close(in_k010);
            end
            else
            begin
              assign(f,filename);
              {$i-}
              reset(f);
              {$i+}
              ok:=(ioresult=0);
              if not ok then
              begin
                gotoxy(2,23);
                write('??O?EXE !   TO A?XEIO AYTO ?EN Y?A?XEI. ?ATH?E ENA ??HKT?O..');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                cursor(false,true);
                epex_menu;
              end;
              i:=0;    sw3:=1;
              reset(f);
              repeat
                i:=i+1;
                readln(f,a1); val(a1,xa[i],cod); readln(f,a2); val(a2,ya[i],cod);
                readln(f,a3); val(a3,az[i],cod); readln(f,a4); val(a4,s[i],cod);
                epex(i);
              until eof(f);
            end;
            cursor(false,true);
            epex_menu;
          end;
        4:begin
            cursor(true,false);
            if ((sw1 <> 1) and (sw3 <> 1)) then
            begin
              gotoxy(14,21);
              write('?EN EX? ?E?OMENA.  ?????? ??? ???????..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            sw4:=1;
            seek(k010_scr,1);     read(k010_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            gotoxy(22,2);
            write('? I O ? ? ? ? H  ? E ? O M E N ? N');
            for k:=1 to i do
            begin
              gotoxy(43,5);  write(xa[k]:2:3); gotoxy(43,9);  write(ya[k]:2:3);
              gotoxy(43,13); write(az[k]:2:4); gotoxy(43,17); write(s[k]:2:3);
              inp(k);
              gotoxy(21,23);
              write('?YNEXIZEI? ;  (N/O): ');
              read(kbd,cha);
              if cha in ['o','O'] then goto 10;
            end;
10:         cursor(false,true);
            clrscr;
            epex_menu;
          end;
        5:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              input_results_in_file;
              cursor(false,true);
              epex_menu;
            end
            else
            begin
              gotoxy(14,24);
              write('?EN EX? ?E?OMENA.  ?ATH?E ENA ??HKT?O..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              cursor(false,true);
              epex_menu;
            end;
          end;
        6:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              assign(fill,'prn');
              lprint;
              cursor(false,true);
              epex_menu;
            end
            else
            begin
              gotoxy(14,24);
              write('?EN EX? ?E?OMENA.  ?ATH?E ENA ??HKT?O..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              cursor(false,true);
              epex_menu;
            end;
          end;
        7:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              write_screen;
              cursor(false,true);
              epex_menu;
            end
            else
            begin
              gotoxy(14,24);
              write('?EN EX? ?E?OMENA.  ?ATH?E ENA ??HKT?O..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              cursor(false,true);
              epex_menu;
            end;
          end;
     end; { case }
end; { procedure }


BEGIN
clrscr;
ofs1:=$8000;
if mem[0:1040] and 48 = 48 then ofs1:=$0000;
assign(k010_scr,'DEYTERO.scr');
reset(k010_scr);
seek(k010_scr,3); read(k010_scr,rec1);
for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;
delete_all_input;
cursor(false,true);
epex_menu;
END.

{******************************************************************************
*              K042 ????????? ??????? ??????? ???? ???????                    *
*                            (? ??????????)                                   *
*                  WRITTEN BY G.XALARIS                       *
*                              20-11-1986                                     *
*******************************************************************************}

program  k042;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k042=record
           m    :byte;
           tet  :real;
           teta :real;
           ar_az:real;
           apos :real;
         end;
         rec2_k042=record
           kwdik:string[6];
           g_thl:real;
           dis  :real;
           dummy:real;
         end;
         string40 =string[40];
         string255=string[255];

var      xa,ya,ab,sb,thl,xap,yap:array [1..80] of real;
         xb      :real;
         yb      :real;
         az      :real;
         kwd     :array [1..80] of string[6];
         OthInp,OthPrint:array[1..3680] of byte;
         k042_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         pi      :real;
         fill    :text;

         f       :text;
         b1      :byte;
         b2      :string[10];
         b3      :string[11];
         b4      :string[8];
         b5      :string[10];
         b6      :string[6];
         b7      :string[8];
         b8      :string[10];

         in_k042 :file of rec1_k042;
         in1_rec :rec1_k042;
         in2_rec :rec2_k042 absolute in1_rec;

         sw1     :byte;
         sw3     :byte;
         sw4     :byte;
         cha     :char;

         sel     :integer;
         gram    :integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
var       metr:integer;
begin
  az:=0;
  fillchar(xa,sizeof(xa),0);   fillchar(ya,sizeof(ya),0);
  fillchar(ab,sizeof(ab),0);   fillchar(sb,sizeof(sb),0);
  fillchar(thl,sizeof(thl),0); fillchar(kwd,sizeof(kwd),0);
end;

procedure beep(freq,dur:integer);
begin
  sound(freq);
  delay(dur);
  nosound;
end;
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
     seek(k042_scr,0);
     read(k042_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         close(k042_scr);
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
                    cursor(true,false);
                    close(k042_scr);
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

procedure epex(j:byte);
begin
  pi:=arctan(1) * 4;
  ab[j]:=az + pi + (thl[j] * pi / 200);
  while (ab[j] > (2 * pi)) do ab[j]:=(ab[j] - (2 * pi));
  az:=ab[j];
  xap[j]:=xb;
  xb    :=xb + sb[j] * sin(az);
  yap[j]:=yb;
  yb    :=yb + sb[j] * cos(az);
end;

procedure display_data(l:byte);
begin
  gotoxy(21,13);    write('      ');
  gotoxy(21,13);    write(kwd[l]);
  gotoxy(35,13);    write('        ');
  gotoxy(35,13);    write(thl[l]:5:4);
  gotoxy(50,13);    write('          ');
  gotoxy(50,13);    write(sb[l]:5:3);
end;

procedure inp;
label    10,20,30,40,50,60,70;
begin
     pi:=arctan(1) * 4;
     if ((sw1 = 1) or (sw3 = 1)) then
     begin
       gotoxy(16,7);    write(xa[1]:5:3);
       gotoxy(28,7);    write(ya[1]:5:3);
       gotoxy(47,7);    write(ab[1] * 200 / pi:5:4);
       gotoxy(60,7);    write(sb[1]:5:3);
     end;
10:  input(buff,7,15,11,bit);
     val(buff,xa[1],cod);
20:  input(buff,7,27,11,bit);
     if bit then goto 10
       else val(buff,ya[1],cod);
30:  input(buff,7,46,9,bit);
     if bit then goto 20
       else val(buff,ab[1],cod);
     ab[1]:=ab[1] * pi / 200;
     az:=ab[1];
40:  input(buff,7,59,11,bit);
     if bit then goto 30
       else val(buff,sb[1],cod);
     xap[1]:=xa[1];
     xb    :=xa[1] + sb[1] * sin(az);
     yap[1]:=ya[1];
     yb    :=ya[1] + sb[1] * cos(az);
     kwd[1]:='??????';
     l:=2;
     while l <=i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
50:    input(buff,13,20,6.1,bit);
       if bit then
         if l = 2 then goto 40
         else
         begin
           l:=pred(l);
           if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
           goto 70;
         end
       else kwd[l]:=buff;
60:    input(buff,13,34,9,bit);
       if bit then goto 50
         else val(buff,thl[l],cod);
70:    input(buff,13,49,11,bit);
       if bit then goto 60
         else val(buff,sb[l],cod);
       epex(l);
       l:=succ(l);
       gotoxy(21,13);    write('      ');
       gotoxy(35,13);    write('        ');
       gotoxy(50,13);    write('          ');
     end;
end;

procedure input_results_in_file;
var   k  :integer;
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
    gotoxy(2,23);
    write('??O?EXE ! TO A?XEIO AYTO Y?A?XEI. NA GRA?? E?AN? TOY; (N/O) ');
    read(kbd,cha);
    if cha in ['O','o','?','?'] then exit;
  end;
  pi:=arctan(1) * 4;
  rewrite(fill);
  writeln(fill,'=============================================================================');
  writeln(fill,'    ??????????  ???????????  ???/???  ?????????  ??????  ???  ??????????');
  writeln(fill,'=============================================================================');
  writeln(fill,'???????   ?????????   ?????????    ?????   ??? ?????? ??????? ???? ?? ???????');
  writeln(fill,'???????    ???????     ???????     ??????     ?????????          ????????');
  for k:=1 to i do
  begin
    writeln(fill);  thl[1]:=0;
    writeln(fill,kwd[k],' ':7-length(kwd[k]),
            ' ',xap[k]:11:3,
            ' ',yap[k]:11:3,
            '   ',thl[k]:8:4,
            '    ',ab[k] * 200 / pi:9:4,
            ' ':8,sb[k]:10:3);
  end;
  writeln(fill);
  writeln(fill,'??????','  ',xb:11:3,' ',yb:11:3);
  close(fill);
end;

procedure write_screen;
var   k:integer;
begin
  pi:=arctan(1) * 4;
  clrscr;
  seek(k042_scr,2);    read(k042_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  thl[1]:=0;
  if i <= 15 then
  begin
    for k:=1 to i do
    begin
      gotoxy(2,6+k);    write('?       ?           ?           ?         ?                ?                 ?');
      gotoxy(3,6+k);    write(kwd[k]);
      gotoxy(12,6+k);    write(xap[k]:10:3);
      gotoxy(23,6+k);    write(yap[k]:11:3);
      gotoxy(36,6+k);    write(thl[k]:8:4);
      gotoxy(49,6+k);    write(ab[k] * 200 / pi:8:4);
      gotoxy(66,6+k);    writeln(sb[k]:10:3);
    end;
    gotoxy(2,7+k);    write('?       ?           ?           ?         ?                ?                 ?');
    gotoxy(3,7+k);    write('??????');
    gotoxy(12,7+k);    write(xb:10:3);
    gotoxy(23,7+k);    write(yb:11:3);
    writeln;
    write(' ??????????????????????????????????????????????????????????????????????????????');
    gotoxy(14,25);    write('??? ???????? ??? ???U ?????? ??? ???????..');
    repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
    clrscr;
    exit;
  end
  else
  begin
    if i <= 30 then
    begin
      for k:=1 to 15 do
      begin
        gotoxy(2,6+k);    write('?       ?           ?           ?         ?                ?                 ?');
        gotoxy(3,6+k);    write(kwd[k]);
        gotoxy(12,6+k);    write(xap[k]:10:3);
        gotoxy(23,6+k);    write(yap[k]:11:3);
        gotoxy(36,6+k);    write(thl[k]:8:4);
        gotoxy(49,6+k);    write(ab[k] * 200 / pi:8:4);
        gotoxy(66,6+k);    write(sb[k]:10:3);
      end;
      writeln;
      write(' ??????????????????????????????????????????????????????????????????????????????');
      gotoxy(14,25);    write('??? ???????? ????????????? ?????? ??? ???????..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      seek(k042_scr,2);    read(k042_scr,rec1);
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      for k:=16 to i do
      begin
        gotoxy(2,k-9);    write('?       ?           ?           ?         ?                ?                 ?');
        gotoxy(3,k-9);    write(kwd[k]);
        gotoxy(12,k-9);    write(xap[k]:10:3);
        gotoxy(23,k-9);    write(yap[k]:11:3);
        gotoxy(36,k-9);    write(thl[k]:8:4);
        gotoxy(49,k-9);    write(ab[k] * 200 / pi:8:4);
        gotoxy(66,k-9);    write(sb[k]:10:3);
      end;
      gotoxy(2,k-8);    write('?       ?           ?           ?         ?                ?                 ?');
      gotoxy(3,k-8);    write('??????');
      gotoxy(12,k-8);    write(xb:10:3);
      gotoxy(23,k-8);    write(yb:11:3);
      writeln;
      write(' ??????????????????????????????????????????????????????????????????????????????');
      gotoxy(14,25);    write('??? ???????? ??? ???U ?????? ??? ???????..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      exit;
    end;
    if i <= 45 then
    begin
      for k:=1 to 15 do
      begin
      gotoxy(2,6+k);    write('?       ?           ?           ?         ?                ?                 ?');
      gotoxy(3,6+k);    write(kwd[k]);
      gotoxy(12,6+k);    write(xap[k]:10:3);
      gotoxy(23,6+k);    write(yap[k]:11:3);
      gotoxy(36,6+k);    write(thl[k]:8:4);
      gotoxy(49,6+k);    write(ab[k] * 200 / pi:8:4);
      gotoxy(66,6+k);    write(sb[k]:10:3);
    end;
    writeln;
    write(' ??????????????????????????????????????????????????????????????????????????????');
      gotoxy(14,25);    write('??? ???????? ????????????? ?????? ??? ???????..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      seek(k042_scr,2);    read(k042_scr,rec1);
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      for k:=16 to 30 do
      begin
        gotoxy(2,k-9);    write('?       ?           ?           ?         ?                ?                 ?');
        gotoxy(3,k-9);    write(kwd[k]);
        gotoxy(12,k-9);    write(xap[k]:10:3);
        gotoxy(23,k-9);    write(yap[k]:11:3);
        gotoxy(36,k-9);    write(thl[k]:8:4);
        gotoxy(49,k-9);    write(ab[k] * 200 / pi:8:4);
        gotoxy(66,k-9);    write(sb[k]:10:3);
      end;
      writeln;
      write(' ??????????????????????????????????????????????????????????????????????????????');
      gotoxy(14,25);    write('??? ???????? ????????????? ?????? ??? ???????..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      seek(k042_scr,2);    read(k042_scr,rec1);
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      for k:=31 to i do
      begin
        gotoxy(2,k-24);    write('?       ?           ?           ?         ?                ?                 ?');
        gotoxy(3,k-24);    write(kwd[k]);
        gotoxy(12,k-24);    write(xap[k]:10:3);
        gotoxy(23,k-24);    write(yap[k]:11:3);
        gotoxy(36,k-24);    write(thl[k]:8:4);
        gotoxy(49,k-24);    write(ab[k] * 200 / pi:8:4);
        gotoxy(66,k-24);    write(sb[k]:10:3);
      end;
      gotoxy(2,k-23);    write('?       ?           ?           ?         ?                ?                 ?');
      gotoxy(3,k-23);    write('??????');
      gotoxy(12,k-23);    write(xb:10:3);
      gotoxy(23,k-23);    write(yb:11:3);
      writeln;
      write(' ??????????????????????????????????????????????????????????????????????????????');
      gotoxy(14,25);    write('??? ???????? ??? ???U ?????? ??? ???????..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      exit;
    end;
    if i <=60 then
    begin
      for k:=1 to 15 do
      begin
        gotoxy(2,6+k);    write('?       ?           ?           ?         ?                ?                 ?');
        gotoxy(3,6+k);    write(kwd[k]);
        gotoxy(12,6+k);    write(xap[k]:10:3);
        gotoxy(23,6+k);    write(yap[k]:11:3);
        gotoxy(36,6+k);    write(thl[k]:8:4);
        gotoxy(49,6+k);    write(ab[k] * 200 / pi:8:4);
        gotoxy(66,6+k);    write(sb[k]:10:3);
      end;
      writeln;
      write(' ??????????????????????????????????????????????????????????????????????????????');
      gotoxy(14,25);    write('??? ???????? ????????????? ?????? ??? ???????..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      seek(k042_scr,2);    read(k042_scr,rec1);
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      for k:=16 to 30 do
      begin
        gotoxy(2,k-9);    write('?       ?           ?           ?         ?                ?                 ?');
        gotoxy(3,k-9);    write(kwd[k]);
        gotoxy(12,k-9);    write(xap[k]:10:3);
        gotoxy(23,k-9);    write(yap[k]:11:3);
        gotoxy(36,k-9);    write(thl[k]:8:4);
        gotoxy(49,k-9);    write(ab[k] * 200 / pi:8:4);
        gotoxy(66,k-9);    write(sb[k]:10:3);
      end;
      writeln;
      write(' ??????????????????????????????????????????????????????????????????????????????');
      gotoxy(14,25);    write('??? ???????? ????????????? ?????? ??? ???????..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      seek(k042_scr,2);    read(k042_scr,rec1);
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      for k:=31 to 45 do
      begin
        gotoxy(2,k-24);    write('?       ?           ?           ?         ?                ?                 ?');
        gotoxy(3,k-24);    write(kwd[k]);
        gotoxy(12,k-24);    write(xap[k]:10:3);
        gotoxy(23,k-24);    write(yap[k]:11:3);
        gotoxy(36,k-24);    write(thl[k]:8:4);
        gotoxy(49,k-24);    write(ab[k] * 200 / pi:8:4);
        gotoxy(66,k-24);    write(sb[k]:10:3);
      end;
      writeln;
      write(' ??????????????????????????????????????????????????????????????????????????????');
      gotoxy(14,25);    write('??? ???????? ????????????? ?????? ??? ???????..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      seek(k042_scr,2);    read(k042_scr,rec1);
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      for k:=46 to i do
      begin
        gotoxy(2,k-39);    write('?       ?           ?           ?         ?                ?                 ?');
        gotoxy(3,k-39);    write(kwd[k]);
        gotoxy(12,k-39);    write(xap[k]:10:3);
        gotoxy(23,k-39);    write(yap[k]:11:3);
        gotoxy(36,k-39);    write(thl[k]:8:4);
        gotoxy(49,k-39);    write(ab[k] * 200 / pi:8:4);
        gotoxy(66,k-39);    write(sb[k]:10:3);
      end;
      gotoxy(2,k-38);    write('?       ?           ?           ?         ?                ?                 ?');
      gotoxy(3,k-38);    write('??????');
      gotoxy(12,k-38);    write(xb:10:3);
      gotoxy(23,k-38);    write(yb:11:3);
      writeln;
      write(' ??????????????????????????????????????????????????????????????????????????????');
      gotoxy(14,25);    write('??? ???????? ??? ???U ?????? ??? ???????..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      exit;
    end;
  end;
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'?????? : ',sel:1);
  writeln(fill);
  writeln(fill,'=============================================================================');
  writeln(fill,'    ??????????  ???????????  ???/???  ?????????  ??????  ???  ??????????');
  writeln(fill,'=============================================================================');
  writeln(fill,'???????   ?????????   ?????????    ?????   ??? ?????? ??????? ???? ?? ???????');
  writeln(fill,'???????    ???????     ???????     ??????     ?????????          ????????');
end;

procedure lprint;
var   sel,gram,k:integer;
begin
  pi:=arctan(1) * 4;
  rewrite(fill);
  epikef;
  gram:=8;
  for k:=1 to i do
  begin
    writeln(fill);  thl[1]:=0;
    writeln(fill,kwd[k],' ':7-length(kwd[k]),
            ' ',xap[k]:11:3,
            ' ',yap[k]:11:3,
            '   ',thl[k]:8:4,
            '    ',ab[k] * 200 / pi:9:4,
            ' ':8,sb[k]:10:3);
    gram:=gram + 2;
    if gram >= ar_gram - 4 then
    begin
      writeln(fill);
      writeln(fill);
      writeln(fill);
      writeln(fill);
      epikef;
      gram:=8;
    end;
    if k = i then
    begin
      writeln(fill);
      writeln(fill,'??????','  ',xb:11:3,' ',yb:11:3);
      writeln(fill);
      writeln(fill);
    end;
  end;
  close(fill);
end;

procedure epex_menu;
var  j,k:byte;
     ok :boolean;
label    10,15,20,25;
begin
     case menu of
        1:begin
            if ((sw1=1) or (sw3=1)) then epex_menu;
15:         gotoxy(14,21);
            cursor(true,false);
            write('???? ???????? ?????? ??????? (????? ??? ???????) : ');
            read(i);
            if ad then goto 15;
            if i > 60 then
            begin
              gotoxy(14,22);
              write('???????? ??????? ???????: 60   ?????? ??? ???????..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 20;
            end;
            clrscr;
            seek(k042_scr,1);     read(k042_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            gotoxy(15,2);
            write('?  ?  ?  ?  ?  ?  ?  ?     ?  ?  ?  O  ?  ?  ?  ?  ?');
            inp;
            sw1:=1;
20:         clrscr;
            cursor(false,true);
            epex_menu;
          end;
        2:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1)) then
            begin
              wrt_screen(OthInp,1,20,80,22);
              gotoxy(13,21); read(name);
              assign(in_k042,name);
              {$i-}
              reset(in_k042);
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
              rewrite(in_k042);
              with in1_rec do
              begin
                pi:=arctan(1) * 4;
                m:=i; tet:=xa[1]; teta:=ya[1]; ar_az:=ab[1]*200/pi; apos:=sb[1];
              end;
              write(in_k042,in1_rec);
              j:=1;
              repeat
                j:=j+1;
                pi:=arctan(1) * 4;
                with in2_rec do
                begin
                  kwdik:=kwd[j]; g_thl:=thl[j]; dis:=sb[j];
                end;
                write(in_k042,in1_rec);
              until j = i;
              close(in_k042);
            end
            else
            begin
              gotoxy(14,21);
              writeln('?EN EKANE? EI?A???H ?E?OMEN?N.  ?????? ??? ???????..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
            gotoxy(1,21);    writeln;
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
              assign(in_k042,filename);
              {$i-}
              reset(in_k042);
              {$i+}
              ok:=(ioresult=0);
              if not ok then
              begin
                gotoxy(2,23);
                write('??O?EXE !   TO A?XEIO AYTO ?EN Y?A?XEI. ?ATH?E ENA ??HKT?O..');
                repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
                cursor(false,true);
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(22,12,240,'? ? ? ? ? ? ?   ? ? ? ? ? ? ? ?..');
              reset(in_k042);
              seek(in_k042,0);
              with in1_rec do
              begin
                read(in_k042,in1_rec);
                i:=m; xa[1]:=tet; ya[1]:=teta; ab[1]:=ar_az; sb[1]:=apos;
              end;
              kwd[1]:='??????';
              pi:=arctan(1) * 4;
              ab[1]:=ab[1] * pi / 200;
              az:=ab[1];
              xap[1]:=xa[1];
              yap[1]:=ya[1];
              xb:=xa[1] + sb[1] * sin(az);
              yb:=ya[1] + sb[1] * cos(az);
              j:=1;
              repeat
                j:=j+1;
                read(in_k042,in1_rec);
                with in2_rec do
                begin
                  kwd[j]:=kwdik; thl[j]:=g_thl; sb[j]:=dis;
                end;
                epex(j);
              until j = i;
              close(in_k042);
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
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(22,12,240,'? ? ? ? ? ? ?   ? ? ? ? ? ? ? ?..');
              reset(f);
              readln(f,b1);    i:=b1;
              readln(f,b2);    val(b2,xa[1],cod);
              readln(f,b3);    val(b3,ya[1],cod);
              readln(f,b4);    val(b4,ab[1],cod);
              readln(f,b5);    val(b5,sb[1],cod);
              pi:=arctan(1) * 4;
              ab[1]:=ab[1] * pi / 200;
              az:=ab[1];
              xap[1]:=xa[1];
              yap[1]:=ya[1];
              xb:=xa[1] + sb[1] * sin(az);
              yb:=ya[1] + sb[1] * cos(az);
              kwd[1]:='??????';
              j:=1;
              repeat
                j:=j+1;
                readln(f,b6);    kwd[j]:=b6;
                readln(f,b7);    val(b7,thl[j],cod);
                readln(f,b8);    val(b8,sb[j],cod);
                epex(j);
              until j = i;
              close(f);
            end;
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
            seek(k042_scr,1);    read(k042_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            gotoxy(15,2);
            write('?  I  O  ?  ?  O  ?  H     ?  E  ?  O  M  E  N  ?  N');
            inp;
            repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
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
              wrt_screen(OthPrint,1,4,45,17);
25:           gotoxy(32,13);
              read(ar_gram);
              if ad then goto 25;
              gotoxy(3,15); write('???????????? ??? ???????? ?E ???? ???????');
              gotoxy(10,16); write('?????? RETURN ??? ????????');
              repeat read(kbd,cha) until cha in [#10,#13];
              cursor(false,true);
              assign(fill,'prn');
              clrscr;
              wrt(29,12,240,'?  ?  ?  ?  ?  ?  ?  ?..');
              lprint;
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
assign(k042_scr,'trito.scr');
reset(k042_scr);
seek(k042_scr,3); read(k042_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

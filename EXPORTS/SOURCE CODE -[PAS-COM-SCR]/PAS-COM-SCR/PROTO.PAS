{******************************************************************************
*             K009 ÕĞÏËÏÃÉÓÌÏÓ ÃÙÍÉÁÓ ÄÉÅÕÈÕÍÓÅÙÓ ÊÁÉ ÁĞÏÓÔÁÓÅÙÓ              *
*                            (A ÈÅÌÅËÉÙÄÅÓ)                                                 *
*                  WRITTEN BY G.XALARIS                         *
*                              15-11-1986                                     *
*******************************************************************************}
program  k009;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec_k009=record
           xaa,yaa,xbb,ybb:real;
         end;
         string40=string[40];
         string255=string[255];

var      xa      :array [1..500] of real;
         ya      :array [1..500] of real;
         xb      :array [1..500] of real;
         yb      :array [1..500] of real;
         azim    :array [1..500] of real;
         dist    :array [1..500] of real;
         a1,az   :real;
         dx,dy   :real;
         OthInp:array[1..3680] of byte;
         k009_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,j     :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         pii     :real;
         p       :real;
         fill    :text;

         f       :text;
         b1      :string[10];
         b2      :string[11];
         b3      :string[8];
         b4      :string[10];

         in_k009 :file of rec_k009;
         in_rec  :rec_k009;
         rec2    :rec_k009;

         sw1     :byte;
         sw3     :byte;
         sw4     :byte;
         cha     :char;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}
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
     seek(k009_scr,0);
     read(k009_scr,rec1);
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
         close(k009_scr);
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
                    close(k009_scr);
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
              else for i:=3 to 6 do beep(i*500,50);
       end; {case}
     end {if}
     else
       for i:=3 to 6 do beep(i*500,50);
     goto 5;
end;

procedure delete_all_input;
begin
  fillchar(xa,sizeof(xa),0);     fillchar(ya,sizeof(ya),0);
  fillchar(xb,sizeof(xb),0);     fillchar(yb,sizeof(yb),0);
  fillchar(azim,sizeof(azim),0); fillchar(dist,sizeof(dist),0);
end;

procedure epex(j:byte);
begin
  dx:=xb[j]-xa[j];
  dy:=yb[j]-ya[j];
  p:=3.141592654;
  if ((dx <> 0) or (dy <> 0)) then
  begin
    if dx < 0 then
    begin
      if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p+a1; end;
      if dy = 0 then begin az:=3*p/2; end;
      if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=2*p-a1; end;
    end;
    if dx = 0 then begin if dy < 0 then az:=p; if dy > 0 then az:=0; end;
    if dx > 0 then
    begin
      if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p-a1; end;
      if dy = 0 then begin az:=p/2; end;
      if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
    end;
    pii:=200/3.141592654;
    azim[j]:=az * pii;
    dist[j]:=sqrt(sqr(dx) + sqr(dy));
  end;
end;

procedure inp(j:byte);
label    10,20,30,40;
begin
10:  input(buff,5,42,10,bit);
     val(buff,xa[j],cod);
20:  input(buff,9,42,11,bit);
     if bit then goto 10 else val(buff,ya[j],cod);
30:  input(buff,13,42,10,bit);
     if bit then goto 20 else val(buff,xb[j],cod);
40:  input(buff,17,42,11,bit);
     if bit then goto 30 else val(buff,yb[j],cod);
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
    gotoxy(2,23);
    write('O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) ');
    read(kbd,cha);
    if cha in ['O','o','','¦'] then exit;
  end;
  rewrite(fill);
  writeln(fill,'==============================================================');
  writeln(fill,'        “OŠO‚I‘MO‘ ‚—Œˆ€‘ ƒˆ„“‡“Œ‘„—‘ ‰€ˆ €‘’€‘„—‘');
  writeln(fill,'                  € ’ˆ‘ ‘“Œ/Œ„‘ ’—Œ A‰—Œ');
  writeln(fill,'==============================================================');
  writeln(fill);
  writeln(fill);
  for k:=1 to i do
  begin
    dx:=xb[k] - xa[k];    dy:=yb[k] - ya[k];
    writeln(fill,'    TETMHMENH ‘HMEIOY A    XA       : ',xa[k]:5:3);
    writeln(fill,'    TETA‚MENH ‘HMEIOY A    YA       : ',ya[k]:5:3);
    writeln(fill,'    ’„’‹†‹„Œ† ‘†‹„ˆ“     •       : ',xb[k]:5:3);
    writeln(fill,'    ’„’€‚‹„Œ† ‘†‹„ˆ“     “       : ',yb[k]:5:3);
    writeln(fill);
    writeln(fill,'      A  O T E Š E ‘ M A T A');
    writeln(fill);
    if ((dx <> 0) or (dy <> 0)) then
    begin
      writeln(fill,'    €…ˆ‹“‡ˆ € ‘  (™˜Ÿ£¦¬ª) AZ = ',azim[k]:5:4);
      writeln(fill,'             €‘’€‘† S€           = ',dist[k]:5:3);
    end
    else
      writeln(fill,'           ’€ ‘†‹„ˆ€ ’€“’ˆ…Œ’€ˆ ');
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
  seek(k009_scr,2);    read(k009_scr,rec1);
  for k:=1 to i do
  begin
    dx:=xb[k] - xa[k];    dy:=yb[k] - ya[k];
    move(rec1.xx[0],mem[$b000:ofs1],3680);
    gotoxy(43,5);     write(xa[k]:5:3);
    gotoxy(43,9);     write(ya[k]:5:3);
    gotoxy(43,13);    write(xb[k]:5:3);
    gotoxy(43,17);    write(yb[k]:5:3);
    if ((dx <> 0) or (dy <> 0)) then
    begin
      gotoxy(43,20);    write(azim[k]:2:4);
      gotoxy(43,22);    write(dist[k]:2:3);
    end
    else
    begin
      gotoxy(43,20);    write('**********');
      gotoxy(58,20);    write('’€   ‘†‹„ˆ€');
      gotoxy(43,22);    write('**********');
      gotoxy(58,22);    write('’€“’ˆ…Œ’€ˆ');
    end;
    gotoxy(1,24);     write('AT†‘„ ENA ŠHKTO ‚IA ‘YNEXEIA..');
    repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
    clrscr;
  end;
end;

procedure lprint;
var   k:integer;
begin
  rewrite(fill);
  writeln(fill,'==============================================================');
  writeln(fill,'        YOŠO‚I‘MO‘ ‚—Œˆ€‘ ƒˆ„“‡“Œ‘„—‘ ‰€ˆ €‘’€‘„—‘');
  writeln(fill,'               € ’ˆ‘ ‘“Œ/Œ„‘ ’—Œ €‰—Œ');
  writeln(fill,'==============================================================');
  writeln(fill);
  writeln(fill);
  for k:=1 to i do
  begin
    dx:=xb[k] - xa[k];    dy:=yb[k] - ya[k];
    writeln(fill,'    TETMHMENH ‘HMEIOY A    XA       : ',xa[k]:5:3);
    writeln(fill,'    TETA‚MENH ‘HMEIOY A    YA       : ',ya[k]:5:3);
    writeln(fill,'    ’„’‹†‹„Œ† ‘†‹„ˆ“     •       : ',xb[k]:5:3);
    writeln(fill,'    ’„’€‚‹„Œ† ‘†‹„ˆ“     “       : ',yb[k]:5:3);
    writeln(fill);
    writeln(fill,'      A  O T E Š E ‘ M A T A');
    writeln(fill);
    if ((dx <> 0) or (dy <> 0)) then
    begin
      writeln(fill,'    €…ˆ‹“‡ˆ € ‘  (™˜Ÿ£¦¬ª) €… = ',azim[k]:5:4);
      writeln(fill,'             €‘’€‘†  €           = ',dist[k]:5:3);
    end
    else
      writeln(fill,'           ’€ ‘†‹„ˆ€ ’€“’ˆ…Œ’€ˆ');
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
            if ((sw1=1) or (sw3=1)) then epex_menu;
            cursor(true,false);
            sw1:=1;    i:=0;
            seek(k009_scr,1);     read(k009_scr,rec1);
            repeat
              move(rec1.xx[0],mem[$b000:ofs1],3680);
              gotoxy(22,2);
              writeln('E I ‘ A ‚ — ‚ H   ƒ E ƒ O M E N — N');
              i:=i+1;
              inp(i);
              gotoxy(21,23);
              write('‘YNEXIZEI‘ ;  (N/O): ');
              read(kbd,cha);
            until cha in ['O','o','','¦'];
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
              assign(in_k009,name);
              {$i-}
              reset(in_k009);
              {$i+}
              ok:=(ioresult=0);
              if ok then
              begin
                gotoxy(2,23);
                write('‘„•„ ! ’ €•„ˆ €“’ “€•„ˆ. Œ€ ‚€–— „€Œ— ’“; (Œ/) ');
                read(kbd,cha);
                if cha in ['O','o','','¦'] then
                begin
                  cursor(false,true);
                  epex_menu;
                end;
              end;
              rewrite(in_k009);
              with in_rec do
              begin
                for k:=1 to i do
                begin
                  xaa:=xa[k]; yaa:=ya[k]; xbb:=xb[k]; ybb:=yb[k];
                  write(in_k009,in_rec);
                end;
              end;
              close(in_k009);
            end
            else
            begin
              gotoxy(14,21);
              writeln('ƒEN EKANE‘ EI‘A‚—‚H ƒEƒOMEN—N.  €’†‘„ „Œ€ Š†‰’..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
            gotoxy(1,21);     writeln;
            cursor(false,true);
            epex_menu;
          end;
        3:begin
            cursor(true,false);
            gotoxy(1,20);
            write('TO AXEIO AYTO EINAI ƒHMIOY‚†MENO ME EDITOR "H ME TO ŠHKTO F2; (E/F): ');
            read(cha);
            wrt_screen(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k009,filename);
              {$i-}
              reset(in_k009);
              {$i+}
              ok:=(ioresult=0);
              if not ok then
              begin
                gotoxy(2,23);
                write('O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                cursor(false,true);
                epex_menu;
              end;
              i:=0;    sw3:=1;
              reset(in_k009);
              seek(in_k009,0);
              with rec2 do
              begin
                repeat
                  i:=i+1;
                  read(in_k009,rec2);
                  xa[i]:=xaa; ya[i]:=yaa; xb[i]:=xbb; yb[i]:=ybb; epex(i);
                until eof(in_k009);
              end;
              close(in_k009);
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
                write('O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                cursor(false,true);
                epex_menu;
              end;
              i:=0;    sw3:=1;
              reset(f);
              repeat
                i:=i+1;
                readln(f,b1);    val(b1,xa[i],cod);
                readln(f,b2);    val(b2,ya[i],cod);
                readln(f,b3);    val(b3,xb[i],cod);
                readln(f,b4);    val(b4,yb[i],cod);
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
              write('ƒEN EX— ƒEƒOMENA.  €’†‘„ „Œ€ Š†‰’..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            sw4:=1;
            seek(k009_scr,1);     read(k009_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            gotoxy(22,2);
            write('ƒ I O  ‡ — ‘ H   ƒ E ƒ O M E N — N');
            for k:=1 to i do
            begin
              gotoxy(43,5);     write(xa[k]:2:3);
              gotoxy(43,9);     write(ya[k]:2:3);
              gotoxy(43,13);    write(xb[k]:2:3);
              gotoxy(43,17);    write(yb[k]:2:3);
              inp(k);
              gotoxy(21,23);
              write('‘YNEXIZEI‘ ;  (N/O): ');
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
              write('ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
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
              write('ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
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
              write('ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
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
assign(k009_scr,'PROTO.scr');
reset(k009_scr);
seek(k009_scr,3); read(k009_scr,rec1);
for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;
cursor(false,true);
epex_menu;
END.

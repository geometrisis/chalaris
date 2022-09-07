{******************************************************************************
*                        k018 ÔÏÌÇ ĞÅÑÉÖÅÑÅÉÙÍ                               *
*                  WRITTEN BY G.XALARIS                       *
*                              04-12-1986                                     *
*******************************************************************************}
program  k018;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k018 =record
           tet1,teta1,akt1,tet2,teta2,akt2:real;
           kwdik:string[6];
         end;

         string40 =string[40];
         string255=string[255];

var      xm1,ym1,r1,xm2,ym2,r2,xs1,ys1,xs2,ys2 : array [1..500] of real;
         kwd : array [1..500] of string[6];
         dx,dy,s12,t12,par1,Par2,cosa2,sina2,a2,a,sg,p,a1,az:real;
         OthInp,OthPrint:array[1..3680] of byte;
         k018_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l,m   :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f:text;
         b1,b3,b4,b6:string[10];
         b2,b5:string[11];
         b7:string[6];

         in_k018 :file of rec1_k018;
         in1_rec :rec1_k018;

         sw1,sw3,sw4:byte;
         cha:char;

         sel,gram,scr_line1,k1:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
  fillchar(xm1,sizeof(xm1),0); fillchar(ym1,sizeof(ym1),0);
  fillchar(r1,sizeof(r1),0);   fillchar(xm2,sizeof(xm2),0);
  fillchar(ym2,sizeof(ym2),0); fillchar(r2,sizeof(r2),0);
  fillchar(kwd,sizeof(kwd),0); fillchar(xs1,sizeof(xs1),0);
  fillchar(ys1,sizeof(ys1),0); fillchar(xs2,sizeof(xs2),0);
  fillchar(ys2,sizeof(ys2),0);
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
     seek(k018_scr,0);
     read(k018_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         close(k018_scr);
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
                    paint_box(4,21,6,38,15);   paint_box(4,40,6,57,15);
                    paint_box(8,21,10,38,15);  paint_box(8,40,10,57,15);
                    paint_box(12,21,14,38,15); paint_box(12,40,14,57,15);
                    paint_box(16,21,18,38,15); paint_box(16,40,18,57,15);
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
                    close(k018_scr);
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
  '8','2',#72,#80:begin      { ArrUp , ArrDn }
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

procedure arctan;
begin
  p:=3.141592654;
  if dx < 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p+a1; end;
    if dy = 0 then az:=3*p/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=2*p-a1; end;
  end;
  if dx = 0 then begin if dy < 0 then az:=p; if dy > 0 then az:=0; end;
  if dx > 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p-a1; end;
    if dy = 0 then az:=p/2;
    if dy > 0 then
    begin a1:=arctan(abs(dx/dy)); az:=a1; end;
  end;
end;

procedure epex(j:integer);
begin
  dx:=xm2[j]-xm1[j]; dy:=ym2[j]-ym1[j]; arctan;
  s12:=sqrt(sqr(dx) + sqr(dy)); t12:=az;      { in radians }
  par1:=sqrt(sqr(r1[j] + s12) - sqr(r2[j]));
  par2:=sqrt(sqr(r2[j]) - sqr(r1[j] - s12));
  cosa2:=par1; sina2:=par2;
  dx:=par2; dy:=par1; arctan; a2:=az;
  a:=2 * a2;      { in radians }
  xs1[j]:=xm1[j]+r1[j]*sin(t12-a); ys1[j]:=ym1[j]+r1[j]*cos(t12-a);
  xs2[j]:=xm1[j]+r1[j]*sin(t12+a); ys2[j]:=ym1[j]+r1[j]*cos(t12+a);
  sg:=sin(a)*s12/r2[j];
end;

procedure display_data(l:integer);
begin
  wrt(11,11,15,'          ');  gotoxy(11,11); write(xm1[l]:4:3);
  wrt(27,11,15,'           '); gotoxy(27,11); write(ym1[l]:4:3);
  wrt(43,11,15,'          ');  gotoxy(43,11); write(r1[l]:4:3);
  wrt(11,20,15,'          ');  gotoxy(11,20); write(xm2[l]:4:3);
  wrt(27,20,15,'           '); gotoxy(27,20); write(ym2[l]:4:3);
  wrt(43,20,15,'          ');  gotoxy(43,20); write(r2[l]:4:3);
  wrt(62,20,15,'      ');      gotoxy(62,20); write(kwd[l]);
end;

procedure inp(l:integer);
label     10,20,30,40,50,60,70;
begin
10:    input(buff,11,10,11,bit); val(buff,xm1[l],cod);
20:    input(buff,11,26,12,bit);
       if bit then goto 10 else val(buff,ym1[l],cod);
30:    input(buff,11,42,11,bit);
       if bit then goto 20 else val(buff,r1[l],cod);
40:    input(buff,20,10,11,bit);
       if bit then goto 30 else val(buff,xm2[l],cod);
50:    input(buff,20,26,12,bit);
       if bit then goto 40 else val(buff,ym2[l],cod);
60:    input(buff,20,42,11,bit);
       if bit then goto 50 else val(buff,r2[l],cod);
70:    input(buff,20,61,7.1,bit);
       if bit then goto 60 else kwd[l]:=buff;
       dx:=xm2[l]-xm1[l]; dy:=ym2[l]-xm2[l];
       if (dx=0) and (dy=0) then
       begin
         wrt(13,22,112,'‘„•„!! ˆ ‰“‰Šˆ ’€“’ˆ…Œ’€ˆ. €’†‘„ „Œ€ Š†‰’..');
         repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
         wrt(13,22,15,'                                                     ');
         goto 10;
       end;
       epex(l);
end;

procedure diorth;
label     10,20,30,40,50,60,70;
begin
       l:=1;
       while l <= i do
       begin
         display_data(l);
10:      input(buff,11,10,11,bit);
         if bit then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l);
           goto 70;
         end
         else val(buff,xm1[l],cod);
20:      input(buff,11,26,12,bit);
         if bit then goto 10 else val(buff,ym1[l],cod);
30:      input(buff,11,42,11,bit);
         if bit then goto 20 else val(buff,r1[l],cod);
40:      input(buff,20,10,11,bit);
         if bit then goto 30 else val(buff,xm2[l],cod);
50:      input(buff,20,26,12,bit);
         if bit then goto 40 else val(buff,ym2[l],cod);
60:      input(buff,20,42,11,bit);
         if bit then goto 50 else val(buff,r2[l],cod);
70:      input(buff,20,61,7.1,bit);
         if bit then goto 60 else kwd[l]:=buff;
         epex(l);
         wrt(11,11,15,'          ');
         wrt(27,11,15,'           ');
         wrt(43,11,15,'          ');
         wrt(11,20,15,'          ');
         wrt(27,20,15,'           ');
         wrt(43,20,15,'          ');
         wrt(62,20,15,'      ');
         l:=succ(l);
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
       wrt(9,23,15,'O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) : ');
       gotoxy(71,23); read(kbd,cha);
       if cha in ['O','o','','¦'] then
       begin
         cursor(false,true);
         exit;
       end;
     end;
     clrscr;
     cursor(false,true);
     wrt(11,12,240,'  ‚  € ” —   €   ’ „ Š „ ‘ ‹ € ’ €   ‘ „   €  • „ ˆ   ');
     rewrite(fill);
     writeln(fill,'====================================================================');
     writeln(fill,'      € Œ € Š “ ’ ˆ ‰ †  ’  ‹ †  ƒ “    „  ˆ ” „  „ ˆ — Œ ');
     writeln(fill,'====================================================================');
     writeln(fill);
     writeln(fill,' ‰—ƒˆ‰‘            S  E  T   1                   S  E  T   2');
     writeln(fill,'  ’‹—Œ      ’„’‹†‹„Œ†       ’„’€‚‹„Œ†     ’„’‹†‹„Œ†       ’„’€‚‹„Œ†');
     writeln(fill,' -------     -------------------------     -------------------------');
     for l:=1 to i do writeln(fill,'  ',kwd[l],' ':10 - length(kwd[l]),
     xs1[l]:10:3,'     ',ys1[l]:11:3, '    ',xs2[l]:10:3, '     ',ys2[l]:11:3);
     close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
gotoxy(10,grammi); write(kwd[k]);      gotoxy(23,grammi); write(xs1[k]:10:3);
gotoxy(36,grammi); write(ys1[k]:11:3); gotoxy(51,grammi); write(xs2[k]:10:3);
gotoxy(64,grammi); write(ys2[k]:11:3);
end;

procedure write_screen(var scr_line,k1:integer);
var k:integer;
begin
  clrscr;
  seek(k018_scr,2);    read(k018_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  scr_line:=7;
  for k:=1 to i do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 22 then
    begin
      wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=7;
    end;
  end;
  wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
  writeln(fill,'====================================================================');
  writeln(fill,'      € Œ € Š “ ’ ˆ ‰ †  ’  ‹ †  ƒ “    „  ˆ ” „  „ ˆ — Œ ');
  writeln(fill,'====================================================================');
  writeln(fill);
  writeln(fill,' ‰—ƒˆ‰‘            S  E  T   1                   S  E  T   2');
  writeln(fill,'  ’‹—Œ      ’„’‹†‹„Œ†       ’„’€‚‹„Œ†     ’„’‹†‹„Œ†       ’„’€‚‹„Œ†');
  writeln(fill,' -------     -------------------------     -------------------------');
end;

procedure lprint;
var       k:integer;
begin
  rewrite(fill);
  epikef;
  gram:=10;
  for l:=1 to i do
  begin
    writeln(fill);
    writeln(fill,'  ',kwd[l],' ':10 - length(kwd[l]),xs1[l]:10:3,
            '     ',ys1[l]:11:3,'    ',xs2[l]:10:3,'     ',ys2[l]:11:3);
    gram:=gram + 2;
    if gram >= ar_gram - 4 then
    begin
      writeln(fill); writeln(fill); writeln(fill); writeln(fill);
      epikef; gram:=10;
    end;
  end;
  close(fill);
end;

procedure epex_menu;
var  j,k:byte;
     ok :boolean;
label    10,25;
begin
     case menu of
        1:begin
            if ((sw1=1) or (sw3=1)) then epex_menu;
            cursor(true,false);
            seek(k018_scr,1);     read(k018_scr,rec1);
            repeat
              move(rec1.xx[0],mem[$b000:ofs1],3680);
              wrt(14,2,112,'„  ˆ  ‘  €  ‚  —  ‚  †');
              i:=i+1;
              inp(i);
              wrt(20,22,15,'‘“Œ„•ˆ…„ˆ‘ ‹„ Œ„„‘ „ˆ”„„ˆ„‘; (N/O): ');
              gotoxy(59,22);   read(cha);
            until cha in ['o','O'];
            sw1:=1;
            clrscr;
            cursor(false,true);
            epex_menu;
          end;
        2:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              wrt_screen(OthInp,1,20,80,22);
              gotoxy(13,21); read(name);
              assign(in_k018,name);
              {$i-}
              reset(in_k018);
              {$i+}
              ok:=(ioresult=0);
              if ok then
              begin
                wrt(9,23,15,'‘„•„ ! ’ €•„ˆ €“’ “€•„ˆ. Œ€ ‚€–— „€Œ— ’“; (Œ/) : ');
                gotoxy(71,23);    read(kbd,cha);
                if cha in ['O','o','','¦'] then
                begin
                  cursor(false,true);
                  epex_menu;
                end;
              end;
              clrscr;
              cursor(false,true);
              wrt(11,12,240,'  ‰ € ’ € • —  —   ƒ „ ƒ  ‹ „ Œ €   ‘ „   €  • „ ˆ   ');
              rewrite(in_k018);
              j:=0;
              repeat
                j:=j+1;
                with in1_rec do
                begin
                  tet1:=xm1[j]; teta1:=ym1[j]; akt1:=r1[j];
                  tet2:=xm2[j]; teta2:=ym2[j]; akt2:=r2[j];
                  kwdik:=kwd[j]; write(in_k018,in1_rec);
                end;
              until j = i;
              close(in_k018);
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ƒEN EKANE‘ EI‘A‚—‚H ƒEƒOMEN—N.  €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
            epex_menu;
          end;
        3:begin
            cursor(true,false);
            wrt(1,20,15,'TO AXEIO AYTO EINAI ƒHMIOY‚†MENO ME EDITOR "H ME TO ŠHKTO F2; (E/F): ');
            gotoxy(73,20);    read(cha);
            wrt_screen(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k018,filename);
              {$i-}
              reset(in_k018);
              {$i+}
              ok:=(ioresult=0);
              if not ok then
              begin
                cursor(false,true);
                wrt(12,23,240,'  O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..  ');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..  ');
              reset(in_k018);
              seek(in_k018,0);
              l:=0;
              repeat
                l:=l+1;
                read(in_k018,in1_rec);
                with in1_rec do
                begin
                  xm1[l]:=tet1; ym1[l]:=teta1; r1[l]:=akt1;
                  xm2[l]:=tet2; ym2[l]:=teta2; r2[l]:=akt2;
                  kwd[l]:=kwdik;      epex(l);
                end;
              until  eof(in_k018);
              i:=l;
              close(in_k018);
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
                cursor(false,true);
                wrt(12,23,240,'  O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..  ');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..  ');
              reset(f);
              j:=0;
              repeat
                j:=j+1;
                readln(f,b1); val(b1,xm1[j],cod);
                readln(f,b2); val(b2,ym1[j],cod);
                readln(f,b3); val(b3,r1[j],cod);
                readln(f,b4); val(b4,xm2[j],cod);
                readln(f,b5); val(b5,ym2[j],cod);
                readln(f,b6); val(b6,r2[j],cod);
                readln(f,b7); kwd[j]:=b7;
                epex(j);
              until eof(f);
              i:=j;
              close(f);
            end;
            epex_menu;
          end;
        4:begin
            if ((sw1 <> 1) and (sw3 <> 1)) then
            begin
              wrt(19,21,240,'  ƒEN EX— ƒEƒOMENA. €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            cursor(true,false);
            sw4:=1;
            seek(k018_scr,1);    read(k018_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            wrt(14,2,112,'ƒ  I  O    ‡  —  ‘  H');
            diorth;
10:         cursor(false,true);
            clrscr;
            epex_menu;
          end;
        5:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              input_results_in_file;
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(19,21,240,'  ƒEN EX— ƒEƒOMENA. ATH‘E ENA ŠHKTO..  ');
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
              wrt(19,21,240,'  ƒEN EX— ƒEƒOMENA. ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
        7:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              cursor(false,true);
              scr_line1:=7;   k1:=1;
              write_screen(scr_line1,k1);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(19,21,240,'  ƒEN EX— ƒEƒOMENA. ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
     end; { case }
end; { procedure }


BEGIN
clrscr;
ofs1:=$8000;
if mem[0:1040] and 48 = 48 then ofs1:=$0000;
assign(k018_scr,'TOMHKK.scr');
reset(k018_scr);
seek(k018_scr,3); read(k018_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;    gram:=0;
delete_all_input;
cursor(false,true);
epex_menu;
END.

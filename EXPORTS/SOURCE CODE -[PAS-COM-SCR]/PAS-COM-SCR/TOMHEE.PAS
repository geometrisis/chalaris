{******************************************************************************
*                       k011 ÔÏÌÇ ÅÕÈÅÉÙÍ ÁÍÁËÕÔÉÊÁ                               *
*                  WRITTEN BY G.XALARIS                        *
*                             VERSION 1.03                                    *
*                              03-12-1986                                     *
*******************************************************************************}
program  k011;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k011=record
           tet1,teta1,tet2,teta2,tet3,teta3,tet4,teta4   :real;
           metr_ded:integer;
         end;
         rec2_k011=record
           ap1,ap2:real;
           kwdik:string[6];
           dummy:string[30];
         end;
         string40  =string[40];
         string255 =string[255];

var      x1,y1,x2,y2,x3,y3,x4,y4 : array [1..50] of real;
         a1,a2,xs,ys : array [1..50,1..10] of real;
         kwd : array [1..50,1..10] of string[6];
         metr_ded_ap : array [1..50] of integer;
         ya,xa,yb,xb,yg,xg,sa,sb,r1,r2,p1,p2,
         cf,s1,s2,sp,sg,x,y,o1,o2,o3,o4 : real;
         OthInp,OthPrint:array[1..3680] of byte;
         k011_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l,m   :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f  :text;
         b1,b3,b5,b7,b9,b10,b11 : string[10];
         b2,b4,b6,b8 : string[11];
         b12:string[6];

         in_k011     :file of rec1_k011;
         in1_rec     :rec1_k011;
         in2_rec     :rec2_k011 absolute in1_rec;

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
  fillchar(x1,sizeof(x1),0); fillchar(y1,sizeof(y1),0);
  fillchar(x2,sizeof(x2),0); fillchar(y2,sizeof(y2),0);
  fillchar(x3,sizeof(x3),0); fillchar(y3,sizeof(y3),0);
  fillchar(x4,sizeof(x4),0); fillchar(y4,sizeof(y4),0);
  fillchar(a1,sizeof(a1),0); fillchar(a2,sizeof(a2),0);
  fillchar(xs,sizeof(xs),0); fillchar(ys,sizeof(ys),0);
  fillchar(kwd,sizeof(kwd),0);
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
     seek(k011_scr,0);
     read(k011_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         close(k011_scr);
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
                    close(k011_scr);
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

procedure epex(j,m:integer);
begin
  ya:=y3[j]-y1[j]; xa:=x4[j]-x3[j]; yb:=y4[j]-y3[j];
  xb:=x3[j]-x1[j]; yg:=y2[j]-y1[j]; xg:=x2[j]-x1[j];
  sa:=sqrt(sqr(xg)+sqr(yg)); sb:=sqrt(sqr(xa)+sqr(yb));
  r1:=ya*xa; r2:=yb*xb; p1:=yg*xa; p2:=yb*xg;
  if (p1=p2) then cf:=0 else cf:=((r1-r2)/(p1-p2));
  s1:=yg*xa; s2:=yb*xg; sp:=sa*sb; sg:=s1-s2; sg:=sg/sp;
  x:=x1[j]+(cf*xg); y:=y1[j]+(cf*yg);
  o1:=(a2[j,m]/sg)*(xg/sa); o2:=(a1[j,m]/sg)*(xa/sb);
  o3:=(a2[j,m]/sg)*(yg/sa); o4:=(a1[j,m]/sg)*(yb/sb);
  xs[j,m]:=x-o1+o2; ys[j,m]:=y-o3+o4;
end;

procedure display_data(l,m:integer);
begin
  wrt(11,9,15,'          ');   gotoxy(11,9);  write(x1[l]:4:3);
  wrt(27,9,15,'           ');  gotoxy(27,9);  write(y1[l]:4:3);
  wrt(43,9,15,'          ');   gotoxy(43,9);  write(x2[l]:4:3);
  wrt(59,9,15,'           ');  gotoxy(59,9);  write(y2[l]:4:3);
  wrt(11,15,15,'          ');  gotoxy(11,15); write(x3[l]:4:3);
  wrt(27,15,15,'           '); gotoxy(27,15); write(y3[l]:4:3);
  wrt(43,15,15,'          ');  gotoxy(43,15); write(x4[l]:4:3);
  wrt(59,15,15,'           '); gotoxy(59,15); write(y4[l]:4:3);
  wrt(19,20,15,'          ');  gotoxy(19,20); write(a1[l,m]:4:3);
  wrt(35,20,15,'          ');  gotoxy(35,20); write(a2[l,m]:4:3);
  wrt(51,20,15,'     ');       gotoxy(51,20); write(kwd[l,m]);
end;

procedure inp(l:integer);
label     10,20,30,40,50,60,70,80,90,100,110,120;
begin
10:    input(buff,9,10,11,bit); val(buff,x1[l],cod);
20:    input(buff,9,26,12,bit);
       if bit then goto 10 else val(buff,y1[l],cod);
30:    input(buff,9,42,11,bit);
       if bit then goto 20 else val(buff,x2[l],cod);
40:    input(buff,9,58,12,bit);
       if bit then goto 30 else val(buff,y2[l],cod);
50:    input(buff,15,10,11,bit);
       if bit then goto 40 else val(buff,x3[l],cod);
60:    input(buff,15,26,12,bit);
       if bit then goto 50 else val(buff,y3[l],cod);
70:    input(buff,15,42,11,bit);
       if bit then goto 60 else val(buff,x4[l],cod);
80:    input(buff,15,58,12,bit);
       if bit then goto 70 else val(buff,y4[l],cod);
       m:=0;
       repeat
         m:=m + 1;
         if m = 10 then
         begin
           wrt(11,22,112,' ‘„•„ !! ');
           wrt(23,22,15,' ƒˆŒ„ˆ‘ ’ˆ‘ ’„Š„“’€ˆ„‘ „“‡„ˆ„‘ ‰€ˆ €‘’€‘„ˆ‘ ');
         end;
90:      input(buff,20,18,11,bit);
         if bit then
           if m = 1 then goto 80
           else
           begin
             m:=pred(m);
             goto 110;
           end
         else val(buff,a1[l,m],cod);
100:     input(buff,20,34,11,bit);
         if bit then goto 90 else val(buff,a2[l,m],cod);
110:     input(buff,20,50,7.1,bit);
         if bit then goto 100 else kwd[l,m]:=buff;
         epex(l,m);
         if m = 10 then goto 120;
         wrt(21,22,15,'‘“Œ„•ˆ…„ˆ‘ ‹„ Œ„„‘ €‘’€‘„ˆ‘; (N/O): ');
         gotoxy(59,22);    read(cha);
         wrt(19,20,15,'          ');
         wrt(35,20,15,'          ');
         wrt(51,20,15,'     ');
         wrt(59,22,15,'       ');
       until cha in ['o','O'];
120:   metr_ded_ap[l]:=m;
       l:=succ(l);
end;

procedure diorth;
label     10,20,30,40,50,60,70,80,90,100,110;
begin
       l:=1;
       while l <= i do
       begin
         display_data(l,1);
10:      input(buff,9,10,11,bit);
         if bit then
         begin
           l:=pred(1);
           if l = 0 then l:=1;
           display_data(l,1);
           goto 80;
         end
         else val(buff,x1[l],cod);
20:      input(buff,9,26,12,bit);
         if bit then goto 10 else val(buff,y1[l],cod);
30:      input(buff,9,42,11,bit);
         if bit then goto 20 else val(buff,x2[l],cod);
40:      input(buff,9,58,12,bit);
         if bit then goto 30 else val(buff,y2[l],cod);
50:      input(buff,15,10,11,bit);
         if bit then goto 40 else val(buff,x3[l],cod);
60:      input(buff,15,26,12,bit);
         if bit then goto 50 else val(buff,y3[l],cod);
70:      input(buff,15,42,11,bit);
         if bit then goto 60 else val(buff,x4[l],cod);
80:      input(buff,15,58,12,bit);
         if bit then goto 70 else val(buff,y4[l],cod);
         m:=1;
         while m <= metr_ded_ap[l] do
         begin
           display_data(l,m);
90:        input(buff,20,18,11,bit);
           if bit then
           begin
             if m = 1 then
             begin
                if l = 1 then goto 80;
                l:=l-1;
                m:=metr_ded_ap[l];
                display_data(l,m);
                goto 110;
             end
             else
             begin
               m:=pred(m);
               display_data(l,m);
               goto 110;
             end;
           end
           else val(buff,a1[l,m],cod);
100:       input(buff,20,34,11,bit);
           if bit then goto 90 else val(buff,a2[l,m],cod);
110:       input(buff,20,50,7.1,bit);
           if bit then goto 100 else kwd[l,m]:=buff;
           epex(l,m);
           wrt(19,20,15,'          ');
           wrt(35,20,15,'          ');
           wrt(51,20,15,'     ');
           wrt(59,22,15,'       ');
           m:=succ(m);
         end;
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
       gotoxy(2,23); write('O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) : ');
       read(kbd,cha);
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
     writeln(fill,'=============================================================');
     writeln(fill,'         ’  ‹ †   „ “ ‡ „ ˆ — Œ   € Œ € Š “ ’ ˆ ‰ A');
     writeln(fill,'=============================================================');
     writeln(fill);
     writeln(fill,'‰—ƒˆ‰‘    €‘’€‘†     €‘’€‘†    ’„’‹†‹„Œ†    ’„’€‚‹„Œ†');
     writeln(fill,' ’‹†‘      (ñ) A1       (ñ) A2       ’‹†‘        ’‹†‘ ');
     for l:=1 to i do for k:=1 to metr_ded_ap[l] do
       writeln(fill,kwd[l,k],' ':7-length(kwd[l,k]),
       '  ',a1[l,k]:10:3,'   ',a2[l,k]:10:3,
       '   ',xs[l,k]:10:3,'  ',ys[l,k]:11:3);
     close(fill);
end;

procedure anal_gr_scr(grammi,k,l:integer);
begin
gotoxy(11,grammi); write(kwd[k,l]);     gotoxy(24,grammi); write(a1[k,l]:10:3);
gotoxy(38,grammi); write(a2[k,l]:10:3); gotoxy(52,grammi); write(xs[k,l]:10:3);
gotoxy(65,grammi); write(ys[k,l]:11:3);
end;

procedure write_screen(var scr_line,k1:integer);
var k:integer;
begin
  clrscr;
  seek(k011_scr,2);    read(k011_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  scr_line:=7;
  for k:=1 to i do
  begin
    for l:=1 to metr_ded_ap[k] do
    begin
      anal_gr_scr(scr_line,k,l);
      scr_line:=scr_line + 1;
      if scr_line = 22 then
      begin
        wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
        repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
        move(rec1.xx[0],mem[$b000:ofs1],3680);
        scr_line:=7;
      end;
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
  writeln(fill,'=============================================================');
  writeln(fill,'         ’  ‹ †   „ “ ‡ „ ˆ — Œ   € Œ € Š “ ’ ˆ ‰ A');
  writeln(fill,'=============================================================');
  writeln(fill);
  writeln(fill,'‰—ƒˆ‰‘    €‘’€‘†     €‘’€‘†    ’„’‹†‹„Œ†    ’„’€‚‹„Œ†');
  writeln(fill,' ’‹†‘      (ñ) A1       (ñ) A2       ’‹†‘        ’‹†‘ ');
  writeln(fill,'-------    --------     --------    ---------    ---------');
end;

procedure lprint;
var       k:integer;
begin
  rewrite(fill);
  epikef;
  gram:=10;
  for k:=1 to i do
  begin
    for l:=1 to metr_ded_ap[k] do
    begin
      writeln(fill);
      writeln(fill,kwd[k,l],' ':7-length(kwd[k,l]),
              '  ',a1[k,l]:10:3,'   ',a2[k,l]:10:3,
              '   ',xs[k,l]:10:3,'  ',ys[k,l]:11:3);
      gram:=gram + 2;
      if gram >= ar_gram - 2 then
      begin writeln(fill); writeln(fill); epikef; gram:=10; end;
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
            clrscr;
            cursor(true,false);
            seek(k011_scr,1);     read(k011_scr,rec1);
            repeat
              move(rec1.xx[0],mem[$b000:ofs1],3680);
              wrt(14,2,112,'„  ˆ  ‘  €  ‚  —  ‚  †');
              i:=i+1;
              inp(i);
              wrt(22,23,15,'„•„’„ €ŠŠ† ‹€ƒ€ ƒ„ƒ‹„Œ—Œ; (N/O): ');
              gotoxy(57,23);    read(cha);
            until cha in ['o','O'];
            sw1:=1;
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
              assign(in_k011,name);
              {$i-}
              reset(in_k011);
              {$i+}
              ok:=(ioresult=0);
              if ok then
              begin
                gotoxy(2,23); write('‘„•„ ! ’ €•„ˆ €“’ “€•„ˆ. Œ€ ‚€–— „€Œ— ’“; (Œ/) : ');
                read(kbd,cha);
                if cha in ['O','o','','¦'] then
                begin
                  cursor(false,true);
                  epex_menu;
                end;
              end;
              clrscr;
              cursor(false,true);
              wrt(11,12,240,'  ‰ € ’ € • —  —   ƒ „ ƒ  ‹ „ Œ €   ‘ „   €  • „ ˆ   ');
              rewrite(in_k011);
              j:=0;
              repeat
                j:=j+1;
                with in1_rec do
                begin
                  tet1:=x1[j]; teta1:=y1[j]; tet2:=x2[j]; teta2:=y2[j];
                  tet3:=x3[j]; teta3:=y3[j]; tet4:=x4[j]; teta4:=y4[j];
                  metr_ded:=metr_ded_ap[j];  write(in_k011,in1_rec);
                end;
                l:=0;
                repeat
                  l:=l+1;
                  with in2_rec do
                  begin
                    ap1:=a1[j,l]; ap2:=a2[j,l];
                    kwdik:=kwd[j,l]; write(in_k011,in1_rec);
                  end;
                until l=metr_ded_ap[j];
              until j=i;
              close(in_k011);
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
              assign(in_k011,filename);
              {$i-}
              reset(in_k011);
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
              reset(in_k011);
              seek(in_k011,0);
              l:=0;
              repeat
                l:=l+1;
                read(in_k011,in1_rec);
                with in1_rec do
                begin
                  x1[l]:=tet1; y1[l]:=teta1; x2[l]:=tet2; y2[l]:=teta2;
                  x3[l]:=tet3; y3[l]:=teta3; x4[l]:=tet4; y4[l]:=teta4;
                  metr_ded_ap[l]:=metr_ded;
                end;
                j:=0;
                repeat
                  j:=j+1;
                  read(in_k011,in1_rec);
                  with in2_rec do
                  begin a1[l,j]:=ap1; a2[l,j]:=ap2; kwd[l,j]:=kwdik; end;
                  epex(l,j);
                until j=metr_ded_ap[l];
              until  eof(in_k011);
              i:=l;
              close(in_k011);
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
                readln(f,b1); val(b1,x1[j],cod);
                readln(f,b2); val(b2,y1[j],cod);
                readln(f,b3); val(b3,x2[j],cod);
                readln(f,b4); val(b4,y2[j],cod);
                readln(f,b5); val(b5,x3[j],cod);
                readln(f,b6); val(b6,y3[j],cod);
                readln(f,b7); val(b7,x4[j],cod);
                readln(f,b8); val(b8,y4[j],cod);
                readln(f,b9); val(b9,metr_ded_ap[j],cod);
                l:=0;
                repeat
                  l:=l+1;
                  readln(f,b10); val(b10,a1[j,l],cod);
                  readln(f,b11); val(b11,a2[j,l],cod);
                  readln(f,b12); kwd[j,l]:=b12;
                  epex(j,l);
                until l = metr_ded_ap[j];
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
            seek(k011_scr,1);    read(k011_scr,rec1);
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
25:           WRT_SCREEN(OthPrint,1,4,45,17);
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
assign(k011_scr,'TOMHEE.scr');
reset(k011_scr);
seek(k011_scr,3); read(k011_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;    gram:=0;
delete_all_input;
cursor(false,true);
epex_menu;
END.

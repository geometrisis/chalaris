{******************************************************************************
*                      k017 ÔÏÌÇ ÅÕÈÅÉÁÓ ÊÁÉ ÊÕÊËÏÕ                             *
*                  WRITTEN BY G.XALARIS                      *
*                             VERSION 1.02                                    *
*                              03-12-1986                                     *
*******************************************************************************}
program  k017;

type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k017 =record
           tet1,teta1,akt:real;
           metr_ded:integer;
           dummy:string[9];
         end;
         rec2_k017 =record
           tet2,teta2,tet3,teta3,ap:real;
         end;
         string40 =string[40];
         string255=string[255];

var      xm,ym,r : array [1..50] of real;
         x1,y1,x2,y2,a,xs1,ys1,xs2,ys2 : array [1..50,1..10] of real;
         metr_ded_ap : array [1..50] of integer;

         OthInp,OthPrint:array[1..3680] of byte;
         pi,pii,dist,dx,dy,s12,t12,t12100,xh,
         yh,shm,thm,gona,d,s2,shs,sg,p,a1,az : real;

         k017_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l,m,ar_gram:integer;
         buff  :string40;
         bit,ok:boolean;
         name,filename:string[66];
         fill,f:text;
         b1,b3,b4,b5,b7,b9 : string[10];
         b2,b6,b8 : string[11];

         in_k017:file of rec1_k017;
         in1_rec:rec1_k017;
         in2_rec:rec2_k017 absolute in1_rec;

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
  fillchar(xm,sizeof(xm),0); fillchar(ym,sizeof(ym),0);
  fillchar(r,sizeof(r),0);   fillchar(x1,sizeof(x1),0);
  fillchar(y1,sizeof(y1),0); fillchar(x2,sizeof(x2),0);
  fillchar(y2,sizeof(y2),0); fillchar(a,sizeof(a),0);
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
     seek(k017_scr,0);
     read(k017_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         close(k017_scr);
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
                    paint_box(4,21,6,38,15);    paint_box(4,40,6,57,15);
                    paint_box(8,21,10,38,15);   paint_box(8,40,10,57,15);
                    paint_box(12,21,14,38,15);  paint_box(12,40,14,57,15);
                    paint_box(16,21,18,38,15);  paint_box(16,40,18,57,15);
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
                    close(k017_scr);
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
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
  end;
end;

procedure epex(j,m:integer);
begin
  pi:=3.141592654;
  pii:=pi / 200;
  dist:=sqrt(sqr(x2[j,m] - x1[j,m]) + (sqr(y2[j,m] - y1[j,m])));
  dx:=x2[j,m]-x1[j,m]; dy:=y2[j,m]-y1[j,m];
  arctan; s12:=dist; t12:=az;      { in radians }
  t12100:=t12+100*pii;
  xh:=x1[j,m]+a[j,m]*sin(t12100);
  yh:=y1[j,m]+a[j,m]*cos(t12100);
  dx:=xm[j]-xh; dy:=ym[j]-yh;
  shm:=sqrt(sqr(dx)+sqr(dy));
  arctan; thm:=az;      { in radians }
  gona:=thm-t12;
  d:=shm*sin(gona);
  s2:=sqrt(sqr(r[j])-sqr(d));
  shs:=shm*cos(gona);
  xs1[j,m]:=xh+(shs+s2)*sin(t12); ys1[j,m]:=yh+(shs+s2)*cos(t12);
  xs2[j,m]:=xh+(shs-s2)*sin(t12); ys2[j,m]:=yh+(shs-s2)*cos(t12);
  sg:=cos(gona);
end;

procedure display_data(l,m:integer);
begin
  wrt(19,9,15,'          ');   gotoxy(19,9);  write(xm[l]:4:3);
  wrt(35,9,15,'           ');  gotoxy(35,9);  write(ym[l]:4:3);
  wrt(51,9,15,'          ');   gotoxy(51,9);  write(r[l]:4:3);
  wrt(11,15,15,'          ');  gotoxy(11,15); write(x1[l,m]:4:3);
  wrt(27,15,15,'           '); gotoxy(27,15); write(y1[l,m]:4:3);
  wrt(43,15,15,'          ');  gotoxy(43,15); write(x2[l,m]:4:3);
  wrt(59,15,15,'           '); gotoxy(59,15); write(y2[l,m]:4:3);
  wrt(35,20,15,'          ');  gotoxy(35,20); write(a[l,m]:4:3);
end;

procedure inp(l:integer);
label     10,20,30,40,50,60,70,80,90,100;
begin
10:    input(buff,9,18,11,bit); val(buff,xm[l],cod);
20:    input(buff,9,34,12,bit);
       if bit then goto 10 else val(buff,ym[l],cod);
30:    input(buff,9,50,11,bit);
       if bit then goto 20 else val(buff,r[l],cod);
       m:=0;
       repeat
         m:=m + 1;
         if m = 10 then
         begin
           wrt(12,22,112,' ‘„•„ !! ');
           wrt(24,22,15,' ƒˆŒ„ˆ‘ ’†Œ ’„Š„“’€ˆ€ „“‡„ˆ€ ‰€ˆ €‘’€‘„ˆ‘ ');
         end;
40:      input(buff,15,10,11,bit);
         if bit then goto 30 else val(buff,x1[l,m],cod);
50:      input(buff,15,26,12,bit);
         if bit then goto 40 else val(buff,y1[l,m],cod);
60:      input(buff,15,42,11,bit);
         if bit then goto 50 else val(buff,x2[l,m],cod);
70:      input(buff,15,58,11,bit);
         if bit then goto 60 else val(buff,y2[l,m],cod);
80:      input(buff,20,34,11,bit);
         if bit then goto 70 else val(buff,a[l,m],cod);
         dx:=x2[l,m]-x1[l,m]; dy:=y2[l,m]-x2[l,m];
         if (dx = 0) and (dy = 0) then
         begin
           wrt(14,22,112,'‘„•„!! ƒ„Œ ˆ…„’€ˆ „“‡„ˆ€. €’†‘„ „Œ€ Š†‰’..');
           repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
           wrt(14,22,15,'                                                   ');
           goto 100;
         end;
         epex(l,m);
100:     if m = 10 then goto 90;
         wrt(23,22,15,'‘“Œ„•ˆ…„ˆ‘ ‹„ Œ„€ „“‡„ˆ€; (N/O) : ');
         gotoxy(57,22);    read(cha);
         wrt(11,15,15,'          ');
         wrt(27,15,15,'           ');
         wrt(43,15,15,'          ');
         wrt(59,15,15,'           ');
         wrt(35,20,15,'          ');
         wrt(57,22,15,'         ');
       until cha in ['O','o'];
90:    metr_ded_ap[l]:=m;
       l:=succ(l);
end;

procedure diorth;
label     10,20,30,40,50,60,70,80;
begin
       l:=1;
       while l <= i do
       begin
         display_data(l,1);
10:      input(buff,9,18,11,bit);
         if bit then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l,1);
           goto 30;
         end
         else val(buff,xm[l],cod);
20:      input(buff,9,34,12,bit);
         if bit then goto 10 else val(buff,ym[l],cod);
30:      input(buff,9,50,11,bit);
         if bit then goto 20 else val(buff,r[l],cod);
         m:=1;
         while m <= metr_ded_ap[l] do
         begin
           display_data(l,m);
40:        input(buff,15,10,11,bit);
           if bit then
           begin
             if m = 1 then
             begin
               if l = 1 then goto 80;
               l:=l-1;
               m:=metr_ded_ap[l];
               display_data(l,m);
               goto 80;
             end
             else
             begin
               m:=pred(m);
               display_data(l,m);
               goto 80;
             end;
           end
           else val(buff,x1[l,m],cod);
50:        input(buff,15,26,12,bit);
           if bit then goto 40 else val(buff,y1[l,m],cod);
60:        input(buff,15,42,11,bit);
           if bit then goto 50 else val(buff,x2[l,m],cod);
70:        input(buff,15,58,11,bit);
           if bit then goto 60 else val(buff,y2[l,m],cod);
80:        input(buff,20,34,11,bit);
           if bit then goto 70 else val(buff,a[l,m],cod);
           epex(l,m);
           wrt(11,15,15,'          ');
           wrt(27,15,15,'           ');
           wrt(43,15,15,'          ');
           wrt(59,15,15,'           ');
           wrt(35,20,15,'          ');
           wrt(57,22,15,'         ');
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
     writeln(fill,'============================================================================');
     writeln(fill,'    ’    ‹  †     „  “  ‡  „  ˆ  €  ‘     ‰  €  ˆ     ‰  “  ‰  Š    “');
     writeln(fill,'============================================================================');
     writeln(fill);
     writeln(fill,'‘“Œ/Œ„‘ ‰„Œ’“ ‰“‰Š“             ‘“Œ’„’€‚‹„Œ„‘ ’—Œ ‘†‹„ˆ—Œ ’‹†‘');
     writeln(fill,' ’„’‹†‹„Œ†   ’„’€‚‹„Œ†   ’„’‹†‹„Œ† •1 ’„’€‚‹„Œ† “1 ’„’‹†‹„Œ† •2 ’„’€‚‹„Œ† “2');
     writeln(fill,'----------   ---------   ------------ ------------ ------------ ------------');
     for l:=1 to i do for k:=1 to metr_ded_ap[l] do
       writeln(fill,xm[l]:10:3,' ',ym[l]:11:3,'     ',xs1[l,k]:10:3,
               '  ',ys1[l,k]:11:3,'   ',xs2[l,k]:10:3,'  ',ys2[l,k]:11:3);
     close(fill);
end;

procedure anal_gr_scr(grammi,k,l:integer);
begin
gotoxy(4,grammi);  write(xm[k]:10:3);    gotoxy(17,grammi); write(ym[k]:11:3);
gotoxy(31,grammi); write(xs1[k,l]:10:3); gotoxy(43,grammi); write(ys1[k,l]:11:3);
gotoxy(57,grammi); write(xs2[k,l]:10:3); gotoxy(69,grammi); write(ys2[k,l]:11:3);
end;

procedure write_screen(var scr_line,k1:integer);
var k:integer;
begin
  clrscr;
  seek(k017_scr,2);    read(k017_scr,rec1);
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
  writeln(fill,'============================================================================');
  writeln(fill,'    ’    ‹  †     „  “  ‡  „  ˆ  €  ‘     ‰  €  ˆ     ‰  “  ‰  Š    “');
  writeln(fill,'============================================================================');
  writeln(fill);
  writeln(fill,'‘“Œ/Œ„‘ ‰„Œ’“ ‰“‰Š“             ‘“Œ’„’€‚‹„Œ„‘ ’—Œ ‘†‹„ˆ—Œ ’‹†‘');
  writeln(fill,' ’„’‹†‹„Œ†   ’„’€‚‹„Œ†   ’„’‹†‹„Œ† •1 ’„’€‚‹„Œ† “1 ’„’‹†‹„Œ† •2 ’„’€‚‹„Œ† “2');
  writeln(fill,'----------   ---------   ------------ ------------ ------------ ------------');
end;

procedure lprint;
var       k:integer;
begin
  rewrite(fill);
  epikef;
  gram:=10;
  for l:=1 to i do
  begin
    for k:=1 to metr_ded_ap[l] do
    begin
      writeln(fill);
      writeln(fill,xm[l]:10:3,' ',ym[l]:11:3,'     ',xs1[l,k]:10:3,
        '  ',ys1[l,k]:11:3,'   ',xs2[l,k]:10:3,'  ',ys2[l,k]:11:3);
      gram:=gram + 2;
      if gram >= ar_gram - 2 then
      begin
        writeln(fill); writeln(fill); epikef; gram:=10;
      end;
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
            seek(k017_scr,1);     read(k017_scr,rec1);
            repeat
              move(rec1.xx[0],mem[$b000:ofs1],3680);
              wrt(14,2,112,'„  ˆ  ‘  €  ‚  —  ‚  †');
              i:=i+1;
              inp(i);
              wrt(22,23,15,'„•„’„ €ŠŠ† ‹€ƒ€ ƒ„ƒ‹„Œ—Œ; (N/O): ');
              gotoxy(57,23);   read(cha);
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
              assign(in_k017,name);
              {$i-}
              reset(in_k017);
              {$i+}
              ok:=(ioresult=0);
              if ok then
              begin
                gotoxy(1,23); write('‘„•„ ! ’ €•„ˆ €“’ “€•„ˆ. Œ€ ‚€–— „€Œ— ’“; (Œ/) : ');
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
              rewrite(in_k017);
              j:=0;
              repeat
                j:=j+1;
                with in1_rec do
                begin
                  tet1:=xm[j]; teta1:=ym[j]; akt:=r[j];
                  metr_ded:=metr_ded_ap[j]; write(in_k017,in1_rec);
                end;
                l:=0;
                repeat
                  l:=l+1;
                  with in2_rec do
                  begin
                    tet2:=x1[j,l]; teta2:=y1[j,l]; tet3:=x2[j,l];
                    teta3:=y2[j,l]; ap:=a[j,l]; write(in_k017,in1_rec);
                  end;
                until l = metr_ded_ap[j];
              until j = i;
              close(in_k017);
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
              assign(in_k017,filename);
              {$i-}
              reset(in_k017);
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
              reset(in_k017);
              seek(in_k017,0);
              l:=0;
              repeat
                l:=l+1;
                read(in_k017,in1_rec);
                with in1_rec do
                begin
                xm[l]:=tet1; ym[l]:=teta1; r[l]:=akt; metr_ded_ap[l]:=metr_ded;
                end;
                j:=0;
                repeat
                  j:=j+1;
                  read(in_k017,in1_rec);
                  with in2_rec do
                  begin
                    x1[l,j]:=tet2; y1[l,j]:=teta2;
                    x2[l,j]:=tet3; y2[l,j]:=teta3; a[l,j]:=ap;
                  end;
                  epex(l,j);
                until j = metr_ded_ap[l];
              until  eof(in_k017);
              i:=l;
              close(in_k017);
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
                readln(f,b1); val(b1,xm[j],cod);
                readln(f,b2); val(b2,ym[j],cod);
                readln(f,b3); val(b3,r[j],cod);
                readln(f,b4); val(b4,metr_ded_ap[j],cod);
                l:=0;
                repeat
                  l:=l + 1;
                  readln(f,b5); val(b5,x1[j,l],cod);
                  readln(f,b6); val(b6,y1[j,l],cod);
                  readln(f,b7); val(b7,x2[j,l],cod);
                  readln(f,b8); val(b8,y2[j,l],cod);
                  readln(f,b9); val(b9,a[j,l],cod);
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
            seek(k017_scr,1);    read(k017_scr,rec1);
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
assign(k017_scr,'TOMHEK.SCR');
reset(k017_scr);
seek(k017_scr,3); read(k017_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;    gram:=0;
delete_all_input;
cursor(false,true);
epex_menu;
END.

{*******************************************************************************
*                    K044  APOSTASH METAJY SHMEIVN           *
*               WRITTEN BY G.XALARIS                                  *
*                             VERSION 1.02                                   *
*                              09-11-1986                                     *
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k044=record
             atet,ateta,btet,bteta:real;
         end;
         rec2_k044=record
             kwdik:string[6];
             tet1,teta2:real;
             dummy:string[4];
         end;
         string40 =string[40];
         string255=string[255];

var      xa,ya,xb,yb,dx,dy:real;
         kwd:array [0..60] of string[6];
         stest,xtest,ytest:array [1..60] of real;
         OthInp,OthPrint:array[1..3680] of byte;
         k044_scr :file of rec;
         rec1     :rec;
         ofs1,cod :integer;
         i,l      :integer;
         ar_gram  :integer;
         buff     :string40;
         bit,ok   :boolean;
         name,filename:string[66];
         fill     :text;

         f:text;
         b1,b3,b6:string[10];
         b2,b4,b7:string[11];
         b5:string[6];

         in_k044  :file of rec1_k044;
         in1_rec  :rec1_k044;
         in2_rec  :rec2_k044 absolute in1_rec;

         sw1,sw3,sw4:byte;
         cha:char;

         sel,gram:integer;
         a,b,c:real;
     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
  xa:=0; ya:=0; xb:=0; yb:=0;
  fillchar(kwd,sizeof(kwd),0);     fillchar(stest,sizeof(stest),0);
  fillchar(xtest,sizeof(xtest),0); fillchar(ytest,sizeof(ytest),0);
end;

procedure beep(freq,dur:integer);
begin sound(freq); delay(dur); nosound; end;
function menu:byte;
label    5;
var      deik,row,col,i:byte;
         ch:char;
procedure paint_box(ra,ca,rt,ct,att:byte);
          var rows,cols,i:byte;
          begin
            rows:=rt-ra+1; cols:=ct-ca+1;
            for i:=1 to rows do wrt(ca,i+ra-1,att,chr(cols));
          end;
begin
     seek(k044_scr,0);
     read(k044_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
         begin clrscr; cursor(true,false); close(k044_scr); halt; end;
       menu:=deik; exit;
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
                    clrscr; cursor(true,false); close(k044_scr); halt;
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
                      if row>4 then row:=row-4 else row:=16
                    else
                      if row<16 then row:=row+4 else row:=4;
                    paint_box(row,col,row+2,col+17,112);
                    deik:=(row div 4 * 2) - 1;
                    if col=40 then deik:=deik+1;
                  end;
              else for i:=3 to 6 do beep(i*500,50);
       end; {case}
     end {if}
     else for i:=3 to 6 do beep(i*500,50);
     goto 5;
end;

procedure epex(j:byte);
begin stest[j]:=(a*xtest[j]+b*ytest[j]+c)/(sqrt(sqr(a)+sqr(b))); end;

procedure display_data(l:byte);
begin
  gotoxy(21,13); write('      ');      gotoxy(21,13); write(kwd[l]);
  gotoxy(37,13); write('           '); gotoxy(37,13); write(xtest[l]:4:3);
  gotoxy(52,13); write('           '); gotoxy(52,13); write(ytest[l]:4:3);
end;

procedure arx_epex; begin a:=yb-ya; b:=-(xb-xa); c:=(xb*ya-xa*yb); end;

procedure inp;
label    10,20,30,40,50,60,65;
begin
     if ((sw1=1) or (sw3=1)) then
     begin
       gotoxy(11,8); write(xa:10:3); gotoxy(27,8); write(ya:4:3);
       gotoxy(43,8); write(xb:10:3); gotoxy(59,8); write(yb:4:3);
     end;
10:  input(buff,8,10,11,bit); val(buff,xa,cod);
20:  input(buff,8,26,12,bit);
     if bit then goto 10 else val(buff,ya,cod);
30:  input(buff,8,42,11,bit);
     if bit then goto 20 else val(buff,xb,cod);
40:  input(buff,8,58,12,bit);
     if bit then goto 30 else val(buff,yb,cod);
     dx:=xb-xa; dy:=yb-ya;
     if ((dx=0) and (dy=0)) then
     begin
       cursor(false,true);
       clrscr;
       wrt(10,14,240,'  ’€ ‘†‹„ˆ€   ’ € “ ’ ˆ …  Œ ’ € ˆ.   €’†‘„ „Œ€ Š†‰’..  ');
       repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
       goto 10;
     end;
     arx_epex;
     kwd[0]:= 'a';
     l:=1;
     while (kwd[l-1] <> '0') do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
50:    input(buff,13,20,7.1,bit);
       if bit then
         if l = 1 then goto 40
         else
         begin
          l:=pred(l); if ((sw1 = 1) or (sw3 = 1)) then display_data(l); goto 65;
         end
       else kwd[l]:=buff;
60:    input(buff,13,36,11,bit);
       if bit then goto 50 else val(buff,xtest[l],cod);
65:    input(buff,13,51,12,bit);
       if bit then goto 60 else val(buff,ytest[l],cod);
       epex(l);
       l:=succ(l);
       if l = 56 then
       begin
         clrscr;
         wrt(14,14,240,'  „ˆ’„‹„Œ‘ €ˆ‡‹‘ ‘†‹„ˆ—Œ : 55  ');
         wrt(14,15,240,'      €’†‘„    „Œ€   Š†‰’..       ');
         repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
         exit;
       end;
       gotoxy(21,13); write('      ');
       gotoxy(37,13); write('           ');
       gotoxy(52,13); write('            ');
     end;
     i:=l-2;
     exit;
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
    wrt(1,23,15,'O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) ');
    gotoxy(61,23);    read(kbd,cha);
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
  writeln(fill,'==================================================================');
  writeln(fill,'       €   ‘ ’ € ‘ †   ‘ † ‹ „ ˆ  “  €    „ “ ‡ „ ˆ €     ');
  writeln(fill,'==================================================================');
  writeln(fill);
  writeln(fill,'       ‘“Œ’„’€‚‹„Œ„‘ ’—Œ €‰—Œ “ ˆ…“Œ ’†Œ „“‡„ˆ€        ');
  writeln(fill);
  writeln(fill,'’„’‹†‹„Œ† ‘†‹„ˆ“ 1: ',xa:10:3,'  ’„’‹†‹„Œ† ‘†‹„ˆ“ 2: ',xb:10:3);
  writeln(fill,'’„’€‚‹„Œ† ‘†‹„ˆ“ 1:',ya:11:3,'  ’„’€‚‹„Œ† ‘†‹„ˆ“ 2:',yb:11:3);
  writeln(fill);
  writeln(fill,'‰—ƒˆ‰‘    ’„’‹†‹„Œ†    ’„’€‚‹„Œ†   €‘’€‘† ');
  writeln(fill,'‘†‹„ˆ“     ‘†‹„ˆ“      ‘†‹„ˆ“     ‘†‹„ˆ—Œ ');
  writeln(fill,'-------   ----------  -----------  ----------');
  for k:=1 to i do writeln(fill,kwd[k],' ':7-length(kwd[k]),
    '   ',xtest[k]:10:3,'  ',ytest[k]:11:3,'  ',stest[k]:10:3 );
  close(fill);
end;

procedure anal_gr_scr(beg_for,end_for:integer);
var       k,grammi:integer;
begin
  gotoxy(16,7); write(xa:10:3); gotoxy(29,7); write(ya:11:3);
  gotoxy(44,7); write(xb:10:3); gotoxy(57,7); write(yb:11:3);
  grammi:=12;
  for k:=beg_for to end_for do
  begin
    gotoxy(12,grammi);
    write('³             ³             ³             ³             ³');
    gotoxy(17,grammi); write(kwd[k]);
    gotoxy(30,grammi); write(xtest[k]:10:3);
    gotoxy(43,grammi); write(ytest[k]:11:3);
    gotoxy(58,grammi); write(stest[k]:10:3);

    grammi:=grammi + 1;
  end;
end;

procedure write_screen;
begin
  clrscr;
  seek(k044_scr,2);    read(k044_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  if i <= 11 then
  begin
    anal_gr_scr(1,i);
    writeln;
    write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
    wrt(19,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
    clrscr;
    exit;
  end
  else
  begin
    if i <= 22 then
    begin
      anal_gr_scr(1,11);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ €Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(12,i);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(19,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      exit;
    end;
    if i <= 33 then
    begin
      anal_gr_scr(1,11);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(12,22);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(23,i);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(19,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      exit;
    end;
    if i <= 44 then
    begin
      anal_gr_scr(1,11);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(12,22);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(23,33);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(34,i);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(19,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      exit;
    end;
    if i <= 55 then
    begin
      anal_gr_scr(1,11);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(12,22);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(23,33);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(34,44);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(45,i);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(19,24,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
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
  writeln(fill,' ':70,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill,'==================================================================');
  writeln(fill,'        €   ‘ ’ € ‘ †  ‘ † ‹ „ ˆ  “  €    „ “ ‡ „ ˆ €');
  writeln(fill,'==================================================================');
  writeln(fill);
  writeln(fill,'    ‘“Œ’„’€‚‹„Œ„‘ ’—Œ €‰—Œ ’—Œ ‘†‹„ˆ—Œ “ ˆ…“Œ ’†Œ „“‡„ˆ€ ');
  writeln(fill);
  writeln(fill,'’„’‹†‹„Œ† ‘†‹„ˆ“ 1: ',xa:10:3,'  ’„’‹†‹„Œ† ‘†‹„ˆ“ 2: ',xb:10:3);
  writeln(fill,'’„’€‚‹„Œ† ‘†‹„ˆ“ 1:',ya:11:3,'  ’„’€‚‹„Œ† ‘†‹„ˆ“ 2:',yb:11:3);
  writeln(fill);
  writeln(fill,'‰—ƒˆ‰‘    ’„’‹†‹„Œ†    ’„’€‚‹„Œ†    €‘’€‘†');
  writeln(fill,'‘†‹„ˆ“     ‘†‹„ˆ“      ‘†‹„ˆ“      ‘†‹„ˆ—Œ');
  writeln(fill,'-------   ----------  -----------  ----------');
end;

procedure lprint;
var       k:integer;
begin
  rewrite(fill);
  epikef;
  gram:=14;
  for k:=1 to i do
  begin
    writeln(fill);
    writeln(fill,kwd[k],' ':7-length(kwd[k]),'  ',xtest[k]:10:3,
          '  ',ytest[k]:11:3,'   ',stest[k]:10:3,' ');
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin writeln(fill); writeln(fill); epikef; gram:=14; end;
    if k = i then begin writeln(fill); writeln(fill); end;
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
            if (sw1=1) or (sw3=1) then epex_menu;
            clrscr;
            cursor(true,false);
            seek(k044_scr,1);     read(k044_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            wrt(14,2,15,'„  ˆ  ‘  €  ‚  —  ‚  †');
            gotoxy(33,16);    write('‹„  ‰—ƒˆ‰ = 0');
            gotoxy(32,15);    write('„ˆ‘’”† ‘’ ‹„ŒU');
            inp;
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
              assign(in_k044,name);
              {$i-}
              reset(in_k044);
              {$i+}
              ok:=(ioresult=0);
              if ok then
              begin
                wrt(14,23,15,'‘„•„ ! ’ €•„ˆ €“’ “€•„ˆ. Œ€ ‚€–— „€Œ— ’“; (Œ/) ');
                gotoxy(76,23);    read(kbd,cha);
                if cha in ['O','o','','¦'] then
                begin cursor(false,true); epex_menu; end;
              end;
              clrscr;
              cursor(false,true);
              wrt(11,12,240,'  ‰ € ’ € • —  —   ƒ „ ƒ  ‹ „ Œ €   ‘ „   €  • „ ˆ   ');
              rewrite(in_k044);
              with in1_rec do
              begin atet:=xa; ateta:=ya; btet:=xb; bteta:=yb; end;
              write(in_k044,in1_rec);
              j:=0;
              repeat
                j:=j+1;
                with in2_rec do
                begin kwdik:=kwd[j]; tet1:=xtest[j]; teta2:=ytest[j]; end;
                write(in_k044,in1_rec);
              until j = i+1;
              close(in_k044);
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
              assign(in_k044,filename);
              {$i-}
              reset(in_k044);
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
              reset(in_k044);
              seek(in_k044,0);
              with in1_rec do
              begin
                read(in_k044,in1_rec);
                xa:=atet; ya:=ateta; xb:=btet; yb:=bteta;
              end;
              dx:=xb-xa; dy:=yb-ya; arx_epex;
              l:=0;
              repeat
                l:=l+1;
                read(in_k044,in1_rec);
                with in2_rec do
                begin
                  kwd[l]:=kwdik; xtest[l]:=tet1; ytest[l]:=teta2;
                end;
                epex(l);
              until  eof(in_k044);
              i:=l-1;
              close(in_k044);
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
              readln(f,b1); val(b1,xa,cod); readln(f,b2); val(b2,ya,cod);
              readln(f,b3); val(b3,xb,cod); readln(f,b4); val(b4,yb,cod);
              dx:=xb-xa; dy:=yb-ya; arx_epex;
              j:=0;
              repeat
                j:=j+1;
                readln(f,b5); kwd[j]:=b5; readln(f,b6); val(b6,xtest[j],cod);
                readln(f,b7); val(b7,ytest[j],cod); epex(j);
              until eof(f);
              i:=j;
              close(f);
            end;
            epex_menu;
          end;
        4:begin
            if ((sw1 <> 1) and (sw3 <> 1)) then
            begin
              wrt(12,21,240,'  ƒEN EX— ƒEƒOMENA.  €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            cursor(true,false);
            sw4:=1;
            seek(k044_scr,1); read(k044_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            wrt(14,2,15,'ƒ  I  O    ‡  —  ‘  H');
            inp;
            repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            cursor(false,true);
10:         clrscr;
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
              sel:=0;
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
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              cursor(false,true);
              write_screen;
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
clrscr;
ofs1:=$8000;
if mem[0:1040] and 48 = 48 then ofs1:=$0000;
assign(k044_scr,'APOSTASH.scr');
reset(k044_scr);
seek(k044_scr,3); read(k044_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
DELETE_ALL_INPUT;
sw1:=0; sw3:=0; sw4:=0; i:=0; sel:=0; gram:=0;
cursor(false,true);
epex_menu;
END.

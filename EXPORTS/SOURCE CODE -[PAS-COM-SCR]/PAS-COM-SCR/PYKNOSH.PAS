{******************************************************************************
*                      K043 ĞÕÊÍÙÓÇ ÅÕÈÕÃÑÁÌÌÉÁÓ                           *
*                  WRITTEN BY G.XALARIS                        *
*                              27-11-1986                                     *
*******************************************************************************}
program  k043;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k043=record
           atet :real;
           ateta:real;
           btet :real;
           bteta:real;
         end;
         rec2_k043=record
           kwdik:string[6];
           dis  :real;
           dummy:string[11];
         end;

         string40 =string[40];
         string255=string[255];

var      xa,ya,xb,yb,dx,dy,a1,sab,pi,p,az,azab:real;
         kwd  :array [1..60] of string[6];
         stest:array [0..60] of real;
         xtest:array [1..60] of real;
         ytest:array [1..60] of real;
         OthInp,OthPrint:array[1..3680] of byte;
         k043_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f       :text;
         b1      :string[10];
         b2      :string[11];
         b3      :string[10];
         b4      :string[11];
         b5      :string[6];
         b6      :string[10];

         in_k043 :file of rec1_k043;
         in1_rec :rec1_k043;
         in2_rec :rec2_k043 absolute in1_rec;

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
     {$I WRTSCR.PRC}

procedure delete_all_input;
begin
  xa:=0; ya:=0; xb:=0; yb:=0;
  fillchar(kwd,sizeof(kwd),0); fillchar(stest,sizeof(stest),0);
  fillchar(xtest,sizeof(xtest),0); fillchar(ytest,sizeof(ytest),0);
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
     seek(k043_scr,0);
     read(k043_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         close(k043_scr);
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
                    close(k043_scr);
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
              else for i:=3 to 6 do beep(i*500,50);
       end; {case}
     end {if}
     else
       for i:=3 to 6 do beep(i*500,50);
     goto 5;
end;

procedure epex(j:byte);
begin
  xtest[j]:=xa + stest[j] * sin(az);
  ytest[j]:=ya + stest[j] * cos(az);
end;

procedure display_data(l:byte);
begin
  gotoxy(30,13);    write('      ');
  gotoxy(30,13);    write(kwd[l]);
  gotoxy(43,13);    write('          ');
  gotoxy(43,13);    write(stest[l]:4:3);
end;

procedure arx_epex;
begin
  p:=3.141592654;
  if dx < 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p+a1; end;
    if dy = 0 then az:= 3*p/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=2*p-a1; end;
  end;
  if dx = 0 then begin if dy < 0 then az:=p; if dy > 0 then az:=0; end;
  if dx > 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p-a1; end;
    if dy = 0 then az:= p/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
  end;
  azab:=az*200/pi;
end;

procedure inp;
label    10,20,30,40,50,60;
begin
     pi:=arctan(1) * 4;
     if ((sw1 = 1) or (sw3 = 1)) then
     begin
       gotoxy(11,8);    write(xa:4:3);
       gotoxy(27,8);    write(ya:4:3);
       gotoxy(43,8);    write(xb:4:3);
       gotoxy(59,8);    write(yb:4:3);
     end;
10:  input(buff,8,10,11,bit);
     val(buff,xa,cod);
20:  input(buff,8,26,12,bit);
     if bit then goto 10
       else val(buff,ya,cod);
30:  input(buff,8,42,11,bit);
     if bit then goto 20
       else val(buff,xb,cod);
40:  input(buff,8,58,12,bit);
     if bit then goto 30
       else val(buff,yb,cod);
     dx:=xb - xa; dy:=yb - ya; sab:=sqrt(sqr(dx) + sqr(dy));
     if ((dx = 0) and (dy = 0)) then
     begin
       cursor(false,true);
       clrscr;
       wrt(10,14,240,'  ’€ ‘†‹„ˆ€   ’ € “ ’ ˆ …  Œ ’ € ˆ.   €’†‘„ „Œ€ Š†‰’..  ');
       repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
       exit;
     end;
     arx_epex;
     stest[0] := 10;
     l:=1;
     while (stest[l-1] <> 0) do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
50:    input(buff,13,29,7.1,bit);
       if bit then
         if l = 1 then goto 40
         else
         begin
           l:=pred(l);
           if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
           goto 60;
         end
       else kwd[l]:=buff;
60:    input(buff,13,42,11,bit);
       if bit then goto 50
         else val(buff,stest[l],cod);
       epex(l);
       l:=succ(l);
       if l = 56 then
       begin
         clrscr;
         wrt(14,14,240,'  „ˆ’„‹„Œ‘ €ˆ‡‹‘ ‰“”—Œ : 55  ');
         wrt(14,15,240,'      €’†‘„    „Œ€   Š†‰’..       ');
         repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
         exit;
       end;
       gotoxy(30,13);    write('      ');
       gotoxy(43,13);    write('          ');
     end;
     i:=l - 2;
     exit;
end;

procedure input_results_in_file;
var   k  :integer;
begin
  WRT_SCREEN(OthInp,1,20,80,22);
  gotoxy(13,21); read(filename);
  assign(fill,filename);
  {$i-}
  reset(fill);
  {$i+}
  ok:=(ioresult=0);
  if ok then
  begin
    gotoxy(2,23); write('O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) ');
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
  writeln(fill,'         “ ‰ Œ — ‘ †       „ “ ‡ “ ‚  € ‹ ‹ ˆ € ‘ ');
  writeln(fill,'=============================================================');
  writeln(fill,'   €•ˆ‰ €…ˆ‹“‡ˆ : ',azab:4:4);
  writeln(fill,'’„’‹†‹„Œ† ‘†‹„ˆ“ 1: ',xa:11:3,' ','’„’‹†‹„Œ† ‘†‹„ˆ“ 2: ',xb:11:3);
  writeln(fill,'’„’€‚‹„Œ† ‘†‹„ˆ“ 1: ',ya:11:3,' ','’„’€‚‹„Œ† ‘†‹„ˆ“ 2: ',yb:11:3);
  writeln(fill);
  writeln(fill,'‰—ƒˆ‰‘    ƒ„ƒ‹„Œ†    ’„’‹†‹„Œ†    ’„’€‚‹„Œ† ');
  writeln(fill,'‘†‹„ˆ“    €‘’€‘†     ‘†‹„ˆ“      ‘†‹„ˆ“  ');
  for k:=1 to i do
  begin
    write(fill,kwd[k],' ':7-length(kwd[k]),
          '  ',stest[k]:10:3,
          '   ',xtest[k]:10:3,
          '  ',ytest[k]:11:3,' ');
    if stest[k] > sab then
      writeln(fill,'    ****')
    else
      writeln(fill);
  end;
  writeln(fill,'   **** ’¦ ©£œå¦ ™¨å©¡œ«˜  ©«¤ œ§â¡«˜© «ª œ¬Ÿ¬š¨˜££å˜ª');
  close(fill);
end;

procedure anal_gr_scr(beg_for,end_for:integer);
var       k,grammi:integer;
begin
  gotoxy(45,4);    write(azab:8:4);
  gotoxy(16,7);    write(xa:10:3);
  gotoxy(29,7);    write(ya:11:3);
  gotoxy(44,7);    write(xb:10:3);
  gotoxy(57,7);    write(yb:11:3);
  grammi:=12;
  for k:=beg_for to end_for do
  begin
    gotoxy(12,grammi);
    write('³             ³             ³             ³             ³');
    gotoxy(17,grammi);    write(kwd[k]);
    gotoxy(30,grammi);    write(stest[k]:10:3);
    gotoxy(44,grammi);    write(xtest[k]:10:3);
    gotoxy(57,grammi);    write(ytest[k]:11:3);
    if stest[k] > sab then wrt(71,grammi,15,'***');
    grammi:=grammi + 1;
    wrt(12,24,15,' *** : ’¦ ©£œå¦ ™¨å©¡œ«˜  ©«¤ œ§â¡«˜© «ª œ¬Ÿ¬š¨˜££å˜ª');
  end;
end;

procedure write_screen;
begin
  clrscr;
  seek(k043_scr,2);    read(k043_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  if i <= 11 then
  begin
    anal_gr_scr(1,i);
    writeln;
    write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
    wrt(19,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
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
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ €Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(12,i);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(19,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      exit;
    end;
    if i <= 33 then
    begin
      anal_gr_scr(1,11);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(12,22);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(23,i);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(19,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      exit;
    end;
    if i <=44 then
    begin
      anal_gr_scr(1,11);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(12,22);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(23,33);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(34,i);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(19,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      exit;
    end;
    if i <=55 then
    begin
      anal_gr_scr(1,11);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(12,22);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(23,33);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’„Š„‘‹€’—Œ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(34,44);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(18,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
      clrscr;
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      anal_gr_scr(45,i);
      writeln;
      write('           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
      wrt(19,25,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
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
  writeln(fill);
  writeln(fill,'=============================================================');
  writeln(fill,'         “ ‰ Œ — ‘ †       „ “ ‡ “ ‚  € ‹ ‹ ˆ € ‘ ');
  writeln(fill,'=============================================================');
  writeln(fill,'   €•ˆ‰ €…ˆ‹“‡ˆ : ',azab:4:4);
  writeln(fill,'’„’‹†‹„Œ† ‘†‹„ˆ“ 1: ',xa:11:3,' ’„’‹†‹„Œ† ‘†‹„ˆ“ 2: ',xb:11:3);
  writeln(fill,'’„’€‚‹„Œ† ‘†‹„ˆ“ 1: ',ya:11:3,' ’„’€‚‹„Œ† ‘†‹„ˆ“ 2: ',yb:11:3);
  writeln(fill);
  writeln(fill,'‰—ƒˆ‰‘    ƒ„ƒ‹„Œ†    ’„’‹†‹„Œ†    ’„’€‚‹„Œ† ');
  writeln(fill,'‘†‹„ˆ“    €‘’€‘†     ‘†‹„ˆ“      ‘†‹„ˆ“  ');
end;

procedure lprint;
var       k:integer;
begin
  rewrite(fill);
  epikef;
  gram:=12;
  for k:=1 to i do
  begin
    writeln(fill);
    write(fill,kwd[k],' ':7-length(kwd[k]),
          '  ',stest[k]:10:3,
          '   ',xtest[k]:10:3,
          '  ',ytest[k]:11:3,' ');
    if stest[k] > sab then
      writeln(fill,'    ****')
    else
      writeln(fill);
    gram:=gram + 2;
    if gram >= ar_gram - 4 then
    begin
      writeln(fill);
      writeln(fill,'**** : ’¦ ©£œå¦ ™¨å©¡œ«˜  ©«¤ ˜¨®ã «ª œ¬Ÿ¬š¨˜££å˜ª');
      writeln(fill);
      writeln(fill);
      epikef;
      gram:=12;
    end;
    if k = i then
    begin
      writeln(fill);
      writeln(fill,'**** : ’¦ ©£œå¦ ™¨å©¡œ«˜  ©«¤ ˜¨®ã «ª œ¬Ÿ¬š¨˜££å˜ª');
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
            seek(k043_scr,1);     read(k043_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            wrt(14,2,15,'„  ˆ  ‘  €  ‚  —  ‚  †');
            gotoxy(33,16);    write('‹„  €‘’€‘† = 0');
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
              WRT_SCREEN(OthInp,1,20,80,22);
              gotoxy(13,21); read(name);
              assign(in_k043,name);
              {$i-}
              reset(in_k043);
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
              clrscr;
              cursor(false,true);
              wrt(11,12,240,'  ‰ € ’ € • —  —   ƒ „ ƒ  ‹ „ Œ €   ‘ „   €  • „ ˆ   ');
              rewrite(in_k043);
              with in1_rec do
              begin
                atet:=xa; ateta:=ya; btet:=xb; bteta:=yb;
              end;
              write(in_k043,in1_rec);
              j:=0;
              repeat
                j:=j+1;
                with in2_rec do
                begin
                  kwdik:=kwd[j]; dis:=stest[j];
                end;
                write(in_k043,in1_rec);
              until j = i;
              close(in_k043);
            end
            else
            begin
              cursor(false,true);
              wrt(2,23,240,'  ƒEN EKANE‘ EI‘A‚—‚H ƒEƒOMEN—N.  €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
            epex_menu;
          end;
        3:begin
            cursor(true,false);
            wrt(1,20,15,'TO AXEIO AYTO EINAI ƒHMIOY‚†MENO ME EDITOR "H ME TO ŠHKTO F2; (E/F): ');
            gotoxy(73,20); read(cha);
            WRT_SCREEN(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k043,filename);
              {$i-}
              reset(in_k043);
              {$i+}
              ok:=(ioresult=0);
              if not ok then
              begin
                cursor(false,true);
                wrt(2,23,240,'  O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..  ');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..  ');
              reset(in_k043);
              seek(in_k043,0);
              with in1_rec do
              begin
                read(in_k043,in1_rec);
                xa:=atet; ya:=ateta; xb:=btet; yb:=bteta;
              end;
              pi:=arctan(1) * 4;
              dx:=xb-xa; dy:=yb-ya; sab:=sqrt(sqr(dx)+sqr(dy));
              arx_epex;
              l:=0;
              repeat
                l:=l+1;
                read(in_k043,in1_rec);
                with in2_rec do
                begin
                  kwd[l]:=kwdik; stest[l]:=dis;
                end;
                epex(l);
              until  eof(in_k043);
              i:=l;
              close(in_k043);
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
                wrt(2,23,240,'  O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..  ');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..  ');
              reset(f);
              readln(f,b1);    val(b1,xa,cod);
              readln(f,b2);    val(b2,ya,cod);
              readln(f,b3);    val(b3,xb,cod);
              readln(f,b4);    val(b4,yb,cod);
              pi:=arctan(1) * 4;
              dx:=xb-xa; dy:=yb-ya; sab:=sqrt(sqr(dx)+sqr(dy));
              arx_epex;
              j:=0;
              repeat
                j:=j+1;
                readln(f,b5);    kwd[j]:=b5;
                readln(f,b6);    val(b6,stest[j],cod);
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
              wrt(12,21,240,'  ƒEN EX— ƒEƒOMENA.  €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            cursor(true,false);
            sw4:=1;
            seek(k043_scr,1);    read(k043_scr,rec1);
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
              gotoxy(3,15); write('„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•†  ‘„Šˆƒ€‘');
              gotoxy(10,16); write('€’†‘„ RETURN ‚ˆ€ „‰’“—‘†');
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
assign(k043_scr,'PYKNOSH.scr');
reset(k043_scr);
seek(k043_scr,3); read(k043_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;    gram:=0;
delete_all_input;
cursor(false,true);
epex_menu;
END.

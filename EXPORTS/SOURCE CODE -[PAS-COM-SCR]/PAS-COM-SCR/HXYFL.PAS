{******************************************************************************
*    k006 ÁÆÉÌÏÕÈÉÁÊÇ ÉÓÁĞÅ×ÏÕÓÁ ĞÑÏÂÏËÇ (HATT)  ÕĞÏËÏÃÉÓÌÏÓ (ö,ë) ÁĞÏ (÷,ø) *
*                  WRITTEN BY G.XALARIS                         *
*                              30-12-1986                                     *
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k006=record
           kwd_h:string[4];
           x_h,y_h:real;
           imfo_h,ipfo_h :integer;
           secfo_h:real;
           slo_h  :char;
           imlo_h,iplo_h:integer;
           seclo_h:real;
         end;
         string40 =string[40];
         string255=string[255];

var      kwd:array [1..500] of string[4];
         x,y:array [1..500] of real;
         imf,ipf:array [1..500] of integer;
         secf:array [1..500] of real;
         imfo,ipfo:array [1..500] of integer;
         secfo:array [1..500] of real;
         sl:array [1..500] of string[2];
         iml,ipl:array [1..500] of integer;
         secl:array [1..500] of real;
         slo:array [1..500] of string[2];
         imlo,iplo:array [1..500] of integer;
         seclo:array [1..500] of real;
         h_imlo,h_iplo:array [1..500] of integer;
         h_seclo:array [1..500] of real;

         ideg,min,kdeg,adeg,bmin:integer;

         sec,r,rfo,rlo,semia,semib,pi,pii,
         ee2,ee,p,n,rr,f1,f2,f3,f4,
         l1,l2,l3,l4,tanf,cosf,df,dl,
         rff,rll,degmin,degsec,deg,fm,y1,
         fi,degfl,minfl,y2,con,amin  :real;

         s:string[2];
         OthPrint,OthInp:array[1..3680] of byte;
         k006_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l,ar_gram:integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f:text;
         b1_h,b2_h,b3_h,b4_h,b5_h,
         b6_h,b7_h,b8_h,b9_h:string[12];
         b15_h:string[4];

         in_k006 :file of rec1_k006;
         in1_rec :rec1_k006;

         sw1,sw3,sw4:byte;
         cha:char;
         sel,gram    :integer;
     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
  fillchar(imf,sizeof(imf),0);   fillchar(ipf,sizeof(ipf),0);
  fillchar(secf,sizeof(secf),0); fillchar(imfo,sizeof(imfo),0);
  fillchar(ipfo,sizeof(ipfo),0); fillchar(secfo,sizeof(secfo),0);
  fillchar(sl,sizeof(sl),0);     fillchar(iml,sizeof(iml),0);
  fillchar(ipl,sizeof(ipl),0);   fillchar(secl,sizeof(secl),0);
  fillchar(slo,sizeof(slo),0);   fillchar(imlo,sizeof(imlo),0);
  fillchar(iplo,sizeof(iplo),0); fillchar(seclo,sizeof(seclo),0);
  fillchar(x,sizeof(x),0);       fillchar(y,sizeof(y),0);
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
            rows:=rt-ra+1;
            cols:=ct-ca+1;
            for i:=1 to rows do
              wrt(ca,i+ra-1,att,chr(cols));
          end;
begin
     seek(k006_scr,0);     read(k006_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k006_scr);
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
                    close(k006_scr);
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

procedure ed5rad;
begin
    if (r < 0) then s:='-' else s:='+';
    con:=57.29577951308232;
    deg:=con * abs(r);
    kdeg:=trunc(deg);
    adeg:=kdeg;
    amin:=60 * (deg -adeg);
    min:=trunc(amin);
    bmin:=min;
    sec:=60 * (amin - bmin);
    ideg:=kdeg;
end;

procedure rad;
begin
    pi:=3.14159265358979;
    pii:=pi / 180;
    degmin:=min / 60;
    degsec:=sec / 3600;
    deg:=ideg + degmin + degsec;
    r:=deg * pii;
end;

procedure epex(j:byte);
begin
  if slo[j] = '-' then
  begin
    h_imlo[j]:=-imlo[j]; h_iplo[j]:=-iplo[j]; h_seclo[j]:=-seclo[j];
  end
  else
  begin
    h_imlo[j]:=imlo[j]; h_iplo[j]:=iplo[j]; h_seclo[j]:=seclo[j];
  end;
  ideg:=imfo[j]; min:=ipfo[j]; sec:=secfo[j]; rad; rfo:=r;
  ideg:=h_imlo[j]; min:=h_iplo[j]; sec:=h_seclo[j]; rad; rlo:=r;
  semia:=6377397.155;
  semib:=6356078.963;
  pi:=3.14159265358979;
  pii:=180 / pi;
  ee2:=0.006674372232;
  ee:=0.006719218799;
  p:=(semia * (1 - ee2)) / sqrt(sqr(1 - ee2 * sqr(sin(rfo))) * (1 - ee2 * sqr(sin(rfo))));
  n:=semia / sqrt(1 - ee2 * sqr(sin(rfo)));
  rr:=206264.8063;
  r:=sqrt(p * n);
  f1:=rr / p;
  f2:= -(sin(rfo) / cos(rfo)) * rr / (2 * p * n);
  f3:= -3 * ee * sqr(cos(rfo)) * (sin(rfo) / cos(rfo)) * rr / (2 * p * n);
  f4:= -(1 + 3 * sqr(sin(rfo) / cos(rfo)) + ee * sqr(cos(rfo)) - 9 * ee * sqr(sin(rfo))) * rr / (6 * p * sqr(n));
  l1:=rr / (n * cos(rfo));
  tanf:=sin(rfo) / cos(rfo);    cosf:=cos(rfo);
  l2:=tanf * rr / (sqr(n) * cosf);
  l3:= -(sqr(tanf) * rr / (3 * n * n * n * cosf));
  l4:=(1 + 3 * sqr(tanf) + ee * sqr(cosf)) * rr / (3 * n * n * n * cosf);
  df:=f1 * y[j] + f2 * sqr(x[j]) + f3 * sqr(y[j]) + f4 * sqr(x[j]) * y[j];
  dl:=l1 * x[j] + l2 * x[j] * y[j] + l3 * x[j] * x[j] * x[j] + l4 * x[j] * sqr(y[j]);
  rff:=((df / 3600) * pi / 180) + rfo;
  r:=rff;
  ed5rad;
  imf[j]:=ideg;    ipf[j]:=min;    secf[j]:=sec;
  rll:=((dl / 3600) * pi / 180) + rlo;
  r:=rll;
  ed5rad;
  iml[j]:=ideg;    ipl[j]:=min;    secl[j]:=sec;    sl[j]:=s;
end;

procedure display_data(j:byte);
begin
  wrt(59,7,15,'    ');          gotoxy(59,7);  write(kwd[j]);
  wrt(21,10,15,'           ');  gotoxy(21,10); write(x[j]:4:3);
  wrt(48,10,15,'            '); gotoxy(48,10); write(y[j]:4:3);
  wrt(14,18,15,'   ');          gotoxy(14,18); write(imfo[j]:1);
  wrt(23,18,15,'   ');          gotoxy(23,18); write(ipfo[j]:1);
  wrt(29,18,15,'       ');      gotoxy(29,18); write(secfo[j]:5:4);
  wrt(40,18,15,'  ');           gotoxy(40,18); write(slo[j]);
  wrt(47,18,15,'   ');          gotoxy(47,18); write(imlo[j]:1);
  wrt(56,18,15,'   ');          gotoxy(56,18); write(iplo[j]:1);
  wrt(62,18,15,'       ');      gotoxy(62,18); write(seclo[j]:5:4);
end;
procedure inp;
label     i1,i2,i3,i4,i5,i6,i11,i12,i13,i14;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,7,58,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l);
           goto i14;
         end
         else begin end
       else kwd[l]:=buff;
i2:    input(buff,10,20,12,bit);
       if bit then goto i1 else val(buff,x[l],cod);
i3:    input(buff,10,47,13,bit);
       if bit then goto i2 else val(buff,y[l],cod);
i4:    input(buff,18,13,3,bit);
       if bit then goto i3 else val(buff,imfo[l],cod);
       if not (imfo[l] in [0..90]) then goto i4;
i5:    input(buff,18,22,3,bit);
       if bit then goto i4 else val(buff,ipfo[l],cod);
       if not (ipfo[l] in [0..60]) then goto i5;
i6:    input(buff,18,28,8,bit);
       if bit then goto i5 else val(buff,secfo[l],cod);
       if not ((secfo[l] >= 0) and (secfo[l] < 60)) then goto i6;
       if (sw1 = 0) and (sw3 = 0) then
       begin gotoxy(40,18); write('+'); end;
i11:   input(buff,18,39,2.1,bit);
       if bit then goto i6 else slo[l]:=buff;
       if (slo[l] = '+') or (slo[l] = '-') then goto i12 else goto i11;
i12:   input(buff,18,46,3,bit);
       if bit then goto i11 else val(buff,imlo[l],cod);
       if not (imlo[l] in [0..5]) then goto i12;
i13:   input(buff,18,55,3,bit);
       if bit then goto i12 else val(buff,iplo[l],cod);
       if not (iplo[l] in [0..60]) then goto i13;
i14:   input(buff,18,61,8,bit);
       if bit then goto i13 else val(buff,seclo[l],cod);
       if not ((seclo[l] >= 0) and (seclo[l] < 60)) then goto i14;
       epex(l);
       l:=succ(l);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
     end;
end;

procedure input_results_in_file;
var       k:integer;
          st:string[7];
begin
  rewrite(fill);
  writeln(fill,'===============================================================================');
  writeln(fill,'      €…ˆ‹“‡ˆ€‰† ˆ‘€„•“‘€ Š† (HATT).  “§¦¢¦š ©£¦ª (­,¢) ˜§¦ (®,y)');
  writeln(fill,'===============================================================================');
  writeln(fill,'‰—ƒˆ‰‘ ‰„Œ’ Š†‘ ‘“Œ’„’€‚‹„Œ„‘   ‘†‹„ˆ“    ‚„—‚€”ˆ‰      ‚„—‚€”ˆ‰');
  writeln(fill,'‘†‹„ˆ“ ¢˜«¦ª   ‹¡¦ª  ’œ«££œ¤    ’œ«˜š£œ¤   Š€’‘ ‘†‹„ˆ“  ‹†‰‘  ‘†‹„ˆ“');
  writeln(fill,' -----   -----  ------  ----------  -----------  -------------   --------------');
               { *****   ** **  +** **  **********  ***********  ** ** **.****   +** ** **.****}
  for k:=1 to i do
  begin
    write(fill,' ',kwd[k],' ':8-length(kwd[k]),imfo[k]:2,' ',ipfo[k]:2,
          '  ',slo[k],imlo[k]:2,' ',iplo[k]:2,'  ',x[k]:10:3,'  ',y[k]:11:3,
          '  ',imf[k]:2,' ',ipf[k]:2,' ',secf[k]:7:4);
    str(secf[k]:7:4,st);
    writeln(fill,' ':10-length(st),sl[k],iml[k]:2,' ',ipl[k]:2,' ',secl[k]:7:4);
  end;
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(4,grammi);  write(kwd[k]);      gotoxy(11,grammi); write(imfo[k]:1);
  gotoxy(14,grammi); write(ipfo[k]:1);   gotoxy(18,grammi); write(slo[k]);
  gotoxy(19,grammi); write(imlo[k]:1);   gotoxy(22,grammi); write(iplo[k]:1);
  gotoxy(27,grammi); write(x[k]:10:1);   gotoxy(39,grammi); write(y[k]:11:1);
  gotoxy(51,grammi); write(imf[k]:1);    gotoxy(54,grammi); write(ipf[k]:1);
  gotoxy(57,grammi); write(secf[k]:5:4); gotoxy(66,grammi); write(sl[k]);
  gotoxy(67,grammi); write(iml[k]:1);    gotoxy(70,grammi); write(ipl[k]:1);
  gotoxy(73,grammi); write(secl[k]:5:4);
end;
procedure write_screen(m,scr_line:integer);
var       k:integer;
begin
  clrscr;
  seek(k006_scr,2);    read(k006_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to m do
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
  if m <= 15 then
  begin
    wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
  writeln(fill,'===============================================================================');
  writeln(fill,'      €…ˆ‹“‡ˆ€‰† ˆ‘€„•“‘€ Š† (HATT).  “§¦¢¦š ©£¦ª (­,¢) ˜§¦ (®,y)');
  writeln(fill,'===============================================================================');
  writeln(fill);
  writeln(fill,'‰—ƒˆ‰‘ ‰„Œ’ Š†‘ ‘“Œ’„’€‚‹„Œ„‘   ‘†‹„ˆ“    ‚„—‚€”ˆ‰      ‚„—‚€”ˆ‰');
  writeln(fill,'‘†‹„ˆ“ ¢˜«¦ª   ‹¡¦ª  ’œ«££œ¤    ’œ«˜š£œ¤   Š€’‘ ‘†‹„ˆ“  ‹†‰‘  ‘†‹„ˆ“');
  writeln(fill,' -----   -----  ------  ----------  -----------  -------------   --------------');
end;
procedure lprint;
var       sel,gram,k:integer;
          st:string[7];
begin
  rewrite(fill);
  epikef;
  gram:=10;
  for k:=1 to i do
  begin
    writeln(fill);
    write(fill,' ',kwd[k],' ':8-length(kwd[k]),imfo[k]:2,' ',ipfo[k]:2,
          '  ',slo[k],imlo[k]:2,' ',iplo[k]:2,'  ',x[k]:10:3,'  ',y[k]:11:3,
          '  ',imf[k]:2,' ',ipf[k]:2,' ',secf[k]:7:4);
    str(secf[k]:7:4,st);
    writeln(fill,' ':10-length(st),sl[k],iml[k]:2,' ',ipl[k]:2,' ',secl[k]:7:4);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin writeln(fill); writeln(fill); epikef; gram:=10; end;
  end;
  close(fill);
end;

procedure epex_menu;
var       j,k:byte;
          ok :boolean;
label     e1,10,15,25;
begin
    case menu of
       1:begin
           if (sw1 = 1) or (sw3 = 1) then epex_menu;
15:        gotoxy(22,21);
           cursor(true,false);
           write('ƒ—‘„ ‘“ŒŠˆ‰ €ˆ‡‹ “Š‚ˆ‘‹—Œ : ');
           read(i);
           if ad then goto 15;
           clrscr;
           seek(k006_scr,1);    read(k006_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
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
             assign(in_k006,name);
             {$i-}
             reset(in_k006);
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
             wrt(11,12,240,'  ‰ € ’ € • —  —   ƒ „ ƒ  ‹ „ Œ €    ‘ „   €  • „ ˆ   ');
             rewrite(in_k006);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 kwd_h:=kwd[j]; x_h:=x[j]; y_h:=y[j];
                 imfo_h:=imfo[j]; ipfo_h:=ipfo[j]; secfo_h:=secfo[j];
                 slo_h:=slo[j]; imlo_h:=imlo[j];
                 iplo_h:=iplo[j]; seclo_h:=seclo[j];
               end;
               write(in_k006,in1_rec);
             until j = i;
             close(in_k006);
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ƒEN EKANE‘ EI‘A‚—‚H ƒEƒOMEN—N.  €’†‘„ „Œ€ Š†‰’..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
           end;
           cursor(false,true);
           epex_menu;
         end;
       3:begin
           cursor(true,false);
           gotoxy(1,20);
           write('TO AXEIO AYTO EINAI ƒHMIOY‚†MENO ME EDITOR "H ME TO ŠHKTO F2; (E/F): ');
           read(cha);
           WRT_SCREEN(OthInp,1,20,80,22);
           gotoxy(13,21); read(filename);
           if cha in ['F','f','”','­'] then
           begin
             assign(in_k006,filename);
             {$i-}
             reset(in_k006);
             {$i+}
             ok:=(ioresult=0);
             if not ok then
             begin
               gotoxy(1,23);
               write('O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..');
               repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
               cursor(false,true);
               epex_menu;
             end;
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..');
             reset(in_k006);
             seek(in_k006,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k006,in1_rec);
               with in1_rec do
               begin
                 kwd[j]:=kwd_h; x[j]:=x_h; y[j]:=y_h;
                 imfo[j]:=imfo_h; ipfo[j]:=ipfo_h; secfo[j]:=secfo_h;
                 slo[j]:=slo_h; imlo[j]:=imlo_h;
                 iplo[j]:=iplo_h; seclo[j]:=seclo_h;
               end;
               epex(j);
             until eof(in_k006);
             i:=j;
             close(in_k006);
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
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..');
             reset(f);
             j:=0;
             repeat
               j:=j+1;
               readln(f,b15_h);    kwd[j]:=b15_h;
               readln(f,b1_h);    val(b1_h,x[j],cod);
               readln(f,b2_h);    val(b2_h,y[j],cod);
               readln(f,b3_h);    val(b3_h,imfo[j],cod);
               readln(f,b4_h);    val(b4_h,ipfo[j],cod);
               readln(f,b5_h);    val(b5_h,secfo[j],cod);
               readln(f,b6_h);    slo[j]:=b6_h;
               readln(f,b7_h);    val(b7_h,imlo[j],cod);
               readln(f,b8_h);    val(b8_h,iplo[j],cod);
               readln(f,b9_h);    val(b9_h,seclo[j],cod);
               epex(j);
             until eof(f);
             close(f);
             i:=j;
           end;
           epex_menu;
         end;
       4:begin
           cursor(true,false);
           if ((sw1 <> 1) and (sw3 <> 1)) then
           begin
             cursor(false,true);
             wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  €’†‘„ „Œ€ Š†‰’..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             goto 10;
           end;
           sw4:=1;
           seek(k006_scr,1);    read(k006_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           inp;
           repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
           cursor(false,true);
10:        clrscr;
           epex_menu;
         end;
       5:begin
           cursor(true,false);
           if ((sw1=1) or (sw3=1) or (sw4=1)) then
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
               gotoxy(2,23);
               write('O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) ');
               read(kbd,cha);
               if cha in ['O','o','','¦'] then goto e1;
             end;
             input_results_in_file;
             cursor(false,true);
             epex_menu;
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
e1:          clrscr;
             cursor(false,true);
             epex_menu;
           end;
         end;
       6:begin
           cursor(true,false);
           if ((sw1=1) or (sw3=1) or (sw4=1)) then
           begin
25:          wrt_screen(OthPrint,1,4,45,17);
             GOTOXY(32,13); read(ar_gram);
             if ad then goto 25;
             gotoxy(3,15); write('„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘');
             gotoxy(10,16); write('€’†‘„ RETURN ‚ˆ€ „‰’“—‘†..');
             repeat read(kbd,cha) until cha in [#10,#13];
             cursor(false,true);
             assign(fill,'prn');
             clrscr;
             wrt(29,12,240,'„  ‰  ’  “    —  Œ  —..');
             lprint;
             sel:=0;
             epex_menu;
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             clrscr;
             epex_menu;
           end;
         end;
       7:begin
           if ((sw1=1) or (sw3=1) or (sw4=1)) then
           begin
             write_screen(i,7);
             clrscr;
             epex_menu;
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             clrscr;
             epex_menu;
           end;
         end;
    end;      { case }
end;     { procedure }


BEGIN
clrscr;
ofs1:=$8000;
if mem[0:1040] and 48 = 48 then ofs1:=$0000;
assign(k006_scr,'HXYFL.scr');
reset(k006_scr);
seek(k006_scr,3); read(k006_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

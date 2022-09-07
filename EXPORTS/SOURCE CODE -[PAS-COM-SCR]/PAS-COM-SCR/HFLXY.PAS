{******************************************************************************
*                k005 ÁÆÉÌÏÕÈÉÁÊÇ ÉÓÁĞÅ×ÏÕÓÁ ĞÑÏÂÏËÇ (HATT)                    *
*                      ÕĞÏËÏÃÉÓÌÏÓ (x,y) ÁĞÏ (ö,ë)                             *
*                  WRITTEN BY G.XALARIS                         *
*                              29-12-1986                                     *
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k005=record
           kwd_h:string[4];
           imf_h,ipf_h:integer;
           secf_h:real;
           imfo_h,ipfo_h:integer;
           secfo_h:real;
           sl_h:char;
           iml_h,ipl_h:integer;
           secl_h:real;
           slo_h:char;
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
         h_iml,h_ipl:array [1..500] of integer;
         h_secl:array [1..500] of real;
         h_imlo,h_iplo:array [1..500] of integer;
         h_seclo:array [1..500] of real;
         OthInp,OthPrint:array[1..3680] of byte;
         ideg,min:integer;

         rf,rl,rfo,rlo,semia,semib,pi,pii,
         ee2,ee,p,n,rr,r,rfm,rfom,rlm,rlom,
         df,dl,c1,c2,c3,c4,q1,q2,q3,q4,
         degmin,degsec,deg,sec            :real;

         k005_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f       :text;
         b1_h,b2_h,b3_h,b4_h,b5_h,b6_h,b7_h,b8_h,
         b9_h,b10_h,b11_h,b12_h,b13_h,b14_h     :string[12];
         b15_h   :string[4];

         in_k005 :file of rec1_k005;
         in1_rec :rec1_k005;

         sw1,sw3,sw4:byte;
         cha:char;

         sel,gram:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i force.fnc}
     {$I wrtscr.prc}

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
            rows:=rt-ra+1; cols:=ct-ca+1;
            for i:=1 to rows do wrt(ca,i+ra-1,att,chr(cols));
          end;
begin
     seek(k005_scr,0); read(k005_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k005_scr);
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
                    close(k005_scr);
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

procedure rad;
begin
  pi:=arctan(1) * 4;
  pii:=pi / 180;
  degmin:=min / 60;
  degsec:=sec / 3600;
  deg:=ideg + degmin + degsec;
  r:=deg * pii;
end;
procedure epex(j:byte);
begin
  if sl[j] = '-' then
  begin
    h_iml[j]:= -iml[j];
    h_ipl[j]:= -ipl[j];
    h_secl[j]:= -secl[j];
  end
  else
  begin
    h_iml[j]:=iml[j];
    h_ipl[j]:=ipl[j];
    h_secl[j]:=secl[j];
  end;
  if slo[j] = '-' then
  begin
    h_imlo[j]:= -imlo[j];
    h_iplo[j]:= -iplo[j];
    h_seclo[j]:= -seclo[j];
  end
  else
  begin
    h_imlo[j]:=imlo[j];
    h_iplo[j]:=iplo[j];
    h_seclo[j]:=seclo[j];
  end;
  ideg:=imf[j];  min:=ipf[j];  sec:=secf[j];
  rad;
  rf:=r;
  ideg:=h_iml[j];  min:=h_ipl[j];  sec:=h_secl[j];
  rad;
  rl:=r;
  ideg:=imfo[j];  min:=ipfo[j];  sec:=secfo[j];
  rad;
  rfo:=r;
  ideg:=h_imlo[j];  min:=h_iplo[j];  sec:=h_seclo[j];
  rad;
  rlo:=r;
  semia:=6377397.155;
  semib:=6356078.963;
  pi:=arctan(1) * 4;
  pii:=180 / pi;
  ee2:=0.006674372232;
  ee:=0.006719218799;
  p:=(semia * (1 - ee2)) / force(1 - ee2 * sqr(sin(rfo)),1.5);
  n:=semia / sqrt(1 - ee2 * sqr(sin(rfo)));
  rr:=206264.8036;
  r:=sqrt(p * n);
  rfm:=rf * pii;  rfom:=rfo * pii;  rlm:=rl * pii;  rlom:=rlo * pii;
  df:=(rfm -rfom) * 3600;  dl:=(rlm -rlom) * 3600;
  c1:=n * (cos(rfo)) / rr;
  c2:= -p * sin(rfo) / sqr(rr);
  c3:= -p * cos(rfo) * (2 + 9 * ee * sqr(sin(rfo))) / (6 * rr * rr * rr);
  c4:= -n * cos(rfo) * sqr(sin(rfo)) / (6 * rr * rr * rr);
  q1:=p / rr;
  q2:=n * cos(rfo) * sin(rfo) / (2 * sqr(rr));
  q3:=3 * sqr(p) * ee * sin(rfo) * cos(rfo) / (2 * n * sqr(rr));
  q4:=p * (1 - 4 * sqr(sin(rfo)) + ee * force(cos(rfo),4)) / (6 * rr * rr * rr);
  x[j]:=c1 * dl + c2 * dl * df + c3 * dl * sqr(df) + c4 * dl * dl * dl;
  y[j]:=q1 * df + q2 * sqr(dl) + q3 * sqr(df) + q4 * df * sqr(dl);
end;

procedure display_data(j:byte);
begin
  wrt(29,7,15,'    ');     gotoxy(29,7);  write(kwd[j]);
  wrt(16,10,15,'   ');     gotoxy(16,10); write(imf[j]:1);
  wrt(25,10,15,'   ');     gotoxy(25,10); write(ipf[j]:1);
  wrt(32,10,15,'        ');gotoxy(32,10); write(secf[j]:5:4);
  wrt(43,10,15,'   ');     gotoxy(43,10); write(imfo[j]:1);
  wrt(52,10,15,'   ');     gotoxy(52,10); write(ipfo[j]:1);
  wrt(59,10,15,'       '); gotoxy(59,10); write(secfo[j]:5:4);
  wrt(10,18,15,'  ');      gotoxy(10,18); write(sl[j]);
  wrt(16,18,15,'   ');     gotoxy(16,18); write(iml[j]:1);
  wrt(25,18,15,'   ');     gotoxy(25,18); write(ipl[j]:1);
  wrt(32,18,15,'   ');     gotoxy(32,18); write(secl[j]:5:4);
  wrt(43,18,15,'  ');      gotoxy(43,18); write(slo[j]);
  wrt(49,18,15,'   ');     gotoxy(49,18); write(imlo[j]:1);
  wrt(58,18,15,'   ');     gotoxy(58,18); write(iplo[j]:1);
  wrt(65,18,15,'       '); gotoxy(65,18); write(seclo[j]:5:4);
end;
procedure inp;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,7,28,5.1,bit);
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
i15:   input(buff,10,15,3,bit);
       if bit then goto i1 else val(buff,imf[l],cod);
       if not (imf[l] in [0..90]) then goto i15;
i2:    input(buff,10,24,3,bit);
       if bit then goto i15 else val(buff,ipf[l],cod);
       if not (ipf[l] in [0..59]) then goto i2;
i3:    input(buff,10,31,8,bit);
       if bit then goto i2 else val(buff,secf[l],cod);
       if not ((secf[l] >= 0) and (secf[l] < 60)) then goto i3;
i4:    input(buff,10,42,3,bit);
       if bit then goto i3 else val(buff,imfo[l],cod);
       if not (imfo[l] in [0..90]) then goto i4;
i5:    input(buff,10,51,3,bit);
       if bit then goto i4 else val(buff,ipfo[l],cod);
       if not (ipfo[l] in [0..60]) then goto i5;
i6:    input(buff,10,58,8,bit);
       if bit then goto i5 else val(buff,secfo[l],cod);
       if not ((secfo[l] >= 0) and (secfo[l] < 60)) then goto i6;
       if (sw1 = 0) and (sw3 = 0) then
       begin gotoxy(10,18); write('+'); end;
i7:    input(buff,18,9,3.1,bit);
       if bit then goto i6 else sl[l]:=buff;
       if (sl[l] = '+') or (sl[l] = '-') then goto i8 else goto i7;
i8:    input(buff,18,15,3,bit);
       if bit then goto i7 else val(buff,iml[l],cod);
       if not (iml[l] in [0..5]) then goto i8;
i9:    input(buff,18,24,3,bit);
       if bit then goto i8 else val(buff,ipl[l],cod);
       if not (ipl[l] in [0..59]) then goto i9;
i10:   input(buff,18,31,8,bit);
       if bit then goto i9 else val(buff,secl[l],cod);
       if not ((secl[l] >= 0) and (secl[l] < 60)) then goto i10;
       if (sw1 = 0) and (sw3 = 0) then
       begin gotoxy(43,18); write('+'); end;
i11:   input(buff,18,42,2.1,bit);
       if bit then goto i10 else slo[l]:=buff;
       if (slo[l] = '+') or (slo[l] = '-') then goto i12 else goto i11;
i12:   input(buff,18,48,3,bit);
       if bit then goto i11 else val(buff,imlo[l],cod);
       if not (imlo[l] in [0..5]) then goto i12;
i13:   input(buff,18,57,3,bit);
       if bit then goto i12 else val(buff,iplo[l],cod);
       if not (iplo[l] in [0..60]) then goto i13;
i14:   input(buff,18,64,8,bit);
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
  writeln(fill,'=============================================================================');
  writeln(fill,'     €…ˆ‹“‡ˆ€‰† ˆ‘€„•“‘€ Š† (HATT).  “§¦¢¦š ©£¦ª (x,y) ˜§¦ (­,¢)');
  writeln(fill,'=============================================================================');
  writeln(fill,'‰—ƒˆ‰‘   ‚„—‚€”ˆ‰ Š€’‘      ‚„—‚€”ˆ‰ ‹†‰‘         ‘“Œ’„’€‚‹„Œ„‘');
  writeln(fill,'‘†‹„ˆ“    ‘£œ ¦¬    ‰œ¤«¨¦¬    ‘£œ ¦¬     ‰œ¤«¨¦¬  ’œ«££œ¤    ’œ«˜š£œ¤');
  writeln(fill,' -----  -------------  -----  --------------  ------  ----------  -----------');
               { *****  ** ** *******  ** **  +** ** *******  +** **  **********  ***********}
  for k:=1 to i do
  begin
    write(fill,' ',kwd[k],' ':7-length(kwd[k]),
          imf[k]:2,' ',ipf[k]:2,' ',secf[k]:7:4);
    str(secf[k]:7:4,st);
    write(fill,' ':8-length(st),' ',imfo[k]:2,' ',ipfo[k]:2,
          '  ',sl[k],iml[k]:2,' ',ipl[k]:2,' ',secl[k]:7:4);
    str(secl[k]:7:4,st);
    writeln(fill,' ':8-length(st),' ',slo[k],imlo[k]:2,' ',iplo[k]:2,
            '  ',x[k]:10:3,'  ',y[k]:11:3);
  end;
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(3,grammi);  write(kwd[k]);    gotoxy(10,grammi); write(imf[k]:2);
  gotoxy(13,grammi); write(ipf[k]:2);  gotoxy(16,grammi); write(secf[k]:7:4);
  gotoxy(25,grammi); write(imfo[k]:2); gotoxy(28,grammi); write(ipfo[k]:2);
  gotoxy(32,grammi); write(sl[k]);     gotoxy(33,grammi); write(iml[k]:2);
  gotoxy(36,grammi); write(ipl[k]:2);  gotoxy(39,grammi); write(secl[k]:7:4);
  gotoxy(47,grammi); write(slo[k]);    gotoxy(48,grammi); write(imlo[k]:2);
  gotoxy(51,grammi); write(iplo[k]:2); gotoxy(56,grammi); write(x[k]:10:3);
  gotoxy(68,grammi); write(y[k]:11:3);
end;
procedure write_screen(m,scr_line:integer);
var       k:integer;
begin
  clrscr;
  seek(k005_scr,2);    read(k005_scr,rec1);
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
  writeln(fill,'=============================================================================');
  writeln(fill,'     €…ˆ‹“‡ˆ€‰† ˆ‘€„•“‘€ Š† (HATT).  “§¦¢¦š ©£¦ª (x,y) ˜§¦ (­,¢)');
  writeln(fill,'=============================================================================');
  writeln(fill);
  writeln(fill,'‰—ƒˆ‰‘   ‚„—‚€”ˆ‰ Š€’‘      ‚„—‚€”ˆ‰ ‹†‰‘         ‘“Œ’„’€‚‹„Œ„‘');
  writeln(fill,'‘†‹„ˆ“    ‘£œ ¦¬    ‰œ¤«¨¦¬    ‘£œ ¦¬     ‰œ¤«¨¦¬  ’œ«££œ¤    ’œ«˜š£œ¤');
  writeln(fill,' -----  -------------  -----  --------------  ------  ----------  -----------');
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
    write(fill,' ',kwd[k],' ':7-length(kwd[k]),
          imf[k]:2,' ',ipf[k]:2,' ',secf[k]:7:4);
    str(secf[k]:7:4,st);
    write(fill,' ':8-length(st),' ',imfo[k]:2,' ',ipfo[k]:2,
          '  ',sl[k],iml[k]:2,' ',ipl[k]:2,' ',secl[k]:7:4);
    str(secl[k]:7:4,st);
    writeln(fill,' ':8-length(st),' ',slo[k],imlo[k]:2,' ',iplo[k]:2,
            '  ',x[k]:10:3,'  ',y[k]:11:3);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin
      writeln(fill);
      writeln(fill);
      epikef;
      gram:=10;
    end;
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
           seek(k005_scr,1);    read(k005_scr,rec1);
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
             wrt_screen(OthInp,1,20,80,22);
             gotoxy(13,21); read(name);
             assign(in_k005,name);
             {$i-}
             reset(in_k005);
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
             rewrite(in_k005);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 imf_h:=imf[j]; ipf_h:=ipf[j]; secf_h:=secf[j];
                 imfo_h:=imfo[j]; ipfo_h:=ipfo[j]; secfo_h:=secfo[j];
                 sl_h:=sl[j]; iml_h:=iml[j]; ipl_h:=ipl[j];
                 secl_h:=secl[j]; slo_h:=slo[j]; imlo_h:=imlo[j];
                 iplo_h:=iplo[j]; seclo_h:=seclo[j]; kwd_h:=kwd[j];
               end;
               write(in_k005,in1_rec);
             until j = i;
             close(in_k005);
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
           wrt_screen(OthInp,1,20,80,22);
           gotoxy(13,21); read(filename);
           if cha in ['F','f','”','­'] then
           begin
             assign(in_k005,filename);
             {$i-}
             reset(in_k005);
             {$i+}
             ok:=(ioresult=0);
             if not ok then
             begin
               gotoxy(2,23);
               write('O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..');
               repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
               cursor(false,true);
               epex_menu;
             end;
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..');
             reset(in_k005);
             seek(in_k005,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k005,in1_rec);
               with in1_rec do
               begin
                 imf[j]:=imf_h; ipf[j]:=ipf_h; secf[j]:=secf_h;
                 imfo[j]:=imfo_h; ipfo[j]:=ipfo_h; secfo[j]:=secfo_h;
                 sl[j]:=sl_h; iml[j]:=iml_h; ipl[j]:=ipl_h;
                 secl[j]:=secl_h; slo[j]:=slo_h; imlo[j]:=imlo_h;
                 iplo[j]:=iplo_h; seclo[j]:=seclo_h; kwd[j]:=kwd_h;
               end;
               epex(j);
             until eof(in_k005);
             i:=j;
             close(in_k005);
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
               readln(f,b1_h);    val(b1_h,imf[j],cod);
               readln(f,b2_h);    val(b2_h,ipf[j],cod);
               readln(f,b3_h);    val(b3_h,secf[j],cod);
               readln(f,b4_h);    val(b4_h,imfo[j],cod);
               readln(f,b5_h);    val(b5_h,ipfo[j],cod);
               readln(f,b6_h);    val(b6_h,secfo[j],cod);
               readln(f,b7_h);    sl[j]:=b7_h;
               readln(f,b8_h);    val(b8_h,iml[j],cod);
               readln(f,b9_h);    val(b9_h,ipl[j],cod);
               readln(f,b10_h);    val(b10_h,secl[j],cod);
               readln(f,b11_h);    slo[j]:=b11_h;
               readln(f,b12_h);    val(b12_h,imlo[j],cod);
               readln(f,b13_h);    val(b13_h,iplo[j],cod);
               readln(f,b14_h);    val(b14_h,seclo[j],cod);
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
           seek(k005_scr,1);    read(k005_scr,rec1);
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
             gotoxy(32,13); read(ar_gram);
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
assign(k005_scr,'HFLXY.scr');
reset(k005_scr);
seek(k005_scr,3); read(k005_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

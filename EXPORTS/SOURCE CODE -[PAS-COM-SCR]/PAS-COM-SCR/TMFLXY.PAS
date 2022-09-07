{******************************************************************************
*     k029 ÕĞÏËÏÃÉÓÌÏÓ ÏÑÈ/ÍÉÙÍ ÓÕÍ/ÍÙÍ (×,Ø) ÁĞÏ ÃÅÙÃ/ÊÅÓ ÓÕÍ/ÍÅÓ (Ö,Ë)      *
*                        ÓÅ ĞÑÏÂÏËÇ UTM 3 ÌÏÉÑÙÍ                              *
*                  WRITTEN BY G.XALARIS                         *
*                              23-01-1987                                     *
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k029=record
           kwd_h:string[4];
           imf_h,ipf_h:integer;
           secf_h:real;
           sl_h:char;
           iml_h,ipl_h:integer;
           secl_h:real;
           izone_h:integer;
         end;
         string40 =string[40];
         string255=string[255];

var      kwd                     :array [1..500] of string[4];
         xeast1,xnor1,secf,secl,
         h_secl,xk               :array [1..500] of real;
         imf,ipf,iml,ipl,h_iml,
         h_ipl,izone,imerid      :array [1..500] of integer;
         sl                      :array [1..500] of string[2];

         ideg,min,ktag,i1,phio,smin,deg1,j,izs:integer;

         sec,fe,sf,tag1,tag2,tag3,tag4,tag5,tag6,tag7,tag8,
         ck,xlat,deg,xlong,dmin,sec1,sec11,isec,orio,pii,
         pi,oriomi,xlamo,fn,an,ap,bp,cp,dp,s,xnpv,
         pv,si,sine,cosi,tana,ssn,ccs,f1,f2,f3,f4,f5,dlam,p,
         degmin,degsec,r,a6,b5,xp,yp,efnn,iz,izone1,
         izone2,d,sec2,sec3,dl1,dl2,xla,par2,dl           :real;
         OthInp,OthPrint:array[1..3680] of byte;
         k029_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f       :text;
         b1_h,b2_h,b3_h,b4_h,
         b5_h,b6_h,b7_h,b8_h:string[12];
         b15_h:string[4];

         in_k029 :file of rec1_k029;
         in1_rec :rec1_k029;
         sw1,sw3,sw4:byte;
         cha:char;
         sel,gram:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i force.fnc}
     {$i wrtscr.prc}

procedure delete_all_input;
var       metr:integer;
begin
    fillchar(imf,sizeof(imf),0);     fillchar(ipf,sizeof(ipf),0);
    fillchar(secf,sizeof(secf),0);   fillchar(sl,sizeof(sl),0);
    fillchar(iml,sizeof(iml),0);     fillchar(ipl,sizeof(ipl),0);
    fillchar(secl,sizeof(secl),0);   fillchar(xeast1,sizeof(xeast1),0);
    fillchar(xnor1,sizeof(xnor1),0); fillchar(kwd,sizeof(kwd),0);
    fillchar(izone,sizeof(izone),0); fillchar(imerid,sizeof(imerid),0);
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
     seek(k029_scr,0);     read(k029_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k029_scr);
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
                    close(k029_scr);
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
procedure ct5umf3(j:integer);
begin
    fe       :=200000.0;
    sf       :=0.9999;
    tag1     :=0.00001;
    tag2     :=100000000.0;
    tag3     :=1.0E+16;
    tag4     :=10000;
    tag5     :=1.0E+12;
    tag6     :=20.6264806247;
    tag7     :=1.0E+24;
    tag8     :=1.0E+20;
    xnor1[j] :=0;
    xeast1[j]:=0;
    izone1   :=0;
    izone2   :=0;
    ck       :=57.2957795131;
    i1       :=1;
    phio     :=0;
 {  FN FOR UTM OF 3 DEG  }
    efnn:= -3762911.961;
 {  TEST FOR VALIDY OF INPUT VARIABLES  }
    if (abs(xlat * ck) >= 80.5) then exit;
    if (abs(xlong * ck) >= 180) then exit;
    deg:=xlong * ck;
    ideg:=trunc(deg);
    deg1:=ideg;
    dmin:=(deg - deg1) * 60;
    min:=trunc(dmin);
    smin:=min;
    sec:=(dmin - smin) * 60;
    sec1:=sec * 100000.0 + 0.5;
    sec11:=int(sec1);
    isec:=sec11;
    iz:=ideg / 6;
 {  SET I1=0 IF STATION IS ON ZONE BOUNDARY  }
    izs:=ideg mod 6;
    if (izs + min + isec) = 0 then i1:=0;
 {  COMPUTE MAJOR ZONE NUMBER  }
    if xlong < 0 then izone1:=31 + iz - i1;
    if xlong > 0 then izone1:=30 + iz + i1;
    d:=izone1 * 6 - 183;
    orio:=0.02617993878;
    pi:=arctan(1) * 4;
    oriomi:= -orio;
    if xlong < oriomi then xlamo:= -izone[j] * pi / 180;
 {  MESAIA ZONH  }
    if (xlong >= oriomi) and (xlong <= orio) then xlamo:=0;
 {  TRITH ZONH  }
    if xlong > orio then xlamo:= izone[j] * pi / 180;
    imerid[j]:=trunc(xlamo * 180 / pi);
    if (xlat < 0) then fn:=0.1 + 8;
 {  BESSEL ELLIPSOID  }
    xk[1]:=6377397.155;
    xk[2]:=6356078.9628;
    xk[3]:=0.006674372232;
    xk[4]:=0.006719218799;
 {  COMPUTE SPHEROID CONSTANTS  }
    an:=(xk[1]-xk[2])/(xk[1]+xk[2]);
    ap:=xk[1]*(1-an+1.25*(sqr(an)*(1-an))+1.265625*(sqr(an)*sqr(an)*(1-an)));
    bp:=1.5*xk[1]*(an-sqr(an)+0.875*sqr(an)*(an-sqr(an))+
        0.859375*sqr(an)*sqr(an)*an);
    cp:=0.9375*xk[1]*(sqr(an)*(1-an)+0.75*sqr(an)*sqr(an)*(1-an));
    dp:=(35/48)*xk[1]*(sqr(an)*(an-sqr(an))+0.6875*sqr(an)*sqr(an)*an);
 {  COMPUTE MERIDIONAL ARC OF STATION  }
    s:=ap*xlat-bp*sin(2*xlat)+cp*sin(4*xlat)-dp*sin(6*xlat);
 {  COMPUTE RADIUS OF CURVATURE  }
    xnpv:=xk[1]/sqrt(1-xk[3]*sqr(sin(abs(xlat))));
    pv:=xnpv;
 {  COMPUTE FUNCTIONS I,II,III,IV,AND V  }
    si:=0.48481368111*tag1;
    sine:=sin(xlat);
    cosi:=cos(xlat);
    tana:=sine/cosi;
    ssn:=sine;
    ccs:=cosi;
    f1:=s*sf;
    f2:=(pv*ssn*ccs*sqr(si)*sf*tag2)/2;
    f3:=sqr(si)*sqr(si)*pv*ssn*sqr(ccs)*ccs*sf*tag3*(5-sqr(tana)+
        9*(xk[4]*sqr(ccs))+4*(sqr(xk[4])*sqr(ccs)*sqr(ccs)))/24;
    f4:=pv*ccs*si*sf*tag4;
    f5:=sqr(si)*si*pv*sqr(ccs)*ccs*sf*tag5*(1-sqr(tana)+xk[4]*sqr(ccs))/6;
    dlam:=xlamo-xlong;
    p:=abs(dlam*tag6);
 {  COMPUTE FUNCTION A6,B5  }
    a6:=sqr(p)*sqr(p)*sqr(p)*sqr(si)*sqr(si)*sqr(si)*pv*ssn*ccs*
        sqr(ccs)*sqr(ccs)*sf*tag7*(61-58*sqr(tana)+sqr(tana)*sqr(tana)+
        270*(xk[4]*sqr(ccs))-330*(xk[4]*sqr(ssn)))/720;
    b5:=sqr(p)*sqr(p)*p*sqr(si)*sqr(si)*si*pv*sqr(ccs)*sqr(ccs)*ccs*sf*
        tag8*(5-18*sqr(tana)+sqr(tana)*sqr(tana)+
        14*(xk[4]*sqr(ccs))-58*(xk[4]*sqr(ssn)))/120;
    xp:=f4*p+(f5*p*sqr(p))+b5;
    yp:=f1+(f2*sqr(p))+(f3*sqr(p)*sqr(p))+a6;
    xnor1[j]:=efnn+yp;
    if (dlam < 0) then xeast1[j]:=fe+xp else xeast1[j]:=fe-xp;
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
  ideg:=imf[j];  min:=ipf[j];  sec:=secf[j];
  rad;
  xlat:=r;
  ideg:=h_iml[j];  min:=h_ipl[j];  sec:=h_secl[j];
  rad;
  xlong:=r;
  ct5umf3(j);
end;

procedure display_data(j:byte);
begin
  wrt(26,7,15,'    ');      gotoxy(26,7);  write(kwd[j]);
  wrt(14,10,15,'   ');      gotoxy(14,10); write(imf[j]:1);
  wrt(23,10,15,'   ');      gotoxy(23,10); write(ipf[j]:1);
  wrt(28,10,15,'        '); gotoxy(28,10); write(secf[j]:5:4);
  wrt(40,10,15,'  ');       gotoxy(40,10); write(sl[j]);
  wrt(47,10,15,'   ');      gotoxy(47,10); write(iml[j]:1);
  wrt(56,10,15,'   ');      gotoxy(56,10); write(ipl[j]:1);
  wrt(61,10,15,'   ');      gotoxy(61,10); write(secl[j]:5:4);
  wrt(66,16,15,' ');        gotoxy(66,16); write(izone[j]:1);
end;
procedure inp;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,7,25,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l);
           goto i9;
         end
         else begin end
       else kwd[l]:=buff;
i2:    input(buff,10,13,3,bit);
       if bit then goto i1 else val(buff,imf[l],cod);
       if not (imf[l] in [0..90]) then goto i2;
i3:    input(buff,10,22,3,bit);
       if bit then goto i2 else val(buff,ipf[l],cod);
       if not (ipf[l] in [0..59]) then goto i3;
i4:    input(buff,10,27,8,bit);
       if bit then goto i3 else val(buff,secf[l],cod);
       if not ((secf[l] >= 0) and (secf[l] < 60)) then goto i4;
       if (sw1 = 0) and (sw3 = 0) then
       begin gotoxy(40,10); write('+'); end;
i5:    input(buff,10,39,3.1,bit);
       if bit then goto i4 else sl[l]:=buff;
       if (sl[l] = '+') or (sl[l] = '-') then goto i6 else goto i5;
i6:    input(buff,10,46,3,bit);
       if bit then goto i5 else val(buff,iml[l],cod);
       if not (iml[l] in [0..5]) then goto i6;
i7:    input(buff,10,55,3,bit);
       if bit then goto i6 else val(buff,ipl[l],cod);
       if not (ipl[l] in [0..59]) then goto i7;
i8:    input(buff,10,60,8,bit);
       if bit then goto i7 else val(buff,secl[l],cod);
       if not ((secl[l] >= 0) and (secl[l] < 60)) then goto i8;
i9:    input(buff,16,65,2,bit);
       if bit then goto i8 else val(buff,izone[l],cod);
       if not (izone[l] in [1..3]) then goto i9;
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
  writeln(fill,'   “Š‚ˆ‘‹‘ ‡O‚—Œˆ—Œ ‘“Œ/Œ—Œ € ‚„—‚€”ˆ‰„‘ ‘“Œ’/Œ„‘  ‘„ Š† UTM 3ø');
  writeln(fill,'===============================================================================');
  writeln(fill,' ‰—ƒˆ‰‘    ‚„—‚€”ˆ‰      ‚„—‚€”ˆ‰          ‘“Œ’„’€‚‹„Œ„‘        ‰„Œ’ˆ‰‘');
  writeln(fill,' ‘†‹„ˆ“  §¢˜«¦ª ©£œ ¦¬  £¡¦ª  ©£œ ¦¬   ’œ«££œ¤     ’œ«˜š£œ¤    ‹„‘/Œ‘');
  writeln(fill,' -------  --------------  --------------  -----------  ------------  ---------');
               { 3 **** 4  ** ** *******2 +** ** *******2 ***********2 ************   6  *ø}
  for k:=1 to i do
    writeln(fill,' ':3,kwd[k],' ':8-length(kwd[k]),
            imf[k]:2,' ',ipf[k]:2,' ',secf[k]:7:4,
            '  ',sl[k],iml[k]:2,' ',ipl[k]:2,' ',secl[k]:7:4,
            '  ',xeast1[k]:11:3,'  ',xnor1[k]:12:3,' ':6,imerid[k]:1,'ø');
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(5,grammi);  write(kwd[k]);   gotoxy(12,grammi); write(imf[k]:2);
  gotoxy(15,grammi); write(ipf[k]:2); gotoxy(18,grammi); write(secf[k]:7:4);
  gotoxy(26,grammi); write(sl[k]);    gotoxy(27,grammi); write(iml[k]:2);
  gotoxy(30,grammi); write(ipl[k]:2); gotoxy(33,grammi); write(secl[k]:7:4);
  gotoxy(43,grammi); write(xeast1[k]:11:3); gotoxy(56,grammi); write(xnor1[k]:12:3);
  gotoxy(73,grammi); write(imerid[k]:1,'ø');
end;
procedure write_screen(m,scr_line:integer);
var       k:integer;
begin
  clrscr;
  seek(k029_scr,2);    read(k029_scr,rec1);
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
  writeln(fill,'   “Š‚ˆ‘‹‘ ‡O‚—Œˆ—Œ ‘“Œ/Œ—Œ € ‚„—‚€”ˆ‰„‘ ‘“Œ/Œ„‘  ‘„ Š† UTM 3ø');
  writeln(fill,'===============================================================================');
  writeln(fill);
  writeln(fill,' ‰—ƒˆ‰‘    ‚„—‚€”ˆ‰      ‚„—‚€”ˆ‰          ‘“Œ’„’€‚‹„Œ„‘        ‰„Œ’ˆ‰‘');
  writeln(fill,' ‘†‹„ˆ“  §¢˜«¦ª ©£œ ¦¬  £¡¦ª  ©£œ ¦¬   ’œ«££œ¤     ’œ«˜š£œ¤    ‹„‘/Œ‘');
  writeln(fill,' -------  --------------  --------------  -----------  ------------  ---------');
end;
procedure lprint;
var       sel,gram,k:integer;
          st:string[7];
begin
  epikef;
  gram:=10;
  for k:=1 to i do
  begin
    writeln(fill);
    writeln(fill,' ':3,kwd[k],' ':8-length(kwd[k]),
            imf[k]:2,' ',ipf[k]:2,' ',secf[k]:7:4,
            '  ',sl[k],iml[k]:2,' ',ipl[k]:2,' ',secl[k]:7:4,
            '  ',xeast1[k]:11:3,'  ',xnor1[k]:12:3,' ':6,imerid[k]:1,'ø');
    gram:=gram + 2;
    if gram >= ar_gram - 3 then
    begin
      write(fill,#12);
      epikef;
      gram:=10;
    end;
  end;
  write(fill,#12);
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
           seek(k029_scr,1);    read(k029_scr,rec1);
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
             assign(in_k029,name);
             {$i-}
             reset(in_k029);
             {$i+}
             ok:=(ioresult=0);
             if ok then
             begin
               gotoxy(1,23);
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
             rewrite(in_k029);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 imf_h:=imf[j]; ipf_h:=ipf[j]; secf_h:=secf[j];
                 sl_h:=sl[j]; iml_h:=iml[j]; ipl_h:=ipl[j];
                 secl_h:=secl[j]; kwd_h:=kwd[j]; izone_h:=izone[j];
               end;
               write(in_k029,in1_rec);
             until j = i;
             close(in_k029);
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
             assign(in_k029,filename);
             {$i-}
             reset(in_k029);
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
             reset(in_k029);
             seek(in_k029,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k029,in1_rec);
               with in1_rec do
               begin
                 imf[j]:=imf_h; ipf[j]:=ipf_h; secf[j]:=secf_h;
                 sl[j]:=sl_h; iml[j]:=iml_h; ipl[j]:=ipl_h;
                 secl[j]:=secl_h; kwd[j]:=kwd_h; izone[j]:=izone_h;
               end;
               epex(j);
             until eof(in_k029);
             i:=j;
             close(in_k029);
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
               readln(f,b4_h);    sl[j]:=b4_h;
               readln(f,b5_h);    val(b5_h,iml[j],cod);
               readln(f,b6_h);    val(b6_h,ipl[j],cod);
               readln(f,b7_h);    val(b7_h,secl[j],cod);
               readln(f,b8_h);    val(b8_h,izone[j],cod);
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
           seek(k029_scr,1);    read(k029_scr,rec1);
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
             clrscr;
             cursor(false,true);
             wrt(11,12,240,' ‚  € ” —   €   ’ „ Š „ ‘ ‹ € ’ €   ‘ „   €  • „ ˆ  ');
             input_results_in_file;
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
             rewrite(fill);
             clrscr;
             wrt(29,12,240,'„  ‰  ’  “    —  Œ  —..');
             write(fill,#27,#67,chr(ar_gram));
             write(fill,#12);
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
assign(k029_scr,'TMFLXY.scr');
reset(k029_scr);
seek(k029_scr,3);
seek(k029_scr,3); read(k029_scr,rec1);
for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

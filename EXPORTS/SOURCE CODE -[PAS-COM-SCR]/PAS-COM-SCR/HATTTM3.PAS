{******************************************************************************
*              HATTTM3 ÁĞ' ÅÕÈÅÉÁÓ ÌÅÔÁÔÑÏĞÇ ÓÕÍÔÅÔÁÃÌÅÍÙÍ                    *
*                    ÁĞÏ ĞÑÏÂÏËÇ ÇÁÔÔ ÓÅ ĞÑÏÂÏËÇ UTM 3°                    *
*                  WRITTEN BY G.XALARIS                        *
*                              30-01-1987                                     *
*******************************************************************************}
program  hatttm3;

type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_hatttm3=record
           kwd_h  :string[4];
           x_h    :real;
           y_h    :real;
           imfo_h :integer;
           ipfo_h :integer;
           secfo_h:real;
           slo_h  :char;
           imlo_h :integer;
           iplo_h :integer;
           seclo_h:real;
           izone_h:integer;
         end;
         string40 =string[40];
         string255=string[255];

var      kwd                      :array [1..500] of string[4];
         x,y,secfo,seclo,secf,
         secl,xeast1,xnor1        :array [1..500] of real;
         imfo,ipfo,imlo,iplo,imf,
         ipf,iml,ipl,izone,imerid :array [1..500] of integer;
         slo,sl                   :array [1..500] of char;
         OthInp,OthPrint:array[1..3680] of byte;
         hatttm3_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l,J   :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[14];
         fill    :text;

         f:text;
         b1_h,b2_h,b3_h,b4_h,b5_h,
         b6_h,b7_h,b8_h,b9_h,b10_h,b11_h:string[12];
         in_hatttm3 :file of rec1_hatttm3;
         in1_rec    :rec1_hatttm3;

         sw1,sw3,sw4:byte;
         cha:char;
         sel,gram:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
    fillchar(kwd,sizeof(kwd),0);    fillchar(x,sizeof(x),0);
    fillchar(y,sizeof(y),0);        fillchar(imfo,sizeof(imfo),0);
    fillchar(ipfo,sizeof(ipfo),0);  fillchar(secfo,sizeof(secfo),0);
    fillchar(slo,sizeof(slo),0);    fillchar(imlo,sizeof(imlo),0);
    fillchar(iplo,sizeof(iplo),0);  fillchar(seclo,sizeof(seclo),0);
    fillchar(izone,sizeof(izone),0);
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
     seek(hatttm3_scr,0);     read(hatttm3_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(hatttm3_scr);
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
                    close(hatttm3_scr);
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

procedure ed5rad(r:real; var s_ed5:char; var ideg,min:integer; var sec:real);
var       con,deg,amin:real;
          kdeg,adeg,bmin:integer;
begin
    if (r < 0) then s_ed5:='-' else s_ed5:='+';
    con:=57.29577951308232;
    deg:=con * abs(r);
    kdeg:=trunc(deg);
    adeg:=kdeg;
    amin:=60 * (deg - adeg);
    min:=trunc(amin);
    bmin:=min;
    sec:=60 * (amin - bmin);
    ideg:=kdeg;
end;
procedure rad(ideg,min:integer; sec:real; var r:real);
var       pi,pii,degmin,degsec,deg:real;
begin
    pi:=3.14159265358979;
    pii:=pi / 180;
    degmin:=min / 60;
    degsec:=sec / 3600;
    deg:=ideg + degmin + degsec;
    r:=deg * pii;
end;
procedure epex1(j:byte);
var       rfo,rlo,semia,semib,pi,pii,
          ee2,ee,p,n,rr,f1,f2,f3,f4,
          l1,l2,l3,l4,tanf,cosf,df,dl,
          rff,rll,degmin,degsec,fm,y1,
          fi,degfl,minfl,y2,r           :real;
          s:char;
          h_imlo,h_iplo:array[1..500] of integer;
          h_seclo      :array[1..500] of real;
begin
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
  rad(imfo[j],ipfo[j],secfo[j],rfo);
  rad(h_imlo[j],h_iplo[j],h_seclo[j],rlo);
  semia:=6377397.155;
  semib:=6356078.963;
  pi:=arctan(1) * 4;
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
  ed5rad(rff,s,imf[j],ipf[j],secf[j]);
  rll:=((dl / 3600) * pi / 180) + rlo;
  ed5rad(rll,sl[j],iml[j],ipl[j],secl[j]);
end;
procedure ct5umf3(j:integer; xlat,xlong:real);
var       ktag,ideg,min,i1,phio,smin,deg1,izs              :integer;
          fe,sf,tag1,tag2,tag3,tag4,tag5,tag6,tag7,tag8,ck,
          dmin,sec1,sec11,isec,orio,pii,pi,oriomi,xlamo,
          fn,an,ap,bp,cp,dp,s,xnpv,pv,si,sine,cosi,tana,
          ssn,ccs,f1,f2,f3,f4,f5,dlam,p,deg,sec,r,a6,b5,
          xp,yp,efnn,iz,izone1,izone2,d,sec2,sec3,
          dl1,dl2,xla,par2,dl                              :real;
          xk                    :array [1..4] of real;
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
    if xlong < oriomi then BEGIN xlamo:= -3 * pi / 180; imerid[j]:=-3; END;
 {  MESAIA ZONH  }
    if (xlong >= oriomi) and (xlong <= orio) then BEGIN xlamo:=0; imerid[j]:=0; END;
 {  TRITH ZONH  }
    if xlong > orio then BEGIN xlamo:= izone[j] * pi / 180; imerid[j]:=3; END;
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
procedure epex2(j:byte);
var       h_iml,h_ipl:array [1..500] of integer;
          h_secl     :array [1..500] of real;
          xlat,xlong :real;
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
  rad(imf[j],ipf[j],secf[j],xlat);
  rad(h_iml[j],h_ipl[j],h_secl[j],xlong);
  ct5umf3(j,xlat,xlong);
end;
procedure epex;
var       k:integer;
begin
    clrscr;
    cursor(false,true);
    wrt(23,11,112,'                                 ');
    wrt(23,12,112,'  „    ‚  €  …    ‹  €  ˆ ...  ');
    wrt(23,13,112,'                                 ');
    for k:=1 to i do
    begin
      epex1(k);
      epex2(k);
    end;
end;

procedure display_data(j:byte);
begin
  wrt(59,5,15,'    ');         gotoxy(59,5);  write(kwd[j]);
  wrt(21,8,15,'           ');  gotoxy(21,8);  write(x[j]:4:3);
  wrt(48,8,15,'            '); gotoxy(48,8);  write(y[j]:4:3);
  wrt(14,15,15,'   ');         gotoxy(14,15); write(imfo[j]:1);
  wrt(23,15,15,'   ');         gotoxy(23,15); write(ipfo[j]:1);
  wrt(29,15,15,'       ');     gotoxy(29,15); write(secfo[j]:5:4);
  wrt(40,15,15,'  ');          gotoxy(40,15); write(slo[j]);
  wrt(47,15,15,'   ');         gotoxy(47,15); write(imlo[j]:1);
  wrt(56,15,15,'   ');         gotoxy(56,15); write(iplo[j]:1);
  wrt(62,15,15,'       ');     gotoxy(62,15); write(seclo[j]:5:4);
  wrt(66,15,15,'  ');          gotoxy(66,21); write(izone[j]:1);
end;

procedure inp;
label     i1,i2,i3,i4,i5,i6,i11,i12,i13,i14,i15;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,5,58,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l);
           goto i15;
         end
         else begin end
       else kwd[l]:=buff;
i2:    input(buff,8,20,12,bit);
       if bit then goto i1 else val(buff,x[l],cod);
i3:    input(buff,8,47,13,bit);
       if bit then goto i2 else val(buff,y[l],cod);
i4:    input(buff,15,13,3,bit);
       if bit then goto i3 else val(buff,imfo[l],cod);
       if not (imfo[l] in [0..90]) then goto i4;
i5:    input(buff,15,22,3,bit);
       if bit then goto i4 else val(buff,ipfo[l],cod);
       if not (ipfo[l] in [0..60]) then goto i5;
i6:    input(buff,15,28,8,bit);
       if bit then goto i5 else val(buff,secfo[l],cod);
       if not ((secfo[l] >= 0) and (secfo[l] < 60)) then goto i6;
       if (sw1 = 0) and (sw3 = 0) then
       begin gotoxy(40,15); write('+'); end;
i11:   input(buff,15,39,1.1,bit);
       if bit then goto i6 else slo[l]:=buff;
       if (slo[l] = '+') or (slo[l] = '-') then goto i12 else goto i11;
i12:   input(buff,15,46,3,bit);
       if bit then goto i11 else val(buff,imlo[l],cod);
       if not (imlo[l] in [0..5]) then goto i12;
i13:   input(buff,15,55,3,bit);
       if bit then goto i12 else val(buff,iplo[l],cod);
       if not (iplo[l] in [0..60]) then goto i13;
i14:   input(buff,15,61,8,bit);
       if bit then goto i13 else val(buff,seclo[l],cod);
       if not ((seclo[l] >= 0) and (seclo[l] < 60)) then goto i14;
i15:   input(buff,21,65,2,bit);
       if bit then goto i14 else val(buff,izone[l],cod);
       if not (izone[l] in [1..3]) then goto i15;
       l:=succ(l);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
     end;
     epex;
end;

procedure input_results_in_file;
var       k:integer;
          st:string[7];
begin
  rewrite(fill);
  writeln(fill,'============================================================================');
  writeln(fill,'    ‹„’€’† ‘“Œ/Œ—Œ € Š† †€’’ ‘„ ‘“Œ/Œ„‘ Š†‘ UTM …—Œ†‘ 3ø');
  writeln(fill,'============================================================================');
  writeln(fill,'‰—ƒˆ‰‘     ‘“Œ’„’€‚‹„Œ„‘   ‘†‹„ˆ“      ‘“‹’„’€‚‹„Œ„‘   ‘†‹„ˆ“     ‰„Œ’.');
  writeln(fill,'‘†‹„ˆ“        ‘„  Š†  †€’’         ‘„ Š† UTM …—Œ†‘ 3ø     ‹„‘/Œ‘');
  writeln(fill,'            ’œ«££œ¤     ’œ«˜š£œ¤      ’œ«££œ¤     ’œ«˜š£œ¤');
  writeln(fill,' -----     -----------  ------------    -----------  ------------    -------       ');
               { *****  5  ***********  ************  4 ***********  ************   7   *}
  for k:=1 to i do
    writeln(fill,'  ',kwd[k],' ':9-length(kwd[k]),x[k]:11:3,'  ',y[k]:12:3,
            ' ':4,xeast1[k]:11:3,'  ',xnor1[k]:12:3,' ':7,imerid[k]:1,'ø');
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(6,grammi);  write(kwd[k]);    gotoxy(14,grammi); write(x[k]:11:3);
  gotoxy(27,grammi); write(y[k]:12:3); gotoxy(42,grammi); write(xeast1[k]:11:3);
  gotoxy(55,grammi); write(xnor1[k]:12:3); gotoxy(72,grammi); write(imerid[k]:1,'ø');
end;

procedure write_screen(m,scr_line:integer);
var       k:integer;
begin
  clrscr;
  seek(hatttm3_scr,2);    read(hatttm3_scr,rec1);
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
      scr_line:=8;
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
  writeln(fill,'============================================================================');
  writeln(fill,'    ‹„’€’† ‘“Œ/Œ—Œ € Š† †€’’ ‘„ ‘“Œ/Œ„‘ Š†‘ UTM …—Œ†‘ 3ø');
  writeln(fill,'============================================================================');
  writeln(fill,'‰—ƒˆ‰‘     ‘“Œ’„’€‚‹„Œ„‘   ‘†‹„ˆ“      ‘“‹’„’€‚‹„Œ„‘   ‘†‹„ˆ“     ‰„Œ’.');
  writeln(fill,'‘†‹„ˆ“        ‘„  Š†  †€’’         ‘„ Š† UTM …—Œ†‘ 3ø     ‹„‘/Œ‘');
  writeln(fill,'            ’œ«££œ¤     ’œ«˜š£œ¤      ’œ«££œ¤     ’œ«˜š£œ¤');
  writeln(fill,' -----     -----------  ------------    -----------  ------------    -------       ');
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
    writeln(fill,'  ',kwd[k],' ':9-length(kwd[k]),x[k]:11:3,'  ',y[k]:12:3,
            ' ':4,xeast1[k]:11:3,'  ',xnor1[k]:12:3,' ':7,imerid[k]:1,'ø');
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin write(fill,#12); epikef; gram:=10; end;
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
           seek(hatttm3_scr,1);    read(hatttm3_scr,rec1);
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
             assign(in_hatttm3,name);
             {$i-}
             reset(in_hatttm3);
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
             rewrite(in_hatttm3);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 kwd_h:=kwd[j]; x_h:=x[j]; y_h:=y[j];
                 imfo_h:=imfo[j]; ipfo_h:=ipfo[j]; secfo_h:=secfo[j];
                 slo_h:=slo[j]; imlo_h:=imlo[j];
                 iplo_h:=iplo[j]; seclo_h:=seclo[j]; izone_h:=izone[j];
               end;
               write(in_hatttm3,in1_rec);
             until j = i;
             close(in_hatttm3);
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
             assign(in_hatttm3,filename);
             {$i-}
             reset(in_hatttm3);
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
             reset(in_hatttm3);
             seek(in_hatttm3,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_hatttm3,in1_rec);
               with in1_rec do
               begin
                 kwd[j]:=kwd_h; x[j]:=x_h; y[j]:=y_h;
                 imfo[j]:=imfo_h; ipfo[j]:=ipfo_h; secfo[j]:=secfo_h;
                 slo[j]:=slo_h; imlo[j]:=imlo_h;
                 iplo[j]:=iplo_h; seclo[j]:=seclo_h; izone[j]:=izone_h;
               end;
             until eof(in_hatttm3);
             i:=j;
             epex;
             close(in_hatttm3);
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
               readln(f,b1_h);    kwd[j]:=b1_h;
               readln(f,b2_h);    val(b2_h,x[j],cod);
               readln(f,b3_h);    val(b3_h,y[j],cod);
               readln(f,b4_h);    val(b4_h,imfo[j],cod);
               readln(f,b5_h);    val(b5_h,ipfo[j],cod);
               readln(f,b6_h);    val(b6_h,secfo[j],cod);
               readln(f,b7_h);    slo[j]:=b7_h;
               readln(f,b8_h);    val(b8_h,imlo[j],cod);
               readln(f,b9_h);    val(b9_h,iplo[j],cod);
               readln(f,b10_h);    val(b10_h,seclo[j],cod);
               readln(f,b11_h);    val(b11_h,izone[j],cod);
             until eof(f);
             close(f);
             i:=j;
             epex;
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
           seek(hatttm3_scr,1);    read(hatttm3_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           inp;
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
25:          wrt_screen(OThPrint,1,4,45,17);
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
             write_screen(i,8);
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
assign(hatttm3_scr,'hatttm3.scr');
reset(hatttm3_scr);
seek(HATTTM3_scr,3); read(HATTTM3_scr,rec1);
for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

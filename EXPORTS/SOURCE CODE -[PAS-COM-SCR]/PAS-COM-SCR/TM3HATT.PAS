{******************************************************************************
*        027 ¡–' ≈’»≈…¡” Ã≈‘¡‘—œ–« ”’Õ‘≈‘¡√Ã≈ÕŸÕ ¡–œ –—œ¬œÀ« UTM ∆ŸÕ«” 3∞      *
*                       ”≈ ”’Õ‘≈‘¡√Ã≈Õ≈” –—œ¬œÀ«” HATT                        *
*                     WRITTEN BY G.XALARIS                     *
*                                 29-12-1987                                  *
*******************************************************************************}
program  k027;

type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k027=record
           kwd_h  :string[4];
           xeast_h:real;
           xnor_h :real;
           izone_h:integer;
           imfo_h :integer;
           ipfo_h :integer;
           secfo_h:real;
           slo_h  :char;
           imlo_h :integer;
           iplo_h :integer;
           seclo_h:real;
         end;
         string40 =string[40];
         string255=string[255];

var      kwd                        :array [1..500] of string[4];
         slo,sf1,sl                 :array [1..500] of char;
         xeast,xnor,secfo,seclo,x,y,
         secf,secl                  :array [1..500] of real;
         imfo,ipfo,imlo,iplo,izone,
         idegf,minf,idegl,minl      :array [1..500] of integer;
         k027_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l,j   :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;
         f_txt               :text;
         b1_h,b2_h,b3_h,b4_h,
         b5_h,b6_h,b7_h,b8_h,
         b9_h,b10_h,b11_h    :string[12];
         OthInp,OthPrint:array[1..3680] of byte;
         in_k027 :file of rec1_k027;
         in1_rec :rec1_k027;
         sw1     :byte;
         sw3     :byte;
         sw4     :byte;
         cha     :char;
         sel,gram:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i force.fnc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
    fillchar(kwd,sizeof(kwd),0);     fillchar(xeast,sizeof(xeast),0);
    fillchar(xnor,sizeof(xnor),0);   fillchar(izone,sizeof(izone),0);
    fillchar(imfo,sizeof(imfo),0);   fillchar(ipfo,sizeof(ipfo),0);
    fillchar(secfo,sizeof(secfo),0); fillchar(slo,sizeof(slo),0);
    fillchar(imlo,sizeof(imlo),' '); fillchar(iplo,sizeof(iplo),0);
    fillchar(seclo,sizeof(seclo),0); fillchar(x,sizeof(x),0);
    fillchar(y,sizeof(y),0);
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
     seek(k027_scr,0);     read(k027_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k027_scr);
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
                    close(k027_scr);
                    cursor(true,false);
                    halt;
                  end;
  '4','6',#75,#77:begin      { <ƒƒ , ƒƒ> }
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
    amin:=60 * (deg -adeg);
    min:=trunc(abs(amin));
    bmin:=min;
    sec:=60 * (amin - bmin);
    ideg:=kdeg;
end;
procedure ct5umi3(j:integer; var xlat,xlong:real);
var       ideg,min,kdeg,adeg,bmin,k  :integer;
          sec,r,con,deg,amin,xp,
          pi,xlamo,an,ap,bp,
          cp,dp,ak,aa,f,denom,t,a12,
          a3,a4,dphi,p,xnpv,aj,ss,cc,
          ajd,sin1,cc1,cc2,tana,ts,
          const1,vii,viii,d6,xix,dx,
          e5,e7,q,q2,dlam            :real;
          s_ed5                      :string[2];
          xk,c,s,w,a,b               :array [1..50] of real;
const     sf  = 0.9999;
          fe  = 200000.0;
          ffn = -3762911.961;
begin
 {  TEST INPUT PARAMETERS  }
    pi:=arctan(1) * 4;
    case izone[j] of
      1 : xlamo:=-3 * pi / 180;
      2 : xlamo:= 0;
      3 : xlamo:= 3 * pi / 180;
    end;
 {  BESSEL  }
    xk[1]:=6377397.155;
    xk[2]:=6356078.9628;
    xk[3]:=0.006674372232;
    xk[4]:=0.006719218799;
 {  COMPUTE CONSTANTS  }
    an:=(xk[1]-xk[2])/(xk[1]+xk[2]);
    ap:=xk[1]*(1-an+1.25*sqr(an)*(1-an)+1.265625*sqr(an)*sqr(an)*(1-an));
    bp:=1.5*xk[1]*(an-sqr(an)+0.875*an*sqr(an)*(1-an)
        +0.859375*sqr(an)*sqr(an)*an);
    cp:=0.9375*xk[1]*(sqr(an)*(1-an)+0.75*sqr(an)*sqr(an)*(1-an));
    dp:=(35/48)*xk[1]*(an*sqr(an)*(1-an)+0.6875*an*sqr(an)*sqr(an));
 {  FOOT POINT LATITUDE OF STATION  }
    ak:=57.2957795131;
    aa:=ap/ak;
    r:=xnor[j]-ffn;
    xlat:=r/(sf*aa);
    f:=2*xlat/ak;
    c[1]:=cos(f);
    c[2]:=cos(2*f);
    c[3]:=cos(3*f);
    s[1]:=sin(f);
    s[2]:=sin(2*f);
    s[3]:=sin(3*f);
    w[1]:=bp*s[1]-cp*s[2]+dp*s[3];
    w[2]:=2*bp*c[1]-4*cp*c[2]+6*dp*c[3];
    w[3]:=2*bp*s[1]-8*cp*s[2]+18*dp*s[3];
    w[4]:=4/3*bp*c[1]-32/3*cp*c[2]+36*dp*c[3];
    w[5]:=2/3*bp*s[1]-32/3*cp*s[2]+54*dp*s[3];
    w[6]:=4/15*bp*c[1]-128/15*cp*c[2]+324/5*dp*c[3];
    w[7]:=4/45*bp*s[1]-256/45*cp*s[2]+324/5*dp*s[3];
    denom:=aa*ak-w[2];
    t:=w[1]/denom;
    for k:=1 to 5 do a[k]:= -w[k+2]/denom;
    a12:=a[1]*a[1];
    a3:= -a[3];
    a4:= -a[4];
    b[1]:=a[1];
    b[2]:=a[2]+2*a12;
    b[3]:=a[3]+5*(a[2]+a12)*a[1];
    b[4]:=a[4]+a[1]*(6*a[3]+a[1]*(b[2]+8*a[2]))+3*b[2]*b[2];
    b[5]:=a[5]+7*(a[2]*a[3]+a[1]*(b[4]-2*b[3]*a[1]+a12*b[2]+sqr(a[2])));
    dphi:=t;
    for k:=1 to 5 do dphi:=dphi+b[k]*force(t,k+1);
    p:=(xlat + ak * dphi) / ak;
 {  COMPUTE RN FOR FOOT POINT LATITUDE  }
    xlat:=p;
    xnpv:=xk[1]/(sqrt(1-xk[3]*sqr(sin(abs(xlat)))));
    xlat:=0;
    aj:=xnpv;
    ss:=sqr(sin(p));
    cc:=sqr(cos(p));
    ajd:=sqr(aj)*sqr(sf);
    sin1:=sin(1/(3600*ak));
    cc1:=1/cc;
    cc2:=cos(2*p);
    tana:=ss/cc;
    ts:=sin(p)*1.0E+12/(cos(p)*sin1*2*ajd);
    const1:=1.0E+12/(12*ajd);
 {  COMPUTE LAT FUNCTIONS  }
    vii:=ts*(1+xk[4]*cc);
    viii:=ts*const1*(2+3*(cc1+xk[4]*(2*cc2-xk[4]*(cc+ss*cc*2))));
    d6:=ts*sqr(const1)*(32+90*cc1*(cc1-xk[4]*ss)+xk[4]*(214*cc2-20*ss))/5;
    xix:=1.0E+06/(cos(p)*sin1*aj*sf);
    dx:=2*xix*const1*(cc1+tana+xk[4]*cc);
    e5:=1.2*xix*const1*const1*(1+4*cc1*(1+6*tana)+2*xk[4]*(3+ss));
    e7:=xix*const1*sqr(const1)*2.4/7*cc*(61+tana*(662.0+tana*(1320.0+720.0*tana)));
 {  COMPUTE GRID DISTANCE FROM CM  }
    xp:=xeast[j]-fe;
    q:=abs(xp*0.000001);
 {  COMPUTE DIFF OF LONGITUDE STA FROM ORIGIN  }
    q2:=sqr(q);
    dlam:=q*(xix-q2*(dx-q2*(e5-e7*q2)))*4.8481368111E-06;
 {  LAT OF STATION  }
    xlat:=p-q2*(vii-q2*(viii-d6*q2))*4.8481368111E-06;
 {  LONG OF STATION  }
    if (xp < 0) then xlong:=xlamo-dlam else xlong:=xlamo+dlam;
    if ((abs(xlat) * ak) >= 80.5) then
    begin
      xlat:=0;
      xlong:=0;
    end;
end;
procedure epex1(j:integer);
var       xlat,xlong,r:real;
begin
    ct5umi3(j,xlat,xlong);
    r:=xlat;
    ed5rad(r,sf1[j],idegf[j],minf[j],secf[j]);
    r:=xlong;
    ed5rad(r,sl[j],idegl[j],minl[j],secl[j]);
end;
procedure rad(ideg,min:integer; sec:real; var r:real);
var       pi,pii,degmin,degsec,deg:real;
begin
  deg:=0; degmin:=0; degsec:=0;
  pi:=arctan(1) * 4;
  pii:=pi / 180;
  degmin:=min / 60;
  degsec:=sec / 3600;
  deg:=ideg + degmin + degsec;
  r:=deg * pii;
end;
procedure epex2(j:integer);
var       ideg,min         :integer;
          rf,rl,rfo,rlo,semia,semib,pi,pii,
          ee2,ee,p,n,rr,r,rfm,rfom,rlm,rlom,
          df,dl,c1,c2,c3,c4,q1,q2,q3,q4    :real;
          h_imlo,h_iplo                    :array [1..500] of integer;
          h_seclo                          :array [1..500] of real;
begin
  if sl[j] = '-' then
  begin
    idegl[j]:= -idegl[j];
    minl[j]:= -minl[j];
    secl[j]:= -secl[j];
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
  rad(idegf[j],minf[j],secf[j],rf);
  rad(idegl[j],minl[j],secl[j],rl);
  rad(imfo[j],ipfo[j],secfo[j],rfo);
  rad(h_imlo[j],h_iplo[j],h_seclo[j],rlo);
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
  c1:=0; dl:=0; c2:=0; df:=0; c3:=0; c4:=0; q1:=0; q2:=0; q3:=0; q4:=0;
end;
procedure epex;
var       k:integer;
begin
    cursor(false,true);
    clrscr;
    wrt(23,11,112,'                                 ');
    wrt(23,12,112,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à ...  ');
    wrt(23,13,112,'                                 ');
    for k:=1 to i do
    begin
      epex1(k);
      epex2(k);
    end;
end;

procedure display_data(j:integer);
begin
  wrt(59,7,15,'    ');          gotoxy(59,7);  write(kwd[j]);
  wrt(21,10,15,'           ');  gotoxy(21,10); write(xeast[j]:4:3);
  wrt(48,10,15,'            '); gotoxy(48,10); write(xnor[j]:4:3);
  wrt(60,15,15,'  ');           gotoxy(60,15); write(izone[j]:1);
  wrt(16,21,15,'  ');           gotoxy(16,21); write(imfo[j]:1);
  wrt(24,21,15,'  ');           gotoxy(24,21); write(ipfo[j]:1);
  wrt(30,21,15,'       ');      gotoxy(30,21); write(secfo[j]:5:4);
  wrt(40,21,15,' ');            gotoxy(40,21); write(slo[j]);
  wrt(45,21,15,'  ');           gotoxy(45,21); write(imlo[j]:1);
  wrt(53,21,15,'  ');           gotoxy(53,21); write(iplo[j]:1);
  wrt(59,21,15,'       ');      gotoxy(59,21); write(seclo[j]:5:4);
end;

procedure inp;
var       l:integer;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11;
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
           goto i11;
         end
         else begin end
       else kwd[l]:=buff;
i2:    input(buff,10,20,12,bit);
       if bit then goto i1 else val(buff,xeast[l],cod);
i3:    input(buff,10,47,13,bit);
       if bit then goto i2 else val(buff,xnor[l],cod);
i4:    input(buff,15,59,2,bit);
       if bit then goto i3 else val(buff,izone[l],cod);
       if not (izone[l] in [1..3]) then goto i4;
i5:    input(buff,21,15,3,bit);
       if bit then goto i4 else val(buff,imfo[l],cod);
       if not (imfo[l] in [0..90]) then goto i5;
i6:    input(buff,21,23,3,bit);
       if bit then goto i5 else val(buff,ipfo[l],cod);
       if not (ipfo[l] in [0..60]) then goto i6;
i7:    input(buff,21,29,8,bit);
       if bit then goto i6 else val(buff,secfo[l],cod);
       if not ((secfo[l] >= 0) and (secfo[l] < 60)) then goto i5;
       if (sw1=0) and (sw3=0) then
       begin gotoxy(40,21); write('+'); end;
i8:    input(buff,21,39,1.1,bit);
       if not ((buff='+') or (buff='-')) then goto i8;
       if bit then goto i7 else slo[l]:=buff;
i9:    input(buff,21,44,3,bit);
       if bit then goto i8 else val(buff,imlo[l],cod);
       if not (imlo[l] in [0..5]) then goto i9;
i10:   input(buff,21,52,3,bit);
       if bit then goto i9 else val(buff,iplo[l],cod);
       if not (iplo[l] in [0..60]) then goto i10;
i11:   input(buff,21,58,8,bit);
       if bit then goto i10 else val(buff,seclo[l],cod);
       if not ((seclo[l] >= 0) and (seclo[l] < 60)) then goto i11;
       seek(k027_scr,1);    read(k027_scr,rec1);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
       l:=succ(l);
     end;
     epex;
end;

procedure input_results_in_file;
var       k:integer;
          st:string[7];
begin
  rewrite(fill);
  writeln(fill,'=========================================================================');
  writeln(fill,'   ãÑíÄíêéèÜ ëìå/åóå Äèé èêéÅéäÜ UTM ÖóåÜë 3¯ ëÑ ëìå/åÑë èêéÅéäÜë HATT ');
  writeln(fill,'=========================================================================');
  writeln(fill,'  âóÉàâéë      ëìåíÑíÄÇãÑåÑë   ëÜãÑàéì        ëìåíÑíÄÇãÑåÑë   ëÜãÑàéì');
  writeln(fill,'  ëÜãÑàéì      ëÑ èêéÅéäÜ UTM ÖóåÜë 3¯           ëÑ  èêéÅéäÜ  HATT');
  writeln(fill,'              íú´£û£ú§û       íú´òö£ú§û      íú´£û£ú§û       íú´òö£ú§û');
  writeln(fill,'  -------    -----------    ------------    -----------    ------------');
               { 3 *****  5  *********** 4  ************ 4  ***********    ************ }
  for k:=1 to i do writeln(fill,' ':3,kwd[k],' ':10-length(kwd[k]),
    xeast[k]:11:3,' ':4,xnor[k]:12:3,' ':4,x[k]:11:3,' ':4,y[k]:12:3);
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(11,grammi); write(kwd[k]);      gotoxy(19,grammi); write(xeast[k]:11:3);
  gotoxy(32,grammi); write(xnor[k]:12:3);gotoxy(47,grammi); write(x[k]:11:3);
  gotoxy(60,grammi); write(y[k]:12:3);
end;

procedure write_screen(m,scr_line:integer);
var       k:integer;
begin
  clrscr;
  seek(k027_scr,2);    read(k027_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to m do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 22 then
    begin
      wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=8;
    end;
  end;
  if m <= 15 then
  begin
    wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'ëÑäàÉÄ : ',sel:1);
  writeln(fill);
  writeln(fill,'=========================================================================');
  writeln(fill,'   ãÑíÄíêéèÜ ëìå/åóå Äèé èêéÅéäÜ UTM ÖóåÜë 3¯ ëÑ ëìå/åÑë èêéÅéäÜë HATT ');
  writeln(fill,'=========================================================================');
  writeln(fill,'  âóÉàâéë      ëìåíÑíÄÇãÑåÑë   ëÜãÑàéì        ëìåíÑíÄÇãÑåÑë   ëÜãÑàéì');
  writeln(fill,'  ëÜãÑàéì      ëÑ èêéÅéäÜ UTM ÖóåÜë 3¯           ëÑ  èêéÅéäÜ  HATT');
  writeln(fill,'              íú´£û£ú§û       íú´òö£ú§û      íú´£û£ú§û       íú´òö£ú§û');
  writeln(fill,'  -------    -----------    ------------    -----------    ------------');
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
    writeln(fill,' ':3,kwd[k],' ':10-length(kwd[k]),
            xeast[k]:11:3,' ':4,xnor[k]:12:3,' ':4,x[k]:11:3,' ':4,y[k]:12:3);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin write(fill,#12); epikef; gram:=10; end;
  end;
  write(fill,#12);
  close(fill);
end;

procedure epex_menu;
var       j,k:integer;
          ok :boolean;
label     e1,10,15,25;
begin
    case menu of
       1:begin
           if (sw1 = 1) or (sw3 = 1) then epex_menu;
15:        gotoxy(22,21);
           cursor(true,false);
           write('ÉóëÑ ëìåéäàâé Äêàáãé ìèéäéÇàëãóå : ');
           read(i);
           if ad then goto 15;
           clrscr;
           seek(k027_scr,1);    read(k027_scr,rec1);
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
             assign(in_k027,name);
             {$i-}
             reset(in_k027);
             {$i+}
             ok:=(ioresult=0);
             if ok then
             begin
               gotoxy(2,23);
               write('èêéëÑïÑ ! íé ÄêïÑàé Äìíé ìèÄêïÑà. åÄ ÇêÄñó ÑèÄåó íéì; (å/é) ');
               read(kbd,cha);
               if cha in ['O','o','é','¶'] then
               begin
                 cursor(false,true);
                 epex_menu;
               end;
             end;
             clrscr;
             cursor(false,true);
             wrt(11,12,240,'  â Ä í Ä ï ó ê ó   É Ñ É é ã Ñ å Ä    ë Ñ   Ä ê ï Ñ à é  ');
             rewrite(in_k027);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 kwd_h:=kwd[j]; xeast_h:=xeast[j];
                 xnor_h:=xnor[j]; izone_h:=izone[j];
                 imfo_h:=imfo[j]; ipfo_h:=ipfo[j];
                 secfo_h:=secfo[j]; slo_h:=slo[j];
                 imlo_h:=imlo[j]; iplo_h:=iplo[j]; seclo_h:=seclo[j];
               end;
               write(in_k027,in1_rec);
             until j = i;
             close(in_k027);
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ÉEN EKANEë EIëAÇóÇH ÉEÉOMENóN.  èÄíÜëÑ ÑåÄ èäÜâíêé..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
           end;
           cursor(false,true);
           epex_menu;
         end;
       3:begin
           cursor(true,false);
           gotoxy(1,20);
           write('TO AêXEIO AYTO EINAI ÉHMIOYêÇÜMENO ME EDITOR "H ME TO èäHKTêO F2; (E/F): ');
           read(cha);
           wrt_screen(OthInp,1,20,80,22);
           gotoxy(13,21); read(filename);
           if cha in ['F','f','î','≠'] then
           begin
             assign(in_k027,filename);
             {$i-}
             reset(in_k027);
             {$i+}
             ok:=(ioresult=0);
             if not ok then
             begin
               gotoxy(2,23);
               write('èêOëEXE !   TO AêXEIO AYTO ÉEN YèAêXEI. èATHëE ENA èäHKTêO..');
               repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
               cursor(false,true);
               epex_menu;
             end;
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'É à Ä Å Ä Ö ó   É Ñ É é ã Ñ å Ä..');
             reset(in_k027);
             seek(in_k027,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k027,in1_rec);
               with in1_rec do
               begin
                 kwd[j]:=kwd_h; xeast[j]:=xeast_h;
                 xnor[j]:=xnor_h; izone[j]:=izone_h;
                 imfo[j]:=imfo_h; ipfo[j]:=ipfo_h;
                 secfo[j]:=secfo_h; slo[j]:=slo_h;
                 imlo[j]:=imlo_h; iplo[j]:=iplo_h; seclo[j]:=seclo_h;
               end;
             until eof(in_k027);
             close(in_k027);
             i:=j;
             epex;
           end
           else
           begin
             assign(f_txt,filename);
             {$i-}
             reset(f_txt);
             {$i+}
             ok:=(ioresult=0);
             if not ok then
             begin
               gotoxy(2,23);
               write('èêOëEXE !   TO AêXEIO AYTO ÉEN YèAêXEI. èATHëE ENA èäHKTêO..');
               repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
               cursor(false,true);
               epex_menu;
             end;
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'É à Ä Å Ä Ö ó   É Ñ É é ã Ñ å Ä..');
             reset(f_txt);
             j:=0;
             repeat
               j:=j+1;
               readln(f_txt,b1_h);    kwd[j]:=b1_h;
               readln(f_txt,b2_h);    val(b2_h,xeast[j],cod);
               readln(f_txt,b3_h);    val(b3_h,xnor[j],cod);
               readln(f_txt,b4_h);    val(b4_h,izone[j],cod);
               readln(f_txt,b5_h);    val(b5_h,imfo[j],cod);
               readln(f_txt,b6_h);    val(b6_h,ipfo[j],cod);
               readln(f_txt,b7_h);    val(b7_h,secfo[j],cod);
               readln(f_txt,b8_h);    slo[j]:=b8_h;
               readln(f_txt,b9_h);    val(b9_h,imlo[j],cod);
               readln(f_txt,b10_h);    val(b10_h,iplo[j],cod);
               readln(f_txt,b11_h);    val(b11_h,seclo[j],cod);
             until eof(f_txt);
             close(f_txt);
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
             wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èÄíÜëÑ ÑåÄ èäÜâíêé..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             goto 10;
           end;
           sw4:=1;
           seek(k027_scr,1);    read(k027_scr,rec1);
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
               write('èêOëEXE ! TO AêXEIO AYTO YèAêXEI. NA ÇêAñó EèANó TOY; (N/O) ');
               read(kbd,cha);
               if cha in ['O','o','é','¶'] then goto e1;
             end;
             clrscr;
             cursor(false,true);
             wrt(11,12,240,' Ç ê Ä î ó   Ä è é í Ñ ä Ñ ë ã Ä í Ä   ë Ñ   Ä ê ï Ñ à é ');
             input_results_in_file;
             cursor(false,true);
             epex_menu;
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èATHëE ENA èäHKTêO..');
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
             gotoxy(3,15); write('ÑåÑêÇéèéàÜëÑ íéå ÑâíìèóíÜ ëE ÄêïÜ ëÑäàÉÄë');
             gotoxy(10,16); write('èÄíÜëÑ RETURN ÇàÄ ÑâíìèóëÜ..');
             repeat read(kbd,cha) until cha in [#10,#13];
             cursor(false,true);
             assign(fill,'prn');
             clrscr;
             wrt(29,12,240,'Ñ  â  í  ì  è  ó  å  ó..');
             rewrite(fill);
             write(fill,#27,#67,chr(ar_gram));
             writeln(fill,#12);
             lprint;
             sel:=0;
             epex_menu;
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èATHëE ENA èäHKTêO..');
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
             wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èATHëE ENA èäHKTêO..');
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
assign(k027_scr,'TM3HATT.scr');
reset(k027_scr);
seek(k027_scr,3); read(k027_scr,rec1);
for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

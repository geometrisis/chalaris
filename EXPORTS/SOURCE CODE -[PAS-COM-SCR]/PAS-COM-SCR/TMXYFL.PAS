{******************************************************************************
*   Ê030 ÕĞÏËÏÃÉÓÌÏÓ ÃÅÙÃÑÁÖÉÊÙÍ ÓÕÍ/ÍÙÍ (ö,ë) ÁĞÏ ÏÑÈÏÃÙÍÉÅÓ ÓÕÍ/ÍÅÓ (÷,y)   *
*              ĞÑÏÂÏËÇÓ UTM 3 ÌÏÉÑÙÍ.(ÕĞÏÕÑÃÅÉÏÕ ÄÇÌÏÓÉÙÍ ÅÑÃÙÍ)              *
*                     WRITTEN BY G.XALARIS                    *
*                                 21-01-1987                                  *
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k030=record
           kwd_h  :string[4];
           xeast_h:real;
           xnor_h :real;
           izone_h:integer;
         end;
         string40 =string[40];
         string255=string[255];

var      kwd                        :array [1..500] of string[4];
         sf1,sl                     :array [1..500] of char;
         xeast,xnor,secf,secl       :array [1..500] of real;
         xk,c,s,w,a,b               :array [1..10] of real;
         idegf,idegl,minf,minl,izone:array [1..500] of integer;

         ideg,min,kdeg,adeg,bmin,k  :integer;
         sec,r,con,deg,amin,xlat,xp,
         xlong,pi,xlamo,an,ap,bp,
         cp,dp,ak,aa,f,denom,t,a12,
         a3,a4,dphi,p,xnpv,aj,ss,cc,
         ajd,sin1,cc1,cc2,tana,ts,
         const1,vii,viii,d6,xix,dx,
         e5,e7,q,q2,dlam            :real;
         s_ed5                      :string[2];

         k030_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l,ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;
         OthInp,OthPrint:array[1..3680] of byte;
         f_txt:text;
         b1_h,b2_h,b3_h,b4_h :string[12];

         in_k030 :file of rec1_k030;
         in1_rec :rec1_k030;

         sw1,sw3,sw4:byte;
         cha:char;
         sel,gram:integer;

const    sf=0.9999;
         fe=200000.0;
         ffn=-3762911.961;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i force.fnc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
    fillchar(kwd,sizeof(kwd),' '); fillchar(xeast,sizeof(xeast),0);
    fillchar(xnor,sizeof(xnor),0); fillchar(izone,sizeof(izone),0);
    fillchar(sf1,sizeof(sf1),' '); fillchar(idegf,sizeof(idegf),0);
    fillchar(minf,sizeof(minf),0); fillchar(secf,sizeof(secf),0);
    fillchar(sl,sizeof(sl),' ');   fillchar(idegl,sizeof(idegl),0);
    fillchar(minl,sizeof(minl),0); fillchar(secl,sizeof(secl),0);
    fillchar(xk,sizeof(xk),0);     fillchar(c,sizeof(c),0);
    fillchar(s,sizeof(s),0);       fillchar(w,sizeof(w),0);
    fillchar(a,sizeof(a),0);       fillchar(b,sizeof(b),0);
    xlat:=0;                       xlong:=0;
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
     seek(k030_scr,0);     read(k030_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin clrscr; close(k030_scr); cursor(true,false); halt; end;
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
                    clrscr;
                    close(k030_scr);
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
procedure ct5umi3(j:integer);
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
procedure epex(j:integer);
begin
    ct5umi3(j);
    r:=xlat;
    ed5rad;
    sf1[j]:=s_ed5; idegf[j]:=ideg; minf[j]:=min; secf[j]:=sec;
    ideg:=0; min:=0; sec:=0;
    r:=xlong;
    ed5rad;
    sl[j]:=s_ed5; idegl[j]:=ideg; minl[j]:=min; secl[j]:=sec;
    ideg:=0; min:=0; sec:=0;
end;

procedure display_data(j:integer);
begin
  wrt(59,7,15,'    ');          gotoxy(59,7);  write(kwd[j]);
  wrt(21,10,15,'           ');  gotoxy(21,10); write(xeast[j]:4:3);
  wrt(48,10,15,'            '); gotoxy(48,10); write(xnor[j]:4:3);
  wrt(60,15,15,'  ');           gotoxy(60,15); write(izone[j]:1);
end;
procedure inp;
var       l:integer;
label     i1,i2,i3,i4;
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
           goto i4;
         end
         else begin end else kwd[l]:=buff;
i2:    input(buff,10,20,12,bit);
       if bit then goto i1 else val(buff,xeast[l],cod);
i3:    input(buff,10,47,13,bit);
       if bit then goto i2 else val(buff,xnor[l],cod);
i4:    input(buff,15,59,2,bit);
       if bit then goto i3 else val(buff,izone[l],cod);
       if not (izone[l] in [1..3]) then goto i4;
       epex(l);
       seek(k030_scr,1);    read(k030_scr,rec1);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
       l:=succ(l);
     end;
end;

procedure input_results_in_file;
var       k:integer;
          st:string[7];
begin
  rewrite(fill);
  writeln(fill,'===============================================================================');
  writeln(fill,' “Š‚ˆ‘‹‘ ‚„—‚/‰—Œ ‘“Œ/Œ—Œ (­,¢) € ‡/Œˆ„‘ ‘“Œ/Œ„‘ (®,y) Š†‘ UTM 3ø');
  writeln(fill,'===============================================================================');
  writeln(fill,'  ‰—ƒˆ‰‘      ‘“Œ’„’€‚‹„Œ„‘   ‘†‹„ˆ“        ‚„—‚€”ˆ‰        ‚„—‚€”ˆ‰');
  writeln(fill,'  ‘†‹„ˆ“     ’œ«££œ¤       ’œ«˜š£œ¤     Š€’‘ ‘†‹„ˆ“    ‹†‰‘  ‘†‹„ˆ“');
  writeln(fill,'  -------    -----------    ------------    --------------    --------------');
               { 3 *****  5  *********** 4  ************ 4  +** ** **.****  4 +** ** **.****}
  for k:=1 to i do
  begin
    writeln(fill,' ':3,kwd[k],' ':10-length(kwd[k]),
            xeast[k]:11:3,' ':4,xnor[k]:12:3,
            ' ':4,sf1[k],idegf[k]:2,' ',minf[k]:2,' ',secf[k]:7:4,
            ' ':4,sl[k],idegl[k]:2,' ',minl[k]:2,' ',secl[k]:7:4);
  end;
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(12,grammi); write(kwd[k]);
  gotoxy(18,grammi); write(xeast[k]:11:3);
  gotoxy(30,grammi); write(xnor[k]:12:3);
  gotoxy(43,grammi); write(sf1[k]);
  gotoxy(44,grammi); write(idegf[k]:2);
  gotoxy(47,grammi); write(minf[k]:2);
  gotoxy(50,grammi); write(secf[k]:7:4);
  gotoxy(58,grammi); write(sl[k]);
  gotoxy(59,grammi); write(idegl[k]:2);
  gotoxy(62,grammi); write(minl[k]:2);
  gotoxy(65,grammi); write(secl[k]:7:4);
end;
procedure write_screen(m,scr_line:integer);
var       k:integer;
begin
  clrscr;
  seek(k030_scr,2);    read(k030_scr,rec1);
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
  writeln(fill,' “Š‚ˆ‘‹‘ ‚„—‚/‰—Œ ‘“Œ/Œ—Œ (­,¢) € ‡/Œˆ„‘ ‘“Œ/Œ„‘ (®,y) Š†‘ UTM 3ø');
  writeln(fill,'===============================================================================');
  writeln(fill);
  writeln(fill,'  ‰—ƒˆ‰‘      ‘“Œ’„’€‚‹„Œ„‘   ‘†‹„ˆ“        ‚„—‚€”ˆ‰        ‚„—‚€”ˆ‰');
  writeln(fill,'  ‘†‹„ˆ“     ’œ«££œ¤       ’œ«˜š£œ¤     Š€’‘ ‘†‹„ˆ“    ‹†‰‘  ‘†‹„ˆ“');
  writeln(fill,'  -------    -----------    ------------    --------------    --------------');
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
            xeast[k]:11:3,' ':4,xnor[k]:12:3,
            ' ':4,sf1[k],idegf[k]:2,' ',minf[k]:2,' ',secf[k]:7:4,
            ' ':4,sl[k],idegl[k]:2,' ',minl[k]:2,' ',secl[k]:7:4);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then begin write(fill,#12); epikef; gram:=10; end;
  end;
  write(fill,#12); close(fill);
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
           write('ƒ—‘„ ‘“ŒŠˆ‰ €ˆ‡‹ “Š‚ˆ‘‹—Œ : ');
           read(i);
           if ad then goto 15;
           clrscr;
           seek(k030_scr,1);    read(k030_scr,rec1);
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
             assign(in_k030,name);
             {$i-}
             reset(in_k030);
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
             rewrite(in_k030);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 kwd_h:=kwd[j]; xeast_h:=xeast[j];
                 xnor_h:=xnor[j]; izone_h:=izone[j];
               end;
               write(in_k030,in1_rec);
             until j = i;
             close(in_k030);
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
             assign(in_k030,filename);
             {$i-}
             reset(in_k030);
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
             reset(in_k030);
             seek(in_k030,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k030,in1_rec);
               with in1_rec do
               begin
                 kwd[j]:=kwd_h; xeast[j]:=xeast_h;
                 xnor[j]:=xnor_h; izone[j]:=izone_h;
               end;
               epex(j);
             until eof(in_k030);
             i:=j;
             close(in_k030);
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
               write('O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..');
               repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
               cursor(false,true);
               epex_menu;
             end;
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..');
             reset(f_txt);
             j:=0;
             repeat
               j:=j+1;
               readln(f_txt,b1_h);    kwd[j]:=b1_h;
               readln(f_txt,b2_h);    val(b2_h,xeast[j],cod);
               readln(f_txt,b3_h);    val(b3_h,xnor[j],cod);
               readln(f_txt,b4_h);    val(b4_h,izone[j],cod);
               epex(j);
             until eof(f_txt);
             close(f_txt);
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
           seek(k030_scr,1);    read(k030_scr,rec1);
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
             rewrite(fill);
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
assign(k030_scr,'TMXYFL.scr');
reset(k030_scr);
seek(k030_scr,3); read(k030_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

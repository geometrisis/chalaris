{******************************************************************************
*             ĞÑÏÂÏËÇ UÔÌ datum EGSA 87
*                WRITTEN BY G.XALARIS 
*             23.3.93   Turbo pascal 3.0
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k023=record
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
         izone,idegf,minf,idegl,minl:array [1..500] of integer;

         k023_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f_txt :text;
         b1_h  :string[12];

         in_k023 :file of rec1_k023;
         in1_rec :rec1_k023;
         OthInp,OthPrint:array[1..3680] of byte;

         sw1,sw2,sw3,sw4,sw6:byte;
         cha:char;
         gram,sel:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i force.fnc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
    fillchar(kwd,sizeof(kwd),0);      fillchar(xeast,sizeof(xeast),0);
    fillchar(xnor,sizeof(xnor),0);    fillchar(izone,sizeof(izone),0);
    fillchar(sf1,sizeof(sf1),0);      fillchar(idegf,sizeof(idegf),0);
    fillchar(minf,sizeof(minf),0);    fillchar(secf,sizeof(secf),0);
    fillchar(sl,sizeof(sl),0);        fillchar(idegl,sizeof(idegl),0);
    fillchar(minl,sizeof(minl),0);    fillchar(secl,sizeof(secl),0);
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
     seek(k023_scr,0);     read(k023_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k023_scr);
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
                    close(k023_scr);
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
{---------------------------EPEXERGASIA---------------------------------------}
procedure ED5RAD(r:real; var s_ed5:char; var ideg,min:integer; var sec:real);
var       con,deg,amin:real;
          kdeg,adeg,bmin:integer;
begin
    amin:=0; deg:=0; kdeg:=0; adeg:=0; bmin:=0;
    if (r < 0) then s_ed5:='-' else s_ed5:='+';
    con:=57.29577951308232;
    deg:=con*abs(r);
    kdeg:=trunc(deg);
    adeg:=kdeg;
    amin:=60.0*(abs(deg-adeg));
    min:=trunc(amin);
    bmin:=min;
    sec:=60.0*(amin-bmin);
    ideg:=kdeg;
end;
procedure CT5UMI3(j:integer; var xlat,xlong:real);
var       ideg,min,kdeg,adeg,bmin,k  :integer;
          sec,r,con,deg,amin,xp,
          xlamo,an,ap,bp,
          cp,dp,ak,aa,f,denom,t,a12,
          a3,a4,dphi,p,xnpv,aj,ss,cc,
          ajd,sin1,cc1,cc2,tana,ts,
          const1,vii,viii,d6,xix,dx,
          e5,e7,q,q2,dlam            :real;
          s_ed5                      :string[2];
          xk,c,s,w,a,b               :array [1..50] of real;
const     sf  = 0.9996;
          fe  = 500000.0;
          ffn = 0;
begin
    fillchar(xk,sizeof(xk),0);
    fillchar(c,sizeof(c),0);
    fillchar(s,sizeof(s),0);
    fillchar(w,sizeof(w),0);
    fillchar(a,sizeof(a),0);
    fillchar(b,sizeof(b),0);
 {  TEST INPUT PARAMETERS  }
    deg:=6*izone[j]-183;
 {   xlamo:=deg*0.0174532925199;}
     xlamo:=0.418879021;
 {  GRS 80  }
    xk[1]:=6378137.0;
    xk[2]:=6356752.3141;
    xk[3]:=0.006694380022;
    xk[4]:=0.00673949677548;
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
    c[1]:=cos(f);    c[2]:=cos(2*f);    c[3]:=cos(3*f);
    s[1]:=sin(f);    s[2]:=sin(2*f);    s[3]:=sin(3*f);
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
    p:=(xlat+ak*dphi)/ak;
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
    ts:=sin(p)*(1.0E+12)/(cos(p)*sin1*2*ajd);
    const1:=(1.0E+12)/(12*ajd);
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
    if ((abs(xlat)*ak) >= 80.5) then
    begin
      xlat:=0;
      xlong:=0;
    end;
end;
procedure EPEX1(j:integer);
var       xlat,xlong,r:real;
begin
    ct5umi3(j,xlat,xlong);
    r:=xlat;    ed5rad(r,sf1[j],idegf[j],minf[j],secf[j]);
    r:=xlong;   ed5rad(r,sl[j],idegl[j],minl[j],secl[j]);
end;
procedure EPEX;
var       k:integer;
begin
    cursor(false,true); clrscr;
    wrt(23,11,112,'                                 ');
    wrt(23,12,112,'  „    ‚  €  …    ‹  €  ˆ ...  ');
    wrt(23,13,112,'                                 ');
    for k:=1 to i do epex1(k);
end;
{-------------------------------INPUT-----------------------------------------}
procedure display_data(j:integer);
begin
  wrt(17,10,15,'     ');        gotoxy(17,10); write(kwd[j]);
  wrt(30,10,15,'           ');  gotoxy(30,10); write(xeast[j]:4:3);
  wrt(52,10,15,'            '); gotoxy(52,10); write(xnor[j]:4:3);
  wrt(52,15,15,'   ');          gotoxy(52,15); write(izone[j]:1);
end;
procedure inp;
var       l:integer;
label     i1,i2,i3,i4;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,10,16,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l);
           goto i4;
         end
         else begin end
       else kwd[l]:=buff;
i2:    input(buff,10,29,12,bit);
       if bit then goto i1
         else val(buff,xeast[l],cod);
i3:    input(buff,10,51,13,bit);
       if bit then goto i2
         else val(buff,xnor[l],cod);
 i4:    input(buff,15,51,3,bit);
       if bit then goto i3
         else val(buff,izone[l],cod);
       if not (izone[l] in [1]) then goto i4;
       seek(k023_scr,1);    read(k023_scr,rec1);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
       l:=succ(l);
     end;
     izone[l]:=34;
     epex;
end;
{---------------------------WRITE--SCREEN-------------------------------------}
procedure anal_gr_scr(grammi,k:integer);
begin
    gotoxy(10,grammi); write(kwd[k]);
    gotoxy(18,grammi); write(xeast[k]:11:3);
    gotoxy(31,grammi); write(xnor[k]:12:3);
    gotoxy(44,grammi); write(sf1[k]);
    gotoxy(45,grammi); write(idegf[k]:2);
    gotoxy(48,grammi); write(minf[k]:2);
    gotoxy(51,grammi); write(secf[k]:7:4);
    gotoxy(59,grammi); write(sl[k]);
    gotoxy(60,grammi); write(idegl[k]:2);
    gotoxy(63,grammi); write(minl[k]:2);
    gotoxy(66,grammi); write(secl[k]:7:4);
end;
procedure write_screen;
var       scr_line,k:integer;
begin
  clrscr; scr_line:=7;
  seek(k023_scr,2);    read(k023_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to i do
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
  if i <= 15 then
  begin
    wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;
{-------------------------------OUTPUT----------------------------------------}
procedure selida;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
end;
procedure epikef;
begin
  writeln(fill,'========================================================================');
  writeln(fill,' “Š‚ˆ‘‹‘ ‚„—‚€”ˆ‰—Œ ‘“Œ/Œ—Œ € ‡‚—Œˆ„‘ ‘“Œ/Œ„‘ Š†‘ UTM 6ø');
  writeln(fill,'========================================================================');
  writeln(fill,'    ‰—ƒˆ‰‘   ’„’‹†‹„Œ†     ’„’€‚‹„Œ†     ‚„—‚€”ˆ‰      ‚„—‚€”ˆ‰');
  writeln(fill,'    ‘†‹„ˆ“    ‘†‹„ˆ“       ‘†‹„ˆ“        Š€’‘           ‹†‰‘');
  writeln(fill,'    -------  -----------  ------------  --------------  --------------');
               {  6   **** 3 *******.***2 ********.***2 -** ** **.****2 -** ** **.****}
end;
procedure RESULTS;
var       gram,k:integer;
begin
  if sw6=0 then ar_gram:=66;
  selida; epikef;
  gram:=9;
  for k:=1 to i do
  begin
    writeln(fill);
    writeln(fill,' ':6,kwd[k],' ':7-length(kwd[k]),
            xeast[k]:11:3,'  ',xnor[k]:12:3,
            '  ',sf1[k],idegf[k]:2,' ',minf[k]:2,' ',secf[k]:7:4,
            '  ',sl[k],idegl[k]:2,' ',minl[k]:2,' ',secl[k]:7:4);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin
      write(fill,#12); selida; epikef; gram:=9;
    end;
  end;
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
           seek(k023_scr,1);    read(k023_scr,rec1);
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
             gotoxy(13,21);
             read(name);
             assign(in_k023,name);
             {$i-}
             reset(in_k023);
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
             rewrite(in_k023);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 kwd_h:=kwd[j]; xeast_h:=xeast[j];
                 xnor_h:=xnor[j]; izone_h:=izone[j];
               end;
               write(in_k023,in1_rec);
             until j = i;
             close(in_k023);
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
           gotoxy(13,21);
           read(filename);
           if cha in ['F','f','”','­'] then
           begin
             assign(in_k023,filename);
             {$i-}
             reset(in_k023);
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
             reset(in_k023);
             seek(in_k023,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k023,in1_rec);
               with in1_rec do
               begin
                 kwd[j]:=kwd_h; xeast[j]:=xeast_h;
                 xnor[j]:=xnor_h; izone[j]:=izone_h;
               end;
             until eof(in_k023);
             close(in_k023);
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
               gotoxy(1,23);
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
               readln(f_txt,b1_h);    val(b1_h,xeast[j],cod);
               readln(f_txt,b1_h);    val(b1_h,xnor[j],cod);
               readln(f_txt,b1_h);    val(b1_h,izone[j],cod);
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
             wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  €’†‘„ „Œ€ Š†‰’..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             goto 10;
           end;
           sw4:=1;
           seek(k023_scr,1);    read(k023_scr,rec1);
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
             gotoxy(13,21);
             read(filename);
             assign(fill,filename);
             {$i-}
             reset(fill);
             {$i+}
             ok:=(ioresult=0);
             if ok then
             begin
               gotoxy(1,23);
               write('O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) ');
               read(kbd,cha);
               if cha in ['O','o','','¦'] then goto e1;
             end;
             clrscr; sel:=0;
             cursor(false,true);
             wrt(11,12,240,' ‚  € ” —   €   ’ „ Š „ ‘ ‹ € ’ €   ‘ „   €  • „ ˆ  ');
             rewrite(fill);
             results; write(fill,#12); close(fill);
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
             sw6:=1;
             wrt_screen(OthPrint,1,4,45,17);
25:          gotoxy(32,13);
             read(ar_gram);
             if ad then goto 25;
             gotoxy(3,15);   write('„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘');
             gotoxy(10,16);  write('€’†‘„ RETURN ‚ˆ€ „‰’“—‘†');
             repeat read(kbd,cha) until cha in [#10,#13];
             cursor(false,true);
             assign(fill,'prn'); rewrite(fill);
             clrscr;
             wrt(29,12,240,'„  ‰  ’  “    —  Œ  —..');
             rewrite(fill);
             write(fill,#27,#67,chr(ar_gram));
             sel:=0; results; write(fill,#12);
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
             write_screen;
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
assign(k023_scr,'EGSAXYFL.scr');
reset(k023_scr);
seek(k023_scr,3); read(k023_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0; sw3:=0; sw4:=0; sw6:=0; i:=0; sel:=0;
cursor(false,true);
epex_menu;
END.

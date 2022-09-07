{******************************************************************************
*            k022 ÕĞÏËÏÃÉÓÌÏÓ (÷,ø) ĞÑÏÂÏËÇÓ UTM 6°ÁĞÏ (ö,ë)                  *
*                  WRITTEN BY G.XALARIS                         *
*                              10-03-1987                                     *
*******************************************************************************}
program  k022;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k022=record
           Fkwd:string[4];
           Fimf,Fipf,Fiml,Fipl:integer;
           Fsecf,Fsecl:real;
         end;
         string40 =string[40];
         string255=string[255];

var      kwd                      : array [1..500] of string[4];
         secf,secl,xeast1,xnor1,xeast2,xnor2 : array [1..500] of real;
         imf,ipf,iml,ipl : array [1..500] of integer;

         k022_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f :text;
         Tb:string[12];

         in_k022:file of rec1_k022;
         in1_rec:rec1_k022;
         OthInp,OthPrint:array[1..3680] of byte;
         sw1,sw3,sw4,sw6 : byte;
         cha     :char;
         gram,sel:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
    fillchar(kwd,sizeof(kwd),0);        fillchar(imf,sizeof(imf),0);
    fillchar(ipf,sizeof(ipf),0);        fillchar(secf,sizeof(secf),0);
    fillchar(iml,sizeof(iml),0);        fillchar(ipl,sizeof(ipl),0);
    fillchar(secl,sizeof(secl),0);      fillchar(xeast1,sizeof(xeast1),0);
    fillchar(xnor1,sizeof(xnor1),0);    fillchar(xeast2,sizeof(xeast2),0);
    fillchar(xnor2,sizeof(xnor2),0);
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
     seek(k022_scr,0);     read(k022_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k022_scr);
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
                    close(k022_scr);
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
{------------------------------EPEXERGASIA------------------------------------}
procedure RAD(ideg,min:integer; sec:real; var r:real);
var       pi,pii,degmin,degsec,deg:real;
begin
    pi:=arctan(1)*4;
    pii:=pi/180;
    degmin:=min/60;
    degsec:=sec/3600;
    deg:=ideg+degmin+degsec;
    r:=deg*pii;
end;
procedure CT5UMF3(j:integer; xlat,xlong:real);
label     830;
var       ktag,ideg,min,i1,phio,smin,deg1,izs,w   :integer;
          fe,sf,tag1,tag2,tag3,tag4,tag5,tag6,tag7,tag8,ck,
          dmin,sec1,sec11,isec,orio,pii,pi,oriomi,xlamo,
          fn,an,ap,bp,cp,dp,s,xnpv,pv,si,sine,cosi,tana,
          ssn,ccs,f1,f2,f3,f4,f5,dlam,p,deg,sec,r,a6,b5,
          xp,yp,efnn,iz,izone1,izone2,sec2,sec3,
          dl1,dl2,xla,par2,dl,d,dd,dd2                              :real;
          xk                    :array [1..4] of real;
begin
    fe:=500000.0; sf:=0.9996; w :=6;
    tag1:=0.00001; tag2:=100000000.0;
    tag3:=1.0E+16; tag4:=10000;
    tag5:=1.0E+12; tag6:=20.6264806247;
    tag7:=1.0E+24; tag8:=1.0E+20;
    xnor1[j]:=0; xeast1[j]:=0;
    izone1:=0; izone2:=0;
    ck:=57.2957795131; ktag:=0; i1:=1; phio:=0;
 {  FN FOR UTM OF 3 DEG  }
    efnn:=0;
 {  TEST FOR VALIDY OF INPUT VARIABLES  }
    if (abs(xlat*ck) >= 80.5) then exit;
    if (abs(xlong * ck) >= 180) then exit;
    deg:=xlong*ck;
    ideg:=trunc(deg);
    deg1:=ideg;
    dmin:=(deg-deg1)*60;
    min:=trunc(dmin);
    smin:=min;
    sec:=(dmin-smin)*60;
    sec1:=sec*100000.0+0.5;
    sec11:=int(sec1);
    isec:=sec11;
    iz:=ideg/6-1;
 {  SET I1=0 IF STATION IS ON ZONE BOUNDARY  }
    izs:=ideg mod 6;
    if (izs+min+isec) = 0 then i1:=0;
 {  COMPUTE MAJOR ZONE NUMBER  }
    if xlong < 0 then izone1:=31+iz-i1;
    if xlong > 0 then izone1:=34;
    d:=izone1*6-183;
    pi:=arctan(1)*4;
    xlamo:=d*pi/180.0;
    if xlat < 0 then fn:=0.1+8;
 {  INTERNATIONAL ELLIPSOID (HAYFORD)  }
830:xk[1]:=6378388.0;
    xk[2]:=6356911.94613;
    xk[3]:=0.006722670022;
    xk[4]:=0.006768170197;
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
    if ktag=1 then
    begin
      xnor2[j]:=efnn+yp;
      if dlam<0 then xeast2[j]:=fe+xp else xeast2[j]:=fe-xp;
      exit;
    end;
    xnor1[j]:=efnn+yp;
    if (dlam < 0) then xeast1[j]:=fe+xp else xeast1[j]:=fe-xp;
    sec2:=isec/100000.0;
    sec3:=sec2;
 {  DISTANCE FROM CENTRAL MERIDIAN  }
    dl1:=d;
    xla:=xlong;
    dl2:=abs(3600*(ideg-trunc(dl1)));
    par2:=(min*60)+sec3;
    if (xla<0) then dl2:=dl2-par2 else dl2:=dl2+par2;
    dl:=dl2;
    if abs(dl) < (3-w)*3600 then exit;
    if dl <= 0 then
    begin
      izone2:=izone1-1;
      if izone2=0 then begin izone2:=60; xlong:=-xlong; end;
    end
    else begin
      izone2:=izone1+1;
      if izone2=61 then begin izone2:=1; xlong:=-xlong; end;
    end;
    if izone1=34 then izone2:=35;
    dd:=izone2*6-183;
    dd2:=dd;
    xlamo:=dd*pi/180;
    ktag:=1;
    goto 830;
end;
procedure EPEX2(j:integer);
var       xlat,xlong :real;
begin
  rad(imf[j],ipf[j],secf[j],xlat);
  rad(iml[j],ipl[j],secl[j],xlong);
  ct5umf3(j,xlat,xlong);
end;
procedure EPEX;
var       k:integer;
begin
    clrscr;
    cursor(false,true);
    wrt(23,11,112,'                                 ');
    wrt(23,12,112,'  „    ‚  €  …    ‹  €  ˆ ...  ');
    wrt(23,13,112,'                                 ');
    for k:=1 to i do epex2(k);
end;
{-------------------------------INPUT-----------------------------------------}
procedure display_data(j:byte);
begin
  wrt(33,8,15,'     ');    gotoxy(33,8);     write(kwd[j]);
  wrt(17,13,15,'   ');     gotoxy(17,13);    write(imf[j]:1);
  wrt(26,13,15,'   ');     gotoxy(26,13);    write(ipf[j]:1);
  wrt(32,13,15,'       '); gotoxy(32,13);    write(secf[j]:5:4);
  wrt(44,13,15,'  ');      gotoxy(44,13);    write(iml[j]:1);
  wrt(53,13,15,'   ');     gotoxy(53,13);    write(ipl[j]:1);
  wrt(59,13,15,'       '); gotoxy(59,13);    write(secl[j]:5:4);
end;
procedure inp;
label     i1,i2,i3,i4,i5,i6,i7;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,8,32,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l);
           goto i7;
         end
         else begin end
       else kwd[l]:=buff;
i2:    input(buff,13,16,3,bit);
       if bit then goto i1 else val(buff,imf[l],cod);
       if not (imf[l] in [0..90]) then goto i2;
i3:    input(buff,13,25,3,bit);
       if bit then goto i2 else val(buff,ipf[l],cod);
       if not (ipf[l] in [0..60]) then goto i3;
i4:    input(buff,13,31,8,bit);
       if bit then goto i3 else val(buff,secf[l],cod);
       if not ((secf[l] >= 0) and (secf[l] < 60)) then goto i4;
i5:    input(buff,13,43,3,bit);
       if bit then goto i4 else val(buff,iml[l],cod);
       if not (iml[l] in [0..360]) then goto i5;
i6:    input(buff,13,52,3,bit);
       if bit then goto i5 else val(buff,ipl[l],cod);
       if not (ipl[l] in [0..60]) then goto i6;
i7:   input(buff,13,58,8,bit);
       if bit then goto i6 else val(buff,secl[l],cod);
       if not ((secf[l] >= 0) and (secf[l] < 60)) then goto i7;
       l:=succ(l);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
     end;
     epex;
end;
{--------------------------------OTHONH---------------------------------------}
procedure anal_gr_scr(grammi,k:integer);
begin
    gotoxy(11,grammi); write(kwd[k]);
    gotoxy(18,grammi); write(xeast1[k]:12:3);
    gotoxy(31,grammi); write(xnor1[k]:13:3);
    gotoxy(46,grammi); write(xeast2[k]:12:3);
    gotoxy(59,grammi); write(xnor2[k]:13:3);
end;
procedure write_screen;
var       k,scr_line:integer;
begin
  scr_line:=7; clrscr;
  seek(k022_scr,2);    read(k022_scr,rec1);
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
      scr_line:=8;
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
{-----------------------------------OUTPUT------------------------------------}
procedure selida;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
end;
procedure epikef;
begin
  writeln(fill,'============================================================================');
  writeln(fill,'“   Š  ‚ ˆ ‘ ‹  ‘   (®,¯)        Š † ‘   U T M   6ø   €     (­,¢)');
  writeln(fill,'============================================================================');
  writeln(fill,'  ‰—ƒˆ‰‘        …—Œ†:34  M„‘/Œ‘:21ø            …—Œ†:35  ‹„‘/Œ‘:27ø');
  writeln(fill,'  ‘†‹„ˆ“      ’œ«££œ¤      ’œ«˜š£œ¤        ’œ«££œ¤      ’œ«˜š£œ¤');
  writeln(fill,'  -------    -------------  -------------    -------------  -------------');
               { 4  ****  5  *********.***  *********.***  4 *********.***  *********.***}
end;
procedure results;
var       sel,gram,k:integer;
begin
  if sw6=0 then ar_gram:=66;
  sel:=0; selida; epikef;
  gram:=9;
  for k:=1 to i do
  begin
    writeln(fill);
    writeln(fill,' ':4,kwd[k],' ':9-length(kwd[k]),xeast1[k]:13:3,'  ',
            xnor1[k]:13:3,' ':4,xeast2[k]:13:3,'  ',xnor2[k]:13:3);
    gram:=gram + 2;
    if gram >= ar_gram-2 then
    begin
      write(fill,#12); selida; epikef; gram:=9;
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
           seek(k022_scr,1);    read(k022_scr,rec1);
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
             assign(in_k022,name);
             {$i-}
             reset(in_k022);
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
             rewrite(in_k022);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 Fkwd:=kwd[j]; Fimf:=imf[j]; Fipf:=ipf[j]; Fsecf:=secf[j];
                 Fiml:=iml[j]; Fipl:=ipl[j]; Fsecl:=secl[j];
               end;
               write(in_k022,in1_rec);
             until j = i;
             close(in_k022);
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
           readln(filename);
           if cha in ['F','f','”','­'] then
           begin
             assign(in_k022,filename);
             {$i-}
             reset(in_k022);
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
             reset(in_k022);
             seek(in_k022,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k022,in1_rec);
               with in1_rec do
               begin
                 kwd[j]:=Fkwd; imf[j]:=Fimf; ipf[j]:=Fipf; secf[j]:=Fsecf;
                 iml[j]:=Fiml; ipl[j]:=Fipl; secl[j]:=Fsecl;
               end;
             until eof(in_k022);
             i:=j;
             epex;
             close(in_k022);
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
             reset(f);
             j:=0;
             repeat
               j:=j+1;
               readln(f,Tb); kwd[j]:=Tb;
               readln(f,Tb); val(Tb,imf[j],cod);
               readln(f,Tb); val(Tb,ipf[j],cod);
               readln(f,Tb); val(Tb,secf[j],cod);
               readln(f,Tb); val(Tb,iml[j],cod);
               readln(f,Tb); val(Tb,ipl[j],cod);
               readln(f,Tb); val(Tb,secl[j],cod);
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
           seek(k022_scr,1);    read(k022_scr,rec1);
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
             readln(filename);
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
             clrscr;
             cursor(false,true);
             wrt(7,12,240,'  ‰ € ’ € • —  —   €   ’ „ Š „ ‘ ‹ € ’ €    ‘ „   €  • „ ˆ   ');
             rewrite(fill);
             results;
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
             sw6:=1;
             wrt_screen(OthPrint,1,4,45,17);
25:          gotoxy(32,13);
             read(ar_gram);
             if ad then goto 25;
             gotoxy(3,15); write('„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘');
             gotoxy(10,16); write('€’†‘„ RETURN ‚ˆ€ „‰’“—‘†');
             repeat read(kbd,cha) until cha in [#10,#13];
             cursor(false,true);
             assign(fill,'prn');
             rewrite(fill); sel:=0;
             clrscr;
             wrt(29,12,240,'„  ‰  ’  “    —  Œ  —..');
             write(fill,#27,#67,chr(ar_gram));
             results;
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
assign(k022_scr,'UTMFLXY.scr');
reset(k022_scr);
seek(k022_scr,3); read(k022_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0; sw3:=0; sw4:=0; sw6:=0; i:=0; sel:=0;
cursor(false,true);
epex_menu;
END.

{******************************************************************************
*               METATROPH APO KENTRO SE KENTRO     é                    *
*                       SE PROBOLH  HATT                               *
*                  WRITTEN BY G.XALARIS                                       *
*                05-01-1987  .MODIFIED  29/06/90 (FIX BUG OF SLO2 SUGNUM)     *
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k007=record
           imfo1_h,ipfo1_h:integer;
           secfo1_h:real;
           slo1_h  :char;
           imlo1_h,iplo1_h:integer;
           seclo1_h:real;
           imfo2_h,ipfo2_h:integer;
           secfo2_h:real;
           slo2_h  :char;
           imlo2_h,iplo2_h:integer;
           seclo2_h:real;
           metr_ded:integer;
         end;
         rec2_k007=record
           kwd_h:string[4];
           x1_h,y1_h:real;
           dummy:string[26];
         end;
         string40 =string[40];
         string255=string[255];

var      kwd        :array [1..50,1..30] of string[4];
         x1,y1,xap,yap:array [1..50,1..30] of real;
         imfo1,ipfo1:array [1..50] of integer;
         secfo1     :array [1..50] of real;
         slo1       :array [1..50] of string[2];
         imlo1,iplo1:array [1..50] of integer;
         seclo1     :array [1..50] of real;
         imfo2,ipfo2:array [1..50] of integer;
         secfo2     :array [1..50] of real;
         slo2       :array [1..50] of string[2];
         imlo2,iplo2:array [1..50] of integer;
         seclo2    :array [1..50] of real;
         metr_point:array [1..50] of integer;
         imf,ipf:integer;
         secf   :real;
         sl     :string[2];
         iml,ipl:integer;
         secl   :real;
         imfo,ipfo:integer;
         secfo    :real;
         slo      :string[2];
         imlo,iplo:integer;
         seclo    :real;
         OthInp,OthPrint:array[1..3680] of byte;
         ideg,min,kdeg,adeg,bmin     :integer;
         sec,r,rfo,rlo,semia,semib,pi,pii,
         ee2,ee,p,n,rr,f1,f2,f3,f4,
         l1,l2,l3,l4,tanf,cosf,df,dl,
         rff,rll,degmin,degsec,deg,
         degfl,minfl,y2,con,amin,
         rf,rl,rfm,rfom,rlm,rlom,
         c1,c2,c3,c4,q1,q2,q3,q4,x,y :real;

         s:string[2];

         k007_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         ar_gram :integer;
         i,l,m   :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f       :text;
         b1_h,b2_h,b3_h,b4_h,b5_h,
         b6_h,b7_h,b8_h,b9_h,b10_h,
         b11_h,b12_h,b13_h,b14_h,b15_h,
         b16_h,b17_h,b18_h            :string[12];

         in_k007 :file of rec1_k007;
         in1_rec :rec1_k007;
         in2_rec :rec2_k007 absolute in1_rec;

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
begin
    fillchar(imfo1,sizeof(imfo1),0);   fillchar(ipfo1,sizeof(ipfo1),0);
    fillchar(secfo1,sizeof(secfo1),0); fillchar(slo1,sizeof(slo1),' ');
    fillchar(imlo1,sizeof(imlo1),0);   fillchar(iplo1,sizeof(iplo1),0);
    fillchar(seclo1,sizeof(seclo1),0);
    fillchar(imfo2,sizeof(imfo2),0);   fillchar(ipfo2,sizeof(ipfo2),0);
    fillchar(secfo2,sizeof(secfo2),0); fillchar(slo2,sizeof(slo2),' ');
    fillchar(imlo2,sizeof(imlo2),0);   fillchar(iplo2,sizeof(iplo2),0);
    fillchar(seclo2,sizeof(seclo2),0);
    fillchar(x1,sizeof(x1),0);         fillchar(y1,sizeof(y1),0);
    fillchar(xap,sizeof(xap),0);       fillchar(yap,sizeof(yap),0);
    fillchar(kwd,sizeof(kwd),' ');
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
     seek(k007_scr,0);     read(k007_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k007_scr);
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
                    close(k007_scr);
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
    pi:=arctan(1) * 4; pii:=pi / 180;
    degmin:=min / 60;
    degsec:=sec / 3600;
    deg:=ideg + degmin + degsec;
    r:=deg * pii;
end;
procedure k05(j,m:integer);
begin
  if sl='-' then begin iml:=-iml; ipl:=-ipl; secl:=-secl; end;
  if slo='-' then begin imlo:=-imlo; iplo:=-iplo; seclo:=-seclo; end;
  ideg:=imf; min:=ipf; sec:=secf; rad; rf:=r;
  ideg:=iml; min:=ipl; sec:=secl; rad; rl:=r;
  ideg:=imfo; min:=ipfo; sec:=secfo; rad; rfo:=r;
  ideg:=imlo; min:=iplo; sec:=seclo; rad; rlo:=r;
  semia:=6377397.155; semib:=6356078.963;
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
  xap[j,m]:=c1 * dl + c2 * dl * df + c3 * dl * sqr(df) + c4 * dl * dl * dl;
  yap[j,m]:=q1 * df + q2 * sqr(dl) + q3 * sqr(df) + q4 * df * sqr(dl);
end;
procedure k06(j,m:integer);
begin
  if slo='-' then
  begin imlo:=-imlo; iplo:=-iplo; seclo:=-seclo; end;
  ideg:=imfo; min:=ipfo; sec:=secfo; rad; rfo:=r;
  ideg:=imlo; min:=iplo; sec:=seclo; rad; rlo:=r;
  semia:=6377397.155; semib:=6356078.963;
  pi:=arctan(1) * 4;
  pii:=180 / pi;
  ee2:=0.006674372232;
  ee:=0.006719218799;
  p:=(semia * (1 - ee2)) / force(1 - ee2 * sqr(sin(rfo)),1.5);
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
  df:=f1 * y + f2 * sqr(x) + f3 * sqr(y) + f4 * sqr(x) * y;
  dl:=l1 * x + l2 * x * y + l3 * x * x * x + l4 * x * sqr(y);
  rff:=((df / 3600) * pi / 180) + rfo;
  r:=rff;
  ed5rad;
  imf:=ideg;    ipf:=min;    secf:=sec;
  rll:=((dl / 3600) * pi / 180) + rlo;
  r:=rll;
  ed5rad;
  iml:=ideg;    ipl:=min;    secl:=sec;    sl:=s;
end;
procedure epex(j,m:integer);
begin
    x:=x1[j,m]; y:=y1[j,m];
    imfo:=imfo1[j]; ipfo:=ipfo1[j]; secfo:=secfo1[j];
    imlo:=imlo1[j]; iplo:=iplo1[j]; seclo:=seclo1[j]; slo:=slo1[j];
    k06(j,m);
    imfo:=imfo2[j]; ipfo:=ipfo2[j]; secfo:=secfo2[j];
    imlo:=imlo2[j]; iplo:=iplo2[j]; seclo:=seclo2[j]; slo:=slo2[j];
    k05(j,m);
end;

procedure display_data(j,m:integer);
begin
  wrt(14,9,15,'   ');           gotoxy(14,9);  write(imfo1[j]:1);
  wrt(23,9,15,'   ');           gotoxy(23,9);  write(ipfo1[j]:1);
  wrt(29,9,15,'       ');       gotoxy(29,9);  write(secfo1[j]:4:3);
  wrt(40,9,15,' ');             gotoxy(40,9);  write(slo1[j]);
  wrt(47,9,15,'  ');            gotoxy(47,9);  write(imlo1[j]:1);
  wrt(56,9,15,'  ');            gotoxy(56,9);  write(iplo1[j]:1);
  wrt(62,9,15,'       ');       gotoxy(62,9);  write(seclo1[j]:5:4);
  wrt(14,15,15,'   ');          gotoxy(14,15); write(imfo2[j]:1);
  wrt(23,15,15,'   ');          gotoxy(23,15); write(ipfo2[j]:1);
  wrt(29,15,15,'       ');      gotoxy(29,15); write(secfo2[j]:5:4);
  wrt(40,15,15,' ');            gotoxy(40,15); write(slo2[j]);
  wrt(47,15,15,'  ');           gotoxy(47,15); write(imlo2[j]:1);
  wrt(56,15,15,'  ');           gotoxy(56,15); write(iplo2[j]:1);
  wrt(62,15,15,'       ');      gotoxy(62,15); write(seclo2[j]:5:4);
  wrt(24,20,15,'    ');         gotoxy(24,20); write(kwd[j,m]);
  wrt(32,20,15,'           ');  gotoxy(32,20); write(x1[j,m]:4:3);
  wrt(45,20,15,'            '); gotoxy(45,20); write(y1[j,m]:4:3);
end;

procedure inp(l:integer);
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18;
begin
i1:    input(buff,9,13,3,bit);
       val(buff,imfo1[l],cod);
       if not (imfo1[l] in [0..90]) then goto i1;
i2:    input(buff,9,22,3,bit);
       if bit then goto i1 else val(buff,ipfo1[l],cod);
       if not (ipfo1[l] in [0..60]) then goto i2;
i3:    input(buff,9,28,8,bit);
       if bit then goto i2 else val(buff,secfo1[l],cod);
       if not((secfo1[l] >= 0) and (secfo1[l] < 60)) then goto i3;
       wrt(40,9,15,'+ ');
i4:    input(buff,9,39,2.1,bit);
       if bit then goto i3 else slo1[l]:=buff;
       if (slo1[l] = '+') or (slo1[l] = '-') then goto i5 else goto i4;
i5:    input(buff,9,46,3,bit);
       if bit then goto i4 else val(buff,imlo1[l],cod);
       if not (imlo1[l] in [0..90]) then goto i5;
i6:    input(buff,9,55,3,bit);
       if bit then goto i5 else val(buff,iplo1[l],cod);
       if not (iplo1[l] in [0..60]) then goto i6;
i7:    input(buff,9,61,8,bit);
       if bit then goto i6 else val(buff,seclo1[l],cod);
       if not ((seclo1[l] >= 0) and (seclo1[l] < 60)) then goto i6;
i8:    input(buff,15,13,3,bit);
       if bit then goto i7 else val(buff,imfo2[l],cod);
       if not (imfo2[l] in [0..90]) then goto i8;
i9:    input(buff,15,22,3,bit);
       if bit then goto i8 else val(buff,ipfo2[l],cod);
       if not (ipfo2[l] in [0..60]) then goto i9;
i10:   input(buff,15,28,8,bit);
       if bit then goto i9 else val(buff,secfo2[l],cod);
       if not((secfo2[l] >= 0) and (secfo2[l] < 60)) then goto i10;
       wrt(40,15,15,'+ ');
i11:   input(buff,15,39,2.1,bit);
       if bit then goto i10 else slo2[l]:=buff;
       if (slo2[l] = '+') or (slo2[l] = '-') then goto i12 else goto i11;
i12:   input(buff,15,46,3,bit);
       if bit then goto i11 else val(buff,imlo2[l],cod);
       if not (imlo1[l] in [0..90]) then goto i12;
i13:   input(buff,15,55,3,bit);
       if bit then goto i12 else val(buff,iplo2[l],cod);
       if not (iplo2[l] in [0..60]) then goto i13;
i14:   input(buff,15,61,8,bit);
       if bit then goto i13 else val(buff,seclo2[l],cod);
       if not ((seclo2[l] >= 0) and (seclo2[l] < 60)) then goto i14;
       m:=0;
       repeat
         m:=m + 1;
         if m = 30 then
         begin
           wrt(21,23,112,' èêéëÑïÑ !! ');
           wrt(33,23,15,' ÉàåÑàë íé íÑäÑìíÄàé ëÜãÑàé ');
         end;
i15:     input(buff,20,23,5.1,bit);
         if bit then goto i14 else kwd[l,m]:=buff;
i16:     input(buff,20,31,12,bit);
         if bit then goto i15 else val(buff,x1[l,m],cod);
i17:     input(buff,20,44,13,bit);
         if bit then goto i16 else val(buff,y1[l,m],cod);
         epex(l,m);
         if m = 30 then goto i18;
         wrt(23,23,15,'ëìåÑïàÖÑàë ãÑ åÑé ëÜãÑàé; (N/O): ');
         gotoxy(57,23);    read(kbd,cha);
         wrt(24,20,15,'    ');
         wrt(32,20,15,'           ');
         wrt(45,20,15,'            ');
       until cha in ['o','O'];
i18:   if m = 30 then wrt(21,23,15,'                                         ');
       metr_point[l]:=m;
end;

procedure diorth;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17;
begin
     l:=1;
     while l <= i do
     begin
       display_data(l,1);
i1:    input(buff,9,13,3,bit);
       if bit then
       begin
         l:=pred(l);
         if l = 0 then l:=1;
         goto i14;
       end
       else val(buff,imfo1[l],cod);
       if not (imfo1[l] in [0..90]) then goto i1;
i2:    input(buff,9,22,3,bit);
       if bit then goto i1 else val(buff,ipfo1[l],cod);
       if not (ipfo1[l] in [0..60]) then goto i2;
i3:    input(buff,9,28,8,bit);
       if bit then goto i2 else val(buff,secfo1[l],cod);
       if not((secfo1[l] >= 0) and (secfo1[l] < 60)) then goto i3;
       wrt(40,9,15,'+');
i4:    input(buff,9,39,2.1,bit);
       if bit then goto i3 else slo1[l]:=buff;
       if (slo1[l] = '+') or (slo1[l] = '-') then goto i5 else goto i4;
i5:    input(buff,9,46,3,bit);
       if bit then goto i4 else val(buff,imlo1[l],cod);
       if not (imlo1[l] in [0..90]) then goto i5;
i6:    input(buff,9,55,3,bit);
       if bit then goto i5 else val(buff,iplo1[l],cod);
       if not (iplo1[l] in [0..60]) then goto i6;
i7:    input(buff,9,61,8,bit);
       if bit then goto i6 else val(buff,seclo1[l],cod);
       if not ((seclo1[l] >= 0) and (seclo1[l] < 60)) then goto i6;
i8:    input(buff,15,13,3,bit);
       if bit then goto i7 else val(buff,imfo2[l],cod);
       if not (imfo2[l] in [0..90]) then goto i8;
i9:    input(buff,15,22,3,bit);
       if bit then goto i8 else val(buff,ipfo2[l],cod);
       if not (ipfo2[l] in [0..60]) then goto i9;
i10:   input(buff,15,28,8,bit);
       if bit then goto i9 else val(buff,secfo2[l],cod);
       if not((secfo2[l] >= 0) and (secfo2[l] < 60)) then goto i10;
       wrt(40,9,15,'+');
i11:   input(buff,15,39,2.1,bit);
       if bit then goto i10 else slo2[l]:=buff;
       if (slo2[l] = '+') or (slo2[l] = '-') then goto i12 else goto i11;
i12:   input(buff,15,46,3,bit);
       if bit then goto i11 else val(buff,imlo2[l],cod);
       if not (imlo1[l] in [0..90]) then goto i12;
i13:   input(buff,15,55,3,bit);
       if bit then goto i12 else val(buff,iplo2[l],cod);
       if not (iplo2[l] in [0..60]) then goto i13;
i14:   input(buff,15,61,8,bit);
       if bit then goto i13 else val(buff,seclo2[l],cod);
       if not ((seclo2[l] >= 0) and (seclo2[l] < 60)) then goto i14;
       m:=1;
       while m <= metr_point[l] do
       begin
         display_data(l,m);
i15:     input(buff,20,23,5.1,bit);
         if bit then
         begin
           if m = 1 then
           begin
             if l = 1 then goto i14;
             l:=l-1;
             m:=metr_point[l];
             display_data(l,m);
             goto i17;
           end
           else
           begin
             m:=pred(m);
             display_data(l,m);
             goto i17;
           end;
         end else kwd[l,m]:=buff;
i16:     input(buff,20,31,12,bit);
         if bit then goto i15 else val(buff,x1[l,m],cod);
i17:     input(buff,20,44,13,bit);
         if bit then goto i16 else val(buff,y1[l,m],cod);
         epex(l,m);
         wrt(24,20,15,'    ');
         wrt(32,20,15,'           ');
         wrt(45,20,15,'            ');
         m:=succ(m);
       end;
     l:=succ(l);
     end;
end;

procedure input_results_in_file;
var       k:integer;
begin
  rewrite(fill);
  writeln(fill,'==============================================================================');
  writeln(fill,'        ãÑíÄîéêÄ ëìåíÑíÄÇãÑåóå Äèé ÑåÄ âÑåíêé ëÑ Äääé ëÑ èêéÅéäÜ HATT');
  writeln(fill,'==============================================================================');
  writeln(fill);
  writeln(fill,'âóÉàâéë   Äèé âÑåíêé èêéÅéäÜë    ëÑ âÑåíêé èêéÅéäÜë    ëìåíÑíÄÇãÑåÑë  ëÜãÑàéì');
  writeln(fill,'ëÜãÑàéì  è¢ò´¶™      ãû°¶™      è¢ò´¶™      ãû°¶™      íú´£û£ú§û    íú´òö£ú§û');
  writeln(fill,' -----   -----  --------------  -----  --------------  ----------  -----------');
               { *****   ** **  +** ** **.****  ** **  +** ** **.****  **********  ***********}
  for l:=1 to i do
  begin
    for k:= 1 to metr_point[l] do
    begin
      writeln(fill,' ',kwd[l,k],' ':8-length(kwd[l,k]),imfo1[l]:2,' ',ipfo1[l]:2,
              '  ',slo1[l],imlo1[l]:2,' ',iplo1[l]:2,' ',seclo1[l]:7:4,
              '  ',imfo2[l]:2,' ',ipfo2[l]:2,'  ',slo2[l],imlo2[l]:2,
              ' ',iplo2[l]:2,' ',secfo2[l]:7:4,
              '  ',xap[l,k]:10:3,'  ',yap[l,k]:11:3);
    end;
  end;
  close(fill);
end;

procedure anal_gr_scr(grammi,l,k:integer);
begin
  gotoxy(4,grammi);  write(kwd[l,k]);      gotoxy(11,grammi); write(imfo1[l]:2);
  gotoxy(14,grammi); write(ipfo1[l]:2);    gotoxy(18,grammi); write(slo1[l]);
  gotoxy(19,grammi); write(imlo1[l]:2);    gotoxy(22,grammi); write(iplo1[l]:2);
  gotoxy(25,grammi); write(seclo1[l]:7:4); gotoxy(34,grammi); write(imfo2[l]:2);
  gotoxy(37,grammi); write(ipfo2[l]:2);    gotoxy(41,grammi); write(slo2[l]);
  gotoxy(42,grammi); write(imlo2[l]:2);    gotoxy(45,grammi); write(iplo2[l]:2);
  gotoxy(48,grammi); write(seclo2[l]:7:4); gotoxy(57,grammi); write(xap[l,k]:10:3);
  gotoxy(69,grammi); write(yap[l,k]:11:3);
end;

procedure write_screen;
var       k,scr_line:integer;
begin
  clrscr;
  seek(k007_scr,2);    read(k007_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  scr_line:=7;
  for l:=1 to i do
  begin
    for k:=1 to metr_point[l] do
    begin
      anal_gr_scr(scr_line,l,k);
      scr_line:=scr_line + 1;
      if scr_line = 22 then
      begin
        wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
        repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
        move(rec1.xx[0],mem[$b000:ofs1],3680);
        scr_line:=7;
      end;
    end;
  end;
  wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':68,'ëÑäàÉÄ : ',sel:1);
  writeln(fill);
  writeln(fill,'==============================================================================');
  writeln(fill,'        ãÑíÄîéêÄ ëìåíÑíÄÇãÑåóå Äèé ÑåÄ âÑåíêé ëÑ Äääé ëÑ èêéÅéäÜ HATT');
  writeln(fill,'==============================================================================');
  writeln(fill);
  writeln(fill,'âóÉàâéë   Äèé âÑåíêé èêéÅéäÜë    ëÑ âÑåíêé èêéÅéäÜë    ëìåíÑíÄÇãÑåÑë  ëÜãÑàéì');
  writeln(fill,'ëÜãÑàéì  è¢ò´¶™      ãû°¶™      è¢ò´¶™      ãû°¶™      íú´£û£ú§û    íú´òö£ú§û');
  writeln(fill,' -----   -----  --------------  -----  --------------  ----------  -----------');
end;

procedure lprint;
var       sel,gram,k:integer;
          st:string[7];
begin
  rewrite(fill);
  epikef;
  gram:=10;
  for l:=1 to i do
  begin
    for k:= 1 to metr_point[l] do
    begin
      writeln(fill);
      writeln(fill,' ',kwd[l,k],' ':8-length(kwd[l,k]),imfo1[l]:2,' ',ipfo1[l]:2,
              '  ',slo1[l],imlo1[l]:2,' ',iplo1[l]:2,' ',seclo1[l]:7:4,
              '  ',imfo2[l]:2,' ',ipfo2[l]:2,'  ',slo2[l],imlo2[l]:2,
              ' ',iplo2[l]:2,' ',secfo2[l]:7:4,
              '  ',xap[l,k]:10:3,'  ',yap[l,k]:11:3);
      gram:=gram + 2;
      if gram >= ar_gram - 2 then
      begin writeln(fill); writeln(fill); epikef; gram:=10; end;
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
           cursor(true,false);
           seek(k007_scr,1);    read(k007_scr,rec1);
           i:=0;
           repeat
             move(rec1.xx[0],mem[$b000:ofs1],3680);
             i:=i + 1;
             inp(i);
             wrt(23,23,15,'ÑïÑíÑ ÄääÜ éãÄÉÄ ÉÑÉéãÑåóå; (N/O): ');
             gotoxy(59,23);    read(kbd,cha);
           until cha in ['o','O'];
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
             assign(in_k007,name);
             {$i-}
             reset(in_k007);
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
             rewrite(in_k007);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 imfo1_h:=imfo1[j]; ipfo1_h:=ipfo1[j]; secfo1_h:=secfo1[j];
                 slo1_h:=slo1[j]; imlo1_h:=imlo1[j];
                 iplo1_h:=iplo1[j]; seclo1_h:=seclo1[j];
                 imfo2_h:=imfo2[j]; ipfo2_h:=ipfo2[j]; secfo2_h:=secfo2[j];
                 slo2_h:=slo2[j]; imlo2_h:=imlo2[j];
                 iplo2_h:=iplo2[j]; seclo2_h:=seclo2[j];
                 metr_ded:=metr_point[j];
                 write(in_k007,in1_rec);
               end;
               l:=0;
               repeat
                 l:=l + 1;
                 with in2_rec do
                 begin
                   kwd_h:=kwd[j,l]; x1_h:=x1[j,l]; y1_h:=y1[j,l];
                   write(in_k007,in1_rec);
                 end;
               until l = metr_point[j];
             until j = i;
             close(in_k007);
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
             assign(in_k007,filename);
             {$i-}
             reset(in_k007);
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
             reset(in_k007);
             seek(in_k007,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k007,in1_rec);
               with in1_rec do
               begin
                 imfo1[j]:=imfo1_h; ipfo1[j]:=ipfo1_h; secfo1[j]:=secfo1_h;
                 slo1[j]:=slo1_h; imlo1[j]:=imlo1_h;
                 iplo1[j]:=iplo1_h; seclo1[j]:=seclo1_h;
                 imfo2[j]:=imfo2_h; ipfo2[j]:=ipfo2_h; secfo2[j]:=secfo2_h;
                 slo2[j]:=slo2_h; imlo2[j]:=imlo2_h;
                 iplo2[j]:=iplo2_h; seclo2[j]:=seclo2_h;
                 metr_point[j]:=metr_ded;
               end;
               l:=0;
               repeat
                 l:=l+1;
                 read(in_k007,in1_rec);
                 with in2_rec do
                 begin
                   kwd[j,l]:=kwd_h; x1[j,l]:=x1_h; y1[j,l]:=y1_h;
                 end;
                 epex(j,l);
               until l = metr_point[j];
             until eof(in_k007);
             i:=j;
             close(in_k007);
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
               write('èêOëEXE !   TO AêXEIO AYTO ÉEN YèAêXEI. èATHëE ENA èäHKTêO..');
               repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
               cursor(false,true);
               epex_menu;
             end;
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'É à Ä Å Ä Ö ó   É Ñ É é ã Ñ å Ä..');
             reset(f);
             j:=0;
             repeat
               j:=j+1;
               readln(f,b1_h);    val(b1_h,imfo1[j],cod);
               readln(f,b2_h);    val(b2_h,ipfo1[j],cod);
               readln(f,b3_h);    val(b3_h,secfo1[j],cod);
               readln(f,b4_h);    slo1[j]:=b4_h;
               readln(f,b5_h);    val(b5_h,imlo1[j],cod);
               readln(f,b6_h);    val(b6_h,iplo1[j],cod);
               readln(f,b7_h);    val(b7_h,seclo1[j],cod);
               readln(f,b8_h);    val(b8_h,imfo2[j],cod);
               readln(f,b9_h);    val(b9_h,ipfo2[j],cod);
               readln(f,b10_h);    val(b10_h,secfo2[j],cod);
               readln(f,b11_h);    slo2[j]:=b11_h;
               readln(f,b12_h);    val(b12_h,imlo2[j],cod);
               readln(f,b13_h);    val(b13_h,iplo2[j],cod);
               readln(f,b14_h);    val(b14_h,seclo2[j],cod);
               readln(f,b15_h);    val(b15_h,metr_point[j],cod);
               l:=0;
               repeat
                 l:=l+1;
                 readln(f,b16_h);    kwd[j,l]:=b16_h;
                 readln(f,b17_h);    val(b17_h,x1[j,l],cod);
                 readln(f,b18_h);    val(b18_h,y1[j,l],cod);
                 epex(j,l);
               until l = metr_point[j];
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
             wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èÄíÜëÑ ÑåÄ èäÜâíêé..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             goto 10;
           end;
           sw4:=1;
           seek(k007_scr,1);    read(k007_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           diorth;
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
               write('èêOëEXE ! TO AêXEIO AYTO YèAêXEI. NA ÇêAñó EèANó TOY; (N/O) ');
               read(kbd,cha);
               if cha in ['O','o','é','¶'] then goto e1;
             end;
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
             write_screen;
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
assign(k007_scr,'HK1K2.scr');
reset(k007_scr);
seek(k007_scr,3); read(k007_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

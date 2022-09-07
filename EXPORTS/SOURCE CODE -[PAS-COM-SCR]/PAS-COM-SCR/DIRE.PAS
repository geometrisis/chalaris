{******************************************************************************
*                k031  ’–œÀœ√…”Ãœ” √≈Ÿƒ¡…‘… «” Ã≈‘¡÷œ—¡”                    *
*                  WRITTEN BY G.XALARIS                                                      *
*                              13-03-1987                                                            *
*******************************************************************************}
program  k031;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k031=record
           Fkwd1,Fkwd2:string[4];
           Fmlat,Fminlat,Fmlon,Fminlon,Fmfaz,Fminfaz,FChoice:integer;
           Fseclat,Fseclon,Fsecfaz,Fs:real;
         end;
         string40 =string[40];
         string255=string[255];
         string2  =string[2];

var      seclat,seclon,secfaz,s,secbaz,
         secblt,secbln                       :array [1..500] of real;
         kwd1,kwd2                           :array [1..500] of string[4];
         mlat,minlat,mlon,minlon,mfaz,minfaz,
         mbaz,minbaz,mblat,minblt,mblon,
         minbln,Choice                       :array [1..500] of integer;
         pros1,pros2,pros3                   :array [1..500] of string[2];

         k031_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f :text;
         Tb:string[20];

         in_k031:file of rec1_k031;
         in1_rec:rec1_k031;
         OthInp,OthPrint,OthDed:array[1..3680] of byte;
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
    fillchar(kwd1,sizeof(kwd1),0);     fillchar(kwd2,sizeof(kwd2),0);
    fillchar(mlat,sizeof(mlat),0);     fillchar(minlat,sizeof(minlat),0);
    fillchar(seclat,sizeof(seclat),0); fillchar(mlon,sizeof(mlon),0);
    fillchar(minlon,sizeof(minlon),0); fillchar(seclon,sizeof(seclon),0);
    fillchar(mfaz,sizeof(mfaz),0);     fillchar(minfaz,sizeof(minfaz),0);
    fillchar(secfaz,sizeof(secfaz),0); fillchar(mbaz,sizeof(mbaz),0);
    fillchar(minbaz,sizeof(minbaz),0); fillchar(secbaz,sizeof(secbaz),0);
    fillchar(mblat,sizeof(mblat),0);   fillchar(minblt,sizeof(minblt),0);
    fillchar(secblt,sizeof(secblt),0); fillchar(mblon,sizeof(mblon),0);
    fillchar(minbln,sizeof(minbln),0); fillchar(secbln,sizeof(secbln),0);
    fillchar(Choice,sizeof(Choice),0); fillchar(s,sizeof(s),0);
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
     seek(k031_scr,0);     read(k031_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k031_scr);
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
                    close(k031_scr);
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
{------------------------------EPEXERGASIA------------------------------------}
procedure RAD(ideg,min:integer; sec:real; var r:real);
var       pi,pii,degmin,degsec,deg:real;
begin
  deg:=0; degmin:=0; degsec:=0;
  pi:=arctan(1)*4;
  pii:=pi/180;
  degmin:=min/60;
  degsec:=sec/3600;
  deg:=ideg+degmin+degsec;
  r:=deg*pii; if ideg < 0 then r:=-r;
end;
procedure ED5RAD(r:real; var s_ed5:string2; var ideg,min:integer;var sec:real);
var       con,deg,amin:real;
          kdeg,adeg,bmin:integer;
begin
    if (r < 0) then s_ed5:='-' else s_ed5:='+';
    con:=57.29577951308232;
    deg:=con*abs(r);
    kdeg:=trunc(deg);
    adeg:=kdeg;
    amin:=60*(deg -adeg);
    min:=trunc(abs(amin));
    bmin:=min;
    sec:=60*(amin - bmin);
    ideg:=kdeg;
end;
procedure ARC(dx,dy:real; var az:real);
var       p,a1:real;
begin
  p:=arctan(1)*4; az:=0;
  if dx < 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p+a1; end;
    if dy = 0 then az:=3*p/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=2*p-a1; end;
  end;
  if dx = 0 then begin if dy < 0 then az:=p; if dy > 0 then az:=0; end;
  if dx > 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p-a1; end;
    if dy = 0 then az:=p/2;
    if dy>0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
  end;
end;
procedure DIRECT(k:integer; alat,alon,faz:real; var baz,blat,blon:real);
label     d1;
var       a,b,con,f,cosaz,sinaz,tanu,tha,pi,cosu,sinu,sinal,
          cossal,xk,aa,bb,first,th,costhm,sinth,costh,test,
          thtest,gnum,den,blat1,flam,d,blonend,az:real;
begin
    pi:=arctan(1)*4;
    if Choice[k]=1 then begin a:=6377397.155; b:=6356078.963; end
      else begin a:=6378388.0; b:=6356911.94613; end;
    con:=206264.806247006;
    f:=(a-b)/a;
    cosaz:=cos(faz/con); sinaz:=sin(faz/con);
    tanu:=(sin(alat/con)/cos(alat/con))*(1.0-f);
    arc(tanu,cosaz,az);
    while az > 2*pi do az:=az-2*pi; tha:=az;
    cosu:=1.0/sqrt(1.0+sqr(tanu));
    sinu:=tanu*cosu;
    sinal:=cosu*sinaz;
    cossal:=1.0-sqr(sinal);
    xk:=(sqr(a/b)-1.0)*cossal;
    aa:=(((xk*(-175.0)+32.0)*xk-768.0)*xk+4096.0)*xk/16384.0+1.0;
    bb:=(((xk*(-47.0)+74.0)*xk-128.0)*xk+256.0)*xk/1024.0;
    first:=(s[k]/b)/aa;
    th:=first;
d1: costhm:=cos(2.0*tha+th);
    sinth:=sin(th);
    costh:=cos(th);
    test:=th;
    th:=(((sqr(costhm)*4.0-3.0)*(sqr(sinth)*4.0-3.0)*costhm*(-bb)/6.0+
        (sqr(costhm)*2.0-1.0)*costh)*bb/4.0+costhm)*sinth*bb+first;
    thtest:=abs(th-test);
    if (thtest > (1.0E-11)) then goto d1;
    test:=sinu*sinth-cosu*costh*cosaz;
    gnum:=sinu*costh+cosu*sinth*cosaz;
    den:=(1.0-f)*sqrt(sqr(sinal)+sqr(test));
    arc(gnum,den,az);
    while az > 2*pi do az:=az-2*pi; blat1:=az;
    blat:=blat1*con;
    arc((sinth*sinaz),(cosu*costh-sinu*sinth*cosaz),az);
    while az > 2*pi do az:=az-2*pi; flam:=az;
    d:=((-3.0*cossal+4.0)*f+4.0)*cossal*f/16.0;
    blon:=(((sqr(costhm)*2.0-1.0)*costh*d+costhm)*d*sinth+th)*sinal*f*(d-1.0)+flam;
    blon:=alon+blon*con;
    blonend:=blon;
    if blon > 648000.0 then blon:=blon-1296000.0;
    if blon < -648000.0 then blon:=blon+1296000.0;
    arc(-sinal,test,az);
    while az > 2*pi do az:=az-2*pi; baz:=az;
    baz:=baz*con;
    if baz < 0 then baz:=baz+1296000.0;
end;
procedure EPEX;
var       k:integer;
          pi,pii,r,alat,alon,faz,baz,blat,blon,rblat,rblon,rbaz:real;
begin
  clrscr;
  cursor(false,true);
  wrt(23,11,112,'                                 ');
  wrt(23,12,112,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à ...  ');
  wrt(23,13,112,'                                 ');
  pi:=arctan(1)*4;
  pii:=pi/180.0;
  for k:=1 to i do
  begin
    rad(mlat[k],minlat[k],seclat[k],r); alat:=(r*180.0/pi)*3600.0;
    rad(mlon[k],minlon[k],seclon[k],r); alon:=(r*180.0/pi)*3600.0;
    rad(mfaz[k],minfaz[k],secfaz[k],r); faz:=(r*180.0/pi)*3600.0;
    direct(k,alat,alon,faz,baz,blat,blon);
    rblat:=(blat/3600.0)*pii;
    rblon:=(blon/3600.0)*pii;
    rbaz:=(baz/3600.0)*pii;
    ed5rad(rblat,pros2[k],mblat[k],minblt[k],secblt[k]);
    ed5rad(rblon,pros3[k],mblon[k],minbln[k],secbln[k]);
    ed5rad(rbaz,pros1[k],mbaz[k],minbaz[k],secbaz[k]);
  end;
end;
{-------------------------------INPUT-----------------------------------------}
procedure display_data(j:byte);
begin
    if Choice[j]=1 then wrt(61,6,112,#9) else wrt(61,8,112,#9);
    wrt_screen(OthDed,1,11,80,22);
    wrt(49,12,15,'     ');        gotoxy(49,12); write(kwd1[j]);
    wrt(33,13,15,'   ');          gotoxy(33,13); write(mlat[j]:1);
    wrt(33,14,15,'   ');          gotoxy(33,14); write(minlat[j]:1);
    wrt(33,15,15,'        ');     gotoxy(33,15); write(seclat[j]:5:4);
    wrt(62,13,15,'   ');          gotoxy(62,13); write(mlon[j]:1);
    wrt(62,14,15,'   ');          gotoxy(62,14); write(minlon[j]:1);
    wrt(62,15,15,'        ');     gotoxy(62,15); write(seclon[j]:5:4);
    wrt(49,17,15,'     ');        gotoxy(49,17); write(kwd2[j]);
    wrt(45,18,15,'   ');          gotoxy(45,18); write(mfaz[j]:1);
    wrt(45,19,15,'   ');          gotoxy(45,19); write(minfaz[j]:1);
    wrt(45,20,15,'        ');     gotoxy(45,20); write(secfaz[j]:5:4);
    wrt(23,21,15,'            '); gotoxy(23,21); write(s[j]:4:3);
end;
function PaintInp:integer;
label    1;
const    line_tab:array [1..2] of byte = (6,8);
var      deik:integer;
         cha:char;
begin
  deik:=1;
  wrt(61,6,112,#9);
1:read(kbd,cha);
  if cha in [#10,#13] then begin PaintInp:=deik; exit; end
  else if ((cha=#27) or (cha in ['2','8'])) then
  begin
    if keypressed then read(kbd,cha);
    case cha of
      #72,'8':begin
                wrt(61,line_tab[deik],15,#9);
                if deik=1 then deik:=2 else deik:=1;
                wrt(61,line_tab[deik],112,#9);
              end;
      #80,'2':begin
                wrt(61,line_tab[deik],15,#9);
                if deik=2 then deik:=1 else deik:=2;
                wrt(61,line_tab[deik],112,#9);
              end;
    else write(^G);
    end;
  end;
  goto 1;
end;
procedure INP;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12;
var       Paint:integer;
begin
     l:=1;
     while l <= i do
     begin
       cursor(false,true);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l)
       else
       begin
         Paint:=PaintInp;
         if Paint=1 then Choice[l]:=1 else Choice[l]:=2;
         wrt_screen(OthDed,1,11,80,22);
       end;
       cursor(true,false);
i1:    input(buff,12,48,5.1,bit);
       if bit then goto i1 else kwd1[l]:=buff;
i2:    input(buff,13,32,3,bit);
       if bit then goto i1 else val(buff,mlat[l],cod);
i3:    input(buff,14,32,3,bit);
       if bit then goto i2 else val(buff,minlat[l],cod);
i4:    input(buff,15,32,8,bit);
       if bit then goto i3 else val(buff,seclat[l],cod);
i5:    input(buff,13,61,3,bit);
       if bit then goto i4 else val(buff,mlon[l],cod);
i6:    input(buff,14,61,3,bit);
       if bit then goto i5 else val(buff,minlon[l],cod);
i7:    input(buff,15,61,8,bit);
       if bit then goto i6 else val(buff,seclon[l],cod);
i8:    input(buff,17,48,5.1,bit);
       if bit then goto i7 else kwd2[l]:=buff;
i9:    input(buff,18,44,4,bit);
       if bit then goto i8 else val(buff,mfaz[l],cod);
i10:   input(buff,19,44,3,bit);
       if bit then goto i9 else val(buff,minfaz[l],cod);
i11:   input(buff,20,44,8,bit);
       if bit then goto i10 else val(buff,secfaz[l],cod);
i12:   input(buff,21,22,13,bit);
       if bit then goto i11 else val(buff,s[l],cod);
       l:=succ(l);
     end;
     epex;
end;
{--------------------------------OTHONH---------------------------------------}
procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(14,grammi); write(kwd1[k]);      gotoxy(19,grammi); write(kwd2[k]);
  gotoxy(24,grammi); write(mbaz[k]:3);    gotoxy(28,grammi); write(minbaz[k]:2);
  gotoxy(31,grammi); write(secbaz[k]:7:4);gotoxy(39,grammi); write(pros2[k]);
  gotoxy(40,grammi); write(mblat[k]:2);   gotoxy(43,grammi); write(minblt[k]:2);
  gotoxy(46,grammi); write(secblt[k]:7:4);gotoxy(54,grammi); write(pros3[k]);
  gotoxy(55,grammi); write(mblon[k]:2);   gotoxy(58,grammi); write(minbln[k]:2);
  gotoxy(61,grammi); write(secbln[k]:7:4);
end;
procedure write_screen;
var       k,scr_line:integer;
begin
  scr_line:=7; clrscr;
  seek(k031_scr,2);    read(k031_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to i do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line+1;
    if scr_line > 21 then
    begin
      wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=7;
    end;
  end;
  if i <= 15 then
  begin
    wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;
{-----------------------------------OUTPUT------------------------------------}
procedure selida;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':68,'ëÑäàÉÄ : ',sel:1);
  writeln(fill);
end;
procedure epikef;
begin
  writeln(fill,'=========================================================================');
  writeln(fill,'   ì è é ä é Ç à ë ã é ë    Ç Ñ ó É Ä à í à â Ü ë    ã Ñ í Ä î é ê Ä ë');
  writeln(fill,'=========================================================================');
  writeln(fill);
  writeln(fill,'   ëÜãÑàé          ÄÖàãéìáàé                Ç Ñ ó Ç ê Ä î à â é');
  writeln(fill,'  òß¶  ß®¶™                            ß ¢ ò ´ ¶ ™         £ û ° ¶ ™');
  writeln(fill,'  ---------    -----------------    -----------------  -----------------');
               {2 **** ****  5  ***  **  **.**** 4  + **  **  **.**** 2+ **  **  **.****}
end;
procedure results;
var       sel,gram,k:integer;
begin
  if sw6=0 then ar_gram:=66;
  sel:=0; selida; epikef;
  gram:=10;
  for k:=1 to i do
  begin
    writeln(fill);
    writeln(fill,'  ',kwd1[k],' ':5-length(kwd1[k]),kwd2[k],' ':9-length(kwd2[k]),
      mbaz[k]:3,'  ',minbaz[k]:2,'  ',secbaz[k]:7:4,' ':4,pros2[k],
      ' ',mblat[k]:2,'  ',minblt[k]:2,'  ',secblt[k]:7:4,'  ',pros3[k],
      ' ',mblon[k]:2,'  ',minbln[k]:2,'  ',secbln[k]:7:4);
    gram:=gram+2;
    if gram >= ar_gram-3 then
    begin
      write(fill,#12); selida; epikef; gram:=10;
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
           write('ÉóëÑ ëìåéäàâé Äêàáãé ìèéäéÇàëãóå : ');
           read(i);
           if ad then goto 15;
           clrscr;
           seek(k031_scr,1);    read(k031_scr,rec1);
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
             assign(in_k031,name);
             {$i-}
             reset(in_k031);
             {$i+}
             ok:=(ioresult=0);
             if ok then
             begin
               gotoxy(1,23);
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
             rewrite(in_k031);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 Fkwd1:=kwd1[j]; Fkwd2:=kwd2[j]; FChoice:=Choice[j]; Fs:=s[j];
                 Fmlat:=mlat[j]; Fminlat:=minlat[j]; Fseclat:=seclat[j];
                 Fmlon:=mlon[j]; Fminlon:=minlon[j]; Fseclon:=seclon[j];
                 Fmfaz:=mfaz[j]; Fminfaz:=minfaz[j]; Fsecfaz:=secfaz[j];
               end;
               write(in_k031,in1_rec);
             until j = i;
             close(in_k031);
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
           gotoxy(13,21);
           readln(filename);
           if cha in ['F','f','î','≠'] then
           begin
             assign(in_k031,filename);
             {$i-}
             reset(in_k031);
             {$i+}
             ok:=(ioresult=0);
             if not ok then
             begin
               gotoxy(1,23);
               write('èêOëEXE !   TO AêXEIO AYTO ÉEN YèAêXEI. èATHëE ENA èäHKTêO..');
               repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
               cursor(false,true);
               epex_menu;
             end;
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'É à Ä Å Ä Ö ó   É Ñ É é ã Ñ å Ä..');
             reset(in_k031);
             seek(in_k031,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k031,in1_rec);
               with in1_rec do
               begin
                 Choice[j]:=FChoice; kwd1[j]:=Fkwd1;   
                 mlat[j]:=Fmlat; minlat[j]:=Fminlat; seclat[j]:=Fseclat;
                 mlon[j]:=Fmlon; minlon[j]:=Fminlon; seclon[j]:=Fseclon;
                 kwd2[j]:=Fkwd2; mfaz[j]:=Fmfaz; minfaz[j]:=Fminfaz;
                 secfaz[j]:=Fsecfaz; s[j]:=Fs;
               end;
             until eof(in_k031);
             i:=j;
             epex;
             close(in_k031);
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
               readln(f,Tb); val(Tb,Choice[j],cod);
               readln(f,Tb); kwd1[j]:=Tb;
               readln(f,Tb); val(Tb,mlat[j],cod);
               readln(f,Tb); val(Tb,minlat[j],cod);
               readln(f,Tb); val(Tb,seclat[j],cod);
               readln(f,Tb); val(Tb,mlon[j],cod);
               readln(f,Tb); val(Tb,minlon[j],cod);
               readln(f,Tb); val(Tb,seclon[j],cod);
               readln(f,Tb); kwd2[j]:=Tb;
               readln(f,Tb); val(Tb,mfaz[j],cod);
               readln(f,Tb); val(Tb,minfaz[j],cod);
               readln(f,Tb); val(Tb,secfaz[j],cod);
               readln(f,Tb); val(Tb,s[j],cod);
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
             wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èÄíÜëÑ ÑåÄ èäÜâíêé..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             goto 10;
           end;
           sw4:=1;
           seek(k031_scr,1);    read(k031_scr,rec1);
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
               write('èêOëEXE ! TO AêXEIO AYTO YèAêXEI. NA ÇêAñó EèANó TOY; (N/O) ');
               read(kbd,cha);
               if cha in ['O','o','é','¶'] then goto e1;
             end;
             clrscr;
             cursor(false,true);
             wrt(7,12,240,'  â Ä í Ä ï ó ê ó   Ä è é í Ñ ä Ñ ë ã Ä í Ä    ë Ñ   Ä ê ï Ñ à é  ');
             rewrite(fill);
             results;
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
             sw6:=1;
             wrt_screen(OthPrint,1,4,45,17);
25:          gotoxy(32,13);
             read(ar_gram);
             if ad then goto 25;
             gotoxy(3,15); write('ÑåÑêÇéèéàÜëÑ íéå ÑâíìèóíÜ ëE ÄêïÜ ëÑäàÉÄë');
             gotoxy(10,16); write('èÄíÜëÑ RETURN ÇàÄ ÑâíìèóëÜ');
             repeat read(kbd,cha) until cha in [#10,#13];
             cursor(false,true);
             assign(fill,'prn');
             rewrite(fill); sel:=0;
             clrscr;
             wrt(29,12,240,'Ñ  â  í  ì  è  ó  å  ó..');
             write(fill,#27,#67,chr(ar_gram));
             results;
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
  assign(k031_scr,'DIRE.scr');
  reset(k031_scr);
  seek(k031_scr,3); read(k031_scr,rec1);   {*** ö†ò : printer,input ò®Æú†¶ ***}
  for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
  for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
  seek(k031_scr,4); read(k031_scr,rec1);   {*** ö†ò input õúõ¶£ú§‡§ ***}
  for l:=1 to 12 do move(rec1.xx[(l-1)*160],OthDed[(l-1)*160+1],160);
  delete_all_input;
  sw1:=0; sw3:=0; sw4:=0; sw6:=0; i:=0; sel:=0;
  cursor(false,true);
  epex_menu;
END.

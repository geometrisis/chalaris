{******************************************************************************
*     k032  “Š‚ˆ‘‹‘ €…ˆ‹“‡ˆ“ ‰€ˆ €‘’€‘„—‘ € ‚„—‚.‘“Œ/Œ„‘ €‰—Œ     *
*                            WRITTEN BY G.XALARIS                       *
*                              16-03-1987                                     *
*******************************************************************************}
program  k032;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k032=record
           Fkwd1,Fkwd2                          :string[4];
           Fmlata,Fmilata,Fmlona,Fmilona,
           Fmlatb,Fmilatb,Fmlonb,Fmilonb,FChoice:integer;
           Fselata,Fselona,Fselatb,Fselonb     :real;
         end;
         string40 =string[40];
         string255=string[255];
         string2  =string[2];

var      selata,selona,selatb,selonb,secfaz,s,secbaz:array [1..500] of real;
         kwd1,kwd2:array [1..500] of string[4];
         mlata,milata,mlona,milona,mlatb,milatb,mlonb,
         milonb,mfaz,minfaz,mbaz,minbaz,Choice:array [1..500] of integer;

         k032_scr:file of rec;
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

         in_k032:file of rec1_k032;
         in1_rec:rec1_k032;
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
    fillchar(mlata,sizeof(mlata),0);   fillchar(milata,sizeof(milata),0);
    fillchar(selata,sizeof(selata),0); fillchar(mlona,sizeof(mlona),0);
    fillchar(milona,sizeof(milona),0); fillchar(selona,sizeof(selona),0);
    fillchar(mlatb,sizeof(mlatb),0);   fillchar(milatb,sizeof(milatb),0);
    fillchar(selatb,sizeof(selatb),0); fillchar(mlonb,sizeof(mlonb),0);
    fillchar(milonb,sizeof(milonb),0); fillchar(selonb,sizeof(selonb),0);
    fillchar(mfaz,sizeof(mfaz),0);     fillchar(minfaz,sizeof(minfaz),0);
    fillchar(secfaz,sizeof(secfaz),0); fillchar(mbaz,sizeof(mbaz),0);
    fillchar(minbaz,sizeof(minbaz),0); fillchar(secbaz,sizeof(secbaz),0);
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
     seek(k032_scr,0);     read(k032_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k032_scr);
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
                    close(k032_scr);
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
procedure INVERS(k:integer; alat,alon,blat,blon:real; var faz,baz,DummS:real);
label     i1;
var       a,b,con,f,ua,ub,cosua,sinua,cosub,gl,glam,sinla,cosla,sint,
          cost,sina,cosa,costm,c,test,th,gk,d,s1,s2,s3,tl:real;
begin
    if Choice[k]=1 then begin a:=6377397.155; b:=6356078.963; end
      else begin a:=6378388.0; b:=6356911.94613; end;
    con:=206264.806247006;
    f:=b/a;
    ua:=f*sin(alat/con)/cos(alat/con);
    ub:=f*sin(blat/con)/cos(blat/con);
    f:=1.0-f;
    cosua:=1.0/sqrt(sqr(ua)+1);
    sinua:=ua*cosua;
    cosub:=1.0/sqrt(sqr(ub)+1);
    gl:=(alon-blon)/con;
    glam:=gl;
    DummS:=cosua*cosub;
    baz:=DummS*ub;
    faz:=baz*ua;
i1: sinla:=sin(glam);
    cosla:=cos(glam);
    ua:=cosub*sinla;
    ub:=-sinua*cosub*cosla+baz;
    sint:=sqrt(sqr(ua)+sqr(ub));
    cost:=DummS*cosla+faz;
    arc(sint,cost,th);
    sina:=DummS*sinla/sint;
    cosa:=-sqr(sina)+1.0;
    costm:=-2.0*faz/cosa+cost;
    c:=((-3.0*cosa+4.0)*f+4.0)*cosa*f/16.0;
    test:=glam;
    glam:=(((sqr(costm)*2.0-1.0)*cost*c+costm)*sint*c+th)*sina*f*(1.0-c)+gl;
    tl:=abs(test-glam);
    if tl > (0.1E-13) then goto i1;
    gk:=(sqr(a/b)-1.0)*cosa;
    arc((-cosua*sinla),(cosub*sinua-baz*cosla),baz);
    baz:=baz*con;
    if baz < 0 then baz:=baz+1296000.0;
    arc(ua,ub,faz);
    faz:=faz*con;
    if faz < 0 then faz:=faz+1296000.0;
    faz:=1296000.0-faz;
    baz:=1296000.0-baz;
    c:=(((gk*(-175.0)+320.0)*gk-768.0)*gk+4096.0)*gk/16384.0+1.0;
    d:=(((gk*(-47.0)+74.0)*gk-128.0)*gk+256.0)*gk/1024.0;
    s1:=sqr(costm)*4.0-3.0;
    s2:=(sqr(sint)*4.0-3.0)*costm*(-d)/6.0;
    s3:=(sqr(costm)*2.0-1.0)*cost;
    DummS:=(((s1*s2+s3)*d/4.0+costm)*sint*(-d)+th)*c*b;
end;
procedure EPEX;
var       k:integer;
          pi,pii,alat,alon,blat,blon,rmfaz,rmbaz,faz,baz:real;
          pros:string[2];
begin
  clrscr;
  cursor(false,true);
  wrt(23,11,112,'                                 ');
  wrt(23,12,112,'  „    ‚  €  …    ‹  €  ˆ ...  ');
  wrt(23,13,112,'                                 ');
  pi:=arctan(1)*4.0;
  pii:=pi/180.0;
  for k:=1 to i do
  begin
    alat:=((mlata[k]*60.0)+milata[k])*60.0+selata[k];
    alon:=((mlona[k]*60.0)+milona[k])*60.0+selona[k];
    blat:=((mlatb[k]*60.0)+milatb[k])*60.0+selatb[k];
    blon:=((mlonb[k]*60.0)+milonb[k])*60.0+selonb[k];
    invers(k,alat,alon,blat,blon,faz,baz,s[k]);
    rmfaz:=(faz/3600.0)*pii;
    rmbaz:=(baz/3600.0)*pii;
    ed5rad(rmfaz,pros,mfaz[k],minfaz[k],secfaz[k]);
    ed5rad(rmbaz,pros,mbaz[k],minbaz[k],secbaz[k]);
  end;
end;
{-------------------------------INPUT-----------------------------------------}
procedure display_data(j:byte);
begin
    if Choice[j]=1 then wrt(53,6,112,#9) else wrt(53,8,112,#9);
    wrt_screen(OthDed,1,11,80,21);
    wrt(48,12,15,'     ');    gotoxy(48,12); write(kwd1[j]);
    wrt(33,13,15,'   ');      gotoxy(33,13); write(mlata[j]:1);
    wrt(33,14,15,'   ');      gotoxy(33,14); write(milata[j]:1);
    wrt(33,15,15,'        '); gotoxy(33,15); write(selata[j]:5:4);
    wrt(62,13,15,'   ');      gotoxy(62,13); write(mlona[j]:1);
    wrt(62,14,15,'   ');      gotoxy(62,14); write(milona[j]:1);
    wrt(62,15,15,'        '); gotoxy(62,15); write(selona[j]:5:4);
    wrt(48,17,15,'     ');    gotoxy(48,17); write(kwd2[j]);
    wrt(33,18,15,'   ');      gotoxy(33,18); write(mlatb[j]:1);
    wrt(33,19,15,'   ');      gotoxy(33,19); write(milatb[j]:1);
    wrt(33,20,15,'        '); gotoxy(33,20); write(selatb[j]:5:4);
    wrt(62,18,15,'   ');      gotoxy(62,18); write(mlonb[j]:1);
    wrt(62,19,15,'   ');      gotoxy(62,19); write(milonb[j]:1);
    wrt(62,20,15,'        '); gotoxy(62,20); write(selonb[j]:5:4);
end;
function PaintInp:integer;
label    1;
const    line_tab:array [1..2] of byte = (6,8);
var      deik:integer;
         cha:char;
begin
  deik:=1;
  wrt(53,6,112,#9);
1:read(kbd,cha);
  if cha in [#10,#13] then begin PaintInp:=deik; exit; end
  else if ((cha=#27) or (cha in ['2','8'])) then
  begin
    if keypressed then read(kbd,cha);
    case cha of
      #72,'8':begin
                wrt(53,line_tab[deik],15,#9);
                if deik=1 then deik:=2 else deik:=1;
                wrt(53,line_tab[deik],112,#9);
              end;
      #80,'2':begin
                wrt(53,line_tab[deik],15,#9);
                if deik=2 then deik:=1 else deik:=2;
                wrt(53,line_tab[deik],112,#9);
              end;
    else write(^G);
    end;
  end;
  goto 1;
end;
procedure INP;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14;
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
         wrt_screen(OthDed,1,11,80,21);
       end;
       cursor(true,false);
i1:    input(buff,12,47,5.1,bit);
       if bit then goto i1 else kwd1[l]:=buff;
i2:    input(buff,13,32,3,bit);
       if bit then goto i1 else val(buff,mlata[l],cod);
i3:    input(buff,14,32,3,bit);
       if bit then goto i2 else val(buff,milata[l],cod);
i4:    input(buff,15,32,8,bit);
       if bit then goto i3 else val(buff,selata[l],cod);
i5:    input(buff,13,61,3,bit);
       if bit then goto i4 else val(buff,mlona[l],cod);
i6:    input(buff,14,61,3,bit);
       if bit then goto i5 else val(buff,milona[l],cod);
i7:    input(buff,15,61,8,bit);
       if bit then goto i6 else val(buff,selona[l],cod);
i8:    input(buff,17,47,5.1,bit);
       if bit then goto i7 else kwd2[l]:=buff;
i9:    input(buff,18,32,4,bit);
       if bit then goto i8 else val(buff,mlatb[l],cod);
i10:   input(buff,19,32,3,bit);
       if bit then goto i9 else val(buff,milatb[l],cod);
i11:   input(buff,20,32,8,bit);
       if bit then goto i10 else val(buff,selatb[l],cod);
i12:   input(buff,18,61,3,bit);
       if bit then goto i11 else val(buff,mlonb[l],cod);
i13:   input(buff,19,61,3,bit);
       if bit then goto i12 else val(buff,milonb[l],cod);
i14:   input(buff,20,61,8,bit);
       if bit then goto i13 else val(buff,selonb[l],cod);
       l:=succ(l);
     end;
     epex;
end;
{--------------------------------OTHONH---------------------------------------}
procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(14,grammi); write(kwd1[k]);    gotoxy(19,grammi); write(kwd2[k]);
  gotoxy(25,grammi); write(s[k]:13:3);  gotoxy(39,grammi); write(mfaz[k]:3);
  gotoxy(43,grammi); write(minfaz[k]:2);gotoxy(46,grammi); write(secfaz[k]:7:4);
  gotoxy(54,grammi); write(mbaz[k]:3);  gotoxy(58,grammi); write(minbaz[k]:2);
  gotoxy(61,grammi); write(secbaz[k]:7:4);
end;
procedure write_screen;
var       k,scr_line:integer;
begin
  scr_line:=7; clrscr;
  seek(k032_scr,2);    read(k032_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to i do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line+1;
    if scr_line > 21 then
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
  writeln(fill,'======================================================================');
  writeln(fill,'    “Š‚ˆ‘‹‘ €‘’€‘„—‘ ‰€ˆ €…ˆ‹“‡ˆ“ ‹ˆ€‘ ‚„—ƒ€ˆ’ˆ‰†‘ ‚€‹‹†‘');
  writeln(fill,'======================================================================');
  writeln(fill);
  writeln(fill,'   ‘†‹„ˆ                                              €Œ’ˆ‘’”');
  writeln(fill,'  ˜§¦  §¨¦ª       €‘’€‘†          €…ˆ‹“‡ˆ           €…ˆ‹“‡ˆ');
  writeln(fill,'  ---------    -------------    ----------------    ----------------');
               {2 **** ****  4 *********.*** 4  ***  **  **.****  4 ***  **  **.****}
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
    writeln(fill,'  ',kwd1[k],' ':5-length(kwd1[k]),kwd2[k],' ':8-length(kwd2[k]),
      s[k]:13:3,' ':4,mfaz[k]:3,'  ',minfaz[k]:2,'  ',secfaz[k]:7:4,' ':4,
      mbaz[k]:3,'  ',minbaz[k]:2,'  ',secbaz[k]:7:4);
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
           write('ƒ—‘„ ‘“ŒŠˆ‰ €ˆ‡‹ “Š‚ˆ‘‹—Œ : ');
           read(i);
           if ad then goto 15;
           clrscr;
           seek(k032_scr,1);    read(k032_scr,rec1);
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
             assign(in_k032,name);
             {$i-}
             reset(in_k032);
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
             rewrite(in_k032);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 Fkwd1:=kwd1[j];   Fkwd2:=kwd2[j];     FChoice:=Choice[j];
                 Fmlata:=mlata[j]; Fmilata:=milata[j]; Fselata:=selata[j];
                 Fmlona:=mlona[j]; Fmilona:=milona[j]; Fselona:=selona[j];
                 Fmlatb:=mlatb[j]; Fmilatb:=milatb[j]; Fselatb:=selatb[j];
                 Fmlonb:=mlonb[j]; Fmilonb:=milonb[j]; Fselonb:=selonb[j];
               end;
               write(in_k032,in1_rec);
             until j = i;
             close(in_k032);
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
             assign(in_k032,filename);
             {$i-}
             reset(in_k032);
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
             reset(in_k032);
             seek(in_k032,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k032,in1_rec);
               with in1_rec do
               begin
                 Choice[j]:=FChoice; kwd1[j]:=Fkwd1; kwd2[j]:=Fkwd2;
                 mlata[j]:=Fmlata; milata[j]:=Fmilata; selata[j]:=Fselata;
                 mlona[j]:=Fmlona; milona[j]:=Fmilona; selona[j]:=Fselona;
                 mlatb[j]:=Fmlatb; milatb[j]:=Fmilatb; selatb[j]:=Fselatb;
                 mlonb[j]:=Fmlonb; milonb[j]:=Fmilonb; selonb[j]:=Fselonb;
               end;
             until eof(in_k032);
             i:=j;
             epex;
             close(in_k032);
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
               readln(f,Tb); val(Tb,Choice[j],cod);
               readln(f,Tb); kwd1[j]:=Tb;
               readln(f,Tb); val(Tb,mlata[j],cod);
               readln(f,Tb); val(Tb,milata[j],cod);
               readln(f,Tb); val(Tb,selata[j],cod);
               readln(f,Tb); val(Tb,mlona[j],cod);
               readln(f,Tb); val(Tb,milona[j],cod);
               readln(f,Tb); val(Tb,selona[j],cod);
               readln(f,Tb); kwd2[j]:=Tb;
               readln(f,Tb); val(Tb,mlatb[j],cod);
               readln(f,Tb); val(Tb,milatb[j],cod);
               readln(f,Tb); val(Tb,selatb[j],cod);
               readln(f,Tb); val(Tb,mlonb[j],cod);
               readln(f,Tb); val(Tb,milonb[j],cod);
               readln(f,Tb); val(Tb,selonb[j],cod);
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
           seek(k032_scr,1);    read(k032_scr,rec1);
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
  assign(k032_scr,'INVE.scr');
  reset(k032_scr);
  seek(k032_scr,3); read(k032_scr,rec1);   {*** š ˜ : printer,input ˜¨®œ ¦ ***}
  for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
  for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
  seek(k032_scr,4); read(k032_scr,rec1);   {*** š ˜ input ›œ›¦£œ¤à¤ ***}
  for l:=1 to 11 do move(rec1.xx[(l-1)*160],OthDed[(l-1)*160+1],160);
  delete_all_input;
  sw1:=0; sw3:=0; sw4:=0; sw6:=0; i:=0; sel:=0;
  cursor(false,true);
  epex_menu;
END.

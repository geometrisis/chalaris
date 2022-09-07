{******************************************************************************
*             klim ÕĞÏËÏÃÉÓÌÏÓ ÊËÉÌÁÊÁÓ ÓÅ ĞÑÏÂÏËÇ UTM 3° Ç 6°               *
*                  WRITTEN BY G.XALARIS                        *
*                              11-03-1987                                     *
*******************************************************************************}
program  klim;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_klim=record  { 24 Bytes }
           Fkwd:string[4];
           Fmoires,Fik:integer;
           Dummy:string[14];
         end;
         rec2_klim=record  { 24 Bytes }
           Fx1,Fy1,Fx2,Fy2:real;
         end;
         string40 =string[40];
         string255=string[255];

var      x,y       :array [1..500,1..3] of real;
         sk,skm    :array [1..500] of real;
         kwd       :array [1..500] of string[4];
         moires,ik :array [1..500] of integer;
         a,b,sko,fe:real;

         klim_scr:file of rec;
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

         in_klim:file of rec1_klim;
         in2_rec:rec2_klim;
         in1_rec:rec1_klim absolute in2_rec;
         OthInp,OthPrint,SynPoint,SynLine:array[1..3680] of byte;
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
    fillchar(x,sizeof(x),0);           fillchar(y,sizeof(y),0);
    fillchar(kwd,sizeof(kwd),0);       fillchar(ik,sizeof(ik),0);
    fillchar(sk,sizeof(sk),0);         fillchar(skm,sizeof(skm),0);
    fillchar(moires,sizeof(moires),0);
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
     seek(klim_scr,0);     read(klim_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(klim_scr);
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
                    close(klim_scr);
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
procedure FTOXO(var DummFo:real);
label     f1;
var       e2,e4,e6,e8,ao,a2,a4,a6,a8,so,pm,ds,ds1,s:real;
begin
  s:=0;
  e2:=(sqr(a)-sqr(b))/sqr(a); e4:=sqr(e2);
  e6:=e4*e2;                  e8:=e6*e2;
  ao:=1+3*e2/4+45*e4/64+175*e6/256+11025.0*e8/16384.0;
  a2:=3*e2/8+15*e4/32+525*e6/1024.0+2205.0*e8/4096.0;
  a4:=15*e4/256.0+105.0*e6/1024.0+2205.0*e8/16384.0;
  a6:=35*e6/3072.0+315.0*e8/12288.0;
  a8:=315.0*e8/131072.0;
  DummFo:=s/(a*(1-e2)*ao);
f1:
  so:=a*(1-e2)*(ao*DummFo-a2*sin(2*DummFo)+a4*sin(4*DummFo)-a6*sin(6*DummFo)+
      a8*sin(8*DummFo));
  pm:=a*(1-e2)/sqrt(1-e2*sqr(sin(DummFo)));
  ds:=s-so;
  DummFo:=DummFo+ds/pm;
  ds1:=abs(ds);
  if abs(ds1) >= 0.0001 then goto f1;
end;
procedure kxy(DummXX,DummYY:real; var DummSk:real);
var       ytr,fo,e2,etonos,rn,h2,t,h4,h6,t2,ena,dyo,tria,dx:real;
begin
    ytr:=DummYY/sko;
    ftoxo(fo);
    e2:=(sqr(a)-sqr(b))/sqr(a);
    etonos:=(sqr(a)-sqr(b))/sqr(b);
    rn:=a/sqrt(1-e2*sqr(sin(fo)));
    h2:=etonos*sqr(cos(fo));
    t:=sin(fo)/cos(fo);
    h4:=sqr(h2);
    h6:=h4*h2;
    t2:=sqr(t);
    ena:=(1+h2)/(2*sqr(rn));
    dyo:=(1+6*h2+9*h4+4*h6-24*t2*h4-24*t2*h6)/(24*sqr(rn))*(1/sqr(rn));
    tria:=(1/(720*(rn*sqr(rn)*10000.0))*(1/(rn*rn*rn*10000.0)));
    dx:=abs(DummXX-fe);
    DummSk:=sko*(1+ena*sqr(dx)+dyo*sqr(sqr(dx))+tria*sqr(dx)*sqr(sqr(dx)));
end;
procedure EPEX;
var       k,ixy,ifl:integer;
          xx,yy,DummSkk1,DummSkk2,DummSkk3,ska:real;
begin
  clrscr;
  cursor(false,true);
  wrt(23,11,112,'                                 ');
  wrt(23,12,112,'  „    ‚  €  …    ‹  €  ˆ ...  ');
  wrt(23,13,112,'                                 ');
  for k:=1 to i do
  begin
    if moires[k]=1 then    {** 3 £¦ ¨œª **}
    begin
      a:=6377397.155; b:=6356078.963; sko:=0.9999; fe:=200000.0;
    end
    else begin             {** 6 £¦ ¨œª **}
      a:=6378388.0; b:=6356911.94613; sko:=0.9996; fe:=500000.0;
    end;
    if ik[k]=1 then        {** ©£œ ¦ **}
    begin
      ixy:=1; ifl:=0;
      xx:=x[k,1]; yy:=y[k,1];
      kxy(xx,yy,sk[k]);
    end
    else begin             {** š¨˜££ **}
      ixy:=1; ifl:=0;
      x[k,3]:=(x[k,1]+x[k,2])/2.0;
      y[k,3]:=(y[k,1]+y[k,2])/2.0;
      kxy(x[k,1],y[k,1],DummSkk1);
      kxy(x[k,2],y[k,2],DummSkk2);
      kxy(x[k,3],y[k,3],DummSkk3);
      ska:=(1/DummSkk1+4/DummSkk3+1/DummSkk2)/6;
      skm[k]:=1/ska;
    end;
  end;
end;
{-------------------------------INPUT-----------------------------------------}
procedure display_data(j:byte);
begin
  if ik[j]=1 then
  begin
    if moires[j]=1 then wrt(48,8,112,#10) else wrt(58,8,112,#10);
    wrt(40,12,112,#11);
    wrt_screen(SynPoint,1,14,80,19);
    wrt(47,15,15,'     ');         gotoxy(47,15); write(kwd[j]);
    wrt(28,17,15,'             '); gotoxy(28,17); write(x[j,1]:4:3);
    wrt(28,18,15,'             '); gotoxy(28,18); write(y[j,1]:4:3);
  end
  else begin
    if moires[j]=1 then wrt(48,8,112,#10) else wrt(58,8,112,#10);
    wrt(51,12,112,#11);
    wrt_screen(SynLine,1,14,80,19);
    wrt(47,15,15,'     ');         gotoxy(47,15); write(kwd[j]);
    wrt(28,17,15,'             '); gotoxy(28,17); write(x[j,1]:4:3);
    wrt(28,18,15,'             '); gotoxy(28,18); write(y[j,1]:4:3);
    wrt(56,17,15,'             '); gotoxy(56,17); write(x[j,2]:4:3);
    wrt(56,18,15,'             '); gotoxy(56,18); write(y[j,2]:4:3);
  end;
end;
function PaintUtm:integer;
label    1;
const    line_tab:array[1..2] of byte = (48,58);
var      deik:integer;
         cha:char;
begin
  deik:=1;
  wrt(48,8,112,#10);
1:read(kbd,cha);
  if cha in [#10,#13] then begin PaintUtm:=deik; exit; end
  else if ((cha=#27) or (cha in ['4','6'])) then
  begin
    if keypressed then read(kbd,cha);
    case cha of
      #77,'6':begin
                wrt(line_tab[deik],8,15,#10);
                if deik=1 then deik:=2 else deik:=1;
                wrt(line_tab[deik],8,112,#10);
              end;
      #75,'4':begin
                wrt(line_tab[deik],8,15,#10);
                if deik=2 then deik:=1 else deik:=2;
                wrt(line_tab[deik],8,112,#10);
              end;
    else write(^G);
    end;
  end;
  goto 1;
end;
function PaintLine:integer;
label    1;
const    line_tab:array[1..2] of byte = (40,51);
var      deik:integer;
         cha:char;
begin
  deik:=1;
  wrt(40,12,112,#11);
1:read(kbd,cha);
  if cha in [#10,#13] then begin PaintLine:=deik; exit; end
  else if ((cha=#27) or (cha in ['4','6'])) then
  begin
    if keypressed then read(kbd,cha);
    case cha of
      #77,'6':begin
                wrt(line_tab[deik],12,15,#11);
                if deik=1 then deik:=2 else deik:=1;
                wrt(line_tab[deik],12,112,#11);
              end;
      #75,'4':begin
                wrt(line_tab[deik],12,15,#11);
                if deik=2 then deik:=1 else deik:=2;
                wrt(line_tab[deik],12,112,#11);
              end;
    else write(^G);
    end;
  end;
  goto 1;
end;
procedure INP;
label     i1,i2,i3,i4,i5,i6,i7;
begin
     l:=1;
     while l <= i do
     begin
       cursor(false,true);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l)
       else
       begin
         if PaintUtm=1 then moires[l]:=1 else moires[l]:=2;
         if PaintLine=1 then
         begin
           ik[l]:=1; wrt_screen(SynPoint,1,14,80,19);
         end
         else begin
           ik[l]:=2; wrt_screen(SynLine,1,14,80,19);
         end;
       end;
       cursor(true,false);
i1:    input(buff,15,46,5.1,bit);
       if bit then goto i1 else kwd[l]:=buff;
       if ik[l]=1 then
       begin
i2:      input(buff,17,27,13,bit);
         if bit then goto i1 else val(buff,x[l,1],cod);
i3:      input(buff,18,27,13,bit);
         if bit then goto i2 else val(buff,y[l,1],cod);
       end
       else begin
i4:      input(buff,17,27,13,bit);
         if bit then goto i1 else val(buff,x[l,1],cod);
i5:      input(buff,18,27,13,bit);
         if bit then goto i4 else val(buff,y[l,1],cod);
i6:      input(buff,17,55,13,bit);
         if bit then goto i5 else val(buff,x[l,2],cod);
i7:      input(buff,18,55,13,bit);
         if bit then goto i6 else val(buff,y[l,2],cod);
       end;
       l:=succ(l);
     end;
     epex;
end;
{--------------------------------OTHONH---------------------------------------}
procedure anal_gr_scr(grammi,k:integer);
begin
  if ik[k]=1 then
  begin
    gotoxy(11,grammi); write('©£œ ¦ : ',kwd[k]);
    gotoxy(27,grammi); write(x[k,1]:12:3);
    gotoxy(40,grammi); write(y[k,1]:13:3);
    gotoxy(54,grammi); write(sk[k]);
  end
  else begin
    gotoxy(11,grammi); write('š¨˜££ : ',kwd[k]);
    gotoxy(27,grammi); write(x[k,1]:12:3);
    gotoxy(40,grammi); write(y[k,1]:13:3);
    gotoxy(27,grammi+1); write(x[k,2]:12:3);
    gotoxy(40,grammi+1); write(y[k,2]:13:3);
    gotoxy(54,grammi+1); write(skm[k]);
  end
end;
procedure write_screen;
var       k,scr_line:integer;
begin
  scr_line:=7; clrscr;
  seek(klim_scr,2);    read(klim_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to i do
  begin
    anal_gr_scr(scr_line,k);
    if ik[k]=1 then scr_line:=scr_line+1 else scr_line:=scr_line+2;
    if scr_line >= 21 then
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
  writeln(fill,'========================================================================');
  writeln(fill,'          “Š‚ˆ‘‹‘   ‰Šˆ‹€‰€‘   ‘„   Š†   UTM   3ø,6ø');
  writeln(fill,'========================================================================');
  writeln(fill);
  writeln(fill,'    ‰—ƒˆ‰‘           ‘ “ Œ ’ „ ’ € ‚ ‹ „ Œ „ ‘        ‰ Š ˆ ‹ € ‰ €  ');
  writeln(fill,'  ‘†‹„ˆ“/‚€‹‹†‘      ’œ«££œ¤     ’œ«˜š£œ¤       ‘†‹„ˆ€‰† / ‹†‰“‘');
  writeln(fill,'  ---------------    ------------- -------------    ------------------');
               { 3 ©£œ ¦ : ****  5  *********.*** *********.***  4 ******************}
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
    if ik[k]=1 then
    begin
      writeln(fill,'   ©£œ ¦ : ',kwd[k],' ':9-length(kwd[k]),x[k,1]:13:3,' ',
              y[k,1]:13:3,' ':4,sk[k]);
      gram:=gram+2;
    end
    else begin
      writeln(fill,'   š¨˜££ : ',kwd[k],' ':9-length(kwd[k]),x[k,1]:13:3,' ',
              y[k,1]:13:3);
      writeln(fill,' ':21,x[k,2]:13:3,' ',y[k,2]:13:3,' ':4,skm[k]);
      gram:=gram+3;
    end;
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
           seek(klim_scr,1);    read(klim_scr,rec1);
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
             assign(in_klim,name);
             {$i-}
             reset(in_klim);
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
             rewrite(in_klim);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 Fkwd:=kwd[j]; Fmoires:=moires[j]; Fik:=ik[j];
               end;
               write(in_klim,in1_rec);
               with in2_rec do
               begin
                 Fx1:=x[j,1]; Fy1:=y[j,1]; Fx2:=x[j,2]; Fy2:=x[j,2];
               end;
               write(in_klim,in1_rec);
             until j = i;
             close(in_klim);
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
             assign(in_klim,filename);
             {$i-}
             reset(in_klim);
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
             reset(in_klim);
             seek(in_klim,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_klim,in1_rec);
               with in1_rec do
               begin
                 kwd[j]:=Fkwd; moires[j]:=Fmoires; ik[j]:=Fik;
               end;
               read(in_klim,in1_rec);
               with in2_rec do
               begin
                 x[j,1]:=Fx1; y[j,1]:=Fy1; x[j,2]:=Fx2; y[j,2]:=Fy2;
               end;
             until eof(in_klim);
             i:=j;
             epex;
             close(in_klim);
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
               readln(f,Tb); val(Tb,moires[j],cod);
               readln(f,Tb); val(Tb,ik[j],cod);
               readln(f,Tb); kwd[j]:=Tb;
               if ik[j]=1 then
               begin
                 readln(f,Tb); val(Tb,x[j,1],cod);
                 readln(f,Tb); val(Tb,y[j,1],cod);
               end else
               begin
                 readln(f,Tb); val(Tb,x[j,1],cod);
                 readln(f,Tb); val(Tb,y[j,1],cod);
                 readln(f,Tb); val(Tb,x[j,2],cod);
                 readln(f,Tb); val(Tb,y[j,2],cod);
               end;
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
           seek(klim_scr,1);    read(klim_scr,rec1);
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
assign(klim_scr,'klim.scr');
reset(klim_scr);
seek(klim_scr,3); read(klim_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
seek(klim_scr,4); read(klim_scr,rec1);
for l:=1 to 6 do move(rec1.xx[(l-1)*160],SynPoint[(l-1)*160+1],160);
for l:=7 to 12 do move(rec1.xx[(l-1)*160],SynLine[(l-7)*160+1],160);
delete_all_input;
sw1:=0; sw3:=0; sw4:=0; sw6:=0; i:=0; sel:=0;
cursor(false,true);
epex_menu;
END.

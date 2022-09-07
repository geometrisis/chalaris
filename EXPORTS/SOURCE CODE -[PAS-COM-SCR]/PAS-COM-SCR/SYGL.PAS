{******************************************************************************
*             k050 ’–œÀœ√…”Ãœ”  À…Ã¡ ¡” ”≈ –—œ¬œÀ« UTM 3∞ « 6∞                  *
*                  WRITTEN BY G.XALARIS                        *
*                              13-03-1987                                     *
*******************************************************************************}
program  k050;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k050=record  { 17 Bytes }
           Fkwd:string[4];
           Fimf,Fipf,FChoise:integer;
           Fsecf:real;
         end;
         rec2_k050=record  { 12 Bytes }
           Fx,Fy:real;
           Dummy:string[4];
         end;
         rec3_k050=record  { 13 Bytes }
           Fpros:string[2];
           Fiml,Fipl:integer;
           Fsecl:real;
           Dummy:string[3];
         end;
         string40 =string[40];
         string255=string[255];
         string2  =string[2];

var      secf,secl,xh,yh,insec,sec :array [1..500] of real;
         kwd                       :array [1..500] of string[4];
         imf,ipf,iml,ipl,ideg,min,
         inideg,inmin,irlo,Choise  :array [1..500] of integer;
         pros,spros                :array[1..500] of string[2];
         rl,sin1,ccos,xii,xiii,ssin:real;

         k050_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f :text;
         Tb,Tb1,Tb2,Tb3:string[20];

         in_k050:file of rec1_k050;
         in1_rec:rec1_k050;
         in2_rec:rec2_k050 absolute in1_rec;
         in3_rec:rec3_k050 absolute in1_rec;
         OthInp,OthPrint,InpHatt,InpUtm:array[1..3680] of byte;
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
    fillchar(secf,sizeof(secf),0);     fillchar(secl,sizeof(secl),0);
    fillchar(xh,sizeof(xh),0);         fillchar(yh,sizeof(yh),0);
    fillchar(insec,sizeof(insec),0);   fillchar(sec,sizeof(sec),0);
    fillchar(kwd,sizeof(kwd),0);       fillchar(imf,sizeof(imf),0);
    fillchar(ipf,sizeof(ipf),0);       fillchar(iml,sizeof(iml),0);
    fillchar(ipl,sizeof(ipl),0);       fillchar(ideg,sizeof(ideg),0);
    fillchar(min,sizeof(min),0);       fillchar(inideg,sizeof(inideg),0);
    fillchar(inmin,sizeof(inmin),0);   fillchar(pros,sizeof(pros),0);
    fillchar(spros,sizeof(spros),0);   fillchar(irlo,sizeof(irlo),0);
    fillchar(choise,sizeof(choise),0);
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
     seek(k050_scr,0);     read(k050_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k050_scr);
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
                    close(k050_scr);
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
  pi:=arctan(1) * 4;
  pii:=pi / 180;
  degmin:=min / 60;
  degsec:=sec / 3600;
  deg:=ideg + degmin + degsec;
  r:=deg * pii;
end;
procedure ED5RAD(r:real;var s_ed5:string2;var ideg,min:integer;var sec:real);
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
procedure HattPrc(k:integer);
var       a,b,tt,fr,et2,e2,pn,ff1,ff2,ff3,ff4,ff5,ff6,ff7,ff8,ff9,dar:real;
begin
  rad(inideg[k],inmin[k],insec[k],fr);
  a:=6377397.155;
  b:=6356078.9628;
  tt:=sin(fr)/cos(fr);
  et2:=(sqr(a)-sqr(b))/sqr(b);
  e2:=(sqr(a)-sqr(b))/sqr(a);
  pn:=a/sqrt(1-e2*sqr(sin(fr)));
  ff1:=tt/pn;
  ff2:=(1+2*sqr(tt)+et2*sqr(cos(fr)))/(2*sqr(pn));
  ff3:=(tt*(5+6*sqr(tt)+et2*sqr(cos(fr))-4*sqr(et2)*sqr(sqr(cos(fr)))))/
       (6*pn*sqr(pn));
  ff4:=-(tt*(1+2*sqr(tt)+et2*sqr(cos(fr))))/(6*pn*sqr(pn));
  ff5:=(5+28*sqr(tt)+24*sqr(sqr(tt))+6*et2*sqr(cos(fr))+8*et2+sqr(sin(fr))-
       3*sqr(et2)*sqr(sqr(cos(fr)))+4*sqr(et2)*sqr(sqr(cos(fr)))*sqr(tt)-
       4*sqr(et2)*et2*sqr(cos(fr))*sqr(sqr(cos(fr)))+24*et2*sqr(et2)*
       sqr(cos(fr))*sqr(sqr(cos(fr)))*sqr(tt))/(24*sqr(sqr(pn)));
  ff6:=-(1+20*sqr(tt)+24*sqr(sqr(tt))+2*et2*sqr(cos(fr))+8*et2*sqr(sin(fr))+
       sqr(et2)*sqr(sqr(cos(fr)))-12*sqr(et2)*sqr(sqr(cos(fr)))*sqr(tt))/
       (24*sqr(sqr(pn)));
  ff7:=(tt*(1+20*sqr(tt)+24*sqr(sqr(tt))))/(120*pn*sqr(sqr(pn)));
  ff8:=-(tt*(58+280*sqr(tt)+240*sqr(sqr(tt))))/(120*pn*sqr(sqr(pn)));
  ff9:=(tt*(61+180*sqr(tt)+120*sqr(sqr(tt))))/(120*pn*sqr(sqr(pn)));
  dar:=ff1*xh[k]+ff2*xh[k]*yh[k]+ff3*xh[k]*sqr(yh[k])+ff4*sqr(xh[k])*xh[k]+
       ff5*xh[k]*sqr(yh[k])*yh[k]+ff6*yh[k]*sqr(xh[k])*xh[k]+ff7*
       sqr(sqr(xh[k]))*xh[k]+ff8*sqr(xh[k])*sqr(yh[k])*xh[k]+ff9*
       sqr(sqr(yh[k]))*xh[k];
  ed5rad(dar,spros[k],ideg[k],min[k],sec[k]);
end;
procedure CONVE(DumIrlo:integer; var DumConv:real);
var       rlo,dl,dll,dllm,dlsec,p,p3,p5,c51,dtana,dtana2,c52,c5,c1,c2,c:real;
begin
  rad(DumIrlo,0,0,rlo);
  dl:=rlo-rl;
  dll:=abs(dl);
  dllm:=dll*180/pi;
  dlsec:=dllm*3600.0;
  p:=dlsec*0.0001;
  p3:=p*p*p;
  p5:=p*p*p*p*p;
  c51:=(p5*(sqr(sqr(sin1)))*ssin*(sqr(sqr(ccos))))/15.0;
  dtana:=ssin/ccos;
  dtana2:=sqr(dtana);
  c52:=(2-dtana2)*(1.0E+20);
  c5:=c51*c52;
  c1:=xii*p;
  c2:=xiii*p3;
  c:=c1+c2+c5;
  if rl <> rlo then DumConv:=c else DumConv:=0;
  if rl < rlo then DumConv:=-c;
end;
procedure EPEX;
label     c1,c2;
var       k:integer;
          pi,rf,ee2,xiii1,xiii2,orio130,conv,dconv,rconv,r18,r24:real;
begin
  clrscr;
  cursor(false,true);
  wrt(23,11,112,'                                 ');
  wrt(23,12,112,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à ...  ');
  wrt(23,13,112,'                                 ');
  pi:=arctan(1)*4;
  for k:=1 to i do
  begin
    if Choise[k]=1 then HattPrc(k);
    if Choise[k]=2 then
    begin
      rad(imf[k],ipf[k],secf[k],rf);
      rad(iml[k],ipl[k],secl[k],rl);
      if pros[k]='-' then rl:=-rl;
      ee2:=0.006719218799;
      sin1:=0.0000048481368111;
      ssin:=sin(rf);
      ccos:=cos(rf);
      xii:=ssin*10000.0;
      xiii1:=(1+3*ee2*sqr(ccos)+2*sqr(ee2)*sqr(sqr(ccos)))*(1.0E+12);
      xiii2:=(sqr(sin1)*ssin*sqr(ccos))/3.0;
      xiii:=xiii1*xiii2;
      orio130:=0.02617993878;
      if rl < -orio130 then begin irlo[k]:=-3; goto c1; end;
      if rl > orio130 then begin irlo[k]:=3; goto c1; end;
      irlo[k]:=0;
c1:   conve(irlo[k],conv);
      dconv:=conv/3600;
      rconv:=dconv*pi/180;
      ed5rad(rconv,spros[k],ideg[k],min[k],sec[k]);
    end;
    if Choise[k]=3 then
    begin
      rad(imf[k],ipf[k],secf[k],rf);
      rad(iml[k],ipl[k],secl[k],rl);
      if pros[k]='-' then rl:=-rl;
      ee2:=0.006768170197;
      sin1:=0.0000048481368111;
      ssin:=sin(rf);
      ccos:=cos(rf);
      xii:=ssin*10000.0;
      xiii1:=(1+3*ee2*sqr(ccos)+2*sqr(ee2)*sqr(sqr(ccos)))*(1.0E+12);
      xiii2:=(sqr(sin1)*ssin*sqr(ccos))/3.0;
      xiii:=xiii1*xiii2;
      rad(18,0,0,r18);
      rad(24,0,0,r24);
      if rl < r24 then begin irlo[k]:=21; goto c2; end;
      if (rl<r24) and (rl>r18) then begin irlo[k]:=21; goto c2; end;
      irlo[k]:=27;
c2:   conve(irlo[k],conv);
      dconv:=conv/3600;
      rconv:=dconv*pi/180;
      ed5rad(rconv,spros[k],ideg[k],min[k],sec[k]);
    end;
  end;
end;
{-------------------------------INPUT-----------------------------------------}
procedure display_data(j:byte);
begin
  if Choise[j]=1 then
  begin
    wrt(59,5,112,#8); wrt_screen(InpHatt,1,16,80,21);
    wrt(32,12,15,'     ');         gotoxy(32,12); write(kwd[j]);
    wrt(50,13,15,'   ');           gotoxy(50,13); write(inideg[j]:1);
    wrt(50,14,15,'   ');           gotoxy(50,14); write(inmin[j]:1);
    wrt(50,15,15,'        ');      gotoxy(50,15); write(insec[j]:5:4);
    wrt(50,19,15,'             '); gotoxy(26,19); write(xh[j]:4:3);
    wrt(50,20,15,'             '); gotoxy(26,20); write(yh[j]:4:3);
  end
  else begin
    if Choise[j]=2 then wrt(59,7,112,#8) else wrt(59,9,112,#8);
    wrt_screen(InpUtm,1,16,80,21);
    wrt(32,12,15,'     ');    gotoxy(32,12); write(kwd[j]);
    wrt(50,13,15,'   ');      gotoxy(50,13); write(imf[j]:1);
    wrt(50,14,15,'   ');      gotoxy(50,14); write(ipf[j]:1);
    wrt(50,15,15,'        '); gotoxy(50,15); write(secf[j]:5:4);
    wrt(50,17,15,'  ');       gotoxy(50,17); write(pros[j]);
    wrt(50,18,15,'   ');      gotoxy(50,18); write(iml[j]:1);
    wrt(50,19,15,'   ');      gotoxy(50,19); write(ipl[j]:1);
    wrt(50,20,15,'        '); gotoxy(50,20); write(secl[j]:5:4);
  end;
end;
function PaintInp:integer;
label    1;
const    line_tab:array[1..3] of byte = (5,7,9);
var      deik:integer;
         cha:char;
begin
  deik:=1;
  wrt(59,5,112,#8);
1:read(kbd,cha);
  if cha in [#10,#13] then begin PaintInp:=deik; exit; end
  else if ((cha=#27) or (cha in ['2','8'])) then
  begin
    if keypressed then read(kbd,cha);
    case cha of
      #72,'8':begin
                wrt(59,line_tab[deik],15,#8);
                if deik=1 then deik:=3 else deik:=deik-1;
                wrt(59,line_tab[deik],112,#8);
              end;
      #80,'2':begin
                wrt(59,line_tab[deik],15,#8);
                if deik=3 then deik:=1 else deik:=deik+1;
                wrt(59,line_tab[deik],112,#8);
              end;
    else write(^G);
    end;
  end;
  goto 1;
end;
procedure INP;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13;
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
         if Paint=1 then
         begin
           Choise[l]:=1;
           wrt_screen(InpHatt,1,16,80,21);
         end
         else
         begin
           if Paint=2 then Choise[l]:=2 else Choise[l]:=3;
           wrt_screen(InpUtm,1,16,80,21);
         end;
       end;
       cursor(true,false);
i1:    input(buff,12,31,5.1,bit);
       if bit then goto i1 else kwd[l]:=buff;
       if Choise[l]=1 then
       begin
i2:      input(buff,13,49,3,bit);
         if bit then goto i1 else val(buff,inideg[l],cod);
i3:      input(buff,14,49,3,bit);
         if bit then goto i2 else val(buff,inmin[l],cod);
i4:      input(buff,15,49,8,bit);
         if bit then goto i3 else val(buff,insec[l],cod);
i5:      input(buff,19,25,12,bit);
         if bit then goto i4 else val(buff,xh[l],cod);
i6:      input(buff,20,25,13,bit);
         if bit then goto i5 else val(buff,yh[l],cod);
       end
       else begin
i7:      input(buff,13,49,3,bit);
         if bit then goto i1 else val(buff,imf[l],cod);
i8:      input(buff,14,49,3,bit);
         if bit then goto i7 else val(buff,ipf[l],cod);
i9:      input(buff,15,49,8,bit);
         if bit then goto i8 else val(buff,secf[l],cod);
         if (sw4=0) then begin gotoxy(50,17); write('+'); end;
i10:     input(buff,17,49,2.1,bit);
         if bit then goto i9 else pros[l]:=buff;
         if (pros[l] <> '+') and (pros[l] <> '-') then goto i10;
i11:     input(buff,18,49,3,bit);
         if bit then goto i10 else val(buff,iml[l],cod);
i12:     input(buff,19,49,3,bit);
         if bit then goto i11 else val(buff,ipl[l],cod);
i13:     input(buff,20,49,8,bit);
         if bit then goto i12 else val(buff,secl[l],cod);
       end;
       l:=succ(l);
     end;
     epex;
end;
{--------------------------------OTHONH---------------------------------------}
procedure anal_gr_scr(grammi,k:integer);
begin
  if Choise[k]=1 then
  begin
    gotoxy(7,grammi); write(kwd[k]);      gotoxy(14,grammi); write(xh[k]:12:3);
    gotoxy(27,grammi); write(yh[k]:13:3); gotoxy(59,grammi); write(spros[k]);
    gotoxy(61,grammi); write(ideg[k]:2);  gotoxy(65,grammi); write(min[k]:2);
    gotoxy(69,grammi); write(sec[k]:7:4);
  end
  else begin
    gotoxy(7,grammi); write(kwd[k]);       gotoxy(41,grammi); write(pros[k]);
    gotoxy(43,grammi); write(iml[k]:2);    gotoxy(47,grammi); write(ipl[k]:2);
    gotoxy(51,grammi); write(secl[k]:7:4); gotoxy(59,grammi); write(spros[k]);
    gotoxy(61,grammi); write(ideg[k]:2);   gotoxy(65,grammi); write(min[k]:2);
    gotoxy(69,grammi); write(sec[k]:7:4);
  end;
  if Choise[k]=2 then
  begin gotoxy(59,grammi+1); write('°ú§´®.£ú©/§¶™:',irlo[k]:3); end;
end;
procedure write_screen;
var       k,scr_line:integer;
begin
  scr_line:=7; clrscr;
  seek(k050_scr,2);    read(k050_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to i do
  begin
    anal_gr_scr(scr_line,k);
    if Choise[k]=2 then scr_line:=scr_line+2 else scr_line:=scr_line+1;
    if scr_line >= 21 then
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
  writeln(fill,'===========================================================================');
  writeln(fill,'   ìèéäéÇàëãéë  ëìÇâäàëÜë  ãÑëÜãÅêàåóå  ëÑ  èêéÅéäÑë  HATT,UTM 3¯,UTM 6¯');
  writeln(fill,'===========================================================================');
  writeln(fill);
  writeln(fill,'  âóÉàâéë    è ê é Å é ä Ü   H A T T    èêéÅéäÜ UTM 3¯,6¯     ëìÇâäàëÜ');
  writeln(fill,'  ëÜãÑàéì    íú´£û£ú§û     íú´òö£ú§û    Çú‡ö®ò≠†°¶  £û°¶™  (è®¶©û£ò©£ú§û)');
  writeln(fill,'  -------  ------------- -------------  -----------------  --------------');
               { 4  **** 3 *********.*** *********.***  + **  **  **.****  +** ** **.****}
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
    if Choise[k]=1 then writeln(fill,' ':4,kwd[k],' ':7-length(kwd[k]),xh[k]:13:3,
      ' ',yh[k]:13:3,' ':21,spros[k],ideg[k]:2,' ',min[k]:2,' ',sec[k]:7:4)
    else writeln(fill,' ':4,kwd[k],' ':36-length(kwd[k]),pros[k],' ',iml[k]:2,
      '  ',ipl[k]:2,'  ',secl[k]:7:4,'  ',spros[k],ideg[k]:2,' ',
      min[k]:2,' ',sec[k]:7:4);
    if Choise[k]=2 then
    begin
      writeln(fill,' ':59,'°ú§´.£ú©/§¶™:',irlo[k]:2); gram:=gram+3;
    end else gram:=gram+2;
    if gram >= ar_gram-4 then
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
           seek(k050_scr,1);    read(k050_scr,rec1);
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
             assign(in_k050,name);
             {$i-}
             reset(in_k050);
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
             rewrite(in_k050);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 if Choise[j]=1 then
                 begin
                   Fkwd:=kwd[j]; FChoise:=Choise[j]; Fimf:=inideg[j];
                   Fipf:=inmin[j]; Fsecf:=insec[j];
                 end
                 else begin
                   Fkwd:=kwd[j]; FChoise:=Choise[j]; Fimf:=imf[j];
                   Fipf:=ipf[j]; Fsecf:=secf[j];
                 end;
               end;
               write(in_k050,in1_rec);
               if Choise[j]=1 then
               begin
                 with in2_rec do begin Fx:=xh[j]; Fy:=yh[j]; end;
               end
               else
               begin
                 with in3_rec do
                 begin
                   Fpros:=pros[j]; Fiml:=iml[j]; Fipl:=ipl[j]; Fsecl:=secl[j];
                 end;
               end;
               write(in_k050,in1_rec);
             until j = i;
             close(in_k050);
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
             assign(in_k050,filename);
             {$i-}
             reset(in_k050);
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
             reset(in_k050);
             seek(in_k050,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k050,in1_rec);
               with in1_rec do
               begin
                 kwd[j]:=Fkwd; Choise[j]:=FChoise;
                 if Choise[j]=1 then
                 begin
                   inideg[j]:=Fimf; inmin[j]:=Fipf; insec[j]:=Fsecf;
                 end
                 else
                 begin
                   imf[j]:=Fimf; ipf[j]:=Fipf; secf[j]:=Fsecf;
                 end;
               end;
               read(in_k050,in1_rec);
               if Choise[j]=1 then
               begin
                 with in2_rec do begin xh[j]:=Fx; yh[j]:=Fy; end
               end
               else
               begin
                 with in3_rec do
                 begin
                   pros[j]:=Fpros; iml[j]:=Fiml; ipl[j]:=Fipl; secl[j]:=Fsecl;
                 end;
               end;
             until eof(in_k050);
             i:=j;
             epex;
             close(in_k050);
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
               readln(f,Tb); val(Tb,Choise[j],cod);
               readln(f,Tb); kwd[j]:=Tb;
               readln(f,Tb1); readln(f,Tb2); readln(f,Tb3);
               if Choise[j]=1 then
               begin
                 val(Tb1,inideg[j],cod); val(Tb2,inmin[j],cod);
                 val(Tb3,insec[j],cod);
                 readln(f,Tb); val(Tb,xh[j],cod);
                 readln(f,Tb); val(Tb,yh[j],cod);
               end
               else
               begin
                 val(Tb1,imf[j],cod); val(Tb2,ipf[j],cod); val(Tb3,secf[j],cod);
                 readln(f,Tb); pros[j]:=Tb;
                 readln(f,Tb); val(Tb,iml[j],cod);
                 readln(f,Tb); val(Tb,ipl[j],cod);
                 readln(f,Tb); val(Tb,secl[j],cod);
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
             wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èÄíÜëÑ ÑåÄ èäÜâíêé..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             goto 10;
           end;
           sw4:=1;
           seek(k050_scr,1);    read(k050_scr,rec1);
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
  assign(k050_scr,'SYGL.scr');
  reset(k050_scr);
  seek(k050_scr,3); read(k050_scr,rec1);   {*** ö†ò printer,input ò®Æú†¶¨ ***}
  for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
  for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
  seek(k050_scr,4); read(k050_scr,rec1);
  for l:=1 to 6 do move(rec1.xx[(l-1)*160],InpHatt[(l-1)*160+1],160);
  for l:=7 to 12 do move(rec1.xx[(l-1)*160],InpUtm[(l-7)*160+1],160);
  delete_all_input;
  sw1:=0; sw3:=0; sw4:=0; sw6:=0; i:=0; sel:=0;
  cursor(false,true);
  epex_menu;
END.

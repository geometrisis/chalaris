{******************************************************************************
*   NALS ÕĞÏËÏÃÉÓÌÏÓ ÏÑÉÆÏÍÔÉÙÍ ÓÕÍÔÅÔÁÃÌÅÍÙÍ ÌÅÓÙÍ ÔÅÔÑÁÃÙÍÉÊÙÍ ÓÖÁËÌÁÔÙÍ    *
*   ÊÁÉ ÓÔÏÉ×ÅÉÙÍ ÅËËÅÉØÅÙÍ ÓÖÁËÌÁÔÏÓ ÔÙÍ ÓÇÌÅÉÙÍ ÅÍÏÓ ÄÉÊÔÕÏÕ ÌÅ ÔÇÍ  ÌÅÔ  *
*                     WRITTEN BY G.XALARIS                      *
*                                 14-02-1987                                  *
*******************************************************************************}
const    SyntRegSize    = 123;
         MaxDataRecSize = SyntRegSize;
         MaxKeyLen      = 4;
         PageSize       = 16;
         Order          = 8;
         PageStackSize  = 5;
         MaxHeight      = 5;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec_syntetagmenwn=record
                   Kwd_syn:string[4];
         X_syn,Y_syn,H_syn:real;
               Eidos_Point:string[3];
                       Job:string[20];
                    Xronol:string[8];
                Who_Idrise:string[20];
                Axiopistia:string[10];
                  Comments:string[32];
         end;
         string40 =string[40];
         string255=string[255];
         string20 =string[20];
         string44 =string[44];

         matr1 = array [1..70] of real;
         matr2 = array [1..70] of string[4];
         matr3 = array [1..70] of real;
         matr4 = array [1..70] of real;

var                         x,y,df: ^matr1;
         igeod,kodsk,igeodf,igeodn: ^matr2;
                         xnew,ynew: ^matr3;
                              sxyz: ^matr4;
     {$I ACCESS3.BOX}
     {$I GETKEY.BOX}
     {$I ADDKEY.BOX}
     {$I DELKEY.BOX}

var      file_syntetagmenwn : string[40];
         rec_syn            : rec_syntetagmenwn;
         file_syn           : DataFile;
         IndexName          : IndexFile;

         DumFile : file;
         DatRef  : integer;
         nnew,nfix,ns:integer;

         title:string[40];

         k040_scr:file of rec;
         rec1    :rec;
         OthInp,OthPrint:array[1..3680] of byte;
         ofs1,cod:integer;
         ar_gram,J:integer;
         buff    :string40;
         buff1   :string[80];
         bit,okk :boolean;
         name,filename:string[66];
         fill,txt1,txt2,txt_azaf,txta:text;
         sw1,sw3,sw4:byte;
         cha,cha1:char;
         sel,gram:integer;

     {$I WRT-MON.PRC}
     {$I REPSTR.FNC}
     {$I UDIP.PRC}
     {$I AD.FNC}
     {$I CURSOR.PRC}
     {$I ARITH.INP}
     {$I WRTSCR.PRC}

Procedure delete_all_input;
begin
  fillchar(x^,sizeof(x^),0);           fillchar(y^,sizeof(y^),0);
  fillchar(df^,sizeof(df^),0);         fillchar(igeod^,sizeof(igeod^),0);
  fillchar(kodsk^,sizeof(kodsk^),0);   fillchar(igeodf^,sizeof(igeodf^),0);
  fillchar(igeodn^,sizeof(igeodn^),0); fillchar(sxyz^,sizeof(sxyz^),0);
  fillchar(xnew^,sizeof(xnew^),0);     fillchar(ynew^,sizeof(ynew^),0);
end;

Procedure DisposePtrs;
Begin
  dispose(x);     dispose(y);      dispose(df);     dispose(igeod);
  dispose(kodsk); dispose(igeodf); dispose(igeodn); dispose(xnew);
  dispose(ynew);  dispose(sxyz);
End;

Procedure beep(freq,dur:integer);
begin sound(freq); delay(dur); nosound; end;
function menu:byte;
label    5;
var      deik,row,col,i:byte;
         ch:char;
Procedure paint_box(ra,ca,rt,ct,att:byte);
          var rows,cols,i:byte;
          begin
            rows:=rt-ra+1; cols:=ct-ca+1;
            for i:=1 to rows do wrt(ca,i+ra-1,att,chr(cols));
          end;
begin
     seek(k040_scr,0);     read(k040_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr; close(k040_scr); cursor(true,false);
         if (sw1=1) or (sw3=1) then begin
                                      erase(txt1); erase(txta);
                                    end;
         DisposePtrs;
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
                    close(k040_scr);
                    cursor(true,false);
                    if (sw1=1) or (sw3=1) then
                    begin
                      erase(txt1); erase(txta);
                    end;
                    DisposePtrs;
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
                      if row>4 then row:=row-4 else row:=16
                    else
                      if row<16 then row:=row+4 else row:=4;
                    paint_box(row,col,row+2,col+17,112);
                    deik:=(row div 4 * 2) - 1;
                    if col=40 then deik:=deik+1;
                  end;
              else for i:=3 to 6 do beep(i*500,50);
       end; {case}
     end {if}
     else for i:=3 to 6 do beep(i*500,50); goto 5;
end;

Procedure arc(dx,dy:real; var az:real);
var       p,a1:real;
begin
  p:=arctan(1)*4;
  if dx < 0 then
  begin
    if dy<0 then begin a1:=arctan(abs(dx/dy)); az:=p+a1; end;
    if dy=0 then az:=3*p/2;
    if dy>0 then begin a1:=arctan(abs(dx/dy)); az:=2*p-a1; end;
  end;
  if dx=0 then begin if dy<0 then az:=p; if dy>0 then az:=0; end;
  if dx>0 then
  begin
    if dy<0 then begin a1:=arctan(abs(dx/dy)); az:=p-a1; end;
    if dy=0 then az:=p/2;
    if dy>0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
  end;
end;
{-------------------------------INPUT-----------------------------------------}
Procedure inp1;
var       l   :integer;
          dstr:string[20];
label     i1,i2,i3,i4,i5,i6,i7;
begin
i7:  l:=1;
     while l <= nfix do
     begin
       wrt(19,6,15,'   ');         wrt(27,6,15,'    ');
       wrt(37,6,15,'           '); wrt(51,6,15,'            ');
       gotoxy(19,6); write(l:1);
       if sw4=1 then
       begin
         readln(txt1,buff); gotoxy(27,6); write(buff);
         readln(txt1,buff); arith_input(buff,dstr);
         val(dstr,x^[l],cod); gotoxy(37,6); write(x^[l]:4:3);
         readln(txt1,buff); arith_input(buff,dstr);
         val(dstr,y^[l],cod); gotoxy(51,6); write(y^[l]:4:3);
       end;
i1:    input(buff,6,26,5.1,bit);
       if bit then goto i1 else igeod^[l]:=buff;
i2:    input(buff,6,36,11,bit);
       if bit then goto i1 else val(buff,x^[l],cod);
i3:    input(buff,6,50,12,bit);
       if bit then goto i2 else val(buff,y^[l],cod);
       if sw4=0 then
       begin
         writeln(txt1,igeod^[l]); writeln(txt1,x^[l]); writeln(txt1,y^[l]);
       end
       else
       begin
         writeln(txt2,igeod^[l]); writeln(txt2,x^[l]); writeln(txt2,y^[l]);
       end;
       l:=succ(l);
     end;
     l:=nfix+1;
     while l <= ns do
     begin
       wrt(19,15,15,'   ');         wrt(27,15,15,'    ');
       wrt(37,15,15,'           '); wrt(51,15,15,'            ');
       gotoxy(19,15);    write(l-nfix:1);
       if sw4=1 then
       begin
         readln(txt1,buff); gotoxy(27,15); write(buff);
         readln(txt1,buff); arith_input(buff,dstr);
         val(dstr,x^[l],cod); gotoxy(37,15); write(x^[l]:4:3);
         readln(txt1,buff); arith_input(buff,dstr);
         val(dstr,y^[l],cod); gotoxy(51,15); write(y^[l]:4:3);
       end;
i4:    input(buff,15,26,5.1,bit);
       if bit then goto i4 else igeod^[l]:=buff;
i5:    input(buff,15,36,11,bit);
       if bit then goto i4 else val(buff,x^[l],cod);
i6:    input(buff,15,50,12,bit);
       if bit then goto i5 else val(buff,y^[l],cod);
       if sw4=0 then
       begin
         writeln(txt1,igeod^[l]); writeln(txt1,x^[l]); writeln(txt1,y^[l]);
       end
       else begin
         writeln(txt2,igeod^[l]); writeln(txt2,x^[l]); writeln(txt2,y^[l]);
       end;
       l:=succ(l);
     end;
     cursor(false,true);
     if sw4=0 then for l:=1 to nfix do writeln(txt1,igeod^[l])
     else for l:=1 to nfix do begin
                                readln(txt1,buff); writeln(txt2,igeod^[l]);
                              end;
end;
Procedure inp2;
type      matr1a = array [1..100] of real;
var       i,k,l,kk,ndir    :integer;
          pi,z,sumz,azaf   :real;
          azp,xsk,ysk,azp1 :^matr1a;
          dstr             :string[20];
label     i3,i4,i5;
begin
     new(azp); new(xsk); new(ysk); new(azp1);
     assign(txt_azaf,'txt_azaf');
     rewrite(txt_azaf);
     pi:=arctan(1)*4;
     i:=1;
     while i <= ns do
     begin
       move(rec1.xx[0],mem[$b000:ofs1],3680);
       gotoxy(46,7); write(igeod^[i]);
       writeln(txt_azaf); writeln(txt_azaf,'    ‘†‹„ˆ : ',igeod^[i]);
       if sw4=1 then
       begin
         readln(txt1,buff); readln(txt1,buff);
         arith_input(buff,dstr); val(dstr,ndir,cod);
         gotoxy(46,8); write(ndir:1);
       end;
       cursor(true,false);
i3:    input(buff,8,45,3,bit);
       if bit then goto i3 else val(buff,ndir,cod);
       k:=1;
       while k <= ndir do
       begin
         wrt(45,10,15,'  '); wrt(45,11,15,'    ');
         wrt(45,12,15,'        '); gotoxy(45,10); write(k:1);
         if sw4=1 then
         begin
           readln(txt1,buff); gotoxy(45,11); write(buff);
           readln(txt1,buff); arith_input(buff,dstr);
           val(dstr,df^[k],cod); gotoxy(45,12);
           write(df^[k]:5:4); readln(txt1,buff);
         end;
i4:      input(buff,11,44,5.1,bit);
         if bit then goto i4 else kodsk^[k]:=buff;
i5:      input(buff,12,44,9,bit);
         if bit then goto i4 else val(buff,df^[k],cod);
         for l:=1 to ns do
         begin
           if (kodsk^[k]=igeod^[l]) then begin xsk^[k]:=x^[l]; ysk^[k]:=y^[l]; end;
         end;
         k:=succ(k);
       end;
       sumz:=0;
       for k:=1 to ndir do
       begin
         arc((xsk^[k]-x^[i]),(ysk^[k]-y^[i]),azp1^[k]); azp1^[k]:=azp1^[k]*200/pi;
         z:=azp1^[k]-df^[k]; while z<0 do z:=z+400;
         writeln(txt_azaf,'€ £¦¬Ÿ ¦ ˜­œ«¨ ˜ª ˜§¦ ',kodsk^[k],
                 ' ':5-length(kodsk^[k]),': ',z:5:4);
         sumz:=sumz+z;
       end;
       azaf:=sumz/ndir;
       writeln(txt_azaf,'’œ¢ ¡¦ ˜ £¦¬Ÿ ¦ ˜­œ«¨ ˜ª   : ',azaf:5:4);
       if sw4=0 then
       begin writeln(txt1,igeod^[i]); writeln(txt1,ndir); end
       else begin writeln(txt2,igeod^[i]); writeln(txt2,ndir); end;
       for kk:=1 to ndir do
       begin
         azp^[kk]:=df^[kk]+azaf; while azp^[kk]>400 do azp^[kk]:=azp^[kk]-400;
         if sw4=0 then
         begin
           writeln(txt1,kodsk^[kk]); writeln(txt1,df^[kk]); writeln(txt1,azp^[kk]);
         end
         else begin
           writeln(txt2,kodsk^[kk]); writeln(txt2,df^[kk]); writeln(txt2,azp^[kk]);
         end;
       end;
       i:=succ(i);
     end;
     close(txt_azaf);
     dispose(azp); dispose(xsk); dispose(ysk); dispose(azp1);
end;
{--------------------------EPIKEFALIDES---------------------------------------}
Procedure selida;
begin
  sel:=sel+1;
  writeln(txta);
  writeln(txta,' ':68,'‘„Šˆƒ€ : ',sel:1);
  writeln(txta);
end;
Procedure epikef1(titlos:string44; gn,agn,par,ag,thewr,ypol:integer);
var       i:integer;
begin
  selida;
  for i:=1 to 4 do writeln(txta);
  writeln(txta,chr(14),'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
  writeln(txta,chr(14),'“Š‚ˆ‘‹‘ ƒˆ‰’““ ‹„ ’†Œ   ‹ . „ . ’ .');
  writeln(txta,chr(14),'  ( ‹„‡ƒ‘  ‹„’€Š†‘  ‘“Œ’„’€‚‹„Œ—Œ )');
  writeln(txta,chr(14),'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
  writeln(txta);
  writeln(txta,'  „‚€‘ˆ€ : ',titlos);
  writeln(txta);
  writeln(txta,'  ‚Œ—‘’€  ‘†‹„ˆ€ : ',gn:1);
  writeln(txta,'  €‚Œ—‘’€ ‘†‹„ˆ€ : ',agn:1);
  writeln(txta);
  writeln(txta,'  €€’††‘„ˆ‘   : ',par:1);
  writeln(txta,'  €‚Œ—‘’ˆ       : ',ag:1);
  writeln(txta);
  writeln(txta,'  ‡„—†’ˆ‰    „“‘ …—Œ†‘ ‰€ŒŒˆ‰“ ‘“‘’†‹€’‘ : ',thewr:1);
  writeln(txta,'  “Š‚ˆ‘‹„Œ „“‘ …—Œ†‘ ‰€ŒŒˆ‰“ ‘“‘’†‹€’‘ : ',ypol:1);
  writeln(txta);
  writeln(txta,'-------------------------------------------------------------');
  writeln(txta);
end;
Procedure epikef2;
begin
  write(txta,#12); selida;
  writeln(txta,'      „  ˆ ‘ — ‘ „ ˆ ‘    €  € ’ †  † ‘ † ‘');
  writeln(txta);
  writeln(txta,'    €/€  ‰—ƒˆ‰‘   €‘    ‘“Œ’„Š„‘’†‘      ‹„Š‘');
  writeln(txta,'    ---  -------  -------  --------------  ---------');
              {  4 *** 4  **** 3 ****.**        18        ****.****
                               27           ***2 ****.****           }
  writeln(txta);
end;
Procedure epikef3;
begin
  write(txta,#12); selida;
  writeln(txta,chr(14),'   €’„Š„‘‹€’€ ‹„ ’†Œ ‹„’');
  writeln(txta);
  writeln(txta,'  €/€  ‰—ƒˆ‰‘   ƒ•    ‹’‘ ƒ•   ƒ“    ‹’‘ ƒ“     ƒ…     ‹’‘ ƒ…');
  writeln(txta,'  ---  -------  -----  ------  -----  ------  --------  ------');
               {  ***    ****   **.**  ***.**  **.**  ***.**  ***.****  ***.**}
end;
Procedure epikef4;
begin
  writeln(txta,#12); selida; writeln(txta);
  writeln(txta,'  ‘ “ Œ ’ „ ’ € ‚ ‹ „ Œ „ ‘   ‘ ’ € ‡ „  — Œ   ‘ † ‹ „ ˆ — Œ');
  writeln(txta);
  writeln(txta,'  €/€  ‰—ƒˆ‰‘   ’„’‹†‹„Œ†   ‘”€Š‹€ •    ’„’€‚‹„Œ†   ‘”€Š‹€ “');
  writeln(txta,'  ---  -------  -----------  --------  ------------  --------');
               {  ***    ****   ***********  ñ **.**   ************  ñ **.**}
end;
Procedure epikef5;
begin
  writeln(txta,#12); selida; writeln(txta);
  writeln(txta,'     €”‹ˆ—‹„Œ„‘   ’ˆ‹„‘   ‘“Œ’„’€‚‹„Œ—Œ   Œ„—Œ   ‘†‹„ˆ—Œ');
  writeln(txta);
  writeln(txta,'  €/€  ‰—ƒˆ‰‘   ’„’‹†‹„Œ†   ‘”€Š‹€ •    ’„’€‚‹„Œ†   ‘”€Š‹€ “');
  writeln(txta,'  ---  -------  -----------  --------  ------------  --------');
end;
Procedure epikef6;
begin
  writeln(txta,#12); selida; writeln(txta);
  writeln(txta,'         „  Š  Š  „  ˆ  –  „  ˆ  ‘       ‘  ”  €  Š  ‹  €  ’    ‘');
  writeln(txta);
  writeln(txta,'€/€  ‰—ƒˆ‰‘      QXX           QYY           QXY         A     B  ‚—Œˆ€ € “');
  writeln(txta,'---  -------  ------------  ------------  ------------  ----  ----  --------');
               {*** 4  **** 3 ************ 2************ 2************ 2*.**  *.**  ***.****}
end;

{------------------------------OTHONES----------------------------------------}
Procedure anal_gr_scr1(grammi,k:integer);
begin
  gotoxy(16,grammi); write(igeodf^[k]); gotoxy(24,grammi); write(xnew^[k]:11:3);
  wrt(39,grammi,15,'00.00'); gotoxy(46,grammi); write(ynew^[k]:12:3);
  wrt(62,grammi,15,'00.00');
end;
Procedure anal_gr_scr2(grammi,k,jxy:integer);
begin
  gotoxy(16,grammi); write(igeodn^[k-nfix]); gotoxy(24,grammi); write(xnew^[k]:11:3);
  gotoxy(39,grammi); write(sxyz^[jxy]:5:2); gotoxy(46,grammi); write(ynew^[k]:12:3);
  gotoxy(62,grammi); write(sxyz^[jxy+1]:5:2);
end;
Procedure write_screen(m,scr_line:integer);
label     a;
var       k,jxy:integer;
begin
  clrscr;
  seek(k040_scr,3); read(k040_scr,rec1); move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to nfix do
  begin
    anal_gr_scr1(scr_line,k); scr_line:=scr_line+1;
    if scr_line=22 then
    begin
      wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680); scr_line:=7;
    end;
  end;
  if m <= 15 then
  begin
    wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13)); goto a;
  end;
  wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
a:
  seek(k040_scr,5); read(k040_scr,rec1); move(rec1.xx[0],mem[$b000:ofs1],3680);
  scr_line:=7; jxy:=0;
  for k:=1 to nnew do
  begin
    jxy:=jxy+3;
    if k=1 then jxy:=1;
    anal_gr_scr2(scr_line,k+nfix,jxy); scr_line:=scr_line+1;
    if scr_line=22 then
    begin
      wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680); scr_line:=7;
    end;
  end;
  if m <= 15 then
  begin
    wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13)); exit;
  end;
  wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

{-------------------------FOBERH--EPEXERGASIA---------------------------------}
Procedure epex;
label     730,810,1080,1260,1430,1510,1710,1930,2050,2070,2100,
          2150,2240,2270,2490,2610,3430,3450,3460,3530,3560,3610,
          3760,3820,3930;
Type      matr5 = array[1..300] of string[4];
          matr6 = array[1..300] of integer;
          matr7 = array[1..300] of real;
          matr8 = array[1..100,1..100] of real;
          matr9 = array[1..100,1..100] of real;
          matr10= array[1..70] of real;
var       nll,nw,ia,nall,ivarx,lc,i,j,j1,j2,k,ip,l,jj,jr,jr1,me,mee,
          ki,kk,nobs,nalldr,nalls,ndir,ntrobs,l1,iwss,new1,itrig,irr1,
          jro,ico,ic1,ic2,ic3,jrr,icco,icc1,icc2,icc3,ir,ll,min,maxb,
          maxbc,irband,i2,keq,i11,iaux,k1,k2,irk1,ifylbd,irk1i,irm1,
          ip1,ip2,ipk1,ms,it,ms1,metr,ipp,is,mpk1,m,irk2,nrband,iss,
          ism1,ii,m1,mn,ln,jxy,ic  :  integer;
          pi,aprcc,aprmae,sforg,ab,bb,athinl,psq,ak1,pap,sfgrd,psq1,
          ayy1,alfa,vv,so2,so,ss,Qxx,Qxy,Qyy,Q1,Q2,Riza1,Riza2,
          Dar,Dpar,Gaaa,Aaa,Bbb  :  real;
          kodg,kodf,i1,igd,kst                     :string[4];
          kgdir,istat,iskop                        : ^matr5;
          ifixx,innew,knewal,ndir1,ns1,kodir,new2,
          icola,icolt,minr,maxr,ib                 : ^matr6;
          app,ap,p,sy,ay,pp,f,w,ww,v               : ^matr7;
          c                                        : ^matr8;
          a                                        : ^matr9;
          dxyz                                     : ^matr10;
          dst:string[20];
Procedure NewDispose;
Begin
  dispose(kgdir); dispose(istat);  dispose(iskop); dispose(ifixx);
  dispose(innew); dispose(knewal); dispose(ndir1); dispose(ns1);
  dispose(kodir); dispose(new2);   dispose(icola); dispose(icolt);
  dispose(minr);  dispose(maxr);   dispose(ib);    dispose(app);
  dispose(ap);    dispose(p);      dispose(sy);    dispose(ay);
  dispose(pp);    dispose(f);      dispose(ww);    dispose(w);
  dispose(v);     dispose(c);      dispose(a);     dispose(dxyz);
End;
Begin
    nll:=ns; nw:=nnew; ia:=3*nw; nall:=nnew+nfix;
    pi:=arctan(1)*4; aprcc:=3; aprmae:=1/1000000.0; sforg:=0.01;
    ab:=6377397.155; bb:=6356078.963;
    athinl:=(23+42/60+58.815/3600)*pi/180; ivarx:=1; lc:=0;
    new(kgdir); new(istat);  new(iskop); new(ifixx);
    new(innew); new(knewal); new(ndir1); new(ns1);
    new(kodir); new(new2);   new(icola); new(icolt);
    new(minr);  new(maxr);   new(ib);    new(app);
    new(ap);    new(p);      new(sy);    new(ay);
    new(pp);    new(f);      new(ww);    new(w);
    new(v);     new(c);      new(a);     new(dxyz);
    fillchar(x^,sizeof(x^),0);           fillchar(y^,sizeof(y^),0);
    fillchar(ifixx^,sizeof(ifixx^),0);   fillchar(innew^,sizeof(innew^),0);
    fillchar(knewal^,sizeof(knewal^),0); fillchar(kodir^,sizeof(kodir^),0);
    fillchar(f^,sizeof(f^),0);           fillchar(c^,sizeof(c^),0);
    fillchar(dxyz^,sizeof(dxyz^),0);     fillchar(sy^,sizeof(sy^),0);
    fillchar(app^,sizeof(app^),0);       fillchar(ap^,sizeof(ap^),0);
    fillchar(w^,sizeof(w^),0);           fillchar(ww^,sizeof(ww^),0);
    fillchar(v^,sizeof(v^),0);           fillchar(ndir1^,sizeof(ndir1^),0);
    fillchar(ns1^,sizeof(ns1^),0);       fillchar(new2^,sizeof(new2^),0);
    fillchar(icola^,sizeof(icola^),0);   fillchar(icolt^,sizeof(icolt^),0);
    fillchar(minr^,sizeof(minr^),0);     fillchar(maxr^,sizeof(maxr^),0);
    fillchar(ib^,sizeof(ib^),0);         fillchar(p^,sizeof(p^),0);
    fillchar(ay^,sizeof(ay^),0);         fillchar(pp^,sizeof(pp^),0);
    fillchar(a^,sizeof(a^),0);           fillchar(kgdir^,sizeof(kgdir^),0);
    fillchar(istat^,sizeof(istat^),0);   fillchar(iskop^,sizeof(iskop^),0);
    for i:=1 to 3 do readln(txt1,buff);
    for i:=1 to nall do
    begin
      readln(txt1,buff); igeod^[i]:=buff;
      readln(txt1,buff); arith_input(buff,dst); val(dst,x^[i],cod);
      readln(txt1,buff); arith_input(buff,dst); val(dst,y^[i],cod);
    end;
    for i:=1 to nfix do begin readln(txt1,buff); igeodf^[i]:=buff; end;
    ki:=0;
    for i:=1 to nall do
    begin
      kodg:=igeod^[i];
      for j:=1 to nfix do
      begin
        kodf:=igeodf^[j];
        if kodg <> kodf then
        begin
          if j = nfix then
          begin
            ki:=ki+1;
            igeodn^[ki]:=kodg;
          end;
        end else goto 730;
      end;
730:end;
    for i:=1 to nfix do
    begin
      i1:=igeodf^[i];
      for ip:=1 to nall do
      begin
        if i1 = igeod^[ip] then
        begin
          ifixx^[i]:=ip;  goto 810;
        end;
      end;
810:end;
    kk:=0; k:=1;
    for j1:=1 to nall do
    begin
      j2:=k;
      if j1 = ifixx^[j2] then k:=k+1
      else
      begin
        kk:=kk+1; innew^[j1]:=kk; knewal^[kk]:=j1;
      end;
    end;
    nobs:=0; nalldr:=0; nalls:=0; lc:=58;
 {  START OF STATION INPUT  }
    for i:=1 to nall do
    begin
      readln(txt1,buff); igd:=buff;
      readln(txt1,buff); arith_input(buff,dst); val(dst,ndir,cod);
      ns:=0;
      ndir1^[i]:=ndir;
      ns1^[i]:=ns;
      for ip:=1 to nall do
      begin
        if igd = igeod^[ip] then begin itrig:=ip; goto 1080; end;
      end;
1080: nalldr:=nalldr+ndir;      nalls:=nalls+ns;      ntrobs:=ndir+ns;
 {  AT THIS POINT INSERT STMS FOR DISTANCES  }
      if ntrobs = 0 then goto 2270;
      for j:=1 to ndir do
      begin
        readln(txt1,buff); kgdir^[j]:=buff; readln(txt1,buff);
        readln(txt1,buff); arith_input(buff,dst); val(dst,app^[j],cod);
      end;
      for j:=1 to ndir do
      begin
        for ip:=1 to nall do
        begin
          if kgdir^[j] = igeod^[ip] then begin kodir^[j]:=ip; goto 1260; end;
        end;
1260: end;
      for l:=1 to ndir do
      begin
        l1:=kodir^[l]; ap^[l1]:=app^[l]; p^[l1]:=1;
      end;
      nobs:=nobs+ntrobs;
      new1:=0;
      for j:=1 to nfix do
      begin
        if itrig = ifixx^[j] then
        begin
          new1:=1; goto 1430;
        end;
      end;
1430: if ndir <> 0 then
      begin
        for jj:=1 to ndir do
        begin
          new2^[jj]:=0;
          for j:=1 to nfix do
          begin
            if kodir^[jj]=ifixx^[j] then begin new2^[jj]:=1; goto 1510; end;
          end;
1510:   end;
      end;
      irr1:=3*nnew;
      jro:=nobs-ntrobs;
      if new1 <> 1 then
      begin
        ico:=innew^[itrig]; ic1:=3*ico-3+1; ic2:=ic1+1; ic3:=ic2+1;
      end;
      if ndir = 0 then goto 2240;
      for jr:=1 to ndir do
      begin
        me:=0; mee:=0; jr1:=jro+jr;
        for k:=1 to irr1 do begin c^[jr1,k]:=0; f^[jr1]:=0; end;
        icola^[jr1]:=0;
        icolt^[jr1]:=0;
        if new1=1 then goto 1930;
1710:   jrr:=kodir^[jr];
        psq:=sqrt(p^[jrr]);
        arc((x^[jrr]-x^[itrig]),(y^[jrr]-y^[itrig]),ak1);
        ay^[jrr]:=ak1;
        pap:=sqr((x^[jrr]-x^[itrig]))+sqr((y^[jrr]-y^[itrig]));
        sy^[jrr]:=sqrt(pap);
        sfgrd:=(aprcc/636620.0)*sy^[jrr];
        p^[jrr]:=sqr(psq);
        if mee <> 0 then goto 2100;
        me:=1;
        icola^[jr1]:=ic1;
        icolt^[jr1]:=ic3;
        c^[jr1,ic1]:= -((cos(ay^[jrr]))/sy^[jrr])*psq;
        c^[jr1,ic2]:= (sin(ay^[jrr])/sy^[jrr])*psq;
        c^[jr1,ic1]:= c^[jr1,ic1]*2000000.0/pi;
        c^[jr1,ic2]:= c^[jr1,ic2]*2000000.0/pi;
        c^[jr1,ic3]:= -1*psq;
1930:   if new2^[jr]=1 then goto 2150;
        jrr:=kodir^[jr];
        psq:=sqrt(p^[jrr]);
        icco:=innew^[jrr];
        icc1:=3*icco-3+1;
        icc2:=icc1+1;
        icc3:=icc2+1;
        if new1=1 then goto 2050;
        if icola^[jr1] > icc1 then icola^[jr1]:=icc1;
        if icolt^[jr1] < icc2 then icolt^[jr1]:=icc2;
        goto 2070;
2050:   icola^[jr1]:=icc1;
        icolt^[jr1]:=icc2;
2070:   if me <> 1 then begin mee:=1; goto 1710; end;
2100:   c^[jr1,icc1]:= (cos(ay^[jrr])/sy^[jrr])*psq;
        c^[jr1,icc2]:= -(sin(ay^[jrr])/sy^[jrr])*psq;
        c^[jr1,icc1]:= c^[jr1,icc1]*2000000.0/pi;
        c^[jr1,icc2]:= c^[jr1,icc2]*2000000.0/pi;
        c^[jr1,icc3]:= 0;
2150:   f^[jr1]:=(ap^[jrr]-ay^[jrr]*200/pi)*10000.0;
        istat^[jr1]:=igd;
        iskop^[jr1]:=kgdir^[jr];
        psq1:=sqr(psq);
        ayy1:=ay^[jrr]*200/pi;
        f^[jr1]:=f^[jr1]*psq;
        pp^[jr1]:=p^[jrr];
      end;
2240: if ns=0 then goto 2270;
2270:
    end;
    ir:=3*nnew;
 {  FIND MINR[I], MAXR[I]  }
    for ll:=1 to nobs do begin minr^[ll]:=0; maxr^[ll]:=0; end;
    for i:=1 to nobs do
    begin
      min:=icola^[i];
      if minr^[min]=0 then begin minr^[min]:=i; maxr^[min]:=i; j1:=min+1; end
        else maxr^[min]:=i;
      j2:=icolt^[i];
      for j:=j1 to j2 do
      begin
        if c^[i,j]=0 then goto 2490;
        if minr^[j]=0 then begin minr^[j]:=i; maxr^[j]:=i; end else maxr^[j]:=i;
2490: end;
    end;
 {  COMPUTING BANDWITH  }
    for i:=1 to ir do
    begin
      j1:=minr^[i]; j2:=maxr^[i];
      maxb:=1;
      for j:=j1 to j2 do
      begin
        if c^[j,i]=0 then goto 2610;
        maxbc:=icolt^[j];
        if maxb > maxbc then goto 2610;
        maxb:=maxbc;
2610: end;
      ib^[i]:=maxb-i+1;
    end;
    irband:=1;
    for i:=1 to ir do if irband < ib^[i] then irband:=ib^[i];
    assign(txta,'txta'); rewrite(txta); sel:=0;
    epikef1(title,nfix,nnew,nobs,ir,ir*3,irband);
    lc:=29; i2:=0;
    for k:=1 to nall do
    begin
      kst:=igeod^[k];
      keq:=ndir1^[k]+ns1^[k];
      i2:=i2+keq;
      i11:=i2-keq+1;
      for i:=i11 to i2 do
      begin
        iaux:=1;
        if lc>= 29 then begin lc:=8; epikef2; end;
        writeln(txta,' ':4,i:3,' ':4,kst,' ':7-length(kst),pp^[i]:7:2,' ':18,f^[i]:9:4);
        lc:=lc+2;
        j1:=icola^[i]; j2:=icolt^[i];
        for j:=j1 to j2 do
        begin
          if c^[i,j] <> 0 then
          begin
            if iaux = 0 then writeln(txta,' ':27,j:3,'  ',c^[i,j]:9:4)
                        else begin iaux:=0; writeln(txta,' ':27,j:3,'  ',c^[i,j]:9:4); end;
          end;
        end;
      end;
    end;
 {  FORMING NORMALS  }
    for i:=1 to ir do
    begin
      j1:=ib^[i];
      k1:=minr^[i];
      k2:=maxr^[i];
      j1:=j1+i-1;
      for j:=i to j1 do
      begin
        a^[i,j]:=0;
        for k:=k1 to k2 do a^[i,j]:=a^[i,j]+c^[k,i]*c^[k,j];
        a^[j,i]:=a^[i,j];
      end;
      w^[i]:=0;
      for kk:=k1 to k2 do w^[i]:=w^[i]+f^[kk]*c^[kk,i];
      ww^[i]:=w^[i];
    end;
 {  INSERT HERE FOR PRINTING NORMALS  }
    irk1:=ir+1;
    ifylbd:=irband;
    for i:=1 to ir do
    begin
      if ivarx <> 0 then
      begin irk1i:=irk1+i; a^[i,irk1i]:=1; a^[i,irk1]:=w^[i]; end;
    end;
 {  INVERSION  }
    irm1:=ir-1;
    ip1:=ir-irband+1;
    ip2:=ir-2*irband+2;
    for ip:=1 to irm1 do
    begin
      ipk1:=ip+1;
      ms:=ip+2*irband-2;
      i11:=ip+irband-1;
      alfa:=0;
      k:=ip;
3450: kk:=k-ip+1;
3460: if abs(alfa) < abs(a^[k,ip]) then begin alfa:=a^[k,ip]; it:=k; end;
      if ip > ip1 then goto 3530;
      if kk >= irband then goto 3560;
      k:=k+1;
      goto 3450;
3530: if k >= ir then goto 3560;
      k:=k+1;
      goto 3460;
3560: if alfa=a^[ip,ip] then goto 3760;
      ms1:=ms;
      metr:=1;
      ipp:=ip;
3610: if ip >= ip2 then ms1:=ir;
      for is:=ipp to ms1 do
      begin
        w^[is]:=a^[ip,is]; a^[ip,is]:=a^[it,is]; a^[it,is]:=w^[is];
      end;
      if metr <> 1 then goto 3760;
      w^[irk1]:=a^[ip,irk1];
      a^[ip,irk1]:=a^[it,irk1];
      a^[it,irk1]:=w^[irk1];
      if ivarx = 0 then goto 3760;
      ms1:=ir+irband+ip;
      if ip >= ip1 then ms1:=2*ir+1;
      ipp:=ir+2;
      metr:=metr+1;
      goto 3610;
3760: if ip >= ip1 then i11:=ir;
      for i:=ipk1 to i11 do
      begin
        if ip >= ip2 then ms:=ir;
        ms1:=ms;
        metr:=1;
        mpk1:=ipk1;
3820:   for m:=mpk1 to ms1 do a^[i,m]:=a^[i,m]-a^[i,ip]*a^[ip,m]/a^[ip,ip];
        if metr <> 1 then goto 3930;
        a^[i,irk1]:=a^[i,irk1]-a^[i,ip]*a^[ip,irk1]/a^[ip,ip];
        if ivarx=0 then goto 3930;
        ms1:=ir+irband+ip;
        if ip >= ip1 then ms1:=2*ir+1;
        mpk1:=ir+2;
        metr:=metr+1;
        goto 3820;
3930: end;
    end;
    irk2:=ir+2;
    nrband:=2*irband-1;
    j:=0;
    k1:=ir-nrband+1;
    for iss:=1 to irm1 do
    begin
      is:=ir-iss+1;
      k:=k1-j;
      ism1:=is-1;
      if is < nrband then k:=1;
      for ii:=k to ism1 do
      begin
        i:=ism1-ii+k;
        if ivarx <> 0 then
        begin
          m1:=ir+i+1;
          for m:=irk2 to m1 do a^[i,m]:=a^[i,m]-a^[i,is]*a^[is,m]/a^[is,is];
        end;
        a^[i,irk1]:=a^[i,irk1]-a^[i,is]*a^[is,irk1]/a^[is,is];
      end;
      j:=j+1;
    end;
    for l:=1 to ir do
    begin
      if ivarx <> 0 then
      begin
        m1:=ir+l+1;
        for m:=irk2 to m1 do
        begin
          a^[l,m]:=a^[l,m]/a^[l,l]; mn:=m-ir-1;
          ln:=l+ir+1; a^[mn,ln]:=a^[l,m];
        end;
      end;
      dxyz^[l]:=a^[l,irk1]/a^[l,l];
    end;
 {  VARIANCE OF UNIT WEIGHT  }
    vv:=0;
    l:=nobs-ir;
    for i:=1 to nobs do
    begin
      v^[i]:=0;
      for j:=1 to ir do v^[i]:=v^[i]+c^[i,j]*dxyz^[j];
      v^[i]:=v^[i]-f^[i];
      vv:=vv+sqr(v^[i]);
    end;
    so2:=vv/l;
    so:=sqrt(so2);
    for i:=1 to ir do
    begin
      irk1i:=irk1 +i;
      ss:=so2*a^[i,irk1i];
      sxyz^[i]:=sqrt((abs(ss)));
    end;
    epikef3;
    j:=0; i:=1;
    repeat
      j:=j+1;
      writeln(txta,'  ',j:3,' ':4,igeodn^[j],' ':7-length(igeodn^[j]),
              dxyz^[i]:5:2,'  ',sxyz^[i]:6:2,'  ',dxyz^[i+1]:5:2,'  ',
              sxyz^[i+1]:6:2,'  ',dxyz^[i+2]:8:4,'  ',sxyz^[i+2]:6:2);
      i:=i+3;
    until i>=ir;
    writeln(txta);
    writeln(txta,'  ‹„’€Š†’’†’€ ‹Œ€ƒ€‘ €“‘ : ',so:5:4);
 {  AFOMOIWMENES SYN/NES SHMEIWN NEWN  }
    for i:=1 to nnew do
    begin
      i11:=i11+3;
      if i=1 then i11:=1;
      i2:=i11+1;
      j:=knewal^[i];
      x^[j]:=x^[j]+dxyz^[i11];
      y^[j]:=y^[j]+dxyz^[i2];
    end;
    epikef4;
    for i:=1 to nfix do
    begin
      writeln(txta,'  ',i:3,' ':4,igeodf^[i],' ':7-length(igeodf^[i]),
              x^[ifixx^[i]]:11:3,
              '  ñ  0.00   ',y^[ifixx^[i]]:12:3,'  ñ  0.00');
      xnew^[i]:=x^[ifixx^[i]]; ynew^[i]:=y^[ifixx^[i]];
    end;
 {  EKTYPWSH NEWN SHMEIWN  }
    jxy:=0;
    epikef5;
    for i:=1 to nnew do
    begin
      jxy:=jxy+3;
      if i=1 then jxy:=1;
      writeln(txta,'  ',i:3,' ':4,igeodn^[i],' ':7-length(igeodn^[i]),
              x^[knewal^[i]]:11:3,'  ñ ',sxyz^[jxy]:5:2,'   ',
              y^[knewal^[i]]:12:3,'  ñ ',sxyz^[jxy+1]:5:2);
      xnew^[i+nfix]:=x^[knewal^[i]]; ynew^[i+nfix]:=y^[knewal^[i]];
    end;
 {  EY„‘† ‘’ˆ•„ˆ—Œ „ŠŠ„ˆ–„—‘ ‘”€Š‹€’‘ ‚ˆ€ ‰€‡„ ‘†‹„ˆ  }
    epikef6;
    for i:=1 to nnew do
    begin
      l:=1+(i-1)*3;
      ic:=ir+2+(i-1)*3;
      Qxx:=a^[l,ic];
      Qxy:=a^[l,ic+1];
      Qyy:=a^[l+1,ic+1];
      Q1:=(Qxx+Qyy)/2.0;
      Q2:=sqrt(sqr(Qxx-Qyy)/4.0+sqr(Qxy));
      Riza1:=Q1+Q2;
      Riza2:=abs(Q1-Q2);
      Dar:=2*Qxy;
      Dpar:=Qyy-Qxx;
      arc(Dar,Dpar,Gaaa);
      Gaaa:=Gaaa*200.0/pi;
      Aaa:=so*sqrt(Riza1);
      Bbb:=so*sqrt(Riza2);
      Gaaa:=Gaaa/2.0;
      while Gaaa<0 do Gaaa:=Gaaa+400.0;
      writeln(txta,i:3,'    ',igeodn^[i]:4,'   ',Qxx:12,'  ',
              Qyy:12,'  ',Qxy:12,'  ',Aaa:4:2,'  ',Bbb:4:2,'  ',Gaaa:8:4);
      writeln(txta);
    end;
    close(txta);
    NewDispose;
end;

Procedure epex_menu;
var       i,j,k,epil:integer;
          okk :boolean;
          ch:char;
label     e1,e2,e3,e4,e5,e6,e7,e8,e9,10,25,l1,l2,l3;
begin
    case menu of
       1:begin
           if (sw1=1) or (sw3=1) then epex_menu;
           clrscr;
           cursor(true,false);
           seek(k040_scr,4);    read(k040_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           fillchar(buff,sizeof(buff),' ');
e2:        input(buff,11,27,40.1,bit);
           title:=buff;
e3:        input(buff,13,35,4,bit);
           if bit then goto e2 else val(buff,nnew,cod);
           if not (nnew in [1..70]) then goto e3;
e4:        input(buff,15,35,4,bit);
           if bit then goto e3 else val(buff,nfix,cod);
           if not (nfix in [1..70]) then goto e4;
           ns:=nnew+nfix;
           assign(txt1,'txt1');
           rewrite(txt1);
           writeln(txt1,title); writeln(txt1,nnew); writeln(txt1,nfix);
           sw1:=1;
           repeat
             seek(k040_scr,1);    read(k040_scr,rec1);
             move(rec1.xx[0],mem[$b000:ofs1],3680);
             inp1;
             seek(k040_scr,2);    read(k040_scr,rec1);
             move(rec1.xx[0],mem[$b000:ofs1],3680);
             inp2;
             close(txt1);
             if sw4=1 then
             begin
               close(txt2); erase(txt1);
               rename(txt2,'txt1'); assign(txt1,'txt1');
             end;
             ClrScr;
             gotoxy(1,10);
             write(' „§ ©«¨¦­ ©«¦ ™˜© ¡¦ Menu ; (N/O) : ');
             read(cha1);
e8:          if not (cha1 in ['N','n','Œ','¤','O','o','','¦']) then goto e8;
             if cha1 in ['N','n','Œ','¤'] then
               begin cursor(false,true); epex_menu; end;
e5:          clrscr;
             gotoxy(1,10);
             write('‡„Š„ˆ‘ ‚ˆ€ ‰€‡„ ‘†‹„ˆ ’ €…ˆ‹“‡ˆ €”„’†ˆ€‘ ’“; (N/O) : ');
             read(cha1);
             if not (cha1 in ['N','n','Œ','¤','O','o','','¦']) then goto e5;
             if cha1 in ['N','n','Œ','¤'] then
             begin
e7:            gotoxy(4,12); ClrEol;
               write('ƒ—‘„ 1 ‚ˆ€ ‡Œ†, 2 ‚ˆ€ PRINTER : ');
               read(epil); if (epil<>1) and (epil<>2) then goto e7;
               if epil=2 then
               begin
                 gotoxy(1,14);
                 write('„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘. €’†‘„ RETURN ‚ˆ€ „‰’“—‘†..');
                 repeat
                   read(kbd,cha);
                   if ((cha=#27) and keypressed) then read(kbd,cha);
                 until cha in [#10,#13];
                 assign(txta,'prn'); rewrite(txta);
                 sel:=0; selida;
                 gram:=3;
                 reset(txt_azaf);
                 repeat
                   readln(txt_azaf,buff1);    writeln(lst,buff1);
                   gram:=gram+1;
                   if gram >= 64 then
                   begin
                     write(lst,#12); selida; gram:=3;
                   end;
                 until eof(txt_azaf);
                 close(txt_azaf);
                 erase(txt_azaf);
                 write(lst,#12);
               end
               else begin
                 reset(txt_azaf); clrscr; gram:=1;
                 repeat
                   readln(txt_azaf,buff1);
                   gotoxy(20,gram); write(buff1);
                   gram:=gram+1;
                   if gram = 22 then
                   begin
                     gotoxy(30,24); write('€’†‘’„ „Œ€ Š†‰’...');
                     repeat  until keypressed; read(kbd,ch);
                     if ((ch=#27) and keypressed) then read(kbd,ch);
                     clrscr;
                     gram:=1;
                   end;
                 until eof(txt_azaf);
                 gotoxy(30,24); write('€’†‘’„ „Œ€ Š†‰’...');
                 repeat  until keypressed; read(kbd,ch);
                 if ((ch=#27) and keypressed) then read(kbd,ch);
                 close(txt_azaf);
                 erase(txt_azaf);
               end;
               clrscr;
               wrt(1,12,15,'Œ€ ‘“Œ„•ˆ‘— ’†Œ „„„‚€‘ˆ€;  (N/O):');
               gotoxy(37,12);    read(cha);
               if cha in ['o','O','¦',''] then
               begin
                 sw4:=1;
                 assign(txt2,'txt2');
                 rewrite(txt2);
                 writeln(txt2,title); writeln(txt2,nnew); writeln(txt2,nfix);
                 reset(txt1);
                 readln(txt1,buff); readln(txt1,buff); val(buff,nnew,cod);
                 readln(txt1,buff); val(buff,nfix,cod); ns:=nnew+nfix;
               end;
             end
             else cha:='N';
           until cha in ['N','n','Œ','¤'];
           sw4:=0;
           clrscr;
           cursor(false,true);
           wrt(22,11,240,'                                 ');
           wrt(22,12,240,'    œ  ¨  š  ˜    ¦  £  ˜       ');
           wrt(22,13,240,'                                 ');
           reset(txt1);
           epex;
           close(txt1);
           clrscr;
           epex_menu;
         end;
       2:begin
           cursor(true,false);
           if ((sw1=1) or (sw3=1)) then
           begin
             wrt_screen(OthInp,1,20,80,22);
             gotoxy(13,21); read(name);
             assign(fill,name);
             {$i-}
             reset(fill);
             {$i+}
             okk:=(ioresult=0);
             if okk then
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
             assign(txt1,'txt1'); reset(txt1); rewrite(fill);
             repeat
               fillchar(buff1,sizeof(buff1),' ');
               readln(txt1,buff1); writeln(fill,buff1);
             until eof(txt1);
             close(txt1); close(fill);
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
           wrt_screen(OthInp,1,20,80,22);
           gotoxy(13,21); read(filename);
           assign(fill,filename);
           {$i-}
           reset(fill);
           {$i+}
           okk:=(ioresult=0);
           if not okk then
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
           assign(txt1,'txt1'); rewrite(txt1);
           repeat
             fillchar(buff1,sizeof(buff1),' ');
             readln(fill,buff1); writeln(txt1,buff1);
           until eof(fill);
           close(fill); close(txt1); reset(txt1);
           fillchar(buff1,sizeof(buff1),' ');
           readln(txt1,buff1);    title:=buff1;
           fillchar(buff,sizeof(buff),0);
           readln(txt1,buff);    val(buff,nnew,cod);
           fillchar(buff,sizeof(buff),0);
           readln(txt1,buff);    val(buff,nfix,cod);
           ns:=nnew+nfix;
           close(txt1);
           clrscr; cursor(true,false);
           gotoxy(1,10); write('„§ ©«¨¦­ ©«¦ ™˜© ¡¦ Menu; (N/O): ');
           read(cha1);
e9:        if not (cha1 in ['N','n','Œ','¤','O','o','','¦']) then goto e9;
           if cha1 in ['N','n','Œ','¤'] then
             begin Cursor(false,true); epex_menu; end;
           ClrScr; cursor(false,true);
           wrt(22,11,240,'                                 ');
           wrt(22,12,240,'    E    ‚  €  …    ‹  €  ˆ    ');
           wrt(22,13,240,'                                 ');
           reset(txt1);
           epex;
           close(txt1);
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
           assign(txt2,'txt2');
           rewrite(txt2);
           writeln(txt2,title); writeln(txt2,nnew); writeln(txt2,nfix);
           reset(txt1);
           readln(txt1,buff); readln(txt1,buff); val(buff,nnew,cod);
           readln(txt1,buff); val(buff,nfix,cod); ns:=nnew+nfix;
           seek(k040_scr,1);    read(k040_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           inp1;
           seek(k040_scr,2);    read(k040_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           inp2;
           clrscr;
           cursor(false,true);
           close(txt1); close(txt2);
           erase(txt1); rename(txt2,'txt1'); assign(txt1,'txt1');
           cursor(true,false);

           repeat
             ClrScr;
             gotoxy(1,10);
             write(' „§ ©«¨¦­ ©«¦ ™˜© ¡¦ Menu ; (N/O) : ');
             read(cha1);
l1:          if not (cha1 in ['N','n','Œ','¤','O','o','','¦']) then goto l1;
             if cha1 in ['N','n','Œ','¤'] then
               begin cursor(false,true); epex_menu; end;
l2:          clrscr;
             gotoxy(1,10);
             write('‡„Š„ˆ‘ ‚ˆ€ ‰€‡„ ‘†‹„ˆ ’ €…ˆ‹“‡ˆ €”„’†ˆ€‘ ’“; (N/O) : ');
             read(cha1);
             if not (cha1 in ['N','n','Œ','¤','O','o','','¦']) then goto l2;
             if cha1 in ['N','n','Œ','¤'] then
             begin
l3:            gotoxy(4,12); ClrEol;
               write('ƒ—‘„ 1 ‚ˆ€ ‡Œ†, 2 ‚ˆ€ PRINTER : ');
               read(epil); if (epil<>1) and (epil<>2) then goto l3;
               if epil=2 then
               begin
                 gotoxy(1,14);
                 write('„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘. €’†‘„ RETURN ‚ˆ€ „‰’“—‘†..');
                 repeat
                   read(kbd,cha);
                   if ((cha=#27) and keypressed) then read(kbd,cha);
                 until cha in [#10,#13];
                 assign(txta,'prn'); rewrite(txta);
                 sel:=0; selida;
                 gram:=3;
                 reset(txt_azaf);
                 repeat
                   readln(txt_azaf,buff1);    writeln(lst,buff1);
                   gram:=gram+1;
                   if gram >= 64 then
                   begin
                     write(lst,#12); selida; gram:=3;
                   end;
                 until eof(txt_azaf);
                 close(txt_azaf);
                 erase(txt_azaf);
                 write(lst,#12);
               end
               else begin
                 reset(txt_azaf); clrscr; gram:=1;
                 repeat
                   readln(txt_azaf,buff1);
                   gotoxy(20,gram); write(buff1);
                   gram:=gram+1;
                   if gram = 22 then
                   begin
                     gotoxy(30,24); write('€’†‘’„ „Œ€ Š†‰’...');
                     repeat  until keypressed; read(kbd,ch);
                     if ((ch=#27) and keypressed) then read(kbd,ch);
                     clrscr;
                     gram:=1;
                   end;
                 until eof(txt_azaf);
                 gotoxy(30,24); write('€’†‘’„ „Œ€ Š†‰’...');
                 repeat  until keypressed; read(kbd,ch);
                 if ((ch=#27) and keypressed) then read(kbd,ch);
                 close(txt_azaf);
                 erase(txt_azaf);
               end;
               clrscr;
               wrt(1,12,15,'Œ€ ‘“Œ„•ˆ‘— ’†Œ „„„‚€‘ˆ€;  (N/O):');
               gotoxy(37,12);    read(cha);
               if cha in ['o','O','¦',''] then
               begin
                 sw4:=1;
                 assign(txt2,'txt2');
                 rewrite(txt2);
                 writeln(txt2,title); writeln(txt2,nnew); writeln(txt2,nfix);
                 reset(txt1);
                 readln(txt1,buff); readln(txt1,buff); val(buff,nnew,cod);
                 readln(txt1,buff); val(buff,nfix,cod); ns:=nnew+nfix;
               end;
             end
             else cha:='N';
           until cha in ['N','n','Œ','¤'];

           clrscr;
           wrt(22,11,240,'                                 ');
           wrt(22,12,240,'    E    ‚  €  …    ‹  €  ˆ    ');
           wrt(22,13,240,'                                 ');
           reset(txt1);
           epex;
           close(txt1);
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
              okk:=(ioresult=0);
              if okk then
              begin
                gotoxy(2,23);
                write('O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) ');
                read(kbd,cha);
                if cha in ['O','o','','¦'] then goto e6
                else begin
                  cursor(false,true);
                  assign(txta,'txta'); reset(txta); rewrite(fill);
                  repeat
                    fillchar(buff1,sizeof(buff1),' ');
                    readln(txta,buff1); writeln(fill,buff1);
                  until eof(txta);
                  close(txta); close(fill);
                end;
              end
              else
              begin
                cursor(false,true);
                assign(txta,'txta'); reset(txta); rewrite(fill);
                repeat
                  fillchar(buff1,sizeof(buff1),' ');
                  readln(txta,buff1); writeln(fill,buff1);
                until eof(txta);
                close(txta); close(fill);
              end;
e6:           cursor(true,false);
              gotoxy(2,23); clreol;
              gotoxy(2,23);
              write('‡„Š„ˆ‘ €’„Š„‘‹€’€ ‘„ €•„ˆ ‘“Œ’„’€‚‹„Œ—Œ; (N/O) : ');
              READ(CHA);
              if cha in ['O','o','','¦'] then goto e1
              else
              begin
                wrt_screen(OthInp,1,20,80,22);
                gotoxy(13,21); read(file_syntetagmenwn);
             cursor(false,true);
             assign(txta,'txta'); reset(txta); rewrite(fill);
             repeat
                 fillchar(buff1,sizeof(buff1),' ');
                 readln(txta,buff1); writeln(fill,buff1);
             until eof(txta);
             close(txta); close(fill);
               assign(DumFile,file_syntetagmenwn+'.dat');
               {$I-}
               reset(DumFile);
               {$I+}
               okk:=(ioresult=0);
               if okk then
               begin
                 close(DumFile);
                 OpenFile(file_syn,file_syntetagmenwn+'.dat',sizeof(rec_syn));
                 OpenIndex(IndexName,file_syntetagmenwn+'.ind',4,1);
               end
               else
               begin
                 MakeFile(file_syn,file_syntetagmenwn+'.dat',sizeof(rec_syn));
                 MakeIndex(IndexName,file_syntetagmenwn+'.ind',4,1);
               end;
               fillchar(rec_syn,sizeof(rec_syn),0);
               for k:=1 to nnew do
               begin
                 with rec_syn do
                 begin
                   Kwd_syn:=igeodn^[k]; X_syn:=xnew^[k+nfix];
                   Y_syn:=ynew^[k+nfix]; H_syn:=0; Eidos_Point:=' '; Job:=' ';
                   Xronol:=' '; Who_Idrise:=' ';Axiopistia:=' '; Comments:=' ';
                 end;
                 AddRec(file_syn,DatRef,rec_syn);
                 AddKey(IndexName,DatRef,rec_syn.Kwd_syn);
               end;
               CloseFile(file_syn);
               CloseIndex(IndexName);
             end;
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
             clrscr;
             wrt(29,12,240,'„  ‰  ’  “    —  Œ  —..');
             write(lst,#27,#67,chr(ar_gram));
             assign(txta,'txta'); reset(txta);
             repeat
               fillchar(buff1,sizeof(buff1),' ');
               readln(txta,buff1); writeln(lst,buff1);
             until eof(txta);
             close(txta);
             writeln(lst,#12);
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
             write_screen(nnew,7);
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
end;     { Procedure }

BEGIN
  initindex;
  clrscr;
  ofs1:=$8000;
  if mem[0:1040] and 48 = 48 then ofs1:=$0000;
  assign(k040_scr,'NALS.scr');
  reset(k040_scr);
  seek(k040_scr,6); read(k040_scr,rec1);
  for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
  for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
  new(x);     new(y);      new(df);     new(igeod);
  new(kodsk); new(igeodf); new(igeodn); new(xnew);
  new(ynew);  new(sxyz);
  delete_all_input;
  sw1:=0; sw3:=0; sw4:=0; sel:=0;
  cursor(false,true);
  epex_menu;
END.
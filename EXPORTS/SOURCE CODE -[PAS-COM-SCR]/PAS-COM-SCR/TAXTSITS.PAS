{******************************************************************************
*                         k003    Ô Á × Õ Ì Å Ô Ñ É Á  (Ôñïğïğïßçóç)                       *
*                     WRITTEN BY G.XALARIS                     *
*                              15-12-1986                                     *
*******************************************************************************}
{ † œ ©˜šàš ›œ›¦£œ¤à¤ ©«˜©ª «œ¢œ à¤œ  £œ ¡à› ¡¦ = 0.
  ‚ ' ˜¬«¦, « ª œ¡¢¦šœª «¦¬ menu « ª ¡˜¢à £œ 1 ¢ š¦«œ¨˜ ©«¦ ®œ ˜ }
TYPE     rec=record
           xx:array [0..3679] of byte;
         end;
         rec0_file_tax=record
           onerg_t:string[40];
           i_t:integer;
           type_tax_t:byte;
           dummy:string[16]
         end;
         rec1_file_tax=record
           kst_t,kaf_t:string[5];
           yo_t,hs_t,xs_t,yss_t,xsa_t,ysa_t:real;
           dummy:string[12];
         end;
         rec2_file_tax=record
           num_t:string[5];
           g_t:real;
           swmetr_t:boolean;
           ys_t,z_t,b_t,slor_t,dh_t,xp_t,yp_t,hp_t:real;
         end;
         rec_file_plot=record
           num_p:string[5];
           xp_p,yp_p,hp_p:real;
         end;
         string40 =string[40];
         string255=string[255];

VAR      onerg:string[40];
         i,j  :integer;
         type_tax:byte;
         kst,kaf:string[5];
         yo,hs,xs,yss,xsa,ysa:real;
         num : array[1..700] of string[5];
         g,ys,z,b,slor,dh,hp,xp,yp : array[1..700] of real;
         swmetr : array[1..700] of boolean;
         pi,pii,azr,azb,dx,dy,zr,br,sint,p,a1,az:real;
         OthInp,OthPrint:array[1..3680] of byte;
         io,metr_diorth,sw_read_file:integer;

         k003_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         l,m     :integer;
         ar_gram :integer;
         buff    :string40;
         buff_t  :string[40];
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         file_plot:file of rec_file_plot;
         rec_plot :rec_file_plot;

         file_tax:file of rec1_file_tax;
         rec1_tax:rec1_file_tax;
         rec2_tax:rec2_file_tax absolute rec1_tax;
         rec0_tax:rec0_file_tax absolute rec1_tax;
         st:string[2];
         string_t:string[6];

         sw1,sw3,sw4:byte;
         cha:char;
         sel,gram,scr_line1,k1:integer;
     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}
procedure delete_all_input;
begin
  fillchar(kst,sizeof(kst),0); fillchar(kaf,sizeof(kaf),0);
  fillchar(yo,sizeof(yo),0);   fillchar(hs,sizeof(hs),0);
  fillchar(xs,sizeof(xs),0);   fillchar(yss,sizeof(yss),0);
  fillchar(xsa,sizeof(xsa),0); fillchar(ysa,sizeof(ysa),0);
  fillchar(num,sizeof(num),0); fillchar(g,sizeof(g),0);
  fillchar(ys,sizeof(ys),0);   fillchar(z,sizeof(z),0);
  fillchar(b,sizeof(b),0);     fillchar(slor,sizeof(slor),0);
  fillchar(dh,sizeof(dh),0);   fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);   fillchar(hp,sizeof(hp),0);
  fillchar(type_tax,sizeof(type_tax),0);
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
     seek(k003_scr,0);
     read(k003_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         cursor(true,false);
         close(k003_scr);
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
  '8','2',#72,#80:begin      { ArrUp , ArrDn }
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

procedure arctan;
begin
  p:=3.141592654;
  if dx < 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p+a1; end;
    if dy = 0 then az:=3*p/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=2*p-a1; end;
  end;
  if dx = 0 then
  begin
    if dy < 0 then az:=p;
    if dy > 0 then az:=0;
  end;
  if dx > 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p-a1; end;
    if dy = 0 then az:=p/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
  end;
end;

procedure display_data1(l:integer);
begin
  wrt(12,14,15,'     ');  gotoxy(12,14); write(num[l]);
  wrt(19,14,15,'     ');  gotoxy(19,14); write(g[l]:3:2);
  wrt(31,14,15,'     ');  gotoxy(31,14); write(ys[l]:3:2);
  wrt(41,14,15,'      '); gotoxy(41,14); write(z[l]:3:2);
  wrt(52,14,15,'      '); gotoxy(52,14); write(b[l]:3:2);
  wrt(63,14,15,'      ');
end;
procedure display_data2(l:integer);
begin
  wrt(12,14,15,'     ');  gotoxy(12,14); write(num[l]);
  wrt(19,14,15,'     ');  gotoxy(19,14); write(g[l]:3:2);
  wrt(31,14,15,'     ');  wrt(41,14,15,'      ');
  wrt(52,14,15,'      '); gotoxy(52,14); write(b[l]:3:2);
  wrt(63,14,15,'      '); gotoxy(63,14); write(slor[l]:2:3);
end;

procedure inp(l:integer);
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17;
var       j:integer;
begin
i1:    input(buff,4,27,6.1,bit);
       kst:=buff;
i2:    input(buff,4,59,6.1,bit);
       if bit then goto i1 else kaf:=buff;
i3:    input(buff,5,27,5,bit);
       if bit then goto i2 else val(buff,yo,cod);
i4:    input(buff,5,59,7,bit);
       if bit then goto i3 else val(buff,hs,cod);
i5:    input(buff,6,27,11,bit);
       if bit then goto i4 else val(buff,xs,cod);
i6:    input(buff,6,59,11,bit);
       if bit then goto i5 else val(buff,yss,cod);
i7:    input(buff,7,27,11,bit);
       if bit then goto i6 else val(buff,xsa,cod);
i8:    input(buff,7,59,11,bit);
       if bit then goto i7 else val(buff,ysa,cod);
       dx:=xsa-xs; dy:=ysa-yss;
       if ((dx=0) and (dy=0)) then
       begin
         wrt(7,23,112,' ‘„•„!! † €”„’†ˆ€ ’€“’ˆ…„’€ˆ ‹„ ’†Œ ‘’€‘†. €’†‘„ „Œ€ Š†‰’.. ');
         repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
         wrt(7,23,15,'                                                                    ');
         goto i5;
       end;
       arctan;
       pi:=3.141592654; pii:=pi/200; azr:=az; azb:=az/pii;
       m:=0; io:=11;
       repeat
         m:=m+1;
i9:      input(buff,io,11,5.1,bit);
         if bit then goto i9
         else
         begin
           num[m]:=buff;
           if num[m] = '0' then
           begin
             if l < i then
             begin
               wrt(18,23,240,' ‘„•„!! ');
               wrt(30,23,15,'‘“Œ„•ˆ…„ˆ‘ ‚ˆ€ Œ„€ ‘’€‘†; (N/O): ');
               gotoxy(63,23);    read(kbd,cha);
               if cha in ['o','O'] then
               begin
                 wrt(18,23,15,'                                                ');
                 goto i9
               end
               else goto i15;
             end
             else goto i15;
           end;
         end;
i10:     input(buff,io,18,6,bit);
         if bit then goto i9 else val(buff,g[m],cod);
         if g[m] = 999 then
         begin
           swmetr[m]:= true;
i16:       input(buff,io,51,7,bit);
           if bit then goto i10 else val(buff,b[m],cod);
           if ((b[m] < 0) or (b[m] > 400)) then goto i16;
i14:       input(buff,io,62,7,bit);
           if bit then goto i16 else val(buff,slor[m],cod);
           br:=b[m]*pii;
           xp[m]:=xs+slor[m]*sin(br+azr); yp[m]:=yss+slor[m]*cos(br+azr);
         end
         else
         begin
           swmetr[m]:=false;
i11:       input(buff,io,30,6,bit);
           if bit then goto i10 else val(buff,ys[m],cod);
           if ys[m] > 99.99 then goto i11;
i12:       input(buff,io,40,7,bit);
           if bit then goto i11 else val(buff,z[m],cod);
           if ((z[m] < 0)) then goto i12;
i13:       input(buff,io,51,7,bit);
           if bit then goto i12 else val(buff,b[m],cod);
           if ((b[m] > 400) or (b[m] < 0)) then goto i13;
           zr:=z[m]*pii; br:=b[m]*pii; zr:=6.283185307-zr;
           case type_tax of
             1:begin
                 sint:=sqr(sin(zr)); slor[m]:=g[m]*sint;
                 dh[m]:=0.5*g[m]*sin(2*zr)+yo-ys[m];
               end;
             2:begin
                 slor[m]:=g[m]*sin(zr);
                 dh[m]:=g[m]*cos(zr)+yo-ys[m];
               end;
           end;     {  case  }
           xp[m]:=xs+slor[m]*sin(br+azr);
           yp[m]:=yss+slor[m]*cos(br+azr);
           hp[m]:=hs+dh[m];
         end;
         io:=io+1;
         if io = 22 then
         begin
           io:=11;
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           gotoxy(47,2); write(l:1);     gotoxy(28,4); write(kst);
           gotoxy(60,4); write(kaf);     gotoxy(28,5); write(yo:2:2);
           gotoxy(60,5); write(hs:2:2);  gotoxy(28,6); write(xs:2:2);
           gotoxy(60,6); write(yss:2:2); gotoxy(28,7); write(xsa:2:2);
           gotoxy(60,7); write(ysa:2:2);
         end;
i15:   until num[m]='0';
       if l = 1 then
       begin
i17:     wrt(17,23,15,'ƒ—‘„ Œ‹€ €•„ˆ“ ‚ˆ€ ‰€’€•—†‘† ƒ„ƒ‹„Œ—Œ : ');
         input(buff_t,23,62,6.1,bit);
         str(l:2,st);
         st[1]:='0';
         buff_t:=concat(buff_t,st,'.tax');
         assign(file_tax,buff_t);
         {$i-}
         reset(file_tax);
         {$i+}
         ok:=(ioresult=0);
         if ok then
         begin
           wrt(17,23,15,'                                                              ');
           wrt(9,23,15,'O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) : ');
           gotoxy(71,23);    read(kbd,cha);
           if cha in ['O','o','','¦'] then
           begin
             wrt(9,23,15,'                                                                 ');
             goto i17;
           end;
         end;
       end
       else
       begin
         str(l:2,st);
         if l < 10 then st[1]:='0';
         buff_t:=copy(buff_t,1,length(buff_t)-6);
         buff_t:=concat(buff_t,st,'.tax');
         assign(file_tax,buff_t);
       end;
       rewrite(file_tax);
       with rec1_tax do
       begin
         kst_t:=kst; kaf_t:=kaf; yo_t:=yo; hs_t:=hs;
         xs_t:=xs; yss_t:=yss; xsa_t:=xsa; ysa_t:=ysa;
         write(file_tax,rec1_tax);
       end;
       j:=0;
       repeat
         j:=j+1;
         with rec2_tax do
         begin
           num_t:=num[j]; g_t:=g[j]; swmetr_t:=swmetr[j]; ys_t:=ys[j];
           z_t:=z[j]; b_t:=b[j]; slor_t:=slor[j]; dh_t:=dh[j];
           xp_t:=xp[j]; yp_t:=yp[j]; hp_t:=hp[j];
           write(file_tax,rec1_tax);
         end;
       until j = m;
       close(file_tax);
end;

procedure diorth(l:integer);
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i16;
var       j:integer;
begin
       gotoxy(47,5);  write(l:1);     gotoxy(28,7);  write(kst);
       gotoxy(60,7);  write(kaf);     gotoxy(28,8);  write(yo:2:2);
       gotoxy(60,8);  write(hs:2:2);  gotoxy(28,9);  write(xs:2:2);
       gotoxy(60,9);  write(yss:2:2); gotoxy(28,10); write(xsa:2:2);
       gotoxy(60,10); write(ysa:2:2);
i1:    input(buff,7,27,6.1,bit);
       kst:=buff;
i2:    input(buff,7,59,6.1,bit);
       if bit then goto i1 else kaf:=buff;
i3:    input(buff,8,27,5,bit);
       if bit then goto i2 else val(buff,yo,cod);
i4:    input(buff,8,59,7,bit);
       if bit then goto i3 else val(buff,hs,cod);
i5:    input(buff,9,27,11,bit);
       if bit then goto i4 else val(buff,xs,cod);
i6:    input(buff,9,59,11,bit);
       if bit then goto i5 else val(buff,yss,cod);
i7:    input(buff,10,27,11,bit);
       if bit then goto i6 else val(buff,xsa,cod);
i8:    input(buff,10,59,11,bit);
       if bit then goto i7 else val(buff,ysa,cod);
       dx:=xsa-xs;
       dy:=ysa-yss;
       if ((dx=0) and (dy=0)) then
       begin
         wrt(7,23,112,' ‘„•„!! † €”„’†ˆ€ ’€“’ˆ…„’€ˆ ‹„ ’†Œ ‘’€‘†. €’†‘„ „Œ€ Š†‰’.. ');
         repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
         wrt(7,23,15,'                                                                    ');
         goto i5;
       end;
       arctan;
       pi:=3.141592654; pii:=pi/200; azr:=az; azb:=az/pii;
       m:=1;
       while m < metr_diorth do
       begin
         case swmetr[m] of
           true  : display_data2(m);
           false : display_data1(m);
         end;
i9:      input(buff,14,11,5.1,bit);
         if bit then
           if m = 1 then goto i8
           else
           begin
             m:=pred(m);
             case swmetr[m] of
                true : display_data2(m);
               false : display_data1(m);
             end;
             goto i10;
           end
         else num[m]:=buff;
i10:     input(buff,14,18,6,bit);
         if bit then goto i9 else val(buff,g[m],cod);
         if g[m] = 999 then
         begin
           swmetr[m]:= true;
i16:       input(buff,14,51,7,bit);
           if bit then goto i10 else val(buff,b[m],cod);
           if ((b[m] < 0) or (b[m] > 200)) then goto i16;
i14:       input(buff,14,62,7,bit);
           if bit then goto i16 else val(buff,slor[m],cod);
           br:=b[m]*pii;
           xp[m]:=xs+slor[m]*sin(br+azr); yp[m]:=yss+slor[m]*cos(br+azr);
         end
         else
         begin
           swmetr[m]:=false;
i11:       input(buff,14,30,6,bit);
           if bit then goto i10 else val(buff,ys[m],cod);
           if ys[m] > 99.99 then goto i11;
i12:       input(buff,14,40,7,bit);
           if bit then goto i11 else val(buff,z[m],cod);
           if ((z[m] > 200) or (z[m] < 0)) then goto i12;
i13:       input(buff,14,51,7,bit);
           if bit then goto i12 else val(buff,b[m],cod);
           if ((b[m] > 400) or (b[m] < 0)) then goto i13;
           zr:=z[m]*pii; br:=b[m]*pii;
           case type_tax of
             1:begin
                 sint:=sqr(sin(zr)); slor[m]:=g[m]*sint;
                 dh[m]:=0.5*g[m]*sin(2*zr)+yo-ys[m];
               end;
             2:begin
                 slor[m]:=g[m]*sin(zr);
                 dh[m]:=g[m]*cos(zr)+yo-ys[m];
               end;
           end;  { case }
           xp[m]:=xs+slor[m]*sin(br+azr);
           yp[m]:=yss+slor[m]*cos(br+azr);
           hp[m]:=hs+dh[m];
         end;
         m:=m+1;
       end;
       rewrite(file_tax);
       with rec1_tax do
       begin
         kst_t:=kst; kaf_t:=kaf; yo_t:=yo; hs_t:=hs;
         xs_t:=xs; yss_t:=yss; xsa_t:=xsa; ysa_t:=ysa;
         write(file_tax,rec1_tax);
       end;
       j:=0;
       repeat
         j:=j+1;
         with rec2_tax do
         begin
           num_t:=num[j]; g_t:=g[j]; swmetr_t:=swmetr[j]; ys_t:=ys[j];
           z_t:=z[j]; b_t:=b[j]; slor_t:=slor[j]; dh_t:=dh[j];
           xp_t:=xp[j]; yp_t:=yp[j]; hp_t:=hp[j];
           write(file_tax,rec1_tax);
         end;
       until j = m;
       close(file_tax);
end;

procedure input_results_in_file(k,j:integer);
var       l:integer;
begin
     writeln(fill,'=============================================================================');
     writeln(fill,'      ’      €      •      “      ‹      „      ’            ˆ      € ');
     writeln(fill,'=============================================================================');
     writeln(fill);
     writeln(fill,'   ’ˆ’Š‘ „‚€‘ˆ€‘: ',onerg);
     writeln(fill,'   Š†‡‘ ‘’€‘„—Œ : ',i:3,'       ‹„’†‘„ˆ‘ ‹„: ',string_t);
     writeln(fill);
     writeln(fill,'                             ‘  ’  €  ‘  † : ',j:1);
     writeln(fill,'     ‰—ƒˆ‰‘ ‘’€‘†‘:     ',kst,' ':6-length(kst),' ':8,'‰—ƒˆ‰‘ €”„’†ˆ€‘:',' ':6,kaf);
     writeln(fill,'       “–‘ ‚€Œ“:     ',yo:5:2,' ':15,'“–‘ ‘’€‘†‘:   ',hs:8:3);
     writeln(fill,'           • ‘’€‘†‘:',xs:10:2,' ':18,'“ ‘’€‘†‘:',yss:11:2);
     writeln(fill,'        • €”„’†ˆ€‘:',xsa:10:2,' ':15,'Y €”„’†ˆ€‘:',ysa:11:2);
     writeln(fill);
     writeln(fill,' A/A     G     “‘     Z      B     S¦¨    DH       X          Y         H');
     writeln(fill,'-----  ----- ----- ------ ------ ------ ----- ---------- ----------- --------');
     for l:=1 to k do
     begin
       case swmetr[l] of
         false : writeln(fill,num[l],' ':6-length(num[l]),' ',g[l]:5:2,' ',
                         ys[l]:5:2,' ',z[l]:6:2,' ',b[l]:6:2,' ',slor[l]:6:3,
                         ' ',dh[l]:5:2,' ',xp[l]:10:3,' ',yp[l]:11:3,' ',hp[l]:8:3);
          true : writeln(fill,num[l],' ':6-length(num[l]),' ',g[l]:5:2,' ':14,
                         slor[l]:6:3,' ':7,xp[l]:10:3,' ',yp[l]:11:3);
       end;
     end;
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(12,grammi); write(num[k]); gotoxy(21,grammi); write(slor[k]:6:3);
  case swmetr[k] of
    false : begin gotoxy(29,grammi); write(dh[k]:5:2); end;
  end;
  gotoxy(38,grammi); write(xp[k]:10:3); gotoxy(51,grammi); write(yp[k]:11:3);
  case swmetr[k] of
    false : begin gotoxy(64,grammi); write(hp[k]:8:3); end;
  end;
end;

procedure write_screen(m,j:integer; var scr_line,k1:integer);
var k:integer;
begin
  clrscr;
  seek(k003_scr,4);    read(k003_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  gotoxy(47,4);    write(j:2);
  scr_line:=8;
  for k:=1 to m do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 22 then
    begin
      wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      gotoxy(47,4);    write(j:2);
      scr_line:=8;
    end;
  end;
  wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef(jepik:integer);
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
  writeln(fill,'=============================================================================');
  writeln(fill,'      ’      €      •      “      ‹      „      ’            ˆ      € ');
  writeln(fill,'=============================================================================');
  writeln(fill);
  writeln(fill,'   ’ˆ’Š‘ „‚€‘ˆ€‘: ',onerg);
  writeln(fill,'   Š†‡‘ ‘’€‘„—Œ : ',i:3,'       ‹„’†‘„ˆ‘ ‹„: ',string_t);
  writeln(fill);
  writeln(fill,'                             ‘  ’  €  ‘  † : ',jepik:1);
  writeln(fill,'     ‰—ƒˆ‰‘ ‘’€‘†‘:     ',kst,' ':6-length(kst),' ':8,'‰—ƒˆ‰‘ €”„’†ˆ€‘:',' ':6,kaf);
  writeln(fill,'       “–‘ ‚€Œ“:     ',yo:5:2,' ':15,'“–‘ ‘’€‘†‘:   ',hs:8:3);
  writeln(fill,'           • ‘’€‘†‘:',xs:10:2,' ':18,'“ ‘’€‘†‘:',yss:11:2);
  writeln(fill,'        • €”„’†ˆ€‘:',xsa:10:2,' ':15,'Y €”„’†ˆ€‘:',ysa:11:2);
  writeln(fill);
  writeln(fill,' A/A     G     “‘     Z      B     S¦¨    DH       X          Y         H');
  writeln(fill,'-----  ----- ----- ------ ------ ------ ----- ---------- ----------- --------');
end;

procedure lprint(k,j:integer);
var       l:integer;
begin
  epikef(j);
  gram:=18;
  for l:=1 to k do
  begin
    writeln(fill);
    case swmetr[l] of
      false : writeln(fill,num[l],' ':6-length(num[l]),' ',g[l]:5:2,' ',
                      ys[l]:5:2,' ',z[l]:6:2,' ',b[l]:6:2,' ',slor[l]:6:3,
                      ' ',dh[l]:5:2,' ',xp[l]:10:3,' ',yp[l]:11:3,' ',hp[l]:8:3);
       true : writeln(fill,num[l],' ':6-length(num[l]),' ',g[l]:5:2,' ':14,
                      slor[l]:6:3,' ':7,xp[l]:10:3,' ',yp[l]:11:3);
    end;
    gram:=gram+2;
    if gram >= ar_gram-2 then
    begin
      writeln(fill); writeln(fill); writeln(fill); sel:=sel+1;
      writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1); writeln(fill); writeln(fill);
      writeln(fill,' A/A     G     “‘     Z      B      S     DH       X          Y         H');
      writeln(fill,'-----  ----- ----- ------ ------ ------ ----- ---------- ----------- --------');
      gram:=6;
    end;
  end;
end;

procedure write_file_plotter(l:integer);
var       j:integer;
begin
    j:=0;
    repeat
      j:=j+1;
      with rec_plot do
      begin
        case swmetr[j] of
          false:begin
                  num_p:=num[j]; xp_p:=xp[j]; yp_p:=yp[j]; hp_p:=hp[j];
                  write(file_plot,rec_plot);
                end;
           true:begin
                  num_p:=num[j]; xp_p:=xp[j]; yp_p:=yp[j]; hp_p:=0;
                  write(file_plot,rec_plot);
                end;
        end;  { case }
      end;
    until j=l;
end;

procedure read_all_files;
var       j,m:integer;
begin
    buff_t:=copy(buff_t,1,length(buff_t) - 6);
    buff_t:=concat(buff_t,'00.tax');
    assign(file_tax,buff_t);
    reset(file_tax);
    read(file_tax,rec1_tax);
    with rec0_tax do
    begin
      i:=i_t;
      type_tax:=type_tax_t;
    end;
    close(file_tax);
    j:=0;
    repeat
      j:=j+1;
      str(j:2,st);
      if j < 10 then st[1]:='0';
      buff_t:=copy(buff_t,1,length(buff_t) - 6);
      buff_t:=concat(buff_t,st,'.tax');
      assign(file_tax,buff_t);
      reset(file_tax);
      seek(file_tax,0);
      read(file_tax,rec1_tax);
      with rec1_tax do
      begin
        kst:=kst_t; kaf:=kaf_t; yo:=yo_t; hs:=hs_t;
        xs:=xs_t; yss:=yss_t; xsa:=xsa_t; ysa:=ysa_t;
      end;
      m:=0;
      repeat
        m:=m+1;
        read(file_tax,rec1_tax);
        with rec2_tax do
        begin
          num[m]:=num_t; g[m]:=g_t; swmetr[m]:=swmetr_t; ys[m]:=ys_t;
          z[m]:=z_t; b[m]:=b_t; slor[m]:=slor_t; dh[m]:=dh_t;
          xp[m]:=xp_t; yp[m]:=yp_t; hp[m]:=hp_t;
        end;
      until eof(file_tax);
      close(file_tax);
      case sw_read_file of
        2 : write_file_plotter(m-1);
        5 : input_results_in_file(m-1,j);
        6 : begin write(fill,#12); lprint(m-1,j); end;
        7 : begin scr_line1:=8; k1:=1; write_screen(m-1,j,scr_line1,k1); end;
      end;
    until j=i;
end;

procedure read_file_tax;
begin
    reset(file_tax);
    seek(file_tax,0);
    read(file_tax,rec1_tax);
    with rec1_tax do
    begin
      kst:=kst_t; kaf:=kaf_t; yo:=yo_t; hs:=hs_t;
      xs:=xs_t; yss:=yss_t; xsa:=xsa_t; ysa:=ysa_t;
    end;
    l:=0;
    repeat
      l:=l+1;
      read(file_tax,rec1_tax);
      with rec2_tax do
      begin
        num[l]:=num_t; g[l]:=g_t; swmetr[l]:=swmetr_t; ys[l]:=ys_t;
        z[l]:=z_t; b[l]:=b_t; slor[l]:=slor_t; dh[l]:=dh_t;
        xp[l]:=xp_t; yp[l]:=yp_t; hp[l]:=hp_t;
      end;
    until eof(file_tax);
    close(file_tax);
    metr_diorth:=l;
end;

function paint:byte;
label    p5;
var      deikp,rowp,colp,ip:byte;
         ch:char;
procedure paint_line(cap,ctp,att:byte);
var       colsp:byte;
begin colsp:=ctp-cap+1; wrt(cap,14,att,chr(colsp)); end;
begin
     deikp:=1;     colp:=24;
     paint_line(24,31,112);
p5:  read(kbd,ch);
     if ch in [#13,#10] then begin paint:=deikp; exit; end;
     if ((ch = #27) and keypressed) or (ch in ['4','6']) then
     begin
       if ch = #27 then read(kbd,ch);
       case ch of
         '4','6',#75,#77:begin
                          paint_line(colp,colp+7,15);
                          if colp=24 then colp:=34 else colp:=24;
                          paint_line(colp,colp+7,112);
                          deikp:=1;
                          if colp=34 then deikp:=deikp+1;
                        end;
         else for ip:=3 to 6 do beep(ip*500,50);
       end;  { case }
     end  { if }
     else for ip:=3 to 6 do beep(ip*500,50);
     goto p5;
end;

procedure epex_menu;
var  j,k:byte;
     ok :boolean;
label    e5,e6,10,25,e30;
begin
     case menu of
        1:begin
            if (sw1=1) or (sw3=1) then epex_menu;
            clrscr;
            cursor(true,false);
            seek(k003_scr,1);     read(k003_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
e5:         input(buff,10,22,53.1,bit);
            onerg:=buff;
e6:         input(buff,12,22,3,bit);
            if bit then goto e5 else val(buff,i,cod);
            if not (i in [1..99]) then goto e6;
            cursor(false,true);
            case paint of
              1: begin type_tax:=1; string_t:='‘’€ƒˆ€'; end;
              2: begin type_tax:=2; string_t:=' E.D.M'; end;
            end;
            cursor(true,false);
            seek(k003_scr,2); read(k003_scr,rec1);
            j:=0;
            repeat
              j:=j+1;
              move(rec1.xx[0],mem[$b000:ofs1],3680);
              gotoxy(47,2); write(j:1);
              inp(j);
            until j = i;
            buff_t:=copy(buff_t,1,length(buff_t)-6);
            buff_t:=concat(buff_t,'00.tax');
            assign(file_tax,buff_t);
            rewrite(file_tax);
            with rec0_tax do
            begin
              onerg_t:=onerg; i_t:=i; type_tax_t:=type_tax;
              write(file_tax,rec1_tax);
            end;
            close(file_tax);
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
              assign(file_plot,name);
              {$i-}
              reset(file_plot);
              {$i+}
              ok:=(ioresult=0);
              if ok then
              begin
                gotoxy(2,23);
                write('‘„•„ ! ’ €•„ˆ €“’ “€•„ˆ. Œ€ ‚€–— „€Œ— ’“; (Œ/) : ');
                read(kbd,cha);
                if cha in ['O','o','','¦'] then
                begin
                  cursor(false,true);
                  epex_menu;
                end;
              end;
              clrscr;
              cursor(false,true);
              wrt(11,12,240,'  ‰ € ’ € • —  —   ƒ „ ƒ  ‹ „ Œ €   ‘ „   €  • „ ˆ   ');
              assign(file_plot,name);
              rewrite(file_plot);
              sw_read_file:=2;
              read_all_files;
              sw_read_file:=0;
              close(file_plot);
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ƒEN EKANE‘ EI‘A‚—‚H ƒEƒOMEN—N.  €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
            epex_menu;
          end;
        3:begin
            cursor(true,false);
            wrt_screen(OthInp,1,20,80,22);
            gotoxy(13,21); read(buff_t);
            buff_t:=concat(buff_t,'00.tax');
            assign(file_tax,buff_t);
            {$i-}
            reset(file_tax);
            {$i+}
            ok:=(ioresult=0);
            if not ok then
            begin
              cursor(false,true); gotoxy(8,23);
              write('  O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              epex_menu;
            end
            else
            begin
              read(file_tax,rec1_tax);
              with rec0_tax do
              begin onerg:=onerg_t; i:=i_t; type_tax:=type_tax_t; end;
              close(file_tax);
              case type_tax of
                1 : string_t:='‘’€ƒˆ€';
                2 : string_t:=' E.D.M';
              end;
              sw3:=1;
              cursor(false,true);
              epex_menu;
            end;
          end;
        4:begin
            if ((sw1 <> 1) and (sw3 <> 1)) then
            begin
              wrt(19,21,240,'  ƒEN EX— ƒEƒOMENA. €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            cursor(true,false);
e30:        wrt(30,21,15,'ƒ—‘„ €ˆ‡‹ ‘’€‘†‘: ');
            input(buff,21,49,3,bit); val(buff,l,cod);
            if not (l in [1..99]) then goto e30;
            str(l:2,st);
            if l < 10 then st[1]:='0';
            buff_t:=copy(buff_t,1,length(buff_t)-6);
            buff_t:=concat(buff_t,st,'.tax');
            assign(file_tax,buff_t);
            {$i-}
            reset(file_tax);
            {$i+}
            ok:=(ioresult=0);
            if not ok then goto 10;
            read_file_tax;
            seek(k003_scr,3);    read(k003_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            val(st,l,cod);
            diorth(l);
            sw4:=1;
10:         cursor(false,true);
            clrscr;
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
                write('O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) : ');
                read(kbd,cha);
                if cha in ['O','o','','¦'] then
                begin
                  cursor(false,true);
                  epex_menu;
                end;
              end;
              clrscr;
              cursor(false,true);
              wrt(11,12,240,'  ‚  € ” —   €   ’ „ Š „ ‘ ‹ € ’ €   ‘ „   €  • „ ˆ   ');
              rewrite(fill);
              sw_read_file:=5;
              read_all_files;
              sw_read_file:=0;
              close(fill);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(19,21,240,'  ƒEN EX— ƒEƒOMENA. ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
        6:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
25:           wrt_screen(OthPrint,1,4,45,17);
              gotoxy(32,13); read(ar_gram);
              if ad then goto 25;
              cursor(false,true);
              wrt(3,15,15,'„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘');
              wrt(10,16,15,'€’†‘„ RETURN ‚ˆ€ „‰’“—‘†..');
              repeat read(kbd,cha) until cha in [#10,#13];
              assign(fill,'prn');
              rewrite(fill);
              write(fill,#27,#67,chr(ar_gram));
              clrscr;
              wrt(26,12,240,'   „  ‰  ’  “    —  Œ  —..   ');
              sw_read_file:=6;
              read_all_files;
              write(fill,#12);
              close(fill);
              sw_read_file:=0;
              sel:=0;
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(19,21,240,'  ƒEN EX— ƒEƒOMENA. ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
        7:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              cursor(false,true);
              sw_read_file:=7;
              read_all_files;
              sw_read_file:=0;
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(19,21,240,'  ƒEN EX— ƒEƒOMENA. ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
     end; { case }
end; { procedure }

BEGIN
clrscr;
ofs1:=$8000;
if mem[0:1040] and 48 = 48 then ofs1:=$0000;
assign(k003_scr,'TAX.SCR');
reset(k003_scr);
seek(k003_scr,5); read(k003_scr,rec1);
for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
delete_all_input;
sw1:=0; sw3:=0; sw4:=0; i:=0; sel:=0; gram:=0;
cursor(false,true);
epex_menu;
END.

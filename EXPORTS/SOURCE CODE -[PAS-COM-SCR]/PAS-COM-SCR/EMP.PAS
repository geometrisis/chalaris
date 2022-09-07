{******************************************************************************
*                   k013 ÕĞÏËÏÃÉÓÌÏÓ ÅÌĞÑÏÈÏÔÏÌÉÁÓ                        *
*                  WRITTEN BY G.XALARIS                         *
*                              19-12-1986                                     *
*******************************************************************************}
program  k013;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k013=record
           kwd_e :string[5];
           xa_e,ya_e,xb_e,yb_e,a_e,b_e:real;
         end;
         string40 =string[40];
         string255=string[255];

var      xa,ya,xb,yb,a,b,xm,ym:array [1..500] of real;
         kwd:array [1..500] of string[5];
         flag1,FLAG2:array [1..500] of byte;
         OthInp,OthPrint:array[1..3680] of byte;
         dx,dy,pii,ag,bg,aab,aba,sab,syn,sam,sbm,
         aam,abm,xm1,ym1,xm2,ym2,p,a1,az        :real;

         k013_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f   :text;
         b1_e:string[11];
         b2_e:string[12];
         b3_e:string[11];
         b4_e:string[12];
         b5_e:string[5];
         b6_e:string[8];
         b7_e:string[8];

         in_k013 :file of rec1_k013;
         in1_rec :rec1_k013;
         sw1,sw3,sw4:byte;
         cha:char;
         sel,gram:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
  fillchar(xa,sizeof(xa),0);       fillchar(ya,sizeof(ya),0);
  fillchar(xb,sizeof(xb),0);       fillchar(yb,sizeof(yb),0);
  fillchar(a,sizeof(a),0);         fillchar(flag1,sizeof(flag1),0);
  fillchar(flag2,sizeof(flag2),0); fillchar(b,sizeof(b),0);
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
            rows:=rt-ra+1;
            cols:=ct-ca+1;
            for i:=1 to rows do
              wrt(ca,i+ra-1,att,chr(cols));
          end;
begin
     seek(k013_scr,0);     read(k013_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k013_scr);
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
                    close(k013_scr);
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

procedure epex(j:byte);
begin
  dx:=xb[j] - xa[j];
  dy:=yb[j] - ya[j];
  if (dx = 0) and (dy = 0) then exit;
  ag:=a[j] * pii;
  bg:=b[j] * pii;
  arctan;
  aab:=az;
  aba:=aab + (200 * pii);
  sab:=sqrt(sqr(dx) + sqr(dy));
  syn:=sab / sin(ag + bg);
  sam:=syn * sin(bg);
  sbm:=syn * sin(ag);
  aam:=aab - ag;
  abm:=aba + bg;
  xm1:=xa[j] + sam * sin(aam);
  xm2:=xb[j] + sbm * sin(abm);
  ym1:=ya[j] + sam * cos(aam);
  ym2:=yb[j] + sbm * cos(abm);
  if (abs(xm1 - xm2) > 1) then flag1[j]:=1;
  if (abs(ym1 - ym2) > 1) then flag2[j]:=1;
  xm[j]:=(xm1 + xm2) / 2;
  ym[j]:=(ym1 + ym2) / 2;
end;

procedure display_data(j:byte);
begin
  wrt(14,7,15,'          ');  gotoxy(14,7);  write(xa[j]:4:3);
  wrt(27,7,15,'           '); gotoxy(27,7);  write(ya[j]:4:3);
  wrt(40,7,15,'          ');  gotoxy(40,7);  write(xb[j]:4:3);
  wrt(53,7,15,'           '); gotoxy(53,7);  write(yb[j]:4:3);
  wrt(24,13,15,'     ');      gotoxy(24,13); write(kwd[j]);
  wrt(35,13,15,'        ');   gotoxy(35,13); write(a[j]:4:4);
  wrt(48,13,15,'        ');   gotoxy(48,13); write(b[j]:4:4);
end;

procedure inp;
label     i1,i2,i5,i6,i7,i8,i9;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,7,13,11,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l);
           goto i9;
         end
         else begin end
       else val(buff,xa[l],cod);
i2:    input(buff,7,26,12,bit);
       if bit then goto i1 else val(buff,ya[l],cod);
i5:    input(buff,7,39,11,bit);
       if bit then goto i2 else val(buff,xb[l],cod);
i6:    input(buff,7,52,12,bit);
       if bit then goto i5 else val(buff,yb[l],cod);
       dx:=xb[l]-xa[l]; dy:=yb[l]-ya[l];
       if (dx = 0) and (dy = 0) then
       begin
         wrt(27,22,112,' ‘„•„!! ’€ ‘†‹„ˆ€ ’€“’ˆ…Œ’€ˆ. €’†‘„ „Œ€ Š†‰’.. ');
         repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
         wrt(27,22,15,'                                                       ');
         goto i5;
       end;
i7:    input(buff,13,23,6.1,bit);
       if bit then goto i6 else kwd[l]:=buff;
i8:    input(buff,13,34,9,bit);
       if bit then goto i7 else val(buff,a[l],cod);
i9:    input(buff,13,47,9,bit);
       if bit then goto i8 else val(buff,b[l],cod);
       epex(l);
       l:=succ(l);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
     end;
end;

procedure input_results_in_file;
var       k:integer;
begin
  rewrite(fill);
  writeln(fill,'    ==============================================');
  writeln(fill,'          “Š‚ˆ‘‹‘  €Š†‘  „‹‘‡’‹ˆ€‘');
  writeln(fill,'    ==============================================');
  writeln(fill,'     ‰—ƒˆ‰‘         ’„’‹†‹„Œ†         ’„’€‚‹„Œ†');
  writeln(fill,'    „‹/‹ˆ€‘         ‘†‹„ˆ“           ‘†‹„ˆ“');
  writeln(fill,'    ---------      ------------      -------------');
  for k:=1 to i do {  *****        * **********      * ***********   }
  begin
    write(fill,' ':6,kwd[k],' ':8);
    if flag1[k] = 1 then write(fill,'*') else write(fill,'  ');
    write(fill,xm[k]:10:3,' ':6);
    if flag2[k] = 1 then write(fill,'*') else write(fill,'  ');
    writeln(fill,ym[k]:11:3);
  end;
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
    gotoxy(24,grammi);    write(kwd[k]);
    if flag1[k] = 1 then
    begin
      wrt(32,grammi,15,'*'); wrt(27,22,15,'* : ‘­˜¢£˜ ©«¦¤ ¬§¦¢¦š ©£¦');
    end;
    gotoxy(35,grammi);    write(xm[k]:10:3);
    if flag2[k] = 1 then
    begin
      wrt(46,grammi,15,'*'); wrt(27,22,15,'* : ‘­˜¢£˜ ©«¦¤ ¬§¦¢¦š ©£¦');
    end;
    gotoxy(48,grammi);    write(ym[k]:11:3);
end;

procedure write_screen(m,scr_line:integer);
var       k:integer;
begin
  clrscr;
  seek(k013_scr,2);    read(k013_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to m do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 21 then
    begin
      wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=7;
    end;
  end;
  if m < 22 then
  begin
    wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  if scr_line = 7 then exit;
  wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill,'    ==============================================');
  writeln(fill,'          “Š‚ˆ‘‹‘  €Š†‘  „‹‘‡’‹ˆ€‘');
  writeln(fill,'    ==============================================');
  writeln(fill,'     ‰—ƒˆ‰‘         ’„’‹†‹„Œ†         ’„’€‚‹„Œ†');
  writeln(fill,'    „‹/‹ˆ€‘         ‘†‹„ˆ“           ‘†‹„ˆ“');
  writeln(fill,'    ---------      ------------      -------------');
end;

procedure lprint;
var       sel,gram,k,sw_prn:integer;
begin
  rewrite(fill);
  sw_prn:=0;
  epikef;
  gram:=8;
  for k:=1 to i do
  begin
    writeln(fill);
    write(fill,' ':6,kwd[k],' ':8);
    if flag1[k] = 1 then
    begin
      write(fill,'*');
      sw_prn:=1;
    end
    else write(fill,'  ');
    write(fill,xm[k]:10:3,' ':6);
    if flag2[k] = 1 then
    begin
      write(fill,'*');
      sw_prn:=1;
    end
    else write(fill,'  ');
    writeln(fill,ym[k]:11:3);
    gram:=gram + 2;
    if gram >= ar_gram - 4 then
    begin
      writeln(fill);
      if sw_prn = 1 then
        writeln(fill,'                          * : ‘­˜¢£˜ ©«¦¤ ¬§¦¢¦š ©£¦')
      else
        writeln(fill);
      writeln(fill);
      writeln(fill);
      sw_prn:=0;
      epikef;
      gram:=8;
    end;
  end;
  if sw_prn = 1 then
    writeln(fill,'                          * : ‘­˜¢£˜ ©«¦¤ ¬§¦¢¦š ©£¦');
  sw_prn:=0;
  close(fill);
end;

procedure epex_menu;
var       j,k,metr:byte;
          ok :boolean;
label     e1,10,15,25;
begin
     case menu of
        1:begin
            if (sw1 = 1) or (sw3 = 1) then epex_menu;
15:         gotoxy(22,21);
            cursor(true,false);
            write('ƒ—‘„ ‘“ŒŠˆ‰ €ˆ‡‹ “Š‚ˆ‘‹—Œ : ');
            read(i);
            if ad then goto 15;
            clrscr;
            seek(k013_scr,1);    read(k013_scr,rec1);
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
              WRT_SCREEN(OthInp,1,20,80,22);
              gotoxy(13,21); read(name);
              assign(in_k013,name);
              {$i-}
              reset(in_k013);
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
              rewrite(in_k013);
              j:=0;
              repeat
                j:=j+1;
                with in1_rec do
                begin
                  xa_e:=xa[j];    ya_e:=ya[j];
                  xb_e:=xb[j];    yb_e:=yb[j];
                  a_e:=a[j];    b_e:=b[j];
                  kwd_e:=kwd[j];
                end;
                write(in_k013,in1_rec);
              until j = i;
              close(in_k013);
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
            WRT_SCREEN(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k013,filename);
              {$i-}
              reset(in_k013);
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
              for metr:=1 to 500 do
              begin
                flag1[metr]:=0;    flag2[metr]:=0;
              end;
              reset(in_k013);
              seek(in_k013,0);
              j:=0;
              repeat
                j:=j+1;
                read(in_k013,in1_rec);
                with in1_rec do
                begin
                  xa[j]:=xa_e; ya[j]:=ya_e;
                  xb[j]:=xb_e; yb[j]:=yb_e;
                  a[j]:=a_e; b[j]:=b_e;
                  kwd[j]:=kwd_e;
                end;
                epex(j);
              until eof(in_k013);
              i:=j;
              close(in_k013);
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
                write('O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                cursor(false,true);
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              for metr:=1 to 500 do
              begin
                flag1[metr]:=0;    flag2[metr]:=0;
              end;
              wrt(22,12,240,'ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..');
              reset(f);
              j:=0;
              repeat
                j:=j+1;
                readln(f,b1_e);    val(b1_e,xa[j],cod);
                readln(f,b2_e);    val(b2_e,ya[j],cod);
                readln(f,b3_e);    val(b3_e,xb[j],cod);
                readln(f,b4_e);    val(b4_e,yb[j],cod);
                readln(f,b5_e);    kwd[j]:=b5_e;
                readln(f,b6_e);    val(b6_e,a[j],cod);
                readln(f,b7_e);    val(b7_e,b[j],cod);
                epex(j);
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
              wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  €’†‘„ „Œ€ Š†‰’..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            sw4:=1;
            seek(k013_scr,3);    read(k013_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            for metr:=1 to 500 do
            begin
              flag1[metr]:=0;    flag2[metr]:=0;
            end;
            inp;
            repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            cursor(false,true);
10:         clrscr;
            epex_menu;
          end;
        5:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              WRT_SCREEN(OthInp,1,20,80,22);
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
              input_results_in_file;
e1:           cursor(false,true);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              cursor(false,true);
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
              gotoxy(3,15); write('„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘');
              gotoxy(10,16); write('€’†‘„ RETURN ‚ˆ€ „‰’“—‘†..');
              repeat read(kbd,cha) until cha in [#10,#13];
              cursor(false,true);
              assign(fill,'prn');
              clrscr;
              wrt(29,12,240,'„  ‰  ’  “    —  Œ  —..');
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
              cursor(false,true);
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
              cursor(false,true);
              epex_menu;
            end;
          end;
     end; { case }
end; { procedure }

BEGIN
clrscr;
ofs1:=$8000;
if mem[0:1040] and 48 = 48 then ofs1:=$0000;
assign(k013_scr,'EMP.SCR');
reset(k013_scr);
seek(k013_scr,4); read(k013_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
pii:=arctan(1) * 4 / 200;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

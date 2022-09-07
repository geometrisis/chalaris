{******************************************************************************
*      k053 ÕĞÏËÏÃÉÓÌÏÓ ÕØÏÌÅÔÑÙÍ ÌÅ ÁĞËÅÓ Ç ÁÌÏÉÂÁÉÅÓ ÊÁÔÁÊÏÑÕÖÅÓ ÃÙÍÉÅÓ *
*                  WRITTEN BY G.XALARIS                        *
*                              25-08-1987                                     *
*******************************************************************************}
program  k053;

type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k053=record
           kwd1_o:string[4];
           kwd2_o:string[4];
           x1_o,y1_o,x2_o,y2_o,z1_o,z2_o,h1_o,ys_o,yo_o,ys2_o,yo2_o:real;
         end;
         string40 =string[40];
         string255=string[255];

var      x1,y1,x2,y2,z1,z2,h1,
         ys,yo,ys2,yo2,h2,d1,d2:array [1..500] of real;
         kwd1,kwd2             :array [1..500] of string[4];
         inop                  :array [1..500] of boolean;
         dx,dy,z1r,z2r,zzr,pi,sd,
         r,sftana,dhtel1,
         dhtel2,dhtel3,dhtel,
         dhprov,dhprovdd       :real;
         OthInp,OthPrint:array[1..3680] of byte;
         k053_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;
         f                          :text;
         b1_o,b2_o,b3_o,b4_o,b5_o,
         b6_o,b7_o,b8_o,b9_o,b10_o,
         b11_o,b12_o,b13_o          :string[13];

         in_k053 :file of rec1_k053;
         in1_rec :rec1_k053;

         sw1     :byte;
         sw3     :byte;
         sw4     :byte;
         cha     :char;

         sel     :integer;
         gram    :integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
    fillchar(kwd1,sizeof(kwd1),' ');
    fillchar(x1,sizeof(x1),0);
    fillchar(y1,sizeof(y1),0);
    fillchar(kwd2,sizeof(kwd2),' ');
    fillchar(x2,sizeof(x2),0);
    fillchar(y2,sizeof(y2),0);
    fillchar(z1,sizeof(z1),0);
    fillchar(z2,sizeof(z2),0);
    fillchar(h1,sizeof(h1),0);
    fillchar(ys,sizeof(ys),0);
    fillchar(yo,sizeof(yo),0);
    fillchar(ys2,sizeof(ys2),0);
    fillchar(yo2,sizeof(yo2),0);
    fillchar(h2,sizeof(h2),0);
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
     seek(k053_scr,0);     read(k053_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k053_scr);
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
                    close(k053_scr);
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

procedure epex(j:integer);
begin
    pi:=arctan(1) * 4;
    z1r:=z1[j]*pi/200;
    z2r:=z2[j]*pi/200;
    dx:=x2[j]-x1[j];
    dy:=y2[j]-y1[j];
    sd:=sqrt(sqr(dx)+sqr(dy));
    if (inop[j] = false) then
    begin
      d2[j]:=(ys2[j]-yo2[j])*sin(z2r)*636620.0/sd;
      d2[j]:=(d2[j]/10000.0)*pi/200.0;
      z2r:=z2r+d2[j];
    end;
    r:=6373882.0;
    d1[j]:=(ys[j]-yo[j])*sin(z1r)*636620.0/sd;
    d1[j]:=(d1[j]/10000)*pi/200.0;
    z1r:=z1r+d1[j];
    if (inop[j] = true) then
    begin
      ys2[j]:=0;
      yo2[j]:=0;
      sftana:=1/(sin(z1r)/cos(z1r));
      dhtel1:=sd*sftana;
      dhtel2:=(yo[j]-ys[j]);
      dhtel3:=(0.87/(2*r))*sqr(sd);
      dhtel:=dhtel1+dhtel2+dhtel3;
    end
    else
    begin
      zzr:=(z2r-z1r) ;
      dhprov:=sd*(sin(zzr)/cos(zzr))/2*(1+(h1[j]/r));
      dhprovdd:=1+dhprov/(2*r);
      dhtel:=dhprov*dhprovdd;
    end;
    h2[j]:=h1[j]+dhtel;
end;

procedure display_data(j:byte);
begin
  wrt(7,7,15,'    ');
  gotoxy(7,7);    write(kwd1[j]);
  wrt(14,7,15,'          ');
  gotoxy(14,7);    write(x1[j]:3:3);
  wrt(27,7,15,'           ');
  gotoxy(27,7);    write(y1[j]:3:3);
  wrt(43,7,15,'    ');
  gotoxy(43,7);    write(kwd2[j]);
  wrt(50,7,15,'          ');
  gotoxy(50,7);    write(x2[j]:3:3);
  wrt(64,7,15,'           ');
  gotoxy(64,7);    write(y2[j]:3:3);
  wrt(18,10,15,'        ');
  gotoxy(18,10);    write(z1[j]:5:4);
  wrt(54,10,15,'        ');
  gotoxy(54,10);    write(z2[j]:5:4);
  wrt(9,13,15,'        ');
  gotoxy(9,13);    write(h1[j]:4:3);
  wrt(34,13,15,'      ');
  gotoxy(34,13);    write(ys[j]:4:3);
  wrt(62,13,15,'      ');
  gotoxy(62,13);    write(yo[j]:4:3);
  if (inop[j] = false) then
  begin
    wrt(42,15,15,'      ');
    gotoxy(42,15);    write(ys2[j]:4:3);
    wrt(42,17,15,'      ');
    gotoxy(42,17);    write(yo2[j]:4:3);
  end
  else
  begin
    wrt(42,15,15,'      ');
    wrt(42,17,15,'      ');
  end;
end;

procedure inp;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,7,6,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l);
           goto i11;
         end
         else begin end
       else kwd1[l]:=buff;
i2:    input(buff,7,13,11,bit);
       if bit then goto i1
         else val(buff,x1[l],cod);
i3:    input(buff,7,26,12,bit);
       if bit then goto i2
         else val(buff,y1[l],cod);
i4:    input(buff,7,42,5.1,bit);
       if bit then goto i3
         else kwd2[l]:=buff;
i5:    input(buff,7,49,11,bit);
       if bit then goto i4
         else val(buff,x2[l],cod);
i6:    input(buff,7,63,12,bit);
       if bit then goto i5
         else val(buff,y2[l],cod);
i7:    input(buff,10,17,9,bit);
       if bit then goto i6
         else val(buff,z1[l],cod);
i8:    input(buff,10,53,9,bit);
       if bit then goto i7
         else val(buff,z2[l],cod);
       if (z2[l] = 0) then inop[l]:=true else inop[l]:=false;
i9:    input(buff,13,8,9,bit);
       if bit then goto i8
         else val(buff,h1[l],cod);
i10:   input(buff,13,33,7,bit);
       if bit then goto i9
         else val(buff,ys[l],cod);
i11:   input(buff,13,61,7,bit);
       if bit then goto i10
         else val(buff,yo[l],cod);
       if (inop[l] = false) then
       begin
i12:     input(buff,15,41,7,bit);
         if bit then goto i11
           else val(buff,ys2[l],cod);
i13:     input(buff,17,41,7,bit);
         if bit then goto i12
           else val(buff,yo2[l],cod);
       end;
       epex(l);
       l:=succ(l);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
     end;
end;

procedure input_results_in_file;
var   k  :integer;
begin
  rewrite(fill);
  writeln(fill,'=============================================================================');
  writeln(fill,'   ’    ˆ  ‚  —  Œ    ‹  „  ’    ˆ  ‰  †      “  –    ‹  „  ’    ˆ  €');
  writeln(fill,'=============================================================================');
  writeln(fill,'  ‘†‹„ˆ   ‰€’€‰“”†   ‰€’€‰“”†        ƒˆ‡—‘†          “–‘      “–‘');
  writeln(fill,'€  ‘  ‘’.‘ ‘‰.  ‘‰.‘ ‘’.  €Œ€‚—‚†‘  ‘„  ”.„.    ‘’€‘†‘   ‘‰„“‘†‘');
  writeln(fill,'---------  -----------  -----------  ------------------  ---------  ---------');
               {**** ****  4 ********  5  ******** 3 ****************** 2********* 2*********}
  for k:=1 to i do
  begin
    write(fill,kwd1[k],' ':5-length(kwd1[k]),kwd2[k],' ':8-length(kwd2[k]),z1[k]:8:4);
    if (inop[k] = true) then
    begin
      write(fill,' ':16,d1[k],'  ');
      writeln(fill,h1[k]:9:3,'  ',h2[k]:9:3);
    end
    else
    begin
      write(fill,' ':5,z2[k]:8:4,' ':3,d2[k],'  ');
      writeln(fill,h1[k]:9:3,'  ',h2[k]:9:3);
      writeln(fill,' ':27,'1 §¨¦ª 2 :',d1[k]);
      writeln(fill);
    end;
  end;
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
    gotoxy(5,grammi);    write(kwd1[k]);
    gotoxy(10,grammi);    write(kwd2[k]);
    gotoxy(17,grammi);    write(z1[k]:8:4);
    if (inop[k] = true) then
    begin
      gotoxy(37,grammi);    write(d1[k]);
    end
    else
    begin
      gotoxy(28,grammi);    write(z2[k]:8:4);
      gotoxy(37,grammi);    write(d2[k]);
      wrt(55,grammi+1,7,' : 1 §¨¦ª 2');
      gotoxy(37,grammi+1);    write(d1[k]);
    end;
    gotoxy(58,grammi);    write(h1[k]:8:3);
    gotoxy(69,grammi);    write(h2[k]:8:3);
end;

procedure write_screen(m,scr_line:integer);
var   k:integer;
begin
  clrscr;
  seek(k053_scr,2);    read(k053_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  scr_line:=7;
  for k:=1 to m do
  begin
    anal_gr_scr(scr_line,k);
    if (inop[k] = true) then scr_line:=scr_line + 1
      else scr_line:=scr_line + 2;
    if scr_line >= 21 then
    begin
      wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=7;
    end;
  end;
  wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
  writeln(fill,'=============================================================================');
  writeln(fill,'   ’    ˆ  ‚  —  Œ    ‹  „  ’    ˆ  ‰  †      “  –    ‹  „  ’    ˆ  €');
  writeln(fill,'=============================================================================');
  writeln(fill);
  writeln(fill,'  ‘†‹„ˆ   ‰€’€‰“”†   ‰€’€‰“”†        ƒˆ‡—‘†          “–‘      “–‘');
  writeln(fill,'€  ‘  ‘’.‘ ‘‰.  ‘‰.‘ ‘’.  €Œ€‚—‚†‘  ‘„  ”.„.    ‘’€‘†‘   ‘‰„“‘†‘');
  writeln(fill,'---------  -----------  -----------  ------------------  ---------  ---------');
end;

procedure lprint;
var   sel,gram,k:integer;
begin
  epikef;
  gram:=10;
  for k:=1 to i do
  begin
    writeln(fill);
    write(fill,kwd1[k],' ':5-length(kwd1[k]),kwd2[k],' ':8-length(kwd2[k]),z1[k]:8:4);
    if (inop[k] = true) then
    begin
      write(fill,' ':16,d1[k],'  ');
      writeln(fill,h1[k]:9:3,'  ',h2[k]:9:3);
      gram:=gram + 2;
    end
    else
    begin
      write(fill,' ':5,z2[k]:8:4,' ':3,d2[k],'  ');
      writeln(fill,h1[k]:9:3,'  ',h2[k]:9:3);
      writeln(fill,' ':27,'1 §¨¦ª 2 :',d1[k]);
      gram:=gram + 3;
    end;
    if gram >= ar_gram - 5 then
    begin
      write(fill,#12);
      epikef;
      gram:=10;
    end;
  end;
  write(fill,#12);
  close(fill);
end;

procedure epex_menu;
var  j,k:byte;
     ok :boolean;
label    e1,10,15,25;
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
            seek(k053_scr,1);    read(k053_scr,rec1);
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
              gotoxy(13,21); read(name);
              assign(in_k053,name);
              {$i-}
              reset(in_k053);
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
              rewrite(in_k053);
              j:=0;
              repeat
                j:=j+1;
                with in1_rec do
                begin
                  kwd1_o:=kwd1[j]; x1_o:=x1[j]; y1_o:=y1[j];
                  kwd2_o:=kwd2[j]; x2_o:=x2[j]; y2_o:=y2[j];
                  z1_o:=z1[j]; z2_o:=z2[j]; h1_o:=h1[j];
                  ys_o:=ys[j]; yo_o:=yo[j];
                  ys2_o:=ys2[j]; yo2_o:=yo2[j];
                end;
                write(in_k053,in1_rec);
              until j = i;
              close(in_k053);
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
            gotoxy(13,21); readln(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k053,filename);
              {$i-}
              reset(in_k053);
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
              reset(in_k053);
              seek(in_k053,0);
              j:=0;
              repeat
                j:=j+1;
                read(in_k053,in1_rec);
                with in1_rec do
                begin
                  kwd1[j]:=kwd1_o; x1[j]:=x1_o; y1[j]:=y1_o;
                  kwd2[j]:=kwd2_o; x2[j]:=x2_o; y2[j]:=y2_o;
                  z1[j]:=z1_o; z2[j]:=z2_o;
                  h1[j]:=h1_o; ys[j]:=ys_o; yo[j]:=yo_o;
                  if (z2[j] = 0) then
                  begin
                    inop[j]:=true;
                  end
                  else
                  begin
                    inop[j]:=false;
                    ys2[j]:=ys2_o; yo2[j]:=yo2_o;
                  end;
                end;
                epex(j);
              until eof(in_k053);
              i:=j;
              close(in_k053);
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
              wrt(22,12,240,'ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..');
              reset(f);
              j:=0;
              repeat
                j:=j+1;
                readln(f,b1_o);    kwd1[j]:=b1_o;
                readln(f,b2_o);    val(b2_o,x1[j],cod);
                readln(f,b3_o);    val(b3_o,y1[j],cod);
                readln(f,b4_o);    kwd2[j]:=b4_o;
                readln(f,b5_o);    val(b5_o,x2[j],cod);
                readln(f,b6_o);    val(b6_o,y2[j],cod);
                readln(f,b7_o);    val(b7_o,z1[j],cod);
                readln(f,b8_o);    val(b8_o,z2[j],cod);
                readln(f,b9_o);    val(b9_o,h1[j],cod);
                readln(f,b10_o);    val(b10_o,ys[j],cod);
                readln(f,b11_o);    val(b11_o,yo[j],cod);
                if (z2[j] = 0) then
                begin
                  inop[j]:=true;
                end
                else
                begin
                  inop[j] := false;
                  readln(f,b12_o);    val(b12_o,ys2[j],cod);
                  readln(f,b13_o);    val(b13_o,yo2[j],cod);
                end;
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
            seek(k053_scr,3);    read(k053_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
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
              wrt_screen(OthInp,1,20,80,22);
              gotoxy(13,21); readln(filename);
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
            end
            else
            begin
              cursor(false,true);
              wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
e1:         cursor(false,true);
            epex_menu;
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
              rewrite(fill);
              write(fill,#27,#67,chr(ar_gram));
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
assign(k053_scr,'ZEN.scr');
reset(k053_scr);
seek(k053_scr,4); read(k053_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

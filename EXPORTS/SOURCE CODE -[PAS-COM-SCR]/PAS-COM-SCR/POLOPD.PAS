{******************************************************************************
*              k016 ÏĞÉÓÈÏÔÏÌÉÁ ÌÅ ÌÅÔÑÇÌÅÍÅÓ ÄÉÅÕÈÕÍÓÅÉÓ                      *
*                  WRITTEN BY G.XALARIS                        *
*                              20-12-1986                                     *
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k016=record
           kwd_o  :string[5];
           d_o,x_o,y_o:real;
         end;
         string40 =string[40];
         string255=string[255];

var      x,y,d   :array [1..99] of real;
         kwd     :array [1..99] of string[5];
         xxm,yym :array [1..99] of real;
         flag_o  :array [1..99] of byte;
         iop     :array [1..99] of integer;
         OthInp,OthPrint:array[1..3680] of byte;
         i,ism,k1,k2,j2,met,n,j,l,m1,m2,
         m3,jj,ii,kk,iopd,mdk,mdr,io:integer;

         a,b,xa,ya,xb,yb,xc,yc,dx,dy,pi,
         pii,a1,az,azba,azbc,w,wab,
         aa,bb,dtana,e1,dtanb,e2,z1,z2,
         rl,xm,ym,xx,yy,xs,ys,xsxxm,ysyym:real;

         k016_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;
         f :text;
         b1:string[5];
         b2:string[9];
         b3:string[11];
         b4:string[12];

         in_k016 :file of rec1_k016;
         in1_rec :rec1_k016;
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
  fillchar(x,sizeof(x),0);     fillchar(y,sizeof(y),0);
  fillchar(d,sizeof(d),0);     fillchar(iop,sizeof(iop),0);
  fillchar(kwd,sizeof(kwd),0); fillchar(flag_o,sizeof(flag_o),0);
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
     seek(k016_scr,0);
     read(k016_scr,rec1);
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
         close(k016_scr);
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
                    paint_box(4,21,6,38,15);    paint_box(4,40,6,57,15);
                    paint_box(8,21,10,38,15);   paint_box(8,40,10,57,15);
                    paint_box(12,21,14,38,15);  paint_box(12,40,14,57,15);
                    paint_box(16,21,18,38,15);  paint_box(16,40,18,57,15);
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
                    close(k016_scr);
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
  if (dx = 0) and (dy = 0) then exit;
  if dx < 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=pi+a1; end;
    if dy = 0 then az:=3*pi/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=2*pi-a1; end;
  end;
  if dx = 0 then
  begin if dy < 0 then az:=pi; if dy > 0 then az:=0; end;
  if dx > 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=pi-a1; end;
    if dy = 0 then az:= pi/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
  end;
end;
procedure opdief;
label     690,1200,1230,1280,1540;
begin
    ism:=i;
    k1:=ism-1; k2:=ism-2;
    j2:=2;
    met:=1;
    for n:=1 to k2 do
    begin
      for j:=j2 to k1 do
      begin
        a:=d[j]-d[n];
        l:=j+1;
690:    b:=d[l]-d[j];
        m1:=n; m2:=j; m3:=l;
        if (a=100) or (a < 10) then begin flag_o[met]:=2; goto 1200; end;
        if (b=100) or (b < 10) then begin flag_o[met]:=2; goto 1200; end;
        xa:=x[m1]; ya:=y[m1]; xb:=x[m2]; yb:=y[m2]; xc:=x[m3]; yc:=y[m3];
        dx:=xa-xb; dy:=ya-yb; arctan; azba:=az*pii;
        dx:=xc-xb; dy:=yc-yb; arctan; azbc:=az*pii;
        w:=abs(azba-azbc);
        while (w > 200) do w:=400-w;
        wab:=w+a+b;
        if ((wab > 195) and (wab < 200)) then
        begin
          flag_o[met]:=3; goto 1200;
        end;
        aa:=pi*a/200.0; bb:=pi*b/200.0;
        dtana:=sin(aa)/cos(aa); dtanb:=sin(bb)/cos(bb);
        e1:=xa-xb-(ya-yb)/dtana; e2:=xc-xb+(yc-yb)/dtanb;
        z1:=ya-yb+(xa-xb)/dtana; z2:=yc-yb-(xc-xb)/dtanb;
        rl:=(e2-e1)/(z1-z2);
        dx:=(e1+rl*z1)/(1+sqr(rl)); dy:=rl*dx;
        xm:=xb+dx; ym:=yb+dy;
        xxm[met]:=xm; yym[met]:=ym;
        met:=met+1;
1200:   if l=ism then goto 1230;
        l:=l+1;
        goto 690;
1230: end;
      j2:=j2+1;
    end;
    ii:=0;
1280:
    yy:=0; xx:=0; mdk:=met-1;
    for n:=1 to mdk do begin xx:=xx+xxm[n]; yy:=yy+yym[n]; end;
    xs:=0; ys:=0; iopd:=mdk-ii;
    if (iopd = 0) then goto 1540;
    xs:=xx/iopd; ys:=yy/iopd;
    if (ii > 0) then goto 1540;
    for n:=1 to mdk do begin xsxxm:=abs(xs-xxm[n]); ysyym:=abs(ys-yym[n]); end;
    if ii = 0 then goto 1540;
    goto 1280;
1540:
    mdr:=ii;
    for kk:=1 to mdr do flag_o[iop[kk]]:=1;
end;

procedure display_data(l:integer);
begin
  wrt(18,11,15,'     ');        gotoxy(18,11); write(kwd[l]);
  wrt(28,11,15,'        ');     gotoxy(28,11); write(d[l]:4:4);
  wrt(39,11,15,'           ');  gotoxy(39,11); write(x[l]:3:3);
  wrt(53,11,15,'            '); gotoxy(53,11); write(y[l]:3:3);
end;
procedure inp;
label     i1,i2,i3,i4;
var       l:integer;
begin
    io:=7;
    for l:=1 to i do
    begin
i1:   input(buff,io,17,6.1,bit);
      kwd[l]:=buff;
i2:   input(buff,io,27,9,bit);
      if bit then goto i1 else val(buff,d[l],cod);
i3:   input(buff,io,38,11,bit);
      if bit then goto i2 else val(buff,x[l],cod);
i4:   input(buff,io,52,12,bit);
      if bit then goto i3 else val(buff,y[l],cod);
      io:=io + 1;
      if io = 23 then
      begin
        move(rec1.xx[0],mem[$b000:ofs1],3680);
        io:=7;
      end;
    end;
    clrscr;
    cursor(false,true);
    wrt(25,12,240,'  „    ‚  €  …    ‹  €  ˆ  ');
    opdief;
    cursor(true,false);
end;
procedure diorth;
label     i1,i2,i3,i4;
var       metr,l:integer;
begin
    for metr:=1 to 99 do flag_o[metr]:=0;
    l:=1;
    while l <= i do
    begin
      display_data(l);
i1:   input(buff,11,17,6.1,bit);
      if bit then
      begin
        l:=pred(l);
        if l = 0 then l:=1;
        display_data(l);
        goto i4;
      end
      else kwd[l]:=buff;
i2:   input(buff,11,27,9,bit);
      if bit then goto i1 else val(buff,d[l],cod);
i3:   input(buff,11,38,11,bit);
      if bit then goto i2 else val(buff,x[l],cod);
i4:   input(buff,11,52,12,bit);
      if bit then goto i3 else val(buff,y[l],cod);
      l:=l + 1;
    end;
    clrscr;
    cursor(false,true);
    wrt(25,12,240,'  „    ‚  €  …    ‹  €  ˆ  ');
    opdief;
    cursor(true,false);
end;

procedure input_results_in_file;
var       k  :integer;
begin
  rewrite(fill);
  writeln(fill,'=============================================================================');
  writeln(fill,'    ˆ ‘ ‡  ’  ‹ ˆ €   ‹ „   ‹ „ ’  † ‹ „ Œ „ ‘   ƒ ˆ „ “ ‡ “ Œ ‘ „ ˆ ‘');
  writeln(fill,'=============================================================================');
  writeln(fill,'‰—ƒˆ‰ˆ   ‘†‹„ˆ—Œ    ’„’‹†‹„Œ†     ’„’€‚‹„Œ†    €  € ’ †  † ‘ „ ˆ ‘     ');
  writeln(fill,'  ˆ‘‡’‹ˆ€‘        ‘†‹„ˆ“       ‘†‹„ˆ“');
  met:=1;    j2:=2;
  for n:=1 to k2 do
  begin
    for j:=j2 to k1 do
    begin
      l:=j + 1;
      repeat
        m1:=n;    m2:=j;    m3:=l;
        write(fill,kwd[m1],' ':6-length(kwd[m1]),
              kwd[m2],' ':6-length(kwd[m2]),
              kwd[m3],' ':6-length(kwd[m3]),
              '  ',xxm[met]:10:3,'  ',yym[met]:11:3,'   ');
        case flag_o[met] of
             1:writeln(fill,'˜§œ¨ ­Ÿ  ¦§ ©Ÿ¦«¦£ ˜');
             2:writeln(fill,'›œ¤ ¬§œ¢¦š ©Ÿ,šà¤ œª <10 ã =100');
             3:writeln(fill,'›œ¤ ¬§œ¢¦š ©Ÿ,195<˜Ÿ¨¦ ©£˜ šà¤ à¤<200');
          else writeln(fill);
        end;
        l:=l + 1;
      until l = i + 1;
    end;
    j2:=j2 + 1;
  end;
  writeln(fill,'  ’œ¢ ¡ « £       ',xs:10:3,'  ',ys:11:3);
  close(fill);
end;

procedure write_screen;
var       n,j,io,m1,m2,m3,l,met:integer;
begin
  j2:=2; io:=7;
  met:=1;
  for n:=1 to k2 do
  begin
    for j:=j2 to k1 do
    begin
      l:=j + 1;
      repeat
      m1:=n;    m2:=j;    m3:=l;
      gotoxy(2,io);    write(kwd[m1]);
      gotoxy(8,io);    write(kwd[m2]);
      gotoxy(14,io);    write(kwd[m3]);
      gotoxy(25,io);    write(xxm[met]:10:3);
      gotoxy(38,io);    write(yym[met]:11:3);
      case flag_o[met] of
           1:wrt(50,io,15,'˜§œ¨ ­Ÿ  ¦§ ©Ÿ¦«¦£ ˜');
           2:wrt(50,io,15,'šà¤ œª < 10 ã šà¤ œª = 100');
           3:wrt(50,io,15,'195 < ˜Ÿ¨¦ ©£˜ šà¤ à¤ < 200');
      end;
      io:=io + 1;
      if io = 22 then
      begin
        io:=7;
        wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
        repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
        move(rec1.xx[0],mem[$b000:ofs1],3680);
      end;
      met:=met + 1;
      l:=l + 1;
      until l = i + 1;
    end;
    if n < 22 then
    begin
      wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    end;
    j2:=j2 + 1;
  end;
  wrt(2,io,15,'’œ¢ ¡ « £');
  gotoxy(25,io);    write(xs:10:3);
  gotoxy(38,io);    write(ys:11:3);
  wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ MENU €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
  writeln(fill,'=============================================================================');
  writeln(fill,'    ˆ ‘ ‡  ’  ‹ ˆ €   ‹ „   ‹ „ ’  † ‹ „ Œ „ ‘   ƒ ˆ „ “ ‡ “ Œ ‘ „ ˆ ‘');
  writeln(fill,'=============================================================================');
  writeln(fill,'‰—ƒˆ‰ˆ   ‘†‹„ˆ—Œ    ’„’‹†‹„Œ†     ’„’€‚‹„Œ†    €  € ’ †  † ‘ „ ˆ ‘     ');
  writeln(fill,'  ˆ‘‡’‹ˆ€‘        ‘†‹„ˆ“       ‘†‹„ˆ“');
end;
procedure lprint;
var       sel,gram,k:integer;
begin
  rewrite(fill);
  epikef;
  gram:=8;
  met:=1;    j2:=2;
  for n:=1 to k2 do
  begin
    for j:=j2 to k1 do
    begin
      l:=j + 1;
      repeat
        m1:=n;    m2:=j;    m3:=l;
        writeln(fill);
        write(fill,kwd[m1],' ':6-length(kwd[m1]),
              kwd[m2],' ':6-length(kwd[m2]),
              kwd[m3],' ':6-length(kwd[m3]),
              '  ',xxm[met]:10:3,'  ',yym[met]:11:3,'   ');
        case flag_o[met] of
             1:writeln(fill,'˜§œ¨ ­Ÿ  ¦§ ©Ÿ¦«¦£ ˜');
             2:writeln(fill,'›œ¤ ¬§œ¢¦š ©Ÿ,šà¤ œª <10 ã =100');
             3:writeln(fill,'›œ¤ ¬§œ¢¦š ©Ÿ,195<˜Ÿ¨¦ ©£˜ šà¤ à¤<200');
          else writeln(fill);
        end;
        gram:=gram + 2;
        if gram >= ar_gram - 2 then
        begin
          writeln(fill);
          writeln(fill);
          epikef;
          gram:=8;
        end;
        met:=met + 1;
        l:=l + 1;
      until l = i + 1;
    end;
    j2:=j2 + 1;
  end;
  writeln(fill);
  writeln(fill,'  ’œ¢ ¡ « £       ',xs:10:3,'  ',ys:11:3);
  close(fill);
end;

procedure epex_menu;
var       j,k,metr:byte;
          ok :boolean;
label     e1,e2,10,25;
begin
     case menu of
        1:begin
            if ((sw1 = 1) or (sw3 = 1)) then epex_menu;
            gotoxy(14,21);
            cursor(true,false);
            seek(k016_scr,1);     read(k016_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
e1:         input(buff,10,29,3,bit);
            val(buff,i,cod);
            if not (i in [1..99])then goto e1;
            clrscr;
            seek(k016_scr,2);     read(k016_scr,rec1);
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
              assign(in_k016,name);
              {$i-}
              reset(in_k016);
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
              rewrite(in_k016);
              j:=0;
              repeat
                j:=j + 1;
                with in1_rec do
                begin
                  kwd_o:=kwd[j];  d_o:=d[j];  x_o:=x[j];  y_o:=y[j];
                  write(in_k016,in1_rec);
                end;
              until j=i;
              close(in_k016);
            end
            else
            begin
              cursor(false,true);
              wrt(14,21,112,'ƒEN EKANE‘ EI‘A‚—‚H ƒEƒOMEN—N.  €’†‘„ „Œ€ Š†‰’..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
            gotoxy(1,21);    writeln;
            cursor(false,true);
            epex_menu;
          end;
        3:begin
            cursor(true,false);
            gotoxy(1,20);
            write('TO AXEIO AYTO EINAI ƒHMIOY‚†MENO ME EDITOR "H ME TO ŠHKTO F2; (E/F): ');
            read(cha);
            wrt_screen(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k016,filename);
              {$i-}
              reset(in_k016);
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
              reset(in_k016);
              seek(in_k016,0);
              j:=0;
              repeat
                j:=j+1;
                read(in_k016,in1_rec);
                with in1_rec do
                begin
                  kwd[j]:=kwd_o; d[j]:=d_o; x[j]:=x_o;  y[j]:=y_o;
                end;
              until eof(in_k016);
              close(in_k016);
              i := j;
              clrscr;
              wrt(25,12,240,'  „    ‚  €  …    ‹  €  ˆ  ');
              for metr:=1 to 99 do flag_o[metr]:=0;
              opdief;
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
                readln(f,b1);    kwd[j]:=b1;
                readln(f,b2);    val(b2,d[j],cod);
                readln(f,b3);    val(b3,x[j],cod);
                readln(f,b4);    val(b4,y[j],cod);
              until eof(f);
              close(f);
              i:=j;
              clrscr;
              wrt(25,12,240,'  „    ‚  €  …    ‹  €  ˆ  ');
              for metr:=1 to 99 do flag_o[metr]:=0;
              opdief;
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
            seek(k016_scr,3);    read(k016_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            diorth;
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
                write('O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) ');
                read(kbd,cha);
                if cha in ['O','o','','¦'] then goto e2;
              end;
              input_results_in_file;
e2:           cursor(false,true);
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
              clrscr;
              seek(k016_scr,4);    read(k016_scr,rec1);
              move(rec1.xx[0],mem[$b000:ofs1],3680);
              write_screen;
              cursor(false,true);
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
assign(k016_scr,'POLOPD.scr');
reset(k016_scr);
seek(k016_scr,5); read(k016_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
pi:=arctan(1)*4;
pii:=200/pi;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

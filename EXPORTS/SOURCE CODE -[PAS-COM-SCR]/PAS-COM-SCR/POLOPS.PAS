{******************************************************************************
*                 k015 œ–…”»œ‘œÃ…¡ Ã≈ Ã≈‘—«Ã≈Õ≈” –À≈’—≈”                       *
*                  WRITTEN BY G.XALARIS                       *
*                              19-12-1986                                     *
*******************************************************************************}
program  k015;
const    diff=0.40;

type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k015=record
           kwd_o  :string[5];
           s_o,x_o,y_o:real;
         end;
         string40 =string[40];
         string255=string[255];

var      x,y,s,xxm,yym:array [1..99] of real;
         kwd   :array [1..99] of string[5];
         flag_o:array [1..99] of byte;
         iop   :array [1..99] of integer;
         OthInp,OthPrint:array[1..3680] of byte;
         i,k1,k2,j2,met,n,j,l,m1,m2,
         mdr,kk,m3,jj,ii,iops,mdk,io:integer;

         sa,sb,sc,xa,ya,xb,yb,xc,yc,r1,r2,r3,r4,r5,r6,
         diak,xm,ym,xx,yy,xs,ys,syn1,syn2:real;

         k015_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f :text;
         b1:string[5];
         b2:string[11];
         b3:string[11];
         b4:string[12];
         in_k015 :file of rec1_k015;
         in1_rec :rec1_k015;
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
  fillchar(s,sizeof(s),0);     fillchar(iop,sizeof(iop),0);
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
     seek(k015_scr,0);
     read(k015_scr,rec1);
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
         close(k015_scr);
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
                    close(k015_scr);
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

procedure xyops;
label     o1;
begin
    k1:=i - 1;    k2:=i - 2;
    j2:=2;
    met:=1;
    for n:=1 to k2 do
    begin
      for j:=j2 to k1 do
      begin
        l:=j + 1;
        m1:=n;    m2:=j;
        repeat
          m3:=l;
          sa:=s[n];  sb:=s[j];  sc:=s[l];
          xa:=x[m1]; xb:=x[m2]; xc:=x[m3];
          ya:=y[m1]; yb:=y[m2]; yc:=y[m3];
          r1:=xb-xa; r2:=yb-ya; r3:=xc-xa; r4:=yc-ya;
          r5:=(sqr(sa)-sqr(xa)-sqr(ya)-(sqr(sb)-sqr(xb)-sqr(yb)))/2;
          r6:=(sqr(sa)-sqr(xa)-sqr(ya)-(sqr(sc)-sqr(xc)-sqr(yc)))/2;
          diak:=r1*r4-r2*r3;
          xxm[met]:=(r5*r4-r2*r6)/diak;
          yym[met]:=(r1*r6-r5*r3)/diak;
          met:=met+1;
          l:=l+1;
        until (l=i+1);
      end;
      j2:=j2+1;
    end;
    ii:=0;
    repeat
      yy:=0;    xx:=0;    mdk:=met - 1;
      for n:=1 to mdk do
      begin
        xx:=xx + xxm[n];    yy:=yy + yym[n];
      end;
      xs:=0;    ys:=0;    iops:=mdk - ii;
      if (iops <> 0) then
      begin
        xs:=xx / iops;    ys:=yy / iops;
        if (ii <= 0) then
        begin
          for n:=1 to mdk do
          begin
            syn1:=abs(xs - xxm[n]);    syn2:=abs(ys - yym[n]);
            if ((syn1 >= diff) or (syn2 >= diff)) then
            begin
              xxm[n]:=0;    yym[n]:=0;    ii:=ii + 1;    iop[ii]:=n;
            end;
          end;
          if ii = 0 then goto o1;
        end else goto o1
      end else goto o1;
o1: until ((ii >= 0) or (iops = 0));
    mdr:=ii;
    for kk:=1 to mdr do flag_o[iop[kk]]:=1;
end;

procedure display_data(l:integer);
begin
  wrt(17,11,15,'     ');        gotoxy(17,11); write(kwd[l]);
  wrt(27,11,15,'           ');  gotoxy(27,11); write(s[l]:3:3);
  wrt(40,11,15,'           ');  gotoxy(40,11); write(x[l]:3:3);
  wrt(54,11,15,'            '); gotoxy(54,11); write(y[l]:3:3);
end;

procedure inp;
label     i1,i2,i3,i4;
var       l:integer;
begin
    io:=7;
    for l:=1 to i do
    begin
i1:   input(buff,io,16,6.1,bit);
      kwd[l]:=buff;
i2:   input(buff,io,26,11,bit);
      if bit then goto i1 else val(buff,s[l],cod);
i3:   input(buff,io,39,11,bit);
      if bit then goto i2 else val(buff,x[l],cod);
i4:   input(buff,io,53,12,bit);
      if bit then goto i3 else val(buff,y[l],cod);
      io:=io + 1;
      if io = 23 then begin move(rec1.xx[0],mem[$b000:ofs1],3680); io:=7; end;
    end;
    cursor(false,true);
    clrscr;
    wrt(25,12,240,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à  ');
    xyops;
    cursor(true,false);
end;

procedure diorth;
label     i1,i2,i3,i4;
var       l,metr:integer;
begin
    for metr:=1 to 99 do flag_o[metr]:=0;
    l:=1;
    while l <= i do
    begin
      display_data(l);
i1:   input(buff,11,16,6.1,bit);
      if bit then
      begin
        l:=pred(l);
        if l = 0 then l:=1;
        display_data(l);
        goto i4;
      end
      else kwd[l]:=buff;
i2:   input(buff,11,26,9,bit);
      if bit then goto i1 else val(buff,s[l],cod);
i3:   input(buff,11,39,11,bit);
      if bit then goto i2 else val(buff,x[l],cod);
i4:   input(buff,11,53,12,bit);
      if bit then goto i3
        else val(buff,y[l],cod);
      l:=l + 1;
    end;
    cursor(false,true);
    clrscr;
    wrt(25,12,240,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à  ');
    xyops;
    cursor(true,false);
end;

procedure input_results_in_file;
var       k:integer;
begin
  rewrite(fill);
  writeln(fill,'=====================================================================');
  writeln(fill,'  é è à ë á é í é ã à Ä   ã Ñ   ã Ñ í ê Ü ã Ñ å Ñ ë   è ä Ñ ì ê Ñ ë');
  writeln(fill,'=====================================================================');
  writeln(fill,'âóÉàâéà   ëÜãÑàóå    íÑíãÜãÑåÜ    íÑíÄÇãÑåÜ   è Ä ê Ä í Ü ê Ü ë Ñ à ë');
  writeln(fill,'  éèàëáéíéãàÄë        ëÜãÑàéì      ëÜãÑàéì');
  met:=1;    j2:=2;
  for n:=1 to k2 do
  begin
    for j:=j2 to k1 do
    begin
      l:=j + 1;
      repeat
      m1:=n;    m2:=j;    m3:=l;
      write(fill,kwd[m1],' ':6-length(kwd[m1]),kwd[m2],' ':6-length(kwd[m2]),
      kwd[m3],' ':6-length(kwd[m3]),'  ',xxm[met]:10:3,'  ',yym[met]:11:3,'   ');
      if flag_o[met] = 1 then writeln(fill,'òß¶®†≠üû°ú û ¶ß†©ü¶´¶£†ò')
      else writeln(fill);
      met:=met + 1;
      l:=l + 1;
      until l = i + 1;
    end;
    j2:=j2 + 1;
  end;
  writeln(fill,'  íú¢†°û ´†£û       ',xs:10:3,'  ',ys:11:3);
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
        if flag_o[met] = 1 then wrt(50,io,15,'   òß¶®†≠üû°ú û ¶ß†©ü¶´¶£†ò');
        io:=io + 1;
        if io = 22 then
        begin
          io:=7;
          wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
          repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
          move(rec1.xx[0],mem[$b000:ofs1],3680);
        end;
        met:=met + 1;
        l:=l + 1;
      until l = i + 1;
    end;
    if n < 22 then
    begin
      wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    end;
    j2:=j2 + 1;
  end;
  gotoxy(2,io);    write('íú¢†°û ´†£û');
  gotoxy(25,io);    write(xs:10:3);
  gotoxy(38,io);    write(ys:11:3);
  wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé MENU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'ëÑäàÉÄ : ',sel:1);
  writeln(fill);
  writeln(fill,'=====================================================================');
  writeln(fill,'  é è à ë á é í é ã à Ä   ã Ñ   ã Ñ í ê Ü ã Ñ å Ñ ë   è ä Ñ ì ê Ñ ë');
  writeln(fill,'=====================================================================');
  writeln(fill,'âóÉàâéà   ëÜãÑàóå    íÑíãÜãÑåÜ    íÑíÄÇãÑåÜ   è Ä ê Ä í Ü ê Ü ë Ñ à ë');
  writeln(fill,'  éèàëáéíéãàÄë        ëÜãÑàéì      ëÜãÑàéì');
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
      write(fill,kwd[m1],' ':6-length(kwd[m1]),kwd[m2],' ':6-length(kwd[m2]),
      kwd[m3],' ':6-length(kwd[m3]),'  ',xxm[met]:10:3,'  ',yym[met]:11:3,'   ');
      if flag_o[met] = 1 then writeln(fill,'òß¶®†≠üû°ú û ¶ß†©ü¶´¶£†ò')
      else writeln(fill);
      gram:=gram + 2;
      if gram >= ar_gram - 2 then
      begin writeln(fill); writeln(fill); epikef; gram:=8; end;
      met:=met + 1;
      l:=l + 1;
      until l = i + 1;
    end;
    j2:=j2 + 1;
  end;
  writeln(fill);
  writeln(fill,'  íú¢†°û ´†£û       ',xs:10:3,'  ',ys:11:3);
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
            seek(k015_scr,1);     read(k015_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
e1:         input(buff,10,29,3,bit);
            val(buff,i,cod);
            if not (i in [1..99]) then goto e1;
            clrscr;
            seek(k015_scr,2);     read(k015_scr,rec1);
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
              assign(in_k015,name);
              {$i-}
              reset(in_k015);
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
              rewrite(in_k015);
              j:=0;
              repeat
                j:=j + 1;
                with in1_rec do
                begin
                  kwd_o:=kwd[j];  s_o:=s[j];  x_o:=x[j];  y_o:=y[j];
                  write(in_k015,in1_rec);
                end;
              until j=i;
              close(in_k015);
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
            gotoxy(13,21); readln(filename);
            if cha in ['F','f','î','≠'] then
            begin
              assign(in_k015,filename);
              {$i-}
              reset(in_k015);
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
              reset(in_k015);
              seek(in_k015,0);
              j:=0;
              repeat
                j:=j+1;
                read(in_k015,in1_rec);
                with in1_rec do
                begin
                  kwd[j]:=kwd_o; s[j]:=s_o; x[j]:=x_o;  y[j]:=y_o;
                end;
              until eof(in_k015);
              close(in_k015);
              clrscr;
              wrt(25,12,240,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à  ');
              for metr:=1 to 99 do flag_o[metr]:=0;
              i := j;
              xyops;
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
              wrt(21,12,240,' É à Ä Å Ä Ö ó   É Ñ É é ã Ñ å Ä.. ');
              reset(f);
              j:=0;
              repeat
                j:=j+1;
                readln(f,b1);    kwd[j]:=b1;
                readln(f,b2);    val(b2,s[j],cod);
                readln(f,b3);    val(b3,x[j],cod);
                readln(f,b4);    val(b4,y[j],cod);
              until eof(f);
              close(f);
              clrscr;
              wrt(25,12,240,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à  ');
              for metr:=1 to 99 do flag_o[metr]:=0;
              i:=j;
              xyops;
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
            seek(k015_scr,3);    read(k015_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            diorth;
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
                write('èêOëEXE ! TO AêXEIO AYTO YèAêXEI. NA ÇêAñó EèANó TOY; (N/O) ');
                read(kbd,cha);
                if cha in ['O','o','é','¶'] then goto e2;
              end;
              input_results_in_file;
e2:           cursor(false,true);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èATHëE ENA èäHKTêO..');
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
              cursor(false,true);
              epex_menu;
            end;
          end;
        7:begin
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              clrscr;
              seek(k015_scr,4);    read(k015_scr,rec1);
              move(rec1.xx[0],mem[$b000:ofs1],3680);
              write_screen;
              cursor(false,true);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èATHëE ENA èäHKTêO..');
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
assign(k015_scr,'POLOPS.scr');
reset(k015_scr);
seek(k015_scr,5); read(k015_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
delete_all_input;
cursor(false,true);
epex_menu;
END.

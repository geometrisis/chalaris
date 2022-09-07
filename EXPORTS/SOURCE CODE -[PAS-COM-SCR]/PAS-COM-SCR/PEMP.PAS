{******************************************************************************
*             PEMP : ≈Ã–—œ”»œ‘œÃ…¡ Ã≈ Ã≈‘—«Ã≈Õ≈” ƒ…≈’»’Õ”≈…”                 *
*                  WRITTEN BY G.XALARIS                         *
*                              29-12-1986                                     *
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k014=record
           kwdep_e:string[5];
           x_e    :real;
           y_e    :real;
           diep_e :real;
           nuff_e :integer;
         end;
         rec2_k014=record
           kwdff_e:string[5];
             dff_e:real;
             dummy:string[13];
         end;
         string40 =string[40];
         string255=string[255];

var      x,y,diep,diep_em:array [1..500] of real;
         kwdep   :array [1..500] of string[5];
         nuff    :array [1..500] of integer;
         kwdff   :array [1..500] of string[5];
         dff,xeml,yeml   :array [1..500] of real;
         flag_e  :array [1..500] of byte;
         iap     :array [1..500] of integer;
         OthInp,OthPrint:array[1..3680] of byte;
         i,jk,iemp,ig,jf,j,kf,iempm1,l,lk1,
         ig1,ig2,ieml1,ii,iemn,n,iem,l1,io,iall,oldiall:integer;

         dtaf,p,pi,pii,a1,az,azab,dtafj,
         dief,xa,ya,xb,yb,dx,dy,xem,yem,
         a2,gem,a1r,a2r,r1,r2,r3,r4,q1,q2,
         diak,xemn,yemn,xtest,ytest      :real;

         k014_scr:file of rec;
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
         b3:string[12];
         b4:string[9];
         b5:string[3];
         b6:string[5];
         b7:string[9];

         in_k014 :file of rec1_k014;
         in1_rec :rec1_k014;
         in2_rec :rec2_k014 absolute in1_rec;
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
  xem:=0; yem:=0; iemp:=0; iem:=0; oldiall:=0; iall:=0;
  fillchar(x,sizeof(x),0);         fillchar(y,sizeof(y),0);
  fillchar(diep,sizeof(diep),0);   fillchar(iap,sizeof(iap),0);
  fillchar(kwdep,sizeof(kwdep),0); fillchar(flag_e,sizeof(flag_e),0);
  fillchar(xeml,sizeof(xeml),0);   fillchar(yeml,sizeof(yeml),0);
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
     seek(k014_scr,0);
     read(k014_scr,rec1);
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
         close(k014_scr);
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
                    close(k014_scr);
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

procedure arctan;
begin
  if (dx = 0) and (dy = 0) then exit;
  if dx < 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=pi+a1; end;
    if dy = 0 then az:=3*pi/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=2*pi-a1; end;
  end;
  if dx = 0 then begin if dy < 0 then az:=pi; if dy > 0 then az:=0; end;
  if dx > 0 then
  begin
    if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=pi-a1; end;
    if dy = 0 then az:=pi/2;
    if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
  end;
end;
procedure xyemp;
label     1170,1350;
begin
    for n:=1 to i do diep[n]:=diep_em[n];
    fillchar(flag_e,sizeof(flag_e),0);
    jk:=0;
    iemp:=i;
    for n:=1 to iemp do
    begin
      ig:=n;
      jf:=nuff[n];
      dtaf:=0;
      for j:=1 to jf do
      begin
        jk:=jk+1;
        for L1:=1 to iall do
        begin
          if kwdff[jk] = kwdep[L1] then kf:=L1;
        end;
        dief:=dff[jk];
        xa:=x[ig]; ya:=y[ig]; xb:=x[kf]; yb:=y[kf];
        dx:=xb-xa; dy:=yb-ya; arctan; azab:=az*200/pi;
        dtafj:=azab-dief;
        if (dtafj < 0) then dtafj:=dtafj+400; dtaf:=dtaf+dtafj;
      end;
      dtaf:=dtaf/jf;
      diep[n]:=diep[n]+dtaf;
      if (diep[n] > 400) then diep[n]:=diep[n]-400;
    end;
    xem:=0; yem:=0; iem:=0;
    iempm1:=iemp-1;
    for l:=1 to iempm1 do
    begin
      lk1:=l+1;
      for l1:=lk1 to iemp do
      begin
        ig1:=l;
        ig2:=l1;
        a1:=diep[l]+200;
        a2:=diep[l1]+200;
        if (a1 > 400) then a1:=a1-400;
        if (a2 > 400) then a2:=a2-400;
        gem:=abs(a2-a1);
        if gem>200 then
        begin
          if ((gem>230 ) and (gem<370)) then goto 1170
          else begin flag_e[iem]:=1; goto 1350; end;
        end
        else begin
          if ((gem>12) and (gem<188)) then goto 1170
          else begin flag_e[iem]:=1; goto 1350; end;
        end;
1170:   a1r:=diep[l]*pi/200;
        a2r:=diep[l1]*pi/200;
        iem:=iem+1;
        r1:=cos(a1r);
        r2:=-sin(a1r);
        r3:=cos(a2r);
        r4:=-sin(a2r);
        q1:=r1*x[ig1]+r2*y[ig1];
        q2:=r3*x[ig2]+r4*y[ig2];
        diak:=r1*r4-r2*r3;
        xeml[iem]:=(q1*r4-r2*q2)/diak; yeml[iem]:=(r1*q2-q1*r3)/diak;
        xem:=xem+xeml[iem]; yem:=yem+yeml[iem];
1350: end;
    end;
    xem:=xem/iem; yem:=yem/iem;
    ii:=0; xemn:=0; yemn:=0; iemn:=0;
    for j:=1 to iem do
    begin
      xtest:=abs(xem-xeml[j]); ytest:=abs(yem-yeml[j]);
      if (xtest < 0.2) and (ytest < 0.2) then
      begin
        xemn:=xemn+xeml[j]; yemn:=yemn+yeml[j]; iemn:=iemn+1;
      end
      else
      begin
        ii:=ii+1; iap[ii]:=j;
      end;
    end;
    iem:=iemn;
    xem:=xemn/iem; yem:=yemn/iem;
    for l:=1 to ii do flag_e[iap[l]]:=2;
end;

procedure display_data(l:integer);
begin
  wrt(3,12,15,'     ');       gotoxy(3,12);  write(kwdep[l]);
  wrt(10,12,15,'          '); gotoxy(10,12); write(x[l]:3:3);
  wrt(23,12,15,'           ');gotoxy(23,12); write(y[l]:3:3);
  wrt(38,12,15,'        ');   gotoxy(38,12); write(diep_em[l]:4:4);
  wrt(53,12,15,'   ');        gotoxy(53,12); write(nuff[l]);
  wrt(62,12,15,'     ');      wrt(70,12,15,'        ');
end;
procedure display_data2(k:integer);
begin
  wrt(62,12,15,'     ');     gotoxy(62,12); write(kwdff[k]);
  wrt( 70,12,15,'        '); gotoxy(70,12); write(dff[k]:4:4);
end;
procedure inp;
label     i1,i2,i3,i4,i5,i6,i7;
var       l,j:integer;
begin
    io:=8; iall:=0; oldiall:=1;
    for l:=1 to i do
    begin
i1:   input(buff,io,2,6.1,bit); kwdep[l]:=buff;
i2:   input(buff,io,9,11,bit);
      if bit then goto i1 else val(buff,x[l],cod);
i3:   input(buff,io,22,12,bit);
      if bit then goto i2 else val(buff,y[l],cod);
i4:   input(buff,io,37,9,bit);
      if bit then goto i3 else val(buff,diep_em[l],cod);
i5:   input(buff,io,52,3,bit);
      if bit then goto i4 else val(buff,nuff[l],cod);
      iall:=iall+nuff[l];
      for j:=oldiall to iall do
      begin
i6:     input(buff,io,61,6.1,bit); kwdff[j]:=buff;
i7:     input(buff,io,69,9,bit);
        if bit then goto i6 else val(buff,dff[j],cod);
        io:=io+1; oldiall:=iall+1;
        if io = 23 then
        begin move(rec1.xx[0],mem[$b000:ofs1],3680); io:=8; end;
      end;
    end;
    clrscr;
    cursor(false,true);
    wrt(25,12,240,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à  ');
    xyemp;
    cursor(true,false);
end;
procedure diorth;
label     i1,i2,i3,i4,i5,i6,i7;
var       l,m:integer;
begin
    fillchar(flag_e,sizeof(flag_e),0);
    l:=1; iall:=0; oldiall:=1;
    while l <= i do
    begin
      display_data(l);
i1:   input(buff,12,2,6.1,bit);
      if bit then goto i1 else kwdep[l]:=buff;
i2:   input(buff,12,9,11,bit);
      if bit then goto i1 else val(buff,x[l],cod);
i3:   input(buff,12,22,12,bit);
      if bit then goto i2 else val(buff,y[l],cod);
i4:   input(buff,12,37,9,bit);
      if bit then goto i3 else val(buff,diep_em[l],cod);
i5:   input(buff,12,52,3,bit);
      if bit then goto i4 else val(buff,nuff[l],cod);
      iall:=iall+nuff[l];
      for m:=oldiall to iall do
      begin
        display_data2(m);
i6:     input(buff,12,61,6.1,bit);
        if bit then
          if m = 1 then goto i6 else kwdff[m]:=buff;
i7:       input(buff,12,69,9,bit);
          if bit then goto i6 else val(buff,dff[m],cod);
          oldiall:=iall+1;
        end;
      l:=l + 1;
    end;
    clrscr;
    cursor(false,true);
    wrt(25,12,240,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à  ');
    xyemp;
    cursor(true,false);
end;

procedure input_results_in_file;
var       k  :integer;
begin
  rewrite(fill);
  writeln(fill,'=============================================================================');
  writeln(fill,'Ñ ã è ê é ë á é í é ã à Ä   ã Ñ   ã Ñ í ê Ü ã Ñ å Ñ ë   É à Ñ ì á ì å ë Ñ à ë');
  writeln(fill,'=============================================================================');
  writeln(fill,'âóÉàâéà   ëÜãÑàóå    íÑíãÜãÑåÜ     íÑíÄÇãÑåÜ   è Ä ê Ä í Ü ê Ü ë Ñ à ë     ');
  writeln(fill,' ÑãèêéëáéíéãàÄë       ëÜãÑàéì       ëÜãÑàéì');
  iem:=0;
  for l:=1 to iempm1 do
  begin
    lk1:=l + 1;
    for l1:=lk1 to i do
    begin
      ig1:=l;    ig2:=l1;    iem:=iem + 1;
      write(fill,'   ',kwdep[ig1],' ':6-length(kwdep[ig1]),
            kwdep[ig2],' ':6-length(kwdep[ig2]),
            '     ',xeml[iem]:10:3,'   ',yeml[iem]:11:3,'   ');
      case flag_e[iem] of
           1:writeln(fill,'õú§ ¨ßú¢¶ö†©üû û ú£ß®¶©ü¶´¶£†ò');
           2:writeln(fill,'û ú£ß®¶©ü¶´¶£†ò òßú®†≠üû');
        else writeln(fill);
      end;
    end;
  end;
  writeln(fill,'  íú¢†°û ´†£û       ',xem:10:3,'   ',yem:11:3);
  close(fill);
end;

procedure write_screen;
begin
  iem:=0;    io:=7;
  for l:=1 to iempm1 do
  begin
    lk1:=l + 1;
    for l1:=lk1 to i do
    begin
      ig1:=l;    ig2:=l1;    iem:=iem + 1;
      gotoxy(6,io);    write(kwdep[ig1]);
      gotoxy(12,io);    write(kwdep[ig2]);
      gotoxy(22,io);    write(xeml[iem]:10:3);
      gotoxy(35,io);    write(yeml[iem]:11:3);
      case flag_e[iem] of
           1:wrt(48,io,15,'õú§ ¨ßú¢¶ö†©üû û ú£ß®¶©ü¶´¶£†ò');
           2:wrt(48,io,15,'û ú£ß®¶©ü¶´¶£†ò òßú®†≠üû');
      end;
      io:=io + 1;
      if io = 22 then
      begin
        io:=7;
        wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
        repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
        move(rec1.xx[0],mem[$b000:ofs1],3680);
      end;
    end;
    if n < 22 then
    begin
      wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    end;
  end;
  wrt(6,io,15,'íú¢†°û ´†£û');
  gotoxy(22,io);    write(xem:10:3);
  gotoxy(35,io);    write(yem:11:3);
  wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé MENU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'ëÑäàÉÄ : ',sel:1);
  writeln(fill);
  writeln(fill,'=============================================================================');
  writeln(fill,'Ñ ã è ê é ë á é í é ã à Ä   ã Ñ   ã Ñ í ê Ü ã Ñ å Ñ ë   É à Ñ ì á ì å ë Ñ à ë');
  writeln(fill,'=============================================================================');
  writeln(fill,'âóÉàâéà   ëÜãÑàóå    íÑíãÜãÑåÜ     íÑíÄÇãÑåÜ   è Ä ê Ä í Ü ê Ü ë Ñ à ë     ');
  writeln(fill,' ÑãèêéëáéíéãàÄë       ëÜãÑàéì       ëÜãÑàéì');
end;
procedure lprint;
var       sel,gram,k:integer;
begin
  rewrite(fill);
  epikef;
  gram:=8;
  iem:=0;
  for l:=1 to iempm1 do
  begin
    lk1:=l + 1;
    for l1:=lk1 to i do
    begin
      ig1:=l;    ig2:=l1;    iem:=iem + 1;
      writeln(fill);
      write(fill,'   ',kwdep[ig1],' ':6-length(kwdep[ig1]),
            kwdep[ig2],' ':6-length(kwdep[ig2]),
            '     ',xeml[iem]:10:3,'   ',yeml[iem]:11:3,'   ');
      case flag_e[iem] of
           1:writeln(fill,'õú§ ¨ßú¢¶ö†©üû û ú£ß®¶©ü¶´¶£†ò');
           2:writeln(fill,'û ú£ß®¶©ü¶´¶£†ò òßú®†≠üû');
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
    end;
  end;
  writeln(fill);
  writeln(fill,'  íú¢†°û ´†£û       ',xem:10:3,'   ',yem:11:3);
  close(fill);
end;

procedure epex_menu;
var       j,k,metr:byte;
          ok :boolean;
label     e1,e2,10,25;
begin
     case menu of
        1:begin
            if ((sw1=1) or (sw3=1)) then epex_menu;
            gotoxy(14,21);
            cursor(true,false);
            seek(k014_scr,1);     read(k014_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
e1:         input(buff,10,29,3,bit);
            val(buff,i,cod);
            if not (i in [1..500])then goto e1;
            clrscr;
            seek(k014_scr,2);     read(k014_scr,rec1);
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
              assign(in_k014,name);
              {$i-}
              reset(in_k014);
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
              iall:=0; oldiall:=1;
              rewrite(in_k014);
              for j:=1 to i do
              begin
                with in1_rec do
                begin
                  kwdep_e:=kwdep[j];
                  x_e:=x[j];
                  y_e:=y[j];
                  diep_e:=diep_em[j];
                  nuff_e:=nuff[j];
                  write(in_k014,in1_rec);
                  iall:=iall+nuff[j];
                end;
                for k:=oldiall to iall do
                begin
                  with in2_rec do
                  begin
                    kwdff_e:=kwdff[k];
                    dff_e:=dff[k];
                    write(in_k014,in1_rec);
                    oldiall:=iall+1;
                  end;
                end;
              end;
              close(in_k014);
            end
            else
            begin
              cursor(false,true);
              wrt(13,21,112,' ÉEN EKANEë EIëAÇóÇH ÉEÉOMENóN.  èÄíÜëÑ ÑåÄ èäÜâíêé.. ');
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
            gotoxy(13,21); read(filename);
            if cha in ['F','f','î','≠'] then
            begin
              assign(in_k014,filename);
              {$i-}
              reset(in_k014);
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
              reset(in_k014);
              seek(in_k014,0);
              j:=0; iall:=0; oldiall:=1;
              repeat
                j:=j+1;
                read(in_k014,in1_rec);
                with in1_rec do
                begin
                  kwdep[j]:=kwdep_e;
                  x[j]:=x_e;
                  y[j]:=y_e;
                  diep_em[j]:=diep_e;
                  nuff[j]:=nuff_e;
                  iall:=iall+nuff[j];
                end;
                for k:=oldiall to iall do
                begin
                  read(in_k014,in1_rec);
                  with in2_rec do
                  begin
                    kwdff[k]:=kwdff_e;
                    dff[k]:=dff_e;
                    oldiall:=iall+1;
                  end;
                end;
              until eof(in_k014);
              close(in_k014);
              i:=j;
              clrscr;
              wrt(25,12,240,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à  ');
              for metr:=1 to 500 do flag_e[metr]:=0;
              xyemp;
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
              wrt(22,12,240,'É à Ä Å Ä Ö ó   É Ñ É é ã Ñ å Ä..');
              reset(f);
              j:=0; iall:=0; oldiall:=1;
              repeat
                j:=j+1;
                readln(f,b1); kwdep[j]:=b1;
                readln(f,b2); val(b2,x[j],cod);
                readln(f,b3); val(b3,y[j],cod);
                readln(f,b4); val(b4,diep_em[j],cod);
                readln(f,b5); val(b5,nuff[j],cod);
                iall:=iall+nuff[j];
                for k:=oldiall to iall do
                begin
                  readln(f,b6); kwdff[k]:=b6;
                  readln(f,b7); val(b7,dff[k],cod);
                  oldiall:=iall+1;
                end;
              until eof(f);
              close(f);
              i:=j;
              clrscr;
              wrt(25,12,240,'  Ñ  ê  Ç  Ä  Ö  é  ã  Ä  à  ');
              for metr:=1 to 500 do flag_e[metr]:=0;
              xyemp;
            end;
            epex_menu;
          end;
        4:begin
            cursor(true,false);
            if ((sw1 <> 1) and (sw3 <> 1)) then
            begin
              cursor(false,true);
              wrt(13,21,112,' ÉEN EXó ÉEÉOMENA.  èÄíÜëÑ ÑåÄ èäÜâíêé.. ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            sw4:=1;
            seek(k014_scr,3);    read(k014_scr,rec1);
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
              gotoxy(13,21); read(filename);
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
              wrt(13,21,112,' ÉEN EXó ÉEÉOMENA.  èATHëE ENA èäHKTêO.. ');
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
              epex_menu;
            end;
          end;
        7:begin
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              clrscr;
              seek(k014_scr,4);    read(k014_scr,rec1);
              move(rec1.xx[0],mem[$b000:ofs1],3680);
              write_screen;
              cursor(false,true);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(13,21,112,' ÉEN EXó ÉEÉOMENA.  èATHëE ENA èäHKTêO.. ');
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
assign(k014_scr,'PEMP.scr');
reset(k014_scr);
seek(k014_scr,5); read(k014_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
pi:=arctan(1) * 4;
pii:=200 / pi;
delete_all_input;
sw1:=0; sw3:=0; sw4:=0; i:=0; sel:=0;
cursor(false,true);
epex_menu;
END.

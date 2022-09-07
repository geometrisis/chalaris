{****************************************************************************
*                      k008 ≈–…À’”« ‘’◊œÕ‘œ” ‘—…√ŸÕœ’                      *
*                    WRITTEN BY G.XALARIS                    *
*                              VERSION 1.02                                 *
*                               17-12-1986                                  *
*****************************************************************************}
type     rec = record
           xx:array [0..3679] of byte;
         end;
         rec1_k008 = record
           epil    :integer;
           pleva   :real;
           plevb   :real;
           plevc   :real;
         end;
         string40 = string [40];
         string255= string [255];

var      answer:integer;
         sa,sb,sc,pla,plb,plb1,plc,gwna,gwnb,gwnb1,gwnc,gwnc1,pi,emb:real;
         k008_scr :file of rec;
         rec1     :rec;
         ofs1, cod:integer;
         i,l,m,j  :integer;
         ar_gram  :integer;
         buff     :string40;
         bit, ok  :boolean;
         name,filename:string[66];
         fill:text;
         OthInp:array[1..3680] of byte;
         f:text;
         sepil:char;
         sb1,sb2,sb3:string[10];

         in_k008:file of rec1_k008;
         in1_rec:rec1_k008;
         sw,sw1,sw3,sw4:byte;
         cha:char;
         lep2:real;
   {$I wrt-mon.prc}
   {$I repstr.fnc}
   {$I udip.prc}
   {$I ad.fnc}
   {$I cursor.prc}
   {$i wrtscr.prc}
   {$i trig.fnc}

procedure delete_all_input;
begin
pla:=0; plb:=0; plc:=0; sa:=0; sb:=0; sc:=0; emb:=0; gwna:=0; gwnb:=0; gwnc:=0;
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
     seek(k008_scr,0);
     read(k008_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k008_scr);
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
                          #59:paint_box(4,21,6,38,112);
                          #60:paint_box(4,40,6,57,112);
                          #61:paint_box(8,21,10,38,112);
                          #62:paint_box(8,40,10,57,112);
                          #63:paint_box(12,21,14,38,112);
                          #64:paint_box(12,40,14,57,112);
                          #65:paint_box(16,21,18,38,112);
                    end;    { case }
                    menu:=ord(ch)-58;
                    exit;
                  end;
              #66:begin      { F8 }
                    clrscr;
                    close(k008_scr);
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
  '8','2',#72,#80:begin      { ArrUp , ArrDn }
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
     else
       for i:=3 to 6 do beep(i*500,50);
     goto 5;
end;

procedure embado(a,b,c:real; var e:real);
var       t:real;
begin
  t:=(a+b+c)/2.0;
  e:=sqrt(t*(t-a)*(t-b)*(t-c));
end;

procedure epex1;
begin
    gwnc:=200-(gwna+gwnb);
    plb:=plc*sin(gwnb*pi/200)/sin((gwna+gwnb)*pi/200);
    pla:=plc*sin(gwna*pi/200)/sin((gwna+gwnb)*pi/200);
    sw:=1;
end;
procedure epex2;
begin
    lep2:=sqrt((sqr(pla)-sqr(plb-plc))/(sqr(plb+plc)-sqr(pla)));
    gwna:=2*atan(lep2)*200/pi;
    gwnb:=asin(plb*sin(gwna*pi/200)/pla)*200/pi;
    gwnc:=asin(plc*sin(gwna*pi/200)/pla)*200/pi;
    sw:=2;
end;
procedure  epex3;
begin
    pla:=sqrt(sqr(plb)+sqr(plc)-2*plb*plc*cos(gwna*pi/200));
    gwnb:=asin(plb*sin(gwna*pi/200)/pla)*200/pi;
    gwnc:=asin(plc*sin(gwna*pi/200)/pla)*200/pi;
    sw:=3;
end;
procedure epex4;
begin
    gwnc:=200-(gwna+gwnb);
    plc:=pla*sin((gwna+gwnb)*pi/200)/sin(gwna*pi/200);
    plb:=plc*sin(gwnb*pi/200)/sin((gwna+gwnb)*pi/200);
    sw:=4;
end;
procedure epex5;
begin
    gwnc:=asin(plc*sin(gwna*pi/200)/pla)*200/pi;
    gwnc1:=200-gwnc; gwnb:=200-(gwna+gwnc); gwnb1:=200-(gwna+gwnc1);
    plb:=pla*sin(gwnb*pi/200)/sin(gwna*pi/200);
    plb1:=pla*sin(gwnb1*pi/200)/sin(gwna*pi/200);
    sw:=5;
end;

procedure inp;
label     10,20,30;
begin
10: input(buff,11,23,10,bit); val(buff,sa,cod);
20: input(buff,11,36,10,bit); if bit then goto 10 else val(buff,sb,cod);
30: input(buff,11,49,10,bit); if bit then goto 20 else val(buff,sc,cod);
end;

procedure apot1;
begin
  writeln(fill,'      è ä Ñ ì ê Ñ ë        Ç ó å à Ä');
  writeln(fill,'     Ä            Å            Ç');
  writeln(fill,'  ---------- ----------   -----------');
  writeln(fill,' ':2,pla:10:3,' ',plb:10:3,' ':3, gwnc:8:4);
end;
procedure apot2;
begin
  writeln(fill,'           Ç  ó  å  à  Ñ  ë ');
  writeln(fill,'     Ä            Å            Ç');
  writeln(fill,'  --------     --------     --------');
  writeln(fill,'  ',gwna:8:4,'     ',gwnb:8:4,'     ',gwnc:8:4);
end;
procedure apot3;
begin
  writeln(fill,' è ä Ñ ì ê Ä        Ç ó å à Ñ ë');
  writeln(fill,'     Ä            Å            Ç');
  writeln(fill,'  ----------    --------     --------');
  writeln(fill,'  ',pla:10:3,'    ',gwnb:8:4,'     ',gwnc:8:4);
end;
procedure apot4;
begin
  writeln(fill,'      è ä Ñ ì ê Ñ ë        Ç ó å à Ä ');
  writeln(fill,'     Å            Ç            Ç');
  writeln(fill,'   ----------     ----------    --------');
  writeln(fill,'   ',plb:10:3,'     ',plc:10:3,'    ':4,gwnc:8:4);
end;
procedure apot5;
begin
  writeln(fill,' è ä Ñ ì ê Ä        Ç ó å à Ñ ë');
  writeln(fill,'     Å            Å            Ç');
  writeln(fill,'  ----------    --------     --------');
  writeln(fill,'  ',plb:10:3,'    ',gwnb:8:4,'     ',gwnc:8:4);
  writeln(fill,'  ',plb1:10:3,'    ',gwnb1:8:4,'     ',gwnc1:8:4);
end;


procedure input_results_in_file;
var   k  :integer;
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
       wrt(9,23,15,'èêOëEXE ! TO AêXEIO AYTO YèAêXEI. åÄ ÇêAñó EèANó TOY; (N/O) : ');
       gotoxy(71,23); read(kbd,cha);
       if cha in ['O','o','é','¶'] then begin cursor(false,true); exit; end;
     end;
     clrscr; cursor(false,true);
     wrt(11,12,240,'  Ç ê Ä î ó   Ä è é í Ñ ä Ñ ë ã Ä í Ä   ë Ñ   Ä ê ï Ñ à é  ');
     EMBADO(pla,plb,plc,emb);
     rewrite(fill);
     writeln(fill,'=========================================');
     writeln(fill,'        ÑèàäìëÜ íìïéåíéë íêàÇóåéì        ');
     writeln(fill,'=========================================');
     writeln(fill);
     case answer of
       1:apot1;
       2:apot2;
       3:apot3;
       4:apot4;
       5:apot5;
     end;
     writeln(fill,'  ÑãÅÄÉé íêàÇóåéì : ',emb:4:3);
     close(fill);
end;

procedure anal_gr_scr1;
begin
  gotoxy(24,15); write(pla:10:3);   gotoxy(37,15); write(plb:10:3);
  gotoxy(52,15); writeln(gwnc:8:4);
end;
procedure anal_gr_scr2;
begin
  gotoxy(26,15); write(gwna:8:4);   gotoxy(39,15); write(gwnb:8:4);
  gotoxy(52,15); writeln(gwnc:8:4);
end;
procedure anal_gr_scr3;
begin
  gotoxy(24,15); write(pla:10:3);   gotoxy(39,15); write(gwnb:8:4);
  gotoxy(52,15); writeln(gwnc:8:4);
end;
procedure anal_gr_scr4;
begin
  gotoxy(24,15); write(plb:10:3);   gotoxy(37,15); write(plc:10:3);
  gotoxy(52,15); writeln(gwnc:8:4);
end;
procedure anal_gr_scr5;
begin
  gotoxy(24,15); write(plb:10:3);   gotoxy(39,15); write(gwnb:8:4);
  gotoxy(52,15); writeln(gwnc:8:4); gotoxy(24,16); write(plb1:10:3);
  gotoxy(39,16); write(gwnb1:8:4);  gotoxy(52,16); writeln(gwnc1:8:4);
end;

procedure write_screen;
begin
  clrscr;
  seek(k008_scr,3);    read(k008_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  embado(pla,plb,plc,emb);
  case answer of
    1:begin
        gotoxy(47,4); writeln('—');
        gotoxy(29,5); writeln('Ç ó å à Ñ ë       ≥è ä Ñ ì ê Ä ');
        gotoxy(27,6); write('Ä'); gotoxy(40,6); write('Å');
        gotoxy(53,6); write('Ç'); gotoxy(26,8); write(gwna:8:4);
        gotoxy(39,8); write(gwnb:8:4); gotoxy(50,8); write(plc:10:3);
        gotoxy(47,11); writeln('—');
        gotoxy(28,12); writeln('è ä Ñ ì ê Ñ ë      ≥ Ç ó å à Ä ');
        gotoxy(27,13); writeln('Ä'); gotoxy(40,13); writeln('Å');
        gotoxy(53,13); writeln('Ç'); anal_gr_scr1;
      end;
    2:begin
        gotoxy(31,5); writeln('è  ä  Ñ  ì  ê  Ñ  ë ');
        gotoxy(27,6); write('Ä'); gotoxy(40,6); write('Å');
        gotoxy(53,6); write('Ç'); gotoxy(24,8); write(pla:10:3);
        gotoxy(37,8); write(plb:10:3); gotoxy(50,8); write(plc:10:3);
        gotoxy(33,12); writeln('Ç  ó  å  à  Ñ  ë ');
        gotoxy(27,13); writeln('Ä'); gotoxy(40,13); writeln('Å');
        gotoxy(53,13); writeln('Ç'); anal_gr_scr2;
      end;
    3:begin
        gotoxy(34,4); writeln('—');
        gotoxy(24,5); writeln('Ç ó å à Ä ≥      è ä Ñ ì ê Ñ ë  ');
        gotoxy(27,6); write('Ä'); gotoxy(40,6); write('Å');
        gotoxy(53,6); write('Ç'); gotoxy(26,8); write(gwna:8:4);
        gotoxy(37,8); write(plb:10:3); gotoxy(50,8); write(plc:10:3);
        gotoxy(34,11); writeln('—');
        gotoxy(23,12); writeln('è ä Ñ ì ê Ä≥       Ç ó å à Ñ ë ');
        gotoxy(27,13); writeln('Ä'); gotoxy(40,13); writeln('Å');
        gotoxy(53,13); writeln('Ç'); anal_gr_scr3;
      end;
    4:begin
        gotoxy(34,4); writeln('—');
        gotoxy(23,5); writeln('è ä Ñ ì ê Ä≥      Ç ó å à Ñ ë  ');
        gotoxy(27,6); write('Ä'); gotoxy(40,6); write('Ä');
        gotoxy(53,6); write('Å'); gotoxy(24,8); write(pla:10:3);
        gotoxy(37,8); write(gwna:8:4); gotoxy(52,8); write(gwnb:8:4);
        gotoxy(47,11); writeln('—');
        gotoxy(28,12); writeln('è ä Ñ ì ê Ñ ë      ≥ Ç ó å à Ä ');
        gotoxy(27,13); writeln('Å'); gotoxy(40,13); writeln('Ç');
        gotoxy(53,13); writeln('Ç'); anal_gr_scr4;
      end;
    5:begin
        gotoxy(34,4); writeln('—');
        gotoxy(24,5); writeln('Ç ó å à Ä ≥      è ä Ñ ì ê Ñ ë  ');
        gotoxy(27,6); write('A'); gotoxy(40,6); write('Ä');
        gotoxy(53,6); write('Ç'); gotoxy(26,8); write(gwna:8:4);
        gotoxy(37,8); write(pla:10:3); gotoxy(50,8); write(plc:10:3);
        gotoxy(34,11); writeln('—');
        gotoxy(23,12); writeln('è ä Ñ ì ê Ä≥       Ç ó å à Ñ ë ');
        gotoxy(27,13); writeln('Å'); gotoxy(40,13); writeln('Å');
        gotoxy(53,13); writeln('Ç'); anal_gr_scr5;
        gotoxy(21,16); write('≥'); gotoxy(34,16); write('≥');
        gotoxy(47,16); write('≥'); gotoxy(60,16); writeln('≥');
      end;
  end;
  writeln(' ':20,'‘ÕÕÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕæ');
  IF answer <> 5 then gotoxy(24,17) else gotoxy(24,18);
  write('Ñ ã Å Ä É é = ',emb:4:3);
  wrt(19,20,143,'ÇàÄ ëìåÑïÑàÄ ëíé MENU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure lprint;
begin
  rewrite(fill);
  writeln(fill,'=========================================');
  writeln(fill,'        ÑèàäìëÜ íìïéåíéë íêàÇóåéì        ');
  writeln(fill,'=========================================');
  writeln(fill); embado(pla,plb,plc,emb);
  case answer of
       1:apot1;
       2:apot2;
       3:apot3;
       4:apot4;
       5:apot5;
  end;
  writeln(fill,'  ÑãÅÄÉé íêàÇóåéì : ',emb:4:3);
  close(fill);
end;

procedure epex_menu;
var  j,k:byte;
     ok :boolean;
label    e1,e2,e3,e4;
begin
     case menu of
        1:begin
            clrscr;
            cursor(true,false);
            seek(k008_scr,1);     read(k008_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            DELETE_ALL_INPUT;
e1:         input(buff,18,18,2,bit);
            if ad then goto  e1 else val(buff,answer,cod);
            if not (answer in [1..5]) then goto e1;
            clrscr;
            seek(k008_scr,2);   read(k008_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            wrt(23,6,15,'Ñ à ë Ä Ç ó Ç Ü    É Ñ É é ã Ñ å ó å');
            case answer of
              1:begin
                  gotoxy(47,7); writeln('¬');
                  gotoxy(29,8); writeln('Ç ó å à Ñ ë       ≥è ä Ñ ì ê Ä ');
                  gotoxy(27,9); write('Ä'); gotoxy(40,9); write('Å');
                  gotoxy(53,9); write('Ç');
                  inp; gwna:=sa; gwnb:=sb; plc:=sc; epex1;
                end;
              2:begin
                  gotoxy(31,8); writeln('è  ä  Ñ  ì  ê  Ñ  ë ');
                  gotoxy(27,9); write('Ä'); gotoxy(40,9); write('Å');
                  gotoxy(53,9); write('Ç'); inp;
                  pla:=sa; plb:=sb; plc:=sc; epex2;
                end;
              3:begin
                  gotoxy(34,7); writeln('¬');
                  gotoxy(24,8); writeln('Ç ó å à Ä ≥      è ä Ñ ì ê Ñ ë  ');
                  gotoxy(27,9); write('Ä'); gotoxy(40,9); write('Å');
                  gotoxy(53,9); write('Ç'); inp;
                  gwna:=sa; plb:=sb; plc:=sc; epex3;
                end;
              4:begin
                  gotoxy(34,7); writeln('¬');
                  gotoxy(23,8); writeln('è ä Ñ ì ê Ä≥      Ç ó å à Ñ ë  ');
                  gotoxy(27,9); write('Ä'); gotoxy(40,9); write('Ä');
                  gotoxy(53,9); write('Å'); inp;
                  pla:=sa; gwna:=sb; gwnb:=sc; epex4;
                end;
              5:begin
                  gotoxy(34,7); writeln('¬');
                  gotoxy(24,8); writeln('Ç ó å à Ä ≥      è ä Ñ ì ê Ñ ë  ');
                  gotoxy(27,9); write('Ä'); gotoxy(40,9); write('Ä');
                  gotoxy(53,9); write('Ç'); inp;
                  gwna:=sa; pla:=sb; plc:=sc; epex5;
                end;
            end;
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
              assign(in_k008,name);
              {$i-}
              reset(in_k008);
              {$i+}
              ok:=(ioresult=0);
              if ok then
              begin
                gotoxy(2,23);
                write('èêéëÑïÑ ! íé ÄêïÑàé Äìíé ìèÄêïÑà. åÄ ÇêÄñó ÑèÄåó íéì; (å/é) : ');
                read(kbd,cha);
                if cha in ['O','o','é','¶'] then
                begin
                  cursor(false,true);
                  epex_menu;
                end;
              end;
              clrscr;
              cursor(false,true);
              wrt(11,12,240,'  â Ä í Ä ï ó ê ó   É Ñ É é ã Ñ å Ä   ë Ñ   Ä ê ï Ñ à é  ');
              rewrite(in_k008);
              with in1_rec do
              begin
                epil :=answer; pleva:=sa; plevb:=sb; plevc:=sc;
                write(in_k008,in1_rec);
              end;
              close(in_k008);
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ÉEN EKANEë EIëAÇóÇH ÉEÉOMENóN.  èÄíÜëÑ ÑåÄ èäÜâíêé..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
            end;
            epex_menu;
          end;
        3:begin
            cursor(true,false);
            wrt(1,20,15,'TO AêXEIO AYTO EINAI ÉHMIOYêÇÜMENO ME EDITOR "H ME TO èäHKTêO F2; (E/F): ');
            gotoxy(73,20); read(cha);
            wrt_screen(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            delete_all_input;
            if cha in ['F','f','î','≠'] then
            begin
              assign(in_k008,filename);
              {$i-}
              reset(in_k008);
              {$i+}
              ok:=(ioresult=0);
              if not ok then
              begin
                cursor(false,true);
                wrt(12,23,240,'  èêOëEXE !   TO AêXEIO AYTO ÉEN YèAêXEI. èATHëE ENA èäHKTêO..  ');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  É à Ä Å Ä Ö ó   É Ñ É é ã Ñ å Ä..  ');
              reset(in_k008);
              seek(in_k008,0);   read(in_k008,in1_rec);
              with in1_rec do
              begin
                answer:=epil; sa:=pleva; sb:=plevb; sc:=plevc;
                case answer of
                  1:begin gwna:=pleva; gwnb:=plevb; plc:=plevc; epex1; end;
                  2:begin pla:=pleva; plb:=plevb; plc:=plevc; epex2; end;
                  3:begin gwna:=pleva; plb:=plevb; plc:=plevc; epex3; end;
                  4:begin pla:=pleva; gwna:=plevb; gwnb:=plevc; epex4; end;
                  5:begin gwna:=pleva; pla:=plevb; plc:=plevc; epex5; end;
                end;
              end;
              close(f);
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
                cursor(false,true);
                wrt(12,23,240,'  èêOëEXE !   TO AêXEIO AYTO ÉEN YèAêXEI. èATHëE ENA èäHKTêO..  ');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  É à Ä Å Ä Ö ó   É Ñ É é ã Ñ å Ä..  ');
              reset(f);
              readln(f,sepil); val(sepil,answer,cod);
              readln(f,sb1); val(sb1,sa,cod); readln(f,sb2); val(sb2,sb,cod);
              readln(f,sb3); val(sb3,sc,cod);
              case answer of
                1:begin gwna:=sa; gwnb:=sb; plc:=sc; epex1; end;
                2:begin pla:=sa; plb:=sb; plc:=sc; epex2; end;
                3:begin gwna:=sa; plb:=sb; plc:=sc; epex3; end;
                4:begin pla:=sa; gwna:=sb; gwnb:=sc; epex4; end;
                5:begin gwna:=sa; pla:=sb; plc:=sc; epex5; end;
              end;
            close(f);
            end;
            epex_menu;
          end;
        4:begin
            if ((sw1 <> 1) and (sw3 <> 1)) then
            begin
              wrt(19,21,240,'  ÉEN EXó ÉEÉOMENA. èÄíÜëÑ ÑåÄ èäÜâíêé..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto e4;
            end;
            cursor(true,false);
            sw4:=1;
            seek(k008_scr,2);    read(k008_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            wrt(23,6,15,' É à é ê á ó ë Ü   É Ñ É é ã Ñ å ó å');
            case answer of
              1:begin
                  gotoxy(47,7); writeln('¬');
                  gotoxy(29,8); writeln('Ç ó å à Ñ ë       ≥è ä Ñ ì ê Ä ');
                  gotoxy(27,9); write('Ä'); gotoxy(40,9); write('Å');
                  gotoxy(53,9); write('Ç'); gotoxy(24,11); write(gwna:5:4);
                  gotoxy(37,11); write(gwnb:5:4); gotoxy(50,11); write(plc:4:3);
                end;
              2:begin
                  gotoxy(31,8); writeln('è  ä  Ñ  ì  ê  Ñ  ë ');
                  gotoxy(27,9); write('Ä'); gotoxy(40,9); write('Å');
                  gotoxy(53,9); write('Ç'); gotoxy(24,11); write(pla:4:3);
                  gotoxy(37,11); write(plb:4:3); gotoxy(50,11); write(plc:4:3);
                end;
              3:begin
                  gotoxy(34,7); writeln('¬');
                  gotoxy(24,8); writeln('Ç ó å à Ä ≥      è ä Ñ ì ê Ñ ë  ');
                  gotoxy(27,9); write('Ä'); gotoxy(40,9); write('Å');
                  gotoxy(53,9); write('Ç'); gotoxy(24,11); write(gwna:5:4);
                  gotoxy(37,11); write(plb:4:3); gotoxy(50,11); write(plc:4:3);
                end;
              4:begin
                  gotoxy(34,7); writeln('¬');
                  gotoxy(23,8); writeln('è ä Ñ ì ê Ä≥      Ç ó å à Ñ ë  ');
                  gotoxy(27,9); write('A'); gotoxy(40,9); write('A');
                  gotoxy(53,9); write('B'); gotoxy(24,11); write(pla:4:3);
                  gotoxy(37,11); write(gwna:5:4); gotoxy(50,11); write(gwnb:5:4);
                end;
              5:begin
                  gotoxy(34,7); writeln('¬');
                  gotoxy(24,8); writeln('Ç ó å à Ä ≥      è ä Ñ ì ê Ñ ë  ');
                  gotoxy(27,9); write('A'); gotoxy(40,9); write('A');
                  gotoxy(53,9); write('Ç'); gotoxy(24,11); write(gwna:5:4);
                  gotoxy(37,11); write(pla:4:3); gotoxy(50,11); write(plc:4:3);
                end;
            end;
e2:         input(buff,11,23,10,bit); val(buff,sa,cod);
e3:         input(buff,11,36,10,bit); if bit then goto e2 else val(buff,sb,cod);
            input(buff,11,49,10,bit); if bit then goto e3 else val(buff,sc,cod);
            case answer of
              1:begin gwna:=sa; gwnb:=sb; plc:=sc; epex1; end;
              2:begin pla:=sa; plb:=sb; plc:=sc; epex2; end;
              3:begin gwna:=sa; plb:=sb; plc:=sc; epex3; end;
              4:begin pla:=sa; gwna:=sb; gwnb:=sc; epex4; end;
              5:begin gwna:=sa; pla:=sb; plc:=sc; epex5; end;
            end;
e4:         cursor(false,true);
            clrscr;
            epex_menu;
          end;
        5:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              input_results_in_file;
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(19,21,240,'  ÉEN EXó ÉEÉOMENA. èATHëE ENA èäHKTêO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
        6:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              cursor(false,true);
              assign(fill,'prn');
              clrscr;
              wrt(26,12,240,'   Ñ  â  í  ì  è  ó  å  ó..   ');
              lprint;
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(19,21,240,'  ÉEN EXó ÉEÉOMENA. èATHëE ENA èäHKTêO..  ');
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
              write_screen;
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(19,21,240,'  ÉEN EXó ÉEÉOMENA. èATHëE ENA èäHKTêO..  ');
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
assign(k008_scr,'TRIG.scr');
reset(k008_scr);
seek(k008_scr,4); read(k008_scr,rec1);
for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
delete_all_input;
pi:=arctan(1)*4; sw1:=0; sw3:=0; sw4:=0; i:=0;
cursor(false,true);
epex_menu;
END.

{******************************************************************************
*                k002 ÁÍÁËÕÔÉÊÏÓ ÕĞÏËÏÃÉÓÌÏÓ ÅÌÂÁÄÏÕ ĞÏËÕÃÙÍÏÕ               *
*                     WRITTEN BY G.XALARIS                                                           *
*                               VERSION   1.02                                                              *
*                                 09-12-1986                                                                 *
*******************************************************************************}
program  k002;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k002 =record
           kwdik   :string[5];
           tet     :real;
           teta    :real;
         end;
         string40 =string[40];
         string255=string[255];

var      x,y,ss:array [1..500] of real;
         kwd: array [1..500] of string[5];
         dx,dy,de,e,diaf:real;
         OthInp,OthPrint:array[1..3680] of byte;
         k002_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l,m,j :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f :text;
         b1:string[5]; b2:string[10]; b3:string[11];

         in_k002 :file of rec1_k002;
         in1_rec :rec1_k002;
         sw1,sw3,sw4:byte;
         cha     :char;
         grammi_inp,sel,gram,scr_line1,k1:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
  e:=0;  fillchar(x,sizeof(x),0);
  fillchar(y,sizeof(y),0); fillchar(ss,sizeof(ss),0);
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
     seek(k002_scr,0);
     read(k002_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         close(k002_scr);
         clrscr;
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
                    close(k002_scr);
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

procedure epex;
begin
  for j := 1 to i do
  begin
    if j = i then begin kwd[j+1]:=kwd[1]; x[j+1]:=x[1]; y[j+1]:=y[1]; end;
    dx:=x[j+1]-x[j]; dy:=y[j+1]-y[j];
    ss[j]:=sqrt(sqr(dx) + sqr(dy));
    e:=e+(y[j+1]-y[j])*(x[j+1]+x[j])/2;
  end;
  e:=-e; e:=abs(e);
end;

procedure inp(var l,grammi_inp:integer);
label     i1,10,20;
begin
    gotoxy(22,grammi_inp); write(l:3);
i1: input(buff,grammi_inp,28,6.1,bit); kwd[l]:=buff;
10: input(buff,grammi_inp,36,11,bit);
    if bit then goto i1 else val(buff,x[l],cod);
20: input(buff,grammi_inp,49,12,bit);
    if bit then goto 10 else val(buff,y[l],cod);
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
       wrt(2,23,15,'      O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) : ');
       gotoxy(71,23); read(kbd,cha);
       if cha in ['O','o','','¦'] then
       begin
         cursor(false,true);
         exit;
       end;
     end;
     clrscr;
     cursor(false,true);
     wrt(11,12,240,'  ‚  € ” —   €   ’ „ Š „ ‘ ‹ € ’ €   ‘ „   €  • „ ˆ   ');
     rewrite(fill);
     writeln(fill,'===========================================================================');
     writeln(fill,'        € Œ € Š “ ’ ˆ ‰  ‘   “   Š  ‚ ˆ ‘ ‹  ‘   „ ‹  € ƒ  “');
     writeln(fill,'===========================================================================');
     writeln(fill);
     writeln(fill,'               „‹€ƒ  Š“‚—Œ“ : ',e:3:3);
     writeln(fill);
     writeln(fill,' €        ‘  †  ‹  „  ˆ             ‘    ‘  †  ‹  „  ˆ      €‘’€‘†');
     writeln(fill,'‰—ƒˆ‰‘  ’„’‹†‹„Œ†   ’„’€‚‹„Œ†   ‰—ƒˆ‰‘  ’„’‹†‹„Œ†   ’„’€‚‹„Œ†     ‘†‹„ˆ—Œ');
     writeln(fill,'------------------------------   ------------------------------    --------');
     writeln(fill);
     for l:=1 to i do
     begin
       writeln(fill,' ',kwd[l],' ':6-length(kwd[l]),
                    ' ',x[l]:10:3,' ',y[l]:11:3,
                    '    ',kwd[l+1],' ':6-length(kwd[l+1]),
                    ' ',x[l+1]:10:3,' ',y[l+1]:11:3,'  ',ss[l]:10:3);
     end;
     close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(5,grammi);  write(kwd[k]);     gotoxy(12,grammi); write(x[k]:10:3);
  gotoxy(23,grammi); write(y[k]:11:3);  gotoxy(37,grammi); write(kwd[k+1]);
  gotoxy(44,grammi); write(x[k+1]:10:3);gotoxy(55,grammi); write(y[k+1]:11:3);
  gotoxy(69,grammi); write(ss[k]:10:3);
end;

procedure write_screen(var scr_line,k1:integer);
var k:integer;
begin
  clrscr;
  seek(k002_scr,3);    read(k002_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  gotoxy(42,4);    write(e:3:3);
  scr_line:=9;
  for k:=1 to i do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 22 then
    begin
      wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      gotoxy(42,4);    write(e:3:3);
      scr_line:=9;
    end;
  end;
  wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure epikef;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
  writeln(fill,'===========================================================================');
  writeln(fill,'        € Œ € Š “ ’ ˆ ‰  ‘   “   Š  ‚ ˆ ‘ ‹  ‘   „ ‹  € ƒ  “');
  writeln(fill,'===========================================================================');
  writeln(fill);
  writeln(fill,'               „‹€ƒ  Š“‚—Œ“ : ',e:3:3);
  writeln(fill);
  writeln(fill,' €        ‘  †  ‹  „  ˆ             ‘    ‘  †  ‹  „  ˆ      €‘’€‘†');
  writeln(fill,'‰—ƒˆ‰‘  ’„’‹†‹„Œ†   ’„’€‚‹„Œ†   ‰—ƒˆ‰‘  ’„’‹†‹„Œ†   ’„’€‚‹„Œ†     ‘†‹„ˆ—Œ');
  writeln(fill,'------------------------------   ------------------------------    --------');
end;

procedure lprint;
var       k:integer;
begin
  rewrite(fill);
  epikef;
  gram:=12;
  for l:=1 to i do
  begin
    writeln(fill);
    writeln(fill,' ',kwd[l],' ':6-length(kwd[l]),
                 ' ',x[l]:10:3,' ',y[l]:11:3,
                 '    ',kwd[l+1],' ':6-length(kwd[l+1]),
                 ' ',x[l+1]:10:3,' ',y[l+1]:11:3,'  ',ss[l]:10:3);
    gram:=gram + 2;
    if gram >= ar_gram - 4 then
    begin
      writeln(fill); writeln(fill); writeln(fill); writeln(fill);
      epikef; gram:=12;
    end;
  end;
  close(fill);
end;

procedure epex_menu;
var  j,k:byte;
     ok :boolean;
label    e1,e2,e3,e4,e5;
begin
     case menu of
        1:begin
            if ((sw1=1) or (sw3=1)) then epex_menu;
            cursor(true,false);
            wrt(16,22,15,'ƒ—‘„ €ˆ‡‹ ‰“”—Œ Š“‚—Œ“ : ');
e1:         gotoxy(48,22);   read(i);
            if ad then goto e1;
            clrscr;
            seek(k002_scr,1);     read(k002_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            l:=0;
            grammi_inp:=7;
            repeat
              if grammi_inp = 23 then
              begin
                move(rec1.xx[0],mem[$b000:ofs1],3680);
                grammi_inp:=7;
              end;
              l:=l + 1;
              inp(l,grammi_inp);
              grammi_inp:=grammi_inp + 1;
            until l = i;
            e:=0;
            epex;
            sw1:=1;
            clrscr;
            cursor(false,true);
            epex_menu;
          end;
        2:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              wrt_screen(OthInp,1,20,80,22);
              gotoxy(13,21); read(name);
              assign(in_k002,name);
              {$i-}
              reset(in_k002);
              {$i+}
              ok:=(ioresult=0);
              if ok then
              begin
                gotoxy(2,23); write('‘„•„ ! ’ €•„ˆ €“’ “€•„ˆ. Œ€ ‚€–— „€Œ— ’“; (Œ/) : ');
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
              rewrite(in_k002);
              j:=0;
              repeat
                j:=j+1;
                with in1_rec do
                begin
                  kwdik:=kwd[j]; tet:=x[j]; teta:=y[j]; write(in_k002,in1_rec);
                end;
              until j = i;
              close(in_k002);
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
            wrt(1,20,15,'TO AXEIO AYTO EINAI ƒHMIOY‚†MENO ME EDITOR "H ME TO ŠHKTO F2; (E/F): ');
            gotoxy(73,20);    read(cha);
            wrt_screen(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k002,filename);
              {$i-}
              reset(in_k002);
              {$i+}
              ok:=(ioresult=0);
              if not ok then
              begin
                cursor(false,true);
                wrt(12,23,240,'  O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..  ');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..  ');
              reset(in_k002);
              seek(in_k002,0);
              l:=0;
              repeat
                l:=l+1;
                read(in_k002,in1_rec);
                with in1_rec do begin kwd[l]:=kwdik; x[l]:=tet; y[l]:=teta; end;
              until  eof(in_k002);
              e:=0;
              i:=l;
              epex;
              close(in_k002);
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
                wrt(12,23,240,'  O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..  ');
                repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
                epex_menu;
              end;
              sw3:=1;
              clrscr;
              cursor(false,true);
              wrt(20,12,240,'  ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..  ');
              reset(f);
              j:=0;
              repeat
                j:=j+1; readln(f,b1); kwd[j]:=b1;
                readln(f,b2); val(b2,x[j],cod); readln(f,b3); val(b3,y[j],cod);
              until eof(f);
              i:=j;
              e:=0;
              epex;
              close(f);
            end;
            epex_menu;
          end;
        4:begin
            if ((sw1 <> 1) and (sw3 <> 1)) then
            begin
              wrt(19,21,240,'  ƒEN EX— ƒEƒOMENA. €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto e2;
            end;
            cursor(true,false);
            sw4:=1;
            seek(k002_scr,2);    read(k002_scr,rec1);
            repeat
e5:           move(rec1.xx[0],mem[$b000:ofs1],3680);
              gotoxy(57,15); read(j);
              if j > i then
              begin
                wrt(10,23,112,' ‘„•„!! ƒ„Œ “€•„ˆ €“’† † ‰“”†. €’†‘„ „Œ€ Š†‰’.. ');
                repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
                goto e5;
              end;
              gotoxy(25,11); write(j:1);
              gotoxy(34,11); write(x[j]:4:3);
              gotoxy(48,11); write(y[j]:4:3);
e2:           input(buff,11,33,11,bit);
              val(buff,x[j],cod);
              input(buff,11,47,12,bit);
              if bit then goto e2 else val(buff,y[j],cod);
              wrt(29,18,15,'€ŠŠ† ƒˆ‡—‘†; (N/O): ');
              gotoxy(51,18); read(kbd,cha);
            until cha in['o','O'];
            e:=0;
            epex;
e3:         cursor(false,true);
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
e4:           wrt_screen(OthPrint,1,4,45,17);
              gotoxy(32,13); read(ar_gram);
              if ad then goto e4;
              cursor(false,true);
              wrt(3,15,15,'„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘');
              wrt(10,16,15,'€’†‘„ RETURN ‚ˆ€ „‰’“—‘†');
              repeat read(kbd,cha) until cha in [#10,#13];
              assign(fill,'prn');
              clrscr;
              wrt(26,12,240,'   „  ‰  ’  “    —  Œ  —..   ');
              lprint;
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
              cursor(false,true); scr_line1:=7; k1:=1;
              write_screen(scr_line1,k1); epex_menu;
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
assign(k002_scr,'EMBADO.scr');
reset(k002_scr);
seek(k002_scr,4); read(k002_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;    gram:=0;
delete_all_input;
cursor(false,true);
epex_menu;
END.

{******************************************************************************
*         K028 ÁÍÁÃÙÃÇ ÓÔÏ ÅËËÅÉØÏÅÉÄÅÓ ÁĞÏÓÔÁÓÅÙÍ ÌÅÔÑÇÌÅÍÙÍ ÌÅ              *
*                         ÇËÅÊÔÑÏÏĞÔÉÊÁ  ÏÑÃÁÍÁ                                             *
*                                                                             *
*                  WRITTEN BY G.XALARIS                         *
*                                                                             *
*                              19-01-1987                                     *
*******************************************************************************}
program  k028;

type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k028=record
           kwd1_o :string[4];
           h1_o   :real;
           kwd2_o :string[4];
           h2_o   :real;
           synt_o :real;
           dm_o   :real;
         end;
         string40 =string[40];
         string255=string[255];

var      h1,h2,synt,dm,s1,s2,s3,s4,stel    :array [1..500] of real;
         kwd1,kwd2                         :array [1..500] of string[4];
         k028_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;
         OthInp,OthPrint:array[1..3680] of byte;
         f                   :text;
         b1_o,b2_o,b3_o,
         b4_o,b5_o,b6_o      :string[13];

         in_k028 :file of rec1_k028;
         in1_rec :rec1_k028;

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

const    r = 6373882.0;

procedure delete_all_input;
begin
    fillchar(kwd1,sizeof(kwd1),' ');
    fillchar(h1,sizeof(h1),0);
    fillchar(kwd2,sizeof(kwd2),' ');
    fillchar(h2,sizeof(h2),0);
    fillchar(synt,sizeof(synt),0);
    fillchar(dm,sizeof(dm),0);
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
     seek(k028_scr,0);     read(k028_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k028_scr);
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
                    close(k028_scr);
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
    s1[j]:= -((2 * synt[j] - sqr(synt[j])) * (sqr(synt[j]) * synt[j])) / (24 * sqr(r));
    s2[j]:= -(sqr(h2[j] - h1[j])) / (2 * dm[j]);
    s3[j]:= -((h1[j] + h2[j]) * dm[j]) / (2 * r);
    s4[j]:=(sqr(dm[j]) * dm[j]) / (24 * sqr(r));
    stel[j]:=dm[j] + s1[j] + s2[j] + s3[j] + s4[j];
end;

procedure display_data(j:byte);
begin
  wrt(10,12,15,'    ');
  gotoxy(10,12);    write(kwd1[j]);
  wrt(18,12,15,'         ');
  gotoxy(18,12);    write(h1[j]:3:3);
  wrt(31,12,15,'    ');
  gotoxy(31,12);    write(kwd2[j]);
  wrt(39,12,15,'         ');
  gotoxy(39,12);    write(h2[j]:3:3);
  wrt(52,12,15,'     ');
  gotoxy(52,12);    write(synt[j]:3:2);
  wrt(64,12,15,'          ');
  gotoxy(64,12);    write(dm[j]:4:3);
end;

procedure inp;
var       grammi_in:byte;
label     i1,i2,i3,i4,i5,i6;
begin
     l:=1;
     grammi_in:=7;
     while l <= i do
     begin
i1:    input(buff,grammi_in,9,5.1,bit);
         kwd1[l]:=buff;
i2:    input(buff,grammi_in,17,9,bit);
       if bit then goto i1
         else val(buff,h1[l],cod);
i3:    input(buff,grammi_in,30,5.1,bit);
       if bit then goto i2
         else kwd2[l]:=buff;
i4:    input(buff,grammi_in,38,9,bit);
       if bit then goto i3
         else val(buff,h2[l],cod);
       wrt(52,grammi_in,15,'0.13');
       val('0.13',synt[l],cod);
i5:    input(buff,grammi_in,51,5,bit);
       if bit then goto i4
         else val(buff,synt[l],cod);
i6:    input(buff,grammi_in,63,10,bit);
       if bit then goto i5
         else val(buff,dm[l],cod);
       epex(l);
       l:=succ(l);
       grammi_in:=grammi_in + 1;
       if (grammi_in = 23) then
       begin
         move(rec1.xx[0],mem[$b000:ofs1],3680);
         grammi_in:=7;
       end;
     end;
end;


procedure diorth;
label     i1,i2,i3,i4,i5,i6;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,12,9,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data(l);
           goto i6;
         end
         else begin end
       else kwd1[l]:=buff;
i2:    input(buff,12,17,9,bit);
       if bit then goto i1
         else val(buff,h1[l],cod);
i3:    input(buff,12,30,5.1,bit);
       if bit then goto i2
         else kwd2[l]:=buff;
i4:    input(buff,12,38,9,bit);
       if bit then goto i3
         else val(buff,h2[l],cod);
i5:    input(buff,12,51,5,bit);
       if bit then goto i4
         else val(buff,synt[l],cod);
i6:    input(buff,12,63,10,bit);
       if bit then goto i5
         else val(buff,dm[l],cod);
       epex(l);
       l:=succ(l);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
     end;
end;


procedure input_results_in_file;
var   k  :integer;
begin
  rewrite(fill);
  writeln(fill,'============================================================================');
  writeln(fill,'       “   Š  ‚ ˆ ‘ ‹  ‘    € Œ † ‚ ‹ „ Œ † ‘    €   ‘ ’ € ‘ † ‘');
  writeln(fill,'============================================================================');
  writeln(fill,'  ‘†‹„ˆ                                                          €’„Š„‘‹€');
  writeln(fill,'€  ‘       „  ˆ    ‹ „   “ ‘    ƒ ˆ   ‡ — ‘ „ ˆ ‘        €Œ€‚—‚†‘');
  writeln(fill,'--------- ------------- ------------- ------------- ------------- ----------');
               {**** **** ************* ************* ************* ************* **********}
  for k:=1 to i do
  begin
    writeln(fill,kwd1[k],' ':5-length(kwd1[k]),kwd2[k],' ':5-length(kwd2[k]),
            s1[k]:13,' ',s2[k]:13,' ',s3[k]:13,' ',s4[k]:13,' ',stel[k]:10:3);
  end;
  close(fill);
end;


procedure anal_gr_scr(grammi,k:integer);
begin
    gotoxy(2,grammi);    write(kwd1[k]);
    gotoxy(7,grammi);    write(kwd2[k]);
    gotoxy(12,grammi);    write(s1[k]:13);
    gotoxy(26,grammi);    write(s2[k]:13);
    gotoxy(40,grammi);    write(s3[k]:13);
    gotoxy(55,grammi);    write(s4[k]:13);
    gotoxy(70,grammi);    write(stel[k]:10:3);
end;


procedure write_screen(m,scr_line:integer);
var   k:integer;
begin
  clrscr;
  seek(k028_scr,2);    read(k028_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  scr_line:=7;
  for k:=1 to m do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 22 then
    begin
      if k=i then
      begin
        wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
        repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
        move(rec1.xx[0],mem[$b000:ofs1],3680);
        exit;
      end;
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
  writeln(fill,'============================================================================');
  writeln(fill,'       “   Š  ‚ ˆ ‘ ‹  ‘    € Œ † ‚ ‹ „ Œ † ‘    €   ‘ ’ € ‘ † ‘');
  writeln(fill,'============================================================================');
  writeln(fill);
  writeln(fill,'  ‘†‹„ˆ                                                          €’„Š„‘‹€');
  writeln(fill,'€  ‘       „  ˆ    ‹ „   “ ‘    ƒ ˆ   ‡ — ‘ „ ˆ ‘        €Œ€‚—‚†‘');
  writeln(fill,'--------- ------------- ------------- ------------- ------------- ----------');
end;


procedure lprint;
var   sel,gram,k:integer;
begin
  epikef;
  gram:=10;
  for k:=1 to i do
  begin
    writeln(fill);
    writeln(fill,kwd1[k],' ':5-length(kwd1[k]),kwd2[k],' ':5-length(kwd2[k]),
            s1[k]:13,' ',s2[k]:13,' ',s3[k]:13,' ',s4[k]:13,' ',stel[k]:10:3);
    gram:=gram + 2;
    if gram >= ar_gram - 3 then
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
            seek(k028_scr,1);    read(k028_scr,rec1);
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
              assign(in_k028,name);
              {$i-}
              reset(in_k028);
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
              rewrite(in_k028);
              j:=0;
              repeat
                j:=j+1;
                with in1_rec do
                begin
                  kwd1_o:=kwd1[j]; h1_o:=h1[j];
                  kwd2_o:=kwd2[j]; h2_o:=h2[j];
                  synt_o:=synt[j]; dm_o:=dm[j];
                end;
                write(in_k028,in1_rec);
              until j = i;
              close(in_k028);
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
            gotoxy(13,21); read(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k028,filename);
              {$i-}
              reset(in_k028);
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
              reset(in_k028);
              seek(in_k028,0);
              j:=0;
              repeat
                j:=j+1;
                read(in_k028,in1_rec);
                with in1_rec do
                begin
                  kwd1[j]:=kwd1_o; h1[j]:=h1_o;
                  kwd2[j]:=kwd2_o; h2[j]:=h2_o;
                  synt[j]:=synt_o; dm[j]:=dm_o;
                end;
                epex(j);
              until eof(in_k028);
              i:=j;
              close(in_k028);
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
                readln(f,b2_o);    val(b2_o,h1[j],cod);
                readln(f,b3_o);    kwd2[j]:=b3_o;
                readln(f,b4_o);    val(b4_o,h2[j],cod);
                readln(f,b5_o);    val(b5_o,synt[j],cod);
                readln(f,b6_o);    val(b6_o,dm[j],cod);
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
            seek(k028_scr,3);    read(k028_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            diorth;
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
assign(k028_scr,'SLANT.scr');
reset(k028_scr);
seek(k028_scr,4); read(k028_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

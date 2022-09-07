{******************************************************************************
*                     k012 ÕĞÏËÏÃÉÓÌÏÓ ÏĞÉÓÈÏÔÏÌÉÁÓ                          *
*                  WRITTEN BY G.XALARIS                        *
*                              16-12-1986                                     *
*******************************************************************************}
type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k012=record
           kwd_o:string[5];
           xa_o,ya_o,xg_o,yg_o,xb_o,yb_o,ag_o,bg_o:real;
         end;
         string40 =string[40];
         string255=string[255];

var      xa,ya,xg,yg,xb,yb,ag,bg,xm,ym:array [1..500] of real;
         kwd:array [1..500] of string[6];
         a,b,pii,ax,ay,bx,by,tana,tanb,a1,a2,b1,b2,l1,mx,my:real;
         OthInp,OthPrint:array[1..3680] of byte;
         k012_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f       :text;
         b1_o    :string[10];
         b2_o    :string[11];
         b3_o    :string[10];
         b4_o    :string[11];
         b5_o    :string[10];
         b6_o    :string[11];
         b7_o    :string[5];
         b8_o    :string[8];
         b9_o    :string[8];

         in_k012 :file of rec1_k012;
         in1_rec :rec1_k012;
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
    fillchar(xa,sizeof(xa),0); fillchar(ya,sizeof(ya),0);
    fillchar(xg,sizeof(xg),0); fillchar(yg,sizeof(yg),0);
    fillchar(xb,sizeof(xb),0); fillchar(yb,sizeof(yb),0);
    fillchar(ag,sizeof(ag),0); fillchar(bg,sizeof(bg),0);
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
     seek(k012_scr,0);     read(k012_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k012_scr);
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
                    close(k012_scr);
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

procedure epex(j:byte);
begin
  pii:=3.141592654/200;
  a:=ag[j]*pii; b:=bg[j]*pii;
  ax:=xa[j]-xg[j]; ay:=ya[j]-yg[j];
  bx:=xb[j]-xg[j]; by:=yb[j]-yg[j];
  tana:=(sin(a)/cos(a)); tanb:=(sin(b)/cos(b));
  a1:=ax-(ay/tana); a2:=bx+(by/tanb);
  b1:=ay+(ax/tana); b2:=by-(bx/tanb);
  l1:=-((a1-a2)/(b1-b2));
  mx:=(a1+l1*b1)/(1+sqr(l1));
  my:=l1*mx;
  xm[j]:=xg[j]+mx; ym[j]:=yg[j]+my;
end;

procedure display_data(j:byte);
begin
  wrt(3,7,15,'          ');   gotoxy(3,7);   write(xa[j]:3:3);
  wrt(16,7,15,'           '); gotoxy(16,7);  write(ya[j]:3:3);
  wrt(29,7,15,'          ');  gotoxy(29,7);  write(xg[j]:3:3);
  wrt(42,7,15,'           '); gotoxy(42,7);  write(yg[j]:3:3);
  wrt(55,7,15,'          ');  gotoxy(55,7);  write(xb[j]:3:3);
  wrt(68,7,15,'           '); gotoxy(68,7);  write(yb[j]:3:3);
  wrt(24,13,15,'     ');      gotoxy(24,13); write(kwd[j]);
  wrt(34,13,15,'        ');   gotoxy(34,13); write(ag[j]:4:4);
  wrt(47,13,15,'        ');   gotoxy(47,13); write(bg[j]:4:4);
end;
procedure inp;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,7,2,11,bit);
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
i2:    input(buff,7,15,12,bit);
       if bit then goto i1 else val(buff,ya[l],cod);
i3:    input(buff,7,28,11,bit);
       if bit then goto i2 else val(buff,xg[l],cod);
i4:    input(buff,7,41,12,bit);
       if bit then goto i3 else val(buff,yg[l],cod);
i5:    input(buff,7,54,11,bit);
       if bit then goto i4 else val(buff,xb[l],cod);
i6:    input(buff,7,67,12,bit);
       if bit then goto i5 else val(buff,yb[l],cod);
i7:    input(buff,13,23,6.1,bit);
       if bit then goto i6 else kwd[l]:=buff;
i8:    input(buff,13,33,9,bit);
       if bit then goto i7 else val(buff,ag[l],cod);
i9:    input(buff,13,46,9,bit);
       if bit then goto i8 else val(buff,bg[l],cod);
       epex(l);
       l:=succ(l);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
     end;
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
    gotoxy(2,23);
    write('O‘EXE ! TO AXEIO AYTO YAXEI. NA GRA–— EAN— TOY; (N/O) ');
    read(kbd,cha);
    if cha in ['O','o','','¦'] then exit;
  end;
  rewrite(fill);
  writeln(fill,'    ======================================');
  writeln(fill,'       “Š‚ˆ‘‹‘  €Š†‘  ˆ‘‡’‹ˆ€‘');
  writeln(fill,'    ======================================');
  writeln(fill,'     ‰—ƒˆ‰‘      ’„’‹†‹„Œ†      ’„’€‚‹„Œ†');
  writeln(fill,'    ˆ‘/‹ˆ€‘      ‘†‹„ˆ“        ‘†‹„ˆ“');
  for k:=1 to i do writeln(fill,' ':6,kwd[k],' ':6-length(kwd[k]),
    ' ':5,xm[k]:10:3,'   ',ym[k]:11:3);
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
    gotoxy(24,grammi);    write(kwd[k]);
    gotoxy(35,grammi);    write(xm[k]:10:3);
    gotoxy(48,grammi);    write(ym[k]:11:3);
end;

procedure write_screen(m,scr_line:integer);
var   k:integer;
begin
  clrscr;
  seek(k012_scr,2);    read(k012_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to m do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 22 then
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
  writeln(fill,'    ======================================');
  writeln(fill,'       “Š‚ˆ‘‹‘  €Š†‘  ˆ‘‡’‹ˆ€‘');
  writeln(fill,'    ======================================');
  writeln(fill,'     ‰—ƒˆ‰‘      ’„’‹†‹„Œ†      ’„’€‚‹„Œ†');
  writeln(fill,'    ˆ‘/‹ˆ€‘      ‘†‹„ˆ“        ‘†‹„ˆ“');
end;

procedure lprint;
var   sel,gram,k:integer;
begin
  rewrite(fill);
  epikef;
  gram:=8;
  for k:=1 to i do
  begin
    writeln(fill);
    writeln(fill,' ':6,kwd[k],' ':6-length(kwd[k]),
            ' ':5,xm[k]:10:3,'   ',ym[k]:11:3);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin writeln(fill); writeln(fill); epikef; gram:=8; end;
  end;
  close(fill);
end;

procedure epex_menu;
var  j,k:byte;
     ok :boolean;
label    10,15,25;
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
            seek(k012_scr,1);    read(k012_scr,rec1);
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
              assign(in_k012,name);
              {$i-}
              reset(in_k012);
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
              rewrite(in_k012);
              j:=0;
              repeat
                j:=j+1;
                with in1_rec do
                begin
                  xa_o:=xa[j]; ya_o:=ya[j]; xg_o:=xg[j]; yg_o:=yg[j];
                  xb_o:=xb[j]; yb_o:=yb[j]; ag_o:=ag[j]; bg_o:=bg[j];
                  kwd_o:=kwd[j];
                end;
                write(in_k012,in1_rec);
              until j = i;
              close(in_k012);
            end
            else
            begin
              gotoxy(14,21);
              write('ƒEN EKANE‘ EI‘A‚—‚H ƒEƒOMEN—N.  €’†‘„ „Œ€ Š†‰’..');
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
              assign(in_k012,filename);
              {$i-}
              reset(in_k012);
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
              reset(in_k012);
              seek(in_k012,0);
              j:=0;
              repeat
                j:=j+1;
                read(in_k012,in1_rec);
                with in1_rec do
                begin
                  xa[j]:=xa_o; ya[j]:=ya_o; xg[j]:=xg_o; yg[j]:=yg_o;
                  xb[j]:=xb_o; yb[j]:=yb_o; ag[j]:=ag_o; bg[j]:=bg_o;
                  kwd[j]:=kwd_o;
                end;
                epex(j);
              until eof(in_k012);
              i:=j;
              close(in_k012);
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
                readln(f,b1_o);    val(b1_o,xa[j],cod);
                readln(f,b2_o);    val(b2_o,ya[j],cod);
                readln(f,b3_o);    val(b3_o,xg[j],cod);
                readln(f,b4_o);    val(b4_o,yg[j],cod);
                readln(f,b5_o);    val(b5_o,xb[j],cod);
                readln(f,b6_o);    val(b6_o,yb[j],cod);
                readln(f,b7_o);    kwd[j]:=b7_o;
                readln(f,b8_o);    val(b8_o,ag[j],cod);
                readln(f,b9_o);    val(b9_o,bg[j],cod);
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
              gotoxy(14,21);
              write('ƒEN EX— ƒEƒOMENA.  €’†‘„ „Œ€ Š†‰’..');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            sw4:=1;
            seek(k012_scr,3);    read(k012_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            inp;
            repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
10:         cursor(false,true);
            clrscr;
            epex_menu;
          end;
        5:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              input_results_in_file;
              cursor(false,true);
              epex_menu;
            end
            else
            begin
              gotoxy(14,24);
              write('ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
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
              gotoxy(14,24);
              write('ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
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
              gotoxy(14,24);
              write('ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
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
assign(k012_scr,'OPI.scr');
reset(k012_scr);
seek(k012_scr,4); read(k012_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

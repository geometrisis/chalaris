{******************************************************************************
*                  k037 ÕĞÏËÏÃÉÓÌÏÓ ÓÖÁÉÑÉÊÇÓ ÕĞÅÑÏ×ÇÓ                         *
*                  WRITTEN BY G.XALARIS                       *
*                              14-03-1987                                     *
*******************************************************************************}
program  k037;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k037=record
           Fsa,Fsb,Fg:real;
           Fideg:integer;
         end;
         string40 =string[40];
         string255=string[255];
         string2  =string[2];

var      sa,sb,g,sy:array [1..500] of real;
         ideg:array [1..500] of integer;

         k037_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f :text;
         Tb:string[20];

         in_k037:file of rec1_k037;
         in1_rec:rec1_k037;
         OthInp,OthPrint:array[1..3680] of byte;
         sw1,sw3,sw4,sw6 : byte;
         cha     :char;
         gram,sel:integer;

     {$i wrt-mon.prc}
     {$i repstr.fnc}
     {$i udip.prc}
     {$i ad.fnc}
     {$i cursor.prc}
     {$i wrtscr.prc}

procedure delete_all_input;
begin
    fillchar(sa,sizeof(sa),0); fillchar(sb,sizeof(sb),0);
    fillchar(g,sizeof(g),0);   fillchar(ideg,sizeof(ideg),0);
    fillchar(sy,sizeof(sy),0);
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
     seek(k037_scr,0);     read(k037_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k037_scr);
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
                    close(k037_scr);
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
{------------------------------EPEXERGASIA------------------------------------}
procedure RAD(ideg,min:integer; sec:real; var r:real);
var       pi,pii,degmin,degsec,deg:real;
begin
  deg:=0; degmin:=0; degsec:=0;
  pi:=arctan(1)*4;
  pii:=pi/180;
  degmin:=min/60;
  degsec:=sec/3600;
  deg:=ideg+degmin+degsec;
  r:=deg*pii; if ideg < 0 then r:=-r;
end;
procedure EPEX;
var       k:integer;
          pi,gn,ari,frad,par,rm,rm2,synt:real;
const     rdis=636619.7723;
          aa=6377397.155;
          ee2=0.006674372232;
begin
  clrscr;
  pi:=arctan(1)*4;
  for k:=1 to i do
  begin
    gn:=g[k]*pi/200.0;
    ari:=aa*(sqrt(1-ee2));
    rad(ideg[k],0,0,frad);
    par:=1-ee2*(sqr(sin(frad)));
    rm:=ari/par;
    rm2:=sqr(rm);
    synt:=((rdis)/(2*rm2));
    sy[k]:=-(sa[k]*sb[k])*sin(gn)*synt;
  end;
end;
{-------------------------------INPUT-----------------------------------------}
procedure display_data(j:byte);
begin
    wrt(33,8,15,'             ');  gotoxy(33,8);  write(sa[j]:4:3);
    wrt(33,10,15,'             '); gotoxy(33,10); write(sb[j]:4:3);
    wrt(48,12,15,'             '); gotoxy(48,12); write(g[j]:5:4);
    wrt(41,14,15,'      ');        gotoxy(41,14); write(ideg[j]:1);
end;
procedure INP;
label     i1,i2,i3,i4;
begin
     l:=1;
     while l <= i do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
i1:    input(buff,8,32,13,bit);
       if bit then
         if ((sw1=1) or (sw3=1)) then
         begin
           l:=pred(l); if l=0 then l:=1; display_data(l); goto i4;
         end
         else begin end
       else val(buff,sa[l],cod);
i2:    input(buff,10,32,13,bit);
       if bit then goto i1 else val(buff,sb[l],cod);
i3:    input(buff,12,47,9,bit);
       if bit then goto i2 else val(buff,g[l],cod);
i4:    input(buff,14,40,4,bit);
       if bit then goto i3 else val(buff,ideg[l],cod);
       l:=succ(l);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
     end;
     epex;
end;
{--------------------------------OTHONH---------------------------------------}
procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(13,grammi); write(sa[k]:13:3); gotoxy(27,grammi); write(sb[k]:13:3);
  gotoxy(44,grammi); write(g[k]:8:4);   gotoxy(55,grammi); write(ideg[k]:3);
  gotoxy(60,grammi); write(sy[k]:8:4);
end;
procedure write_screen;
var       k,scr_line:integer;
begin
  scr_line:=7; clrscr;
  seek(k037_scr,2);    read(k037_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to i do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line+1;
    if scr_line > 21 then
    begin
      wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=7;
    end;
  end;
  if i <= 15 then
  begin
    wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ ‹„ŒU €’†‘„ „Œ€ Š†‰’..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;
{-----------------------------------OUTPUT------------------------------------}
procedure selida;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
end;
procedure epikef;
begin
  writeln(fill,'    ================================================================');
  writeln(fill,'      “   Š  ‚ ˆ ‘ ‹  ‘   ‘ ” € ˆ  ˆ ‰ † ‘   “  „   • † ‘');
  writeln(fill,'    ================================================================');
  writeln(fill);
  writeln(fill,'      Š „ “  €       Š „ “  €     „ˆ„•‹.    ‹„‘     ‘”€ˆˆ‰†');
  writeln(fill,'          €                           ‚—Œˆ€      Š€’‘     “„•†');
  writeln(fill,'    -------------    -------------    --------    ------    --------');
end;
procedure results;
var       sel,gram,k:integer;
begin
  if sw6=0 then ar_gram:=66;
  sel:=0; selida; epikef;
  gram:=10;
  for k:=1 to i do
  begin
    writeln(fill);
    writeln(fill,' ':4,sa[k]:13:3,' ':4,sb[k]:13:3,' ':4,
      g[k]:8:4,' ':6,ideg[k]:3,' ':5,sy[k]:8:4);
    gram:=gram+2;
    if gram >= ar_gram-3 then
    begin
      write(fill,#12); selida; epikef; gram:=10;
    end;
  end;
  write(fill,#12);
  close(fill);
end;


procedure epex_menu;
var       j,k:byte;
          ok :boolean;
label     e1,10,15,25;
begin
    case menu of
       1:begin
           if (sw1 = 1) or (sw3 = 1) then epex_menu;
15:        gotoxy(22,21);
           cursor(true,false);
           write('ƒ—‘„ ‘“ŒŠˆ‰ €ˆ‡‹ “Š‚ˆ‘‹—Œ : ');
           read(i);
           if ad then goto 15;
           clrscr; seek(k037_scr,1); read(k037_scr,rec1);
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
             gotoxy(13,21);
             read(name);
             assign(in_k037,name);
             {$i-}
             reset(in_k037);
             {$i+}
             ok:=(ioresult=0);
             if ok then
             begin
               gotoxy(1,23);
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
             rewrite(in_k037);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 Fsa:=sa[j]; Fsb:=sb[j]; Fg:=g[j]; Fideg:=ideg[j];
               end;
               write(in_k037,in1_rec);
             until j = i;
             close(in_k037);
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
           gotoxy(13,21);
           readln(filename);
           if cha in ['F','f','”','­'] then
           begin
             assign(in_k037,filename);
             {$i-}
             reset(in_k037);
             {$i+}
             ok:=(ioresult=0);
             if not ok then
             begin
               gotoxy(1,23);
               write('O‘EXE !   TO AXEIO AYTO ƒEN YAXEI. ATH‘E ENA ŠHKTO..');
               repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
               cursor(false,true);
               epex_menu;
             end;
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'ƒ ˆ €  € … —   ƒ „ ƒ  ‹ „ Œ €..');
             reset(in_k037);
             seek(in_k037,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k037,in1_rec);
               with in1_rec do
               begin
                 sa[j]:=Fsa; sb[j]:=Fsb; g[j]:=Fg; ideg[j]:=Fideg;
               end;
             until eof(in_k037);
             i:=j;
             epex;
             close(in_k037);
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
               gotoxy(1,23);
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
               readln(f,Tb); val(Tb,sa[j],cod);
               readln(f,Tb); val(Tb,sb[j],cod);
               readln(f,Tb); val(Tb,g[j],cod);
               readln(f,Tb); val(Tb,ideg[j],cod);
             until eof(f);
             close(f);
             i:=j;
             epex;
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
           seek(k037_scr,1);    read(k037_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           inp;
           cursor(false,true);
10:        clrscr;
           epex_menu;
         end;
       5:begin
           cursor(true,false);
           if ((sw1=1) or (sw3=1) or (sw4=1)) then
           begin
             wrt_screen(OthInp,1,20,80,22);
             gotoxy(13,21);
             readln(filename);
             assign(fill,filename);
             {$i-}
             reset(fill);
             {$i+}
             ok:=(ioresult=0);
             if ok then
             begin
               gotoxy(1,23);
               write('O‘EXE ! TO AXEIO AYTO YAXEI. NA ‚A–— EAN— TOY; (N/O) ');
               read(kbd,cha);
               if cha in ['O','o','','¦'] then goto e1;
             end;
             clrscr;
             cursor(false,true);
             wrt(7,12,240,'  ‰ € ’ € • —  —   €   ’ „ Š „ ‘ ‹ € ’ €    ‘ „   €  • „ ˆ   ');
             rewrite(fill);
             results;
             cursor(false,true);
             epex_menu;
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
e1:          clrscr;
             cursor(false,true);
             epex_menu;
           end;
         end;
       6:begin
           cursor(true,false);
           if ((sw1=1) or (sw3=1) or (sw4=1)) then
           begin
             sw6:=1;
             wrt_screen(OthPrint,1,4,45,17);
25:          gotoxy(32,13);
             read(ar_gram);
             if ad then goto 25;
             gotoxy(3,15); write('„Œ„‚ˆ†‘„ ’Œ „‰’“—’† ‘E €•† ‘„Šˆƒ€‘');
             gotoxy(10,16); write('€’†‘„ RETURN ‚ˆ€ „‰’“—‘†');
             repeat read(kbd,cha) until cha in [#10,#13];
             cursor(false,true);
             assign(fill,'prn');
             rewrite(fill); sel:=0;
             clrscr;
             wrt(29,12,240,'„  ‰  ’  “    —  Œ  —..');
             write(fill,#27,#67,chr(ar_gram));
             results;
             epex_menu;
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             clrscr;
             epex_menu;
           end;
         end;
       7:begin
           if ((sw1=1) or (sw3=1) or (sw4=1)) then
           begin
             write_screen;
             clrscr;
             epex_menu;
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..');
             repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
             clrscr;
             epex_menu;
           end;
         end;
    end;      { case }
end;     { procedure }

BEGIN
  clrscr;
  ofs1:=$8000;
  if mem[0:1040] and 48 = 48 then ofs1:=$0000;
  assign(k037_scr,'EXCESS.scr');
  reset(k037_scr);
  seek(k037_scr,3); read(k037_scr,rec1);   {*** š ˜ : printer,input ˜¨®œ ¦ ***}
  for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
  for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
  delete_all_input;
  sw1:=0; sw3:=0; sw4:=0; sw6:=0; i:=0; sel:=0;
  cursor(false,true);
  epex_menu;
END.

{******************************************************************************
*                  k054   éàANTISTROFO PROBLHMA                            *
*                  WRITTEN BY G.XALARIS                                       *
*                              16-03-1987                                             *
*******************************************************************************}
program  k054;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k054=record
           Fn:integer;
           Fa:real;
         end;
         string40 =string[40];
         string255=string[255];

var      a,aM:array [1..2000] of real;
         lM,m:array[1..2000] of integer;
         d:real;

         k054_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,n,j   :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f :text;
         Tb:string[20];

         in_k054:file of rec1_k054;
         in1_rec:rec1_k054;
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
    fillchar(a,sizeof(a),0);   fillchar(aM,sizeof(aM),0);
    fillchar(lM,sizeof(lM),0); fillchar(m,sizeof(m),0); d:=0;
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
     seek(k054_scr,0);     read(k054_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k054_scr);
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
                    close(k054_scr);
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
{------------------------------EPEXERGASIA------------------------------------}
procedure epex;
label     5850;
var       j,nn,nk,kk,iz,k,ij,ki,ji,jp,jk,ik,kj,jq,jr:integer;
          biga,absb,absa,diaf,hold:real;
begin
    nn:=n*n;
 {  SEARCH FOR LARGEST ELEMENT  }
    d:=1; nk:=-n;
    for k:=1 to n do
    begin
      nk:=nk+n; lM[k]:=k; m[k]:=k; kk:=nk+k; biga:=a[kk];
      for j:=k to n do
      begin
        iz:=n*(j-1);
        for i:=k to n do
        begin
          ij:=iz+i;
          absb:=abs(biga);
          absa:=abs(a[ij]);
          diaf:=absb-absa;
          if (diaf < 0) then
          begin
            biga:=a[ij]; lM[k]:=i; m[k]:=j;
          end;
        end;
      end;
   {  INTERCHANGE ROWS  }
      j:=lM[k];
      if ((j-k) > 0) then
      begin
        ki:=k-n;
        for i:=1 to n do
        begin
          ki:=ki+n;
          hold:=-a[ki];
          ji:=ki-k+j;
          a[ki]:=a[ji];
          a[ji]:=hold;
        end;
      end;
   {  INTERCHANGE COLUMNS  }
      i:=m[k];
      if (i-k > 0) then
      begin
        jp:=n*(i-1);
        for j:=1 to n do
        begin
          jk:=nk+j;
          ji:=jp+j;
          hold:=-a[jk];
          a[jk]:=a[ji];
          a[ji]:=hold;
        end;
      end;
   {  DIVIDE COLUMN BY MINUS PIVOT  }
      if biga=0 then begin d:=0; exit; end;
      for i:=1 to n do
      begin
        if ((i-k) <> 0) then begin ik:=nk+i; a[ik]:=a[ik]/(-biga); end;
      end;
   {  REDUCE MATRIX  }
      for i:=1 to n do
      begin
        ik:=nk+i;
        ij:=i-n;
        for j:=1 to n do
        begin
          ij:=ij+n;
          if ((i-k) <> 0) then if ((j-k) <> 0) then begin
                                                      kj:=ij-i+k;
                                                      a[ij]:=a[ik]*a[kj]+a[ij];
                                                    end;
        end;
      end;
   {  DIVIDE ROW BY PIVOT  }
      kj:=k-n;
      for j:=1 to n do
      begin
        kj:=kj+n;
        if ((j-k) <> 0) then a[kj]:=a[kj]/biga;
      end;
      d:=d*(biga/1000.0);
      d:=d*1000.0;
      a[kk]:=1/biga;
    end;
 {  FINAL ROW AND COLUMN INTERCHANGE  }
    k:=n;
5850:
    k:=k-1;
    if (k > 0) then
    begin
      i:=lM[k];
      if ((i-k) > 0) then
      begin
        jq:=n*(k-1);
        jr:=n*(i-1);
        for j:=1 to n do
        begin
          jk:=jq+j;
          hold:=a[jk];
          ji:=jr+j;
          a[jk]:=-a[ji];
          a[ji]:=hold;
        end;
      end;
      j:=m[k];
      if ((j-k) <= 0) then goto 5850;
      ki:=k-n;
      for i:=1 to n do
      begin
        ki:=ki+n;
        hold:=a[ki];
        ji:=ki-k+j;
        a[ki]:=-a[ji];
        a[ji]:=hold;
      end;
      goto 5850;
    end;
end;
{-------------------------------INPUT-----------------------------------------}
procedure display_data(i,j:integer);
begin
    wrt(31,9,15,'     ');           gotoxy(31,9);  write(i:1);
    wrt(31,11,15,'     ');          gotoxy(31,11); write(j:1);
    wrt(56,10,15,'              '); gotoxy(56,10); write(aM[n*(j-1)+i]:6:5);
end;
procedure INP;
label     i1;
var       j,i,ij:integer;
begin
     j:=1;
     while j <= n do
     begin
       i:=1;
       while i <= n do
       begin
         if ((sw1 = 1) or (sw3 = 1)) then display_data(i,j);
i1:      gotoxy(31,9); write(i:1); gotoxy(31,11); write(j:1);
         ij:=n*(j-1)+i;
         input(buff,10,55,15,bit);
         if bit then
           if ((sw1=1) or (sw3=1)) then
           begin
             i:=pred(i);
             if i=0 then
             begin
               i:=n; j:=pred(j); if j=0 then j:=1;
               display_data(i,j); goto i1;
             end
             else begin display_data(i,j); goto i1; end;
           end
           else begin end
         else begin val(buff,aM[ij],cod); a[ij]:=aM[ij]; end;
         i:=succ(i);
         move(rec1.xx[0],mem[$b000:ofs1],3680);
       end;
       j:=succ(j);
     end;
     epex;
end;
{--------------------------------OTHONH---------------------------------------}
procedure anal_gr_scr(grammi,i,j:integer);
begin
  gotoxy(25,grammi); write(i:4);    gotoxy(34,grammi); write(j:4);
  gotoxy(41,grammi); write(a[n*(j-1)+i]);
end;
procedure write_screen;
var       i,j,scr_line:integer;
begin
  scr_line:=6; clrscr;
  seek(k054_scr,2);    read(k054_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for j:=1 to n do
  begin
    for i:=1 to n do
    begin
      anal_gr_scr(scr_line,i,j);
      scr_line:=scr_line+1;
      if scr_line > 21 then
      begin
        wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
        repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
        move(rec1.xx[0],mem[$b000:ofs1],3680);
        scr_line:=6;
      end;
    end;
  end;
  if i <= 15 then
  begin
    wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;
{-----------------------------------OUTPUT------------------------------------}
procedure selida;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':68,'ëÑäàÉÄ : ',sel:1);
  writeln(fill);
end;
procedure epikef(DumD:real);
begin
  writeln(fill,'    ===================================================');
  writeln(fill,'        ÄåíàëíêéîÜ ÇÑåàâéì ãÜíêóéì éàÄëÉÜèéíÑ íÄçÜë');
  writeln(fill,'    ===================================================');
  writeln(fill,'         ÉàÄâêàåéìëÄ èàåÄâÄ : ',DumD);
  writeln(fill,'         ÇêÄããÜ       ëíÜäÜ           ëíéàïÑàé');
  writeln(fill,'         ------      ------      ------------------');
               {    10    ****   8    ****   7   ******************}
end;
procedure results;
var       sel,gram,i,j:integer;
begin
  if sw6=0 then ar_gram:=66;
  sel:=0; selida; epikef(d);
  gram:=10;
  for j:=1 to n do
  begin
    for i:=1 to n do
    begin
      writeln(fill); writeln(fill,' ':10,i:4,' ':8,j:4,' ':7,a[n*(j-1)+i]);
      gram:=gram+2;
      if gram >= ar_gram-3 then
      begin
        write(fill,#12); selida; epikef(d); gram:=10;
      end;
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
15:        gotoxy(16,21);
           cursor(true,false);
           write('ÉóëÑ íÜå íÄçÜ íéì ãÜíêóéì èéì áÄ ÄåíàëíêÄîÑà : ');
           read(n); if ((n > 2000) and (n<=0)) then goto 15;
           if ad then goto 15;
           clrscr; seek(k054_scr,1); read(k054_scr,rec1);
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
             assign(in_k054,name);
             {$i-}
             reset(in_k054);
             {$i+}
             ok:=(ioresult=0);
             if ok then
             begin
               gotoxy(1,23);
               write('èêéëÑïÑ ! íé ÄêïÑàé Äìíé ìèÄêïÑà. åÄ ÇêÄñó ÑèÄåó íéì; (å/é) ');
               read(kbd,cha);
               if cha in ['O','o','é','¶'] then
               begin
                 cursor(false,true);
                 epex_menu;
               end;
             end;
             clrscr;
             cursor(false,true);
             wrt(11,12,240,'  â Ä í Ä ï ó ê ó   É Ñ É é ã Ñ å Ä    ë Ñ   Ä ê ï Ñ à é  ');
             rewrite(in_k054);
             j:=0;
             repeat
               j:=j+1; i:=0;
               repeat
                 i:=i+1;
                 with in1_rec do
                 begin
                   Fn:=n; Fa:=aM[n*(j-1)+i]; write(in_k054,in1_rec);
                 end;
               until i=n;
             until j=n;
             close(in_k054);
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
           gotoxy(13,21);
           readln(filename);
           if cha in ['F','f','î','≠'] then
           begin
             assign(in_k054,filename);
             {$i-}
             reset(in_k054);
             {$i+}
             ok:=(ioresult=0);
             if not ok then
             begin
               gotoxy(1,23);
               write('èêOëEXE !   TO AêXEIO AYTO ÉEN YèAêXEI. èATHëE ENA èäHKTêO..');
               repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
               cursor(false,true);
               epex_menu;
             end;
             sw3:=1;
             clrscr;
             cursor(false,true);
             wrt(22,12,240,'É à Ä Å Ä Ö ó   É Ñ É é ã Ñ å Ä..');
             reset(in_k054);
             seek(in_k054,0);
             j:=0;
             repeat
               j:=j+1; i:=0;
               repeat
                 i:=i+1;
                 read(in_k054,in1_rec);
                 with in1_rec do
                 begin
                   n:=Fn; a[n*(j-1)+i]:=Fa; aM[n*(j-1)+i]:=Fa;
                 end;
               until i=n;
             until j=n;
             close(in_k054);
             epex;
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
             readln(f,Tb); val(Tb,n,cod);
             j:=0;
             repeat
               j:=j+1; i:=0;
               repeat
                 i:=i+1;
                 readln(f,Tb); val(Tb,a[n*(j-1)+i],cod);
                 val(Tb,aM[n*(j-1)+i],cod);
               until i=n;
             until j=n;
             close(f);
             epex;
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
           seek(k054_scr,1);    read(k054_scr,rec1);
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
               write('èêOëEXE ! TO AêXEIO AYTO YèAêXEI. NA ÇêAñó EèANó TOY; (N/O) ');
               read(kbd,cha);
               if cha in ['O','o','é','¶'] then goto e1;
             end;
             clrscr;
             cursor(false,true);
             wrt(7,12,240,'  â Ä í Ä ï ó ê ó   Ä è é í Ñ ä Ñ ë ã Ä í Ä    ë Ñ   Ä ê ï Ñ à é  ');
             rewrite(fill);
             results;
             cursor(false,true);
             epex_menu;
           end
           else
           begin
             cursor(false,true);
             wrt(14,21,112,'ÉEN EXó ÉEÉOMENA.  èATHëE ENA èäHKTêO..');
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
             gotoxy(3,15); write('ÑåÑêÇéèéàÜëÑ íéå ÑâíìèóíÜ ëE ÄêïÜ ëÑäàÉÄë');
             gotoxy(10,16); write('èÄíÜëÑ RETURN ÇàÄ ÑâíìèóëÜ');
             repeat read(kbd,cha) until cha in [#10,#13];
             cursor(false,true);
             assign(fill,'prn');
             rewrite(fill); sel:=0;
             clrscr;
             wrt(29,12,240,'Ñ  â  í  ì  è  ó  å  ó..');
             write(fill,#27,#67,chr(ar_gram));
             results;
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
             write_screen;
             clrscr;
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
    end;      { case }
end;     { procedure }

BEGIN
  clrscr;
  ofs1:=$8000;
  if mem[0:1040] and 48 = 48 then ofs1:=$0000;
  assign(k054_scr,'ANTISTRO.scr');
  reset(k054_scr);
  seek(k054_scr,3); read(k054_scr,rec1);   {*** ö†ò : printer,input ò®Æú†¶ ***}
  for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
  for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
  delete_all_input;
  sw1:=0; sw3:=0; sw4:=0; sw6:=0; n:=0; sel:=0;
  cursor(false,true);
  epex_menu;
END.

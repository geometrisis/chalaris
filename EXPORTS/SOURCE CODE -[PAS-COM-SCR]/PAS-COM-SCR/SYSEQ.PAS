{******************************************************************************
*                k051 ≈–…À’”« ”’”‘«Ã¡‘ŸÕ ‘«” Ãœ—÷«” GX=W                    *
*                  WRITTEN BY G.XALARIS                        *
*                              17-03-1987                                     *
*******************************************************************************}
program  k051;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k051=record
           Fir,Fn,Fpaint:integer;
           Fc,Fb,Fp:real;
         end;
         string40 =string[40];
         string255=string[255];

var      a,bn,Nb,b,x,p:array [1..25] of real;
         c,Nc,aa:array [1..50,1..25] of real;
         l,m:array[1..25] of integer;
         ir,n,paint:integer;
         d:real;

         k051_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,j     :integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f :text;
         Tb:string[20];

         in_k051:file of rec1_k051;
         in1_rec:rec1_k051;
         OthInp,OthPrint,ExisAgn,YorN,Baros:array[1..3680] of byte;
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
    fillchar(a,sizeof(a),0);   fillchar(aa,sizeof(aa),0);
    fillchar(bn,sizeof(bn),0); fillchar(x,sizeof(x),0);
    fillchar(p,sizeof(p),0);   fillchar(c,sizeof(c),0);
    fillchar(l,sizeof(l),0);   fillchar(m,sizeof(m),0);
    fillchar(b,sizeof(b),0);   fillchar(Nb,sizeof(Nb),0);
    d:=0; paint:=0; ir:=0; n:=0;
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
     seek(k051_scr,0);     read(k051_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k051_scr);
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
                    close(k051_scr);
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
procedure invert;
label     5850;
var       j,nn,nk,kk,iz,k,ij,ki,ji,jp,jk,ik,kj,jq,jr:integer;
          biga,absb,absa,diaf,hold:real;
begin
    nn:=n*n;
 {  SEARCH FOR LARGEST ELEMENT  }
    d:=1; nk:=-n;
    for k:=1 to n do
    begin
      nk:=nk+n; l[k]:=k; m[k]:=k; kk:=nk+k; biga:=a[kk];
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
            biga:=a[ij]; l[k]:=i; m[k]:=j;
          end;
        end;
      end;
   {  INTERCHANGE ROWS  }
      j:=l[k];
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
      i:=l[k];
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
procedure epex;
var       k,l,ij,j,i:integer;
          psq:real;
begin
    if paint=2 then
    begin
      for i:=1 to ir do
      begin
        psq:=sqrt(p[i]);
        b[i]:=Nb[i]*psq;
        for j:=1 to n do c[i,j]:=Nc[i,j]*psq;
      end;
    end else
    begin
      for i:=1 to ir do
      begin
        b[i]:=Nb[i]; for j:=1 to n do c[i,j]:=Nc[i,j];
      end;
    end;
    for k:=1 to n do for l:=k to n do begin
                                        aa[k,l]:=0;
                                        for i:=1 to ir do
                                          aa[k,l]:=aa[k,l]+c[i,k]*c[i,l];
                                        aa[l,k]:=aa[k,l];
                                      end;
    for l:=1 to n do
    begin
      bn[l]:=0;
      for i:=1 to ir do bn[l]:=bn[l]+b[i]*c[i,l];
    end;
    for j:=1 to n do for i:=1 to n do begin ij:=n*(j-1)+i; a[ij]:=aa[i,j]; end;
    invert;                     if d=0 then halt;
    for j:=1 to n do for i:=1 to n do begin ij:=n*(j-1)+i; aa[i,j]:=a[ij]; end;
    for i:=1 to n do
    begin
      x[i]:=0;
      for j:=1 to n do x[i]:=x[i]+aa[i,j]*bn[j];
    end;
end;
{-------------------------------INPUT-----------------------------------------}
procedure display_data1(i,j:integer);
begin
    wrt(32,6,15,'     ');          gotoxy(32,6); write(i:1);
    wrt(32,8,15,'     ');          gotoxy(32,8); write(j:1);
    wrt(56,7,15,'              '); gotoxy(56,7); write(Nc[i,j]:6:5);
end;
procedure display_data2(j:integer);
begin
    wrt(28,17,15,'     ');         gotoxy(28,17); write(j:1);
    wrt(44,17,15,'             '); gotoxy(44,17); write(p[j]:6:5);
end;
function PaintInp:integer;
label    1;
const    line_tab:array [1..2] of byte = (11,13);
var      deik:integer;
         cha:char;
begin
  deik:=1;
  wrt(38,11,112,#5);
1:read(kbd,cha);
  if cha in [#10,#13] then begin PaintInp:=deik; exit; end
  else if ((cha=#27) or (cha in ['2','8'])) then
  begin
    if keypressed then read(kbd,cha);
    case cha of
      #72,'8':begin
                wrt(38,line_tab[deik],15,#5);
                if deik=1 then deik:=2 else deik:=1;
                wrt(38,line_tab[deik],112,#5);
              end;
      #80,'2':begin
                wrt(38,line_tab[deik],15,#5);
                if deik=2 then deik:=1 else deik:=2;
                wrt(38,line_tab[deik],112,#5);
              end;
    else write(^G);
    end;
  end;
  goto 1;
end;
procedure INP;
label     i1,i2;
var       j,i:integer;
begin
     i:=1;
     while i <= ir do
     begin
       j:=1;
       while j <= n do
       begin
         if ((sw1 = 1) or (sw3 = 1)) then display_data1(i,j);
i1:      gotoxy(32,6); write(i:1); gotoxy(32,8); write(j:1);
         input(buff,7,55,15,bit);
         if bit then
           if ((sw1=1) or (sw3=1)) then
           begin
             j:=pred(j);
             if j=0 then
             begin
               j:=n; i:=pred(i); if i=0 then i:=1;
               display_data1(j,i); goto i1;
             end
             else begin display_data1(j,i); goto i1; end;
           end
           else begin end
         else val(buff,Nc[i,j],cod);
         j:=succ(j);
         move(rec1.xx[0],mem[$b000:ofs1],3680);
       end;
       gotoxy(20,9); write('ÉóëÑ íé B ãÑäéë íÜë ',i:3,' ÑçàëóëÜë :');
       if ((sw1=1) or (sw3=1)) then begin gotoxy(54,9); write(b[i]:5:4); end;
       input(buff,9,53,15,bit);
       if bit then begin j:=n-1; goto i1; end else val(buff,Nb[i],cod);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
       i:=succ(i);
     end;
     cursor(false,true);
     wrt_screen(YorN,1,10,80,14);
     if not ((sw1=1) or (sw3=1)) then paint:=PaintInp;
     if paint=2 then
     begin
       i:=1; cursor(true,false);
       while i <= ir do
       begin
         wrt_screen(YorN,1,10,80,14); wrt(38,13,112,#5);
         wrt_screen(Baros,1,14,80,19);
         if ((sw1 = 1) or (sw3 = 1)) then display_data2(i);
i2:      gotoxy(28,17); write(i:1);
         input(buff,17,43,15,bit);
         if bit then
           if ((sw1=1) or (sw3=1)) then
           begin
             i:=pred(i);
             if i=0 then i:=1; display_data2(i);
           end
           else begin end
         else val(buff,p[i],cod);
         i:=succ(i);
         move(rec1.xx[0],mem[$b000:ofs1],3680);
       end;
     end;
     epex;
end;
{--------------------------------OTHONH---------------------------------------}
procedure anal_gr_scr(grammi,i:integer);
begin
  gotoxy(30,grammi); write(i:4);    gotoxy(36,grammi); write(x[i]);
end;
procedure write_screen;
var       i,j,scr_line:integer;
begin
  scr_line:=6; clrscr;
  seek(k051_scr,2);    read(k051_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for i:=1 to n do
  begin
    anal_gr_scr(scr_line,i);
    scr_line:=scr_line+1;
    if scr_line > 21 then
    begin
      wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=6;
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
  writeln(fill,' ':50,'ëÑäàÉÄ : ',sel:1);
  writeln(fill);
end;
procedure epikef;
begin
  writeln(fill,'    ========================================');
  writeln(fill,'        ÑèàäìëÜ ìèÑêâÄåéåàâéì ëìëíÜãÄíéë');
  writeln(fill,'    ========================================');
  writeln(fill);
  writeln(fill,'         ÇêÄããÜ           ëíéàïÑàé');
  writeln(fill,'         ------      ------------------');
               {    10    ****   7   ******************}
end;
procedure results;
var       sel,gram,i:integer;
begin
  if sw6=0 then ar_gram:=66;
  sel:=0; selida; epikef;
  gram:=10;
  for i:=1 to n do
  begin
    writeln(fill); writeln(fill,' ':10,i:4,' ':7,x[i]);
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
label     e1,e2,10,25;
begin
    case menu of
       1:begin
           if (sw1 = 1) or (sw3 = 1) then epex_menu;
           cursor(true,false);
           wrt_screen(ExisAgn,11,7,48,11);
e2:        input(buff,8,42,4,bit); val(buff,ir,cod);
           input(buff,10,42,4,bit); if bit then goto e2 else val(buff,n,cod);
           clrscr; seek(k051_scr,1); read(k051_scr,rec1);
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
             assign(in_k051,name);
             {$i-}
             reset(in_k051);
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
             rewrite(in_k051);
             for i:=1 to ir do
             begin
               for j:=1 to n do
               begin
                 with in1_rec do
                 begin
                   Fpaint:=paint; Fir:=ir; Fn:=n; Fc:=Nc[i,j];
                   Fb:=Nb[i]; Fp:=p[i]; write(in_k051,in1_rec);
                 end;
               end;
             end;
             close(in_k051);
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
             assign(in_k051,filename);
             {$i-}
             reset(in_k051);
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
             reset(in_k051); seek(in_k051,0); delete_all_input;
             read(in_k051,in1_rec);
             with in1_rec do begin n:=Fn; ir:=Fir; paint:=Fpaint; end;
             seek(in_k051,0);
             for i:=1 to ir do
             begin
               for j:=1 to n do
               begin
                 read(in_k051,in1_rec);
                 with in1_rec do
                 begin
                   Nc[i,j]:=Fc; Nb[i]:=Fb; p[i]:=Fp;
                 end;
               end;
             end;
             close(in_k051);
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
             reset(f); delete_all_input;
             readln(f,Tb); val(Tb,ir,cod); readln(f,Tb); val(Tb,n,cod);
             readln(f,Tb); val(Tb,paint,cod);
             for i:=1 to ir do
             begin
               for j:=1 to n do
               begin
                 readln(f,Tb); val(Tb,Nc[i,j],cod);
               end;
               readln(f,Tb); val(Tb,Nb[i],cod);
             end;
             if paint=2 then
               for i:=1 to ir do begin readln(f,Tb); val(Tb,p[i],cod); end;
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
           seek(k051_scr,1);    read(k051_scr,rec1);
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
  assign(k051_scr,'SYSEQ.scr');
  reset(k051_scr);
  seek(k051_scr,3); read(k051_scr,rec1);
  for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
  for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
  for j:=18 to 22 do move(rec1.xx[(j-1)*160],ExisAgn[(j-18)*76+1],76);
  seek(k051_scr,4); read(k051_scr,rec1);
  for j:=1 to 5 do move(rec1.xx[(j-1)*160],YorN[(j-1)*160+1],160);
  for j:=7 to 12 do move(rec1.xx[(j-1)*160],Baros[(j-7)*160+1],160);
  delete_all_input;
  sw1:=0; sw3:=0; sw4:=0; sw6:=0; n:=0; ir:=0; sel:=0;
  cursor(false,true);
  epex_menu;
END.

{******************************************************************************
*       026 ¡Õ¡À’‘… « –—œ”¡—Ãœ√« ƒ’œ ”’”‘«Ã¡‘ŸÕ œ—»œ√ŸÕ…ŸÕ ”’Õ‘≈‘¡√Ã≈ÕŸÕ *
*                     WRITTEN BY G.XALARIS                     *
*                                 28-01-1987                                  *
*******************************************************************************}
program  k026;

type     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k026=record  { 36 Bytes }
           ncon_h          :integer;
           p_h,q_h         :string[4];
           xmeas_h,ymeas_h,
           xcon_h,ycon_h   :real;
         end;
         rec2_k026=record  { 36 Bytes }
           p_h,q_h         :string[4];
           xmeas_h,ymeas_h :real;
           dummy           :string[13];
         end;
         string40 =string[40];
         string255=string[255];

var      xcon,ycon    :array [1..100] of real;
         xmeas,ymeas  :array [1..200] of real;
         p,q          :array [1..200] of string[4];
         xgro,ygro    :array [1..200] of real;
         at           :array [1..4,1..200] of real;
         a            :array [1..200,1..4] of real;
         ata          :array [1..4,1..4] of real;
         el           :array [1..200,1..1] of real;
         atl,x        :array [1..4,1..1] of real;
         ncon,np,l    :integer;
         OthInp,OthPrint:array[1..3680] of byte;
         k026_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         ar_gram :integer;
         buff    :string40;
         bit,ok  :boolean;
         name,filename:string[66];
         fill    :text;

         f_txt               :text;
         b1_h,b2_h,b3_h,b4_h,
         b5_h,b6_h,b7_h      :string[12];

         in_k026 :file of rec1_k026;
         in1_rec :rec1_k026;
         in2_rec :rec2_k026 absolute in1_rec;

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

procedure delete_all_input;
begin
    fillchar(xcon,sizeof(xcon),0);   fillchar(ycon,sizeof(ycon),0);
    fillchar(xmeas,sizeof(xmeas),0); fillchar(ymeas,sizeof(ymeas),0);
    fillchar(p,sizeof(p),0);         fillchar(q,sizeof(q),0);
    fillchar(xgro,sizeof(xgro),0);   fillchar(ygro,sizeof(ygro),0);
    fillchar(a,sizeof(a),0);         fillchar(at,sizeof(at),0);
    fillchar(ata,sizeof(ata),0);     fillchar(atl,sizeof(atl),0);
    fillchar(el,sizeof(el),0);       fillchar(x,sizeof(x),0);
    ncon:=0;    np:=0;
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
     seek(k026_scr,0);     read(k026_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k026_scr);
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
                    close(k026_scr);
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

procedure matr;
var       i,j:integer;
begin
    for i:=1 to 2*ncon do begin for j:=1 to 4 do at[j,i]:=a[i,j]; end;
end;
procedure matm1;
var       i,k,j:integer;
begin
    for i:=1 to 4 do
    begin
      for k:=1 to 4 do
      begin
        ata[i,k]:=0; for j:=1 to 2*ncon do ata[i,k]:=ata[i,k]+at[i,j]*a[j,k];
      end;
    end;
end;
procedure matm2;
var       i,k,j:integer;
begin
    for i:=1 to 4 do
    begin
      for k:=1 to 1 do
      begin
        atl[i,k]:=0; for j:=1 to 2*ncon do atl[i,k]:=atl[i,k]+at[i,j]*el[j,k];
      end;
    end;
end;
procedure mati;
var       k,j,i:integer;
begin
    for k:=1 to 4 do
    begin
      for j:=1 to 4 do if ((j-k) <> 0) then ata[k,j]:=ata[k,j]/ata[k,k];
      ata[k,k]:=1/ata[k,k];
      for i:=1 to 4 do
      begin
        if ((i-k) <> 0) then
        begin
          for j:=1 to 4 do
          begin
            if ((j-k) <> 0) then ata[i,j]:=ata[i,j]-ata[i,k]*ata[k,j];
          end;
          ata[i,k]:= -ata[i,k]*ata[k,k];
        end else begin end;
      end;
    end;
end;
procedure matm3;
var       i,k,j:integer;
begin
    for i:=1 to 4 do
    begin
      for k:=1 to 1 do
      begin
        x[i,k]:=0; for j:=1 to 4 do x[i,k]:=x[i,k]+ata[i,j]*atl[j,k];
      end;
    end;
end;
procedure epex;
var       i,j,k,ii:integer;
begin
 {  FORM THE MATRICES  }
    for i:=1 to ncon do
    begin
      a[i,1]:=1;
      a[i,2]:=xmeas[i];
      a[i,3]:= -ymeas[i];
      a[i,4]:=0;
      el[i,1]:=xcon[i];
    end;
    j:=ncon+1;
    k:=2*ncon;
    for i:=j to k do
    begin
      ii:=i-ncon;
      a[i,1]:=0;
      a[i,2]:=ymeas[ii];
      a[i,3]:=xmeas[ii];
      a[i,4]:=1;
      el[i,1]:=ycon[ii];
    end;
 {  SOLVE THE LEAST SQUARES ALGORITHM  }
    matr;
    matm1;
    ata[3,2]:=0;
    ata[2,3]:=0;
    matm2;
    mati;
    matm3;
    for i:=1 to np do
    begin
      xgro[i]:=x[1,1]+x[2,1]*xmeas[i]-x[3,1]*ymeas[i];
      ygro[i]:=x[2,1]*ymeas[i]+x[3,1]*xmeas[i]+x[4,1];
    end;
end;

procedure display_data1(j:integer);
begin
  if (j = 1) then
  begin
    wrt(37,6,15,'    ');
    gotoxy(37,6);    write(ncon:1);
  end;
  wrt(26,10,15,'    ');          gotoxy(26,10); write(p[j]);
  wrt(26,11,15,'            ');  gotoxy(26,11); write(xmeas[j]:4:3);
  wrt(26,12,15,'             '); gotoxy(26,12); write(ymeas[j]:4:3);
  wrt(55,10,15,'    ');          gotoxy(55,10); write(q[j]);
  wrt(55,11,15,'            ');  gotoxy(55,11); write(xcon[j]:4:3);
  wrt(55,12,15,'             '); gotoxy(55,12); write(ycon[j]:4:3);
end;
procedure display_data2(j:integer);
begin
  wrt(26,9,15,'    ');           gotoxy(26,9);  write(p[j]);
  wrt(26,10,15,'            ');  gotoxy(26,10); write(xmeas[j]:4:3);
  wrt(26,11,15,'             '); gotoxy(26,11); write(ymeas[j]:4:3);
  wrt(55,9,15,'    ');           gotoxy(55,9);  write(q[j]);
end;
procedure inp1;
var       l:integer;
label     i1,i2,i3,i4,i5,i6,i7;
begin
     l:=1;
     while l <= ncon do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data1(l);
       if l=1 then goto i1 else goto i2;
i1:    input(buff,6,36,4,bit);
       val(buff,ncon,cod);
i2:    input(buff,10,25,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data1(l);
           goto i7;
         end
         else begin end
       else p[l]:=buff;
i3:    input(buff,11,25,13,bit);
       if bit then goto i2 else val(buff,xmeas[l],cod);
i4:    input(buff,12,25,13,bit);
       if bit then goto i3 else val(buff,ymeas[l],cod);
i5:    input(buff,10,54,5.1,bit);
       if bit then goto i4 else q[l]:=buff;
i6:    input(buff,11,54,13,bit);
       if bit then goto i5 else val(buff,xcon[l],cod);
i7:    input(buff,12,54,13,bit);
       if bit then goto i6 else val(buff,ycon[l],cod);
       move(rec1.xx[0],mem[$b000:ofs1],3680);
       gotoxy(37,6);    write(ncon:1);
       l:=succ(l);
     end;
end;

procedure inp2;
var       l:integer;
label     i2,i3,i4,i5;
begin
     l:=ncon+1;
     repeat
       move(rec1.xx[0],mem[$b000:ofs1],3680);
i2:    input(buff,9,25,5.1,bit); p[l]:=buff;
i3:    input(buff,10,25,13,bit);
       if bit then goto i2 else val(buff,xmeas[l],cod);
i4:    input(buff,11,25,13,bit);
       if bit then goto i3 else val(buff,ymeas[l],cod);
i5:    input(buff,9,54,5.1,bit);
       if bit then goto i4 else q[l]:=buff;
       l:=succ(l);
       wrt(22,14,15,'ëìåÑïàÖÑàë ãÑ Äääé ëÜãÑàé (N/O) ;');
       gotoxy(55,14);    read(kbd,cha);
     until cha in ['O','o','é','¶'];
     np:=l-1;
     epex;
end;

procedure diorth2;
var       l:integer;
label     i1,i3,i4,i5;
begin
     l:=ncon+1;
     while l <= np do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data2(l);
i1:    input(buff,9,25,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = ncon then l:=ncon+1;
           display_data2(l);
           goto i5;
         end
         else begin end
       else p[l]:=buff;
i3:    input(buff,10,25,13,bit);
       if bit then goto i1 else val(buff,xmeas[l],cod);
i4:    input(buff,11,25,13,bit);
       if bit then goto i3 else val(buff,ymeas[l],cod);
i5:    input(buff,9,54,5.1,bit);
       if bit then goto i4 else q[l]:=buff;
       move(rec1.xx[0],mem[$b000:ofs1],3680);
       l:=succ(l);
     end;
     epex;
end;

procedure selida;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':70,'ëÑäàÉÄ : ',sel:1);
  writeln(fill);
end;
procedure epikef1;
begin
  writeln(fill,'  =========================================================================');
  writeln(fill,'      ÄåÄäìíàâÜ  èêéëÄêãéÇÜ  Éìé  ëìëíÜãÄíóå  éêáéÇóåàóå  ëìåíÑíÄÇãÑåóå');
  writeln(fill,'           É Ñ É é ã Ñ å Ä   Ä ê ï à â Ä   â é à å Ä   ë Ü ã Ñ à Ä');
  writeln(fill,'  =========================================================================');
  writeln(fill,'      ë  ì  ë  í  Ü  ã  Ä      à             ë  ì  ë  í  Ü  ã  Ä      àà');
  writeln(fill,'  â‡õ†°¶™   íú´£û£ú§û     íú´òö£ú§û      â‡õ†°¶™   íú´£û£ú§û     íú´òö£ú§û');
  writeln(fill,'  -------  -----------  ------------     -------  -----------  ------------');
end;
procedure epikef2;
begin
  writeln(fill,'  =========================================================================');
  writeln(fill,'      ÄåÄäìíàâÜ  èêéëÄêãéÇÜ  Éìé  ëìëíÜãÄíóå  éêáéÇóåàóå  ëìåíÑíÄÇãÑåóå');
  writeln(fill,'             ãÑíÄëïHãÄíàëãéë   Äèé   ëìëíÜãÄ à   ëÑ   ëìëíÜãÄ àà');
  writeln(fill,'  =========================================================================');
  writeln(fill,'      ë  ì  ë  í  Ü  ã  Ä      à             ë  ì  ë  í  Ü  ã  Ä      àà');
  writeln(fill,'  â‡õ†°¶™   íú´£û£ú§û     íú´òö£ú§û      â‡õ†°¶™   íú´£û£ú§û     íú´òö£ú§û');
  writeln(fill,'  -------  -----------  ------------     -------  -----------  ------------');
end;

procedure input_results_in_file;
var       k:integer;
          st:string[7];
begin
  rewrite(fill);
  epikef1;
  for k:=1 to ncon do
  begin
  writeln(fill,' ':3,p[k],' ':8-length(p[k]),xmeas[k]:11:3,'  ',ymeas[k]:12:3,' ':6,
            q[k],' ':8-length(q[k]),xcon[k]:11:3,'  ',ycon[k]:12:3);
  end;
  writeln(fill); writeln(fill); epikef2;
  for k:=ncon+1 to np do
  begin
    writeln(fill,' ':3,p[k],' ':8-length(p[k]),
            xmeas[k]:11:3,'  ',ymeas[k]:12:3,' ':6,
            q[k],' ':8-length(q[k]),xgro[k]:11:3,'  ',ygro[k]:12:3);
  end;
  close(fill);
end;

procedure anal_gr_scr(grammi,k:integer);
begin
  gotoxy(7,grammi);  write(p[k]);
  gotoxy(15,grammi); write(xmeas[k]:11:3);
  gotoxy(28,grammi); write(ymeas[k]:12:3);
  gotoxy(43,grammi); write(q[k]);
  gotoxy(51,grammi); write(xgro[k]:11:3);
  gotoxy(64,grammi); write(ygro[k]:12:3);
end;

procedure write_screen(m,scr_line:integer);
var       k:integer;
begin
  clrscr;
  seek(k026_scr,3);    read(k026_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=ncon+1 to np do
  begin
    anal_gr_scr(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 22 then
    begin
      wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=7;
    end;
  end;
  if m <= 15 then
  begin
    wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;

procedure lprint;
var       sel,gram,k:integer;
          st:string[7];
begin
  selida;
  epikef1;
  gram:=10;
  for k:=1 to ncon do
  begin
    writeln(fill);
    writeln(fill,' ':3,p[k],' ':8-length(p[k]),
            xmeas[k]:11:3,'  ',ymeas[k]:12:3,' ':6,
            q[k],' ':8-length(q[k]),xcon[k]:11:3,'  ',ycon[k]:12:3);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin write(fill,#12); selida; epikef1; gram:=10; end;
  end;
  write(fill,#12);
  selida; epikef2; gram:=10;
  for k:=ncon+1 to np do
  begin
    writeln(fill);
    writeln(fill,' ':3,p[k],' ':8-length(p[k]),
            xmeas[k]:11:3,'  ',ymeas[k]:12:3,' ':6,
            q[k],' ':8-length(q[k]),xgro[k]:11:3,'  ',ygro[k]:12:3);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin write(fill,#12); selida; epikef2; gram:=10; end;
  end;
  write(fill,#12);
  close(fill);
end;

procedure epex_menu;
var       i,j,k:integer;
          ok :boolean;
label     e1,10,25;
begin
    case menu of
       1:begin
           if (sw1 = 1) or (sw3 = 1) then epex_menu;
           clrscr;
           cursor(true,false);
           seek(k026_scr,1);    read(k026_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           ncon:=2;
           inp1;
           seek(k026_scr,2);    read(k026_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           inp2;
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
             assign(in_k026,name);
             {$i-}
             reset(in_k026);
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
             clrscr;
             cursor(false,true);
             wrt(11,12,240,'  â Ä í Ä ï ó ê ó   É Ñ É é ã Ñ å Ä    ë Ñ   Ä ê ï Ñ à é  ');
             rewrite(in_k026);
             j:=0;
             for j:=1 to ncon do
             begin
               with in1_rec do
               begin
                 ncon_h:=ncon; p_h:=p[j]; q_h:=q[j];
                 xmeas_h:=xmeas[j]; ymeas_h:=ymeas[j];
                 xcon_h:=xcon[j]; ycon_h:=ycon[j];
               end;
               write(in_k026,in1_rec);
             end;
             for j:=ncon+1 to np do
             begin
               with in2_rec do
               begin
                 p_h:=p[j]; q_h:=q[j];
                 xmeas_h:=xmeas[j]; ymeas_h:=ymeas[j];
               end;
               write(in_k026,in1_rec);
             end;
             close(in_k026);
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
           gotoxy(13,21); read(filename);
           if cha in ['F','f','î','≠'] then
           begin
             assign(in_k026,filename);
             {$i-}
             reset(in_k026);
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
             reset(in_k026);
             seek(in_k026,0);
             read(in_k026,in1_rec);
             with in1_rec do
             begin
               ncon:=ncon_h; p[1]:=p_h; q[1]:=q_h;
               xmeas[1]:=xmeas_h; ymeas[1]:=ymeas_h;
               xcon[1]:=xcon_h; ycon[1]:=ycon_h;
             end;
             for j:=2 to ncon do
             begin
               with in1_rec do
               begin
                 read(in_k026,in1_rec);
                 p[j]:=p_h; q[j]:=q_h;
                 xmeas[j]:=xmeas_h; ymeas[j]:=ymeas_h;
                 xcon[j]:=xcon_h; ycon[j]:=ycon_h;
               end;
             end;
             j:=ncon+1;
             repeat
               with in2_rec do
               begin
                 read(in_k026,in1_rec);
                 p[j]:=p_h; q[j]:=q_h;
                 xmeas[j]:=xmeas_h; ymeas[j]:=ymeas_h;
               end;
               j:=j+1;
             until eof(in_k026);
             np:=j-1;
             close(in_k026);
             epex;
           end
           else
           begin
             assign(f_txt,filename);
             {$i-}
             reset(f_txt);
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
             reset(f_txt);
             readln(f_txt,b1_h);    val(b1_h,ncon,cod);
             for j:=1 to ncon do
             begin
               readln(f_txt,b2_h);    p[j]:=b2_h;
               readln(f_txt,b3_h);    val(b3_h,xmeas[j],cod);
               readln(f_txt,b4_h);    val(b4_h,ymeas[j],cod);
               readln(f_txt,b5_h);    q[j]:=b5_h;
               readln(f_txt,b6_h);    val(b6_h,xcon[j],cod);
               readln(f_txt,b7_h);    val(b7_h,ycon[j],cod);
             end;
             j:=ncon+1;
             repeat
               readln(f_txt,b2_h);    p[j]:=b2_h;
               readln(f_txt,b3_h);    val(b3_h,xmeas[j],cod);
               readln(f_txt,b4_h);    val(b4_h,ymeas[j],cod);
               readln(f_txt,b5_h);    q[j]:=b5_h;
               j:=j+1;
             until eof(f_txt);
             np:=j-1;
             epex;
             close(f_txt);
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
           seek(k026_scr,1);    read(k026_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           inp1;
           seek(k026_scr,2);    read(k026_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
           diorth2;
           repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
           cursor(false,true);
10:        clrscr;
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
               if cha in ['O','o','é','¶'] then goto e1;
             end;
             clrscr;
             cursor(false,true);
             wrt(11,12,240,' Ç ê Ä î ó   Ä è é í Ñ ä Ñ ë ã Ä í Ä   ë Ñ   Ä ê ï Ñ à é ');
             input_results_in_file;
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
25:          wrt_screen(OthPrint,1,4,45,17);
             gotoxy(32,13); read(ar_gram);
             if ad then goto 25;
             gotoxy(3,15); write('ÑåÑêÇéèéàÜëÑ íéå ÑâíìèóíÜ ëE ÄêïÜ ëÑäàÉÄë');
             gotoxy(10,16); write('èÄíÜëÑ RETURN ÇàÄ ÑâíìèóëÜ..');
             repeat read(kbd,cha) until cha in [#10,#13];
             cursor(false,true);
             assign(fill,'prn');
             clrscr;
             wrt(29,12,240,'Ñ  â  í  ì  è  ó  å  ó..');
             rewrite(fill);
             write(fill,#27,#67,chr(ar_gram));
             sel:=0;
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
             write_screen(np,7);
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
assign(k026_scr,'TRANSF.scr');
reset(k026_scr);
seek(k026_scr,4); read(k026_scr,rec1);
for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);
delete_all_input;
sw1:=0;    sw3:=0;    sw4:=0;    ncon:=0;    np:=0;    sel:=0;
cursor(false,true);
epex_menu;
END.

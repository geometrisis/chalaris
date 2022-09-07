{******************************************************************************
*   LALS ¡÷œÃœ…Ÿ”« ◊Ÿ—œ”‘¡»Ã… œ’ ƒ… ‘’œ’,’–œÀœ√…”Ãœ” ◊Ÿ—œ”‘¡»Ã… œ’ ƒ… ‘’œ’ *
*                  WRITTEN BY G.XALARIS                         *
*                              04-03-1987                                     *
*******************************************************************************}
TYPE     rec=record
           xx:array [0..3679] of BYTE;
         end;
         rec1_k041=record  {64 Bytes}
           titleY     :string[48];
           nnewY,nfixY:integer;
           igeodY     :string[4];
           hY         :real;
         end;
         rec2_k041=record  {64 Bytes}
           nfixY  :integer;
           igeodfY:string[4];
           Dummy  :string[56];
         end;
         rec3_k041=record  {64 Bytes}
           ndhY      :integer;
           igdY,kgdhY:string[4];
           ddhY,ppsY :real;
           Dummy     :string[39];
         end;
         string40 =string[40];
         string255=string[255];
         string20 =string[20];
         string48 =string[48];
         matr1 = array [1..70] of string[4];
         matr2 = array [1..70] of real;
         matr3 = array [1..70] of integer;

VAR      igeod,igeodf,igd,kgdh,igeodn : ^matr1;
         h,ddh,pps,HNew,sh            : ^matr2;
         ifixx,knewal,ndh             : ^matr3; 
         so,vv:real;
         nnew,nfix,nall,parathr,nobs,ir,irband : integer;
         title : string[48];
         buff1,buff2,buff3 : string[40];
         OthInp,OthPrint:array[1..3680] of byte;
         k041_scr: file of rec;
         rec1: rec;
         ofs1,cod,l,j: integer;
         buff: string40;
         bit,ok: boolean;
         name,filename: string[66];
         fill: text;
         dstr: string[20];
         f,temp1,temp2,TXTA,prosTxt : text;
         b : string[25];

         in_k041:file of rec1_k041;
         in1_rec:rec1_k041;
         in2_rec:rec2_k041 absolute in1_rec;
         in3_rec:rec3_k041 absolute in1_rec;

         sw1,sw3,sw4,sw6,swepex :byte;
         cha :char;
         sel,gram,ar_gram :integer;

  {$I WRT-MON.PRC}
  {$I REPSTR.FNC}
  {$I UDIP.PRC}
  {$I AD.FNC}
  {$I CURSOR.PRC}
  {$I ARITH.INP}
  {$I WRTSCR.PRC}

Procedure delete_all_input;
Begin
  nnew:=0; nfix:=0; nall:=0; parathr:=0; swepex:=0; so:=0;
  fillchar(igeod^,sizeof(igeod^),0);   fillchar(igeodf^,sizeof(igeodf^),0);
  fillchar(igd^,sizeof(igd^),0);       fillchar(kgdh^,sizeof(kgdh^),0);
  fillchar(igeodn^,sizeof(igeodn^),0); fillchar(h^,sizeof(h^),0);
  fillchar(ndh^,sizeof(ndh^),0);       fillchar(ddh^,sizeof(ddh^),0);
  fillchar(pps^,sizeof(pps^),0);       fillchar(ifixx^,sizeof(ifixx^),0);
  fillchar(knewal^,sizeof(knewal^),0); fillchar(HNew^,sizeof(HNew^),0);
  fillchar(sh^,sizeof(sh^),0);
end;

Procedure DisposePtrs;
Begin
  dispose(igeod); dispose(igeodf); dispose(igd); dispose(kgdh); dispose(igeodn);
  dispose(h);     dispose(ddh);    dispose(pps); dispose(HNew); dispose(sh);
  dispose(ifixx); dispose(knewal); dispose(ndh);
End;

Procedure beep(freq,dur:integer);
Begin
  sound(freq);
  delay(dur);
  nosound;
end;
function menu:byte;
label    5;
var      deik,row,col,i:byte;
         ch:char;
Procedure paint_box(ra,ca,rt,ct,att:byte);
          var rows,cols,i:byte;
          begin
            rows:=rt-ra+1;
            cols:=ct-ca+1;
            for i:=1 to rows do wrt(ca,i+ra-1,att,chr(cols));
          end;
Begin
     seek(k041_scr,0);     read(k041_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k041_scr);
         cursor(true,false);
         if swepex=1 then
         begin
           erase(txta); erase(temp1); erase(prosTxt);
         end;
         DisposePtrs;
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
                    close(k041_scr);
                    if swepex=1 then
                    begin
                      erase(txta); erase(temp1); erase(prosTxt);
                    end;
                    cursor(true,false);
                    DisposePtrs;
                    halt;
                  end;
  '4','6',#75,#77:begin      { <ƒƒ , ƒƒ> }
                    paint_box(row,col,row+2,col+17,15);
                    if col=21 then col:=40 else col:=21;
                    paint_box(row,col,row+2,col+17,112);
                    deik:=(row div 4)*2-1;
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

{----------------------------EPEXERGASIA--------------------------------------}
Procedure EPEX;
type      matr3 = array [1..100] of integer;
          matr4 = array[1..100] of real;
          matr5 = array [1..100,1..100] of real;
          matr6 = array [1..100,1..100] of real;
var       i,j,ki,ip,k,kk,j1,j2,irr1,itrig,l,l1,new1,
          jj,jro,ico,ic1,jr,me,jr1,jrr,icco,icc1,ll,
          min,maxb,maxbc,i2,keq,i11,iaux,ivarx,
          k1,k2,irk1,ifylbd,irk1i,irm1,ip1,ip2,ipk1,ms,
          it,ms1,metr,ipp,is,mpk1,m,irk2,nrband,iss,ism1,
          ii,m1,mn,ln : integer;
          psq2,psq1,psq,alfa,so2,ss : real;
          kst,str4 : string[4];
          innew,kodh,new2,minr,maxr,icola,
          icolt,ib                  : ^matr3;
          dh,ps,f,dhy,pp,w,ww,dho,v : ^matr4;
          c                         : ^matr5;
          a                         : ^matr6;
label     530,610,870,1020,1150,1220,1460,1590,1610,1620,1860,1970,2400,
          2800,2810,2880,2910,2950,2960,3090,3150,3250;
Begin
    new(innew); new(kodh); new(new2); new(minr); new(maxr); new(icola);
    new(icolt); new(ib);   new(dh);   new(ps);   new(f);    new(dhy);
    new(pp);    new(w);    new(ww);   new(dho);  new(v);    new(c);  new(a);
    fillchar(innew^,sizeof(innew^),0);    fillchar(kodh^,sizeof(kodh^),0);
    fillchar(new2^,sizeof(new2^),0);      fillchar(minr^,sizeof(minr^),0);
    fillchar(maxr^,sizeof(maxr^),0);      fillchar(icola^,sizeof(icola^),0);
    fillchar(icolt^,sizeof(icolt^),0);    fillchar(ib^,sizeof(ib^),0);
    fillchar(dh^,sizeof(dh^),0);          fillchar(ps^,sizeof(ps^),0);
    fillchar(f^,sizeof(f^),0);            fillchar(dhy^,sizeof(dhy^),0);
    fillchar(pp^,sizeof(pp^),0);          fillchar(w^,sizeof(w^),0);
    fillchar(ww^,sizeof(ww^),0);          fillchar(dho^,sizeof(dho^),0);
    fillchar(v^,sizeof(v^),0);            fillchar(c^,sizeof(c^),0);
    fillchar(a^,sizeof(a^),0);
    clrscr;  SwEpex:=1;
    cursor(false,true);
    wrt(23,11,112,'                                 ');
    wrt(23,12,112,'  ú  ®  ö  ò  ù  ¶  £  ò  † ...  ');
    wrt(23,13,112,'                                 ');
    nall:=nnew+nfix;
    ki:=0;
    for i:=1 to nall do
    begin
      for j:=1 to nfix do
      begin
        if igeod^[i]=igeodf^[j] then goto 530;
        if j=nfix then begin ki:=ki+1; igeodn^[ki]:=igeod^[i]; end;
      end;
530:end;
    for i:=1 to nfix do
    begin
      for ip:=1 to nall do
      begin
        if igeodf^[i]=igeod^[ip] then begin ifixx^[i]:=ip; goto 610; end;
      end;
610:end;
    kk:=0; k:=1;
    for j1:=1 to nall do
    begin
      j2:=k;
      if j1=ifixx^[j2] then k:=k+1
        else begin kk:=kk+1; innew^[j1]:=kk; knewal^[kk]:=j1; end;
    end;
 {  FORMING OBSERVATIONS EQUATIONS  }
{   õû£†¶¨®ö‡ ú§ò textfile ö†ò §ò ö®ò≠‡ ´¶¨™ °‡õ†°¶¨™ 'èêéë' ©´û§ epikef2  }
    assign(prosTxt,'prosTxt');
    rewrite(prosTxt);
    nobs:=0; irr1:=nnew;
    reset(temp1);
    for i:=1 to nall do
    begin
      for ip:=1 to nall do
      begin
        if igd^[i]=igeod^[ip] then begin itrig:=ip; goto 870; end;
      end;
870:  if i <> itrig then
      begin
        clrscr; writeln('***CHECK DATA***'); close(temp1);
        erase(temp1); cursor(true,false); DisposePtrs; halt;
      end;
      for j:=1 to ndh^[i] do
      begin
        readln(temp1,b); kgdh^[j]:=b; writeln(prosTxt,kgdh^[j]);
        readln(temp1,b); arith_input(b,dstr); val(dstr,ddh^[j],cod);
        readln(temp1,b); arith_input(b,dstr); val(dstr,pps^[j],cod);
      end;
      for j:=1 to ndh^[i] do
      begin
        for ip:=1 to nall do
        begin
          if kgdh^[j] = igeod^[ip] then begin kodh^[j]:=ip; goto 1020; end;
        end;
1020: end;
      for l:=1 to ndh^[i] do
      begin
        l1:=kodh^[l]; dh^[l1]:=ddh^[l]; ps^[l1]:=pps^[l];
      end;
      nobs:=nobs+ndh^[i];
      new1:=0;
      for j:=1 to nfix do
      begin
        if itrig = ifixx^[j] then
        begin
          new1:=1; goto 1150;
        end;
      end;
1150: for jj:=1 to ndh^[i] do
      begin
        new2^[jj]:=0;
        for j:=1 to nfix do
        begin
          if kodh^[jj]=ifixx^[j] then
          begin
            new2^[jj]:=1; goto 1220;
          end;
        end;
1220: end;
      jro:=nobs-ndh^[i];
      if new1 <> 1 then begin ico:=innew^[itrig]; ic1:=ico; end;
      for jr:=1 to ndh^[i] do
      begin
        me:=0;
        jr1:=jro+jr;
        for k:=1 to irr1 do begin c^[jr1,k]:=0; f^[jr1]:=0; end;
        icola^[jr1]:=0;
        icolt^[jr1]:=0;
        if new1=1 then goto 1460;
        jrr:=kodh^[jr];
        dhy^[jrr]:=h^[jrr]-h^[itrig];
        psq2:=ps^[jrr]/1000.0;
        psq1:=1/sqr(psq2);
        psq:=sqrt(psq1);
        me:=1;
        icola^[jr1]:=ic1;
        icolt^[jr1]:=ic1;
        c^[jr1,ic1]:= -psq;
1460:   if new2^[jr]=1 then goto 1620;
        if me <> 1 then
        begin
          jrr:=kodh^[jr];
          dhy^[jrr]:=h^[jrr]-h^[itrig];
          psq2:=ps^[jrr]/1000.0;
          psq1:=1/sqr(psq2);
          psq:=sqrt(psq1);
        end;
        icco:=innew^[jrr];
        icc1:=icco;
        if new1=1 then goto 1590;
        if icola^[jr1] > icc1 then icola^[jr1]:=icc1;
        if icolt^[jr1] < icc1 then icolt^[jr1]:=icc1;
        goto 1610;
1590:   icola^[jr1]:=icc1;
        icolt^[jr1]:=icc1;
1610:   c^[jr1,icc1]:=psq;
1620:   f^[jr1]:=(dh^[jrr]-dhy^[jrr])*psq;
        pp^[jr1]:=psq1;
      end;
    end;
    close(temp1); close(prosTxt);
    ir:=nnew;
    for ll:=1 to nobs do begin minr^[ll]:=0; maxr^[ll]:=0; end;
    for i:=1 to nobs do
    begin
      min:=icola^[i];
      if minr^[min]=0 then begin minr^[min]:=i; maxr^[min]:=i; end
        else maxr^[min]:=i;
      j1:=min+1; j2:=icolt^[i];
      for j:=j1 to j2 do
      begin
        if c^[i,j]=0 then goto 1860;
        if minr^[j]=0 then begin minr^[j]:=i; maxr^[j]:=i; end else maxr^[j]:=i;
1860: end;
    end;
    for i:=1 to ir do
    begin
      j1:=minr^[i];
      j2:=maxr^[i];
      maxb:=1;
      for j:=j1 to j2 do
      begin
        if c^[j,i]=0 then goto 1970;
        maxbc:=icolt^[j];
        if maxb > maxbc then goto 1970;
        maxb:=maxbc;
1970: end;
      ib^[i]:=maxb-i+1;
    end;
    irband:=1; i2:=0;
    for i:=1 to ir do if irband < ib^[i] then irband:=ib^[i];
    assign(txta,'txta'); rewrite(txta); reset(prosTxt);
    for k:=1 to nall do
    begin
      kst:=igeod^[k];
      keq:=ndh^[k]; if keq=0 then goto 2400;
      i2:=i2+keq;
      i11:=i2-keq+1;
      for i:=i11 to i2 do
      begin
        iaux:=1;
        writeln(txta); readln(prosTxt,str4);
        writeln(txta,'   ',i:3,'    ',kst,' ':5-length(kst),str4,' ':8-length(str4),pp^[i]:8:2,' ':30,f^[i]:7:2);
        j1:=icola^[i]; j2:=icolt^[i];
        for j:=j1 to j2 do
        begin
          if c^[i,j] <> 0 then
          begin
            if iaux = 0 then writeln(txta,' ':38,c^[i,j]:8:2,' ':5,j:3)
              else begin iaux:=0; writeln(txta,' ':38,c^[i,j]:8:2,' ':5,j:3); end;
          end;
        end;
      end;
2400:
    end;
    close(txta); close(prosTxt);
 {  FORMING THE NORMALS  }
    ivarx:=1;
    for i:=1 to ir do
    begin
      j1:=ib^[i];
      k1:=minr^[i];
      k2:=maxr^[i];
      j1:=j1+i-1;
      for j:=i to j1 do
      begin
        a^[i,j]:=0;
        for k:=k1 to k2 do a^[i,j]:=a^[i,j]+c^[k,i]*c^[k,j];
        a^[j,i]:=a^[i,j];
      end;
      w^[i]:=0;
      for kk:=k1 to k2 do w^[i]:=w^[i]+f^[kk]*c^[kk,i];
      ww^[i]:=w^[i];
    end;
    irk1:=ir+1;
    ifylbd:=irband;
    for i:=1 to ir do
    begin
      if ivarx <> 0 then
      begin
        irk1i:=irk1+i; a^[i,irk1i]:=1; a^[i,irk1]:=w^[i];
      end
      else a^[i,irk1]:=w^[i];
    end;
 {  INVERSION OF THE MATRIX  }
    irm1:=ir-1;
    ip1:=ir-irband+1;
    ip2:=ir-2*irband+2;
    for ip:=1 to irm1 do
    begin
      ipk1:=ip+1;
      ms:=ip+2*irband-2;
      i11:=ip+irband-1;
      alfa:=0;
      k:=ip;
2800: kk:=k-ip+1;
2810: if abs(alfa) <= abs(a^[k,ip]) then
      begin
        alfa:=a^[k,ip]; it:=k;
      end;
      if ip > ip1 then goto 2880;
      if kk > irband then goto 2910;
      k:=k+1;
      goto 2800;
2880: if k >= ir then goto 2910;
      k:=k+1;
      goto 2810;
2910: if alfa=a^[ip,ip] then goto 3090;
      ms1:=ms;
      metr:=1;
      ipp:=ip;
2950: if ip >= ip2 then ms1:=ir;
2960: for is:=ipp to ms1 do
      begin
        w^[is]:=a^[ip,is]; a^[ip,is]:=a^[it,is]; a^[it,is]:=w^[is];
      end;
      if metr <> 1 then goto 3090;
      w^[irk1]:=a^[ip,irk1];
      a^[it,irk1]:=w^[irk1];
      if ivarx = 0 then goto 3090;
      ms1:=ir+irband+ip;
      if ip >= ip1 then ms1:=2*ir+1;
      ipp:=ir+2;
      metr:=metr+1;
      goto 2960;
3090: if ip >= ip1 then i11:=ir;
      for i:=ipk1 to i11 do
      begin
        if ip >= ip2 then ms:=ir;
        ms1:=ms;
        metr:=1;
        mpk1:=ipk1;
3150:   for m:=mpk1 to ms1 do a^[i,m]:=a^[i,m]-a^[i,ip]*a^[ip,m]/a^[ip,ip];
        if metr <> 1 then goto 3250;
        a^[i,irk1]:=a^[i,irk1]-a^[i,ip]*a^[ip,irk1]/a^[ip,ip];
        if ivarx=0 then goto 3250;
        ms1:=ir+irband+ip;
        if ip >= ip1 then ms1:=2*ir+1;
        mpk1:=ir+2;
        metr:=metr+1;
        goto 3150;
3250: end;
    end;
    irk2:=ir+2;
    nrband:=2*irband-1;
    j:=0;
    k1:=ir-nrband+1;
    for iss:=1 to irm1 do
    begin
      is:=ir-iss+1;
      k:=k1-j;
      ism1:=is-1;
      if is <= nrband then k:=1;
      for ii:=k to ism1 do
      begin
        i:=ism1-ii+k;
        if ivarx <> 0 then
        begin
          m1:=ir+i+1;
          for m:=irk2 to m1 do a^[i,m]:=a^[i,m]-a^[i,is]*a^[is,m]/a^[is,is];
        end;
        a^[i,irk1]:=a^[i,irk1]-a^[i,is]*a^[is,irk1]/a^[is,is];
      end;
      j:=j+1;
    end;
    for l:=1 to ir do
    begin
      if ivarx <> 0 then
      begin
        m1:=ir+l+1;
        for m:=irk2 to m1 do
        begin
          a^[l,m]:=a^[l,m]/a^[l,l]; mn:=m-ir-1; ln:=l+ir+1; a^[mn,ln]:=a^[l,m];
        end;
      end;
      dho^[l]:=a^[l,irk1]/a^[l,l];
    end;
    vv:=0;
    l:=nobs-ir;
    for i:=1 to nobs do
    begin
      v^[i]:=0;
      for j:=1 to ir do v^[i]:=v^[i]+c^[i,j]*dho^[j];
      v^[i]:=v^[i]-f^[i];
      vv:=vv+sqr(v^[i]);
    end;
    so2:=vv/l;
    so:=sqrt(so2);
    for i:=1 to ir do
    begin
      irk1i:=irk1 +i; ss:=so2*a^[i,irk1i]; sh^[i]:=sqrt(abs(ss));
    end;
    for i:=1 to nnew do
    begin
      j:=knewal^[i]; HNew^[j]:=h^[j];
    end;
    for i:=1 to nnew do
    begin
      j:=knewal^[i]; HNew^[j]:=HNew^[j]+dho^[i];
    end;
    dispose(innew); dispose(kodh);  dispose(new2); dispose(minr); dispose(maxr);
    dispose(icola); dispose(icolt); dispose(ib);   dispose(dh);   dispose(ps);
    dispose(f);     dispose(dhy);   dispose(pp);   dispose(w);    dispose(ww);
    dispose(dho);   dispose(v);     dispose(c);    dispose(a);
end;
{----------------------------DISPLAY--DATA------------------------------------}
Procedure display_data1(j:integer);
Begin
    wrt(36,7,15,'    ');       gotoxy(36,7); write(igeod^[j]);
    wrt(36,8,15,'          '); gotoxy(36,8); write(h^[j]:4:3);
end;
Procedure display_data2(j:integer);
Begin
    wrt(36,12,15,'     '); gotoxy(36,12); write(j);
    wrt(36,13,15,'     '); gotoxy(36,13); write(igeodf^[j]);
end;
Procedure display_data3(j:integer);
Begin
    wrt(49,17,15,'     '); gotoxy(49,17); write(igd^[j]);
    wrt(49,18,15,'     '); gotoxy(49,18); write(ndh^[j]:1);
end;
Procedure display_data4(j:integer);
Begin
    if sw4=1 then
    begin
      readln(temp1,buff); kgdh^[j]:=buff;
      readln(temp1,buff); arith_input(buff,dstr); val(dstr,ddh^[j],cod);
      readln(temp1,buff); arith_input(buff,dstr); val(dstr,pps^[j],cod);
    end;
    wrt(49,19,15,'     '); gotoxy(49,19); write(kgdh^[j]);
    wrt(49,20,15,'     '); gotoxy(49,20); write(ddh^[j]:4:3);
    wrt(49,21,15,'     '); gotoxy(49,21); write(pps^[j]:4:3);
end;
{------------------------------INPUT------------------------------------------}
Procedure inp;
label     i1,i2,i3,i4,i5,i6,i7;
var       l,j:integer;
          cha:char;
Begin
     l:=1;
     while l <= nall do
     begin
       wrt(36,7,15,'    '); wrt(36,13,15,'            ');
       if ((sw1 = 1) or (sw3 = 1)) then display_data1(l);
i1:    input(buff,7,35,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data1(l);
           goto i2;
         end
         else begin end
       else igeod^[l]:=buff;
i2:    input(buff,8,35,11,bit);
       if bit then goto i1 else val(buff,h^[l],cod);
       l:=succ(l);
     end;
     l:=1;
     while l <= nfix do
     begin
       wrt(36,12,15,'     '); wrt(36,12,15,'     ');
       if ((sw1 = 1) or (sw3 = 1)) then display_data2(l);
i3:    gotoxy(36,12); write(l:1);
       input(buff,13,35,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data2(l);
           goto i3;
         end
         else begin end
       else igeodf^[l]:=buff;
       l:=succ(l);
     end;
     assign(temp1,'temp1');
     if sw4=1 then begin
                     reset(temp1); assign(temp2,'temp2'); rewrite(temp2);
                   end else rewrite(temp1);
     l:=0; parathr:=0;
     repeat
       l:=l+1;
       wrt(49,17,15,'     '); wrt(49,18,15,'     ');
       wrt(49,19,15,'     '); wrt(49,20,15,'          ');
       wrt(49,21,15,'            ');
       if ((sw1 = 1) or (sw3 = 1)) then display_data3(l);
i4:    input(buff,17,48,5.1,bit);
       if bit then goto i4 else igd^[l]:=buff;
i5:    input(buff,18,48,3,bit);
       if bit then goto i4 else val(buff,ndh^[l],cod);
       j:=1;
       while j <= ndh^[l] do
       begin
         wrt(49,19,15,'     '); wrt(49,20,15,'          ');
         wrt(49,21,15,'            ');
         if ((sw1 = 1) or (sw3 = 1)) then display_data4(j);
i6:      input(buff1,19,48,5.1,bit); if bit then goto i6;
i7:      input(buff2,20,48,10,bit);  if bit then goto i6;
         input(buff3,21,48,10,bit);  if bit then goto i7;
         if sw4=0 then
         begin
           writeln(temp1,buff1); writeln(temp1,buff2); writeln(temp1,buff3);
         end
         else begin
           writeln(temp2,buff1); writeln(temp2,buff2); writeln(temp2,buff3);
         end;
         j:=j+1; parathr:=succ(parathr);
       end;
       gotoxy(23,23); write('ÄääÜ èÄêÄíÜêÜëÜ; (N/O) : '); read(cha);
       gotoxy(20,23); ClrEol;
     until (cha in ['O','o']) or (l=nall);
     close(temp1);
     if sw4=1 then begin close(temp2); erase(temp1); rename(temp2,'temp1'); end;
     clrscr; epex;
end;
{--------------------------WRITE--SCREEN--------------------------------------}
Procedure AnalGrScr1(grammi,k:integer);
Begin
  gotoxy(24,grammi); write(igeodf^[k]);
  gotoxy(36,grammi); write(h^[ifixx^[k]]:10:3);
  gotoxy(57,grammi); write('0.000');
end;
Procedure AnalGrScr2(grammi,k:integer);
Begin
  gotoxy(24,grammi); write(igeodn^[k]);
  gotoxy(36,grammi); write(HNew^[knewal^[k]]:10:3);
  gotoxy(56,grammi); write(sh^[k]:6:3);
end;
Procedure write_screen;
var       k,scr_line:integer;
Begin
  clrscr; scr_line:=6;
  seek(k041_scr,3);    read(k041_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to nfix do
  begin
    AnalGrScr1(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 22 then
    begin
      wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=6;
    end;
  end;
  wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
  for k:=1 to nnew do
  begin
    AnalGrScr2(scr_line,k);
    scr_line:=scr_line + 1;
    if scr_line = 22 then
    begin
      wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
      repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
      move(rec1.xx[0],mem[$b000:ofs1],3680);
      scr_line:=7;
    end;
  end;
  if nnew <= 15 then
  begin
    wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;
{------------------------------OUTPUT-----------------------------------------}
Procedure selida;
Begin
    sel:=sel + 1;
    writeln(fill);
    writeln(fill,' ':68,'ëÑäàÉÄ : ',sel:1);
    writeln(fill);
end;
Procedure epikef1(Evr,MetrD,Diast:integer);
var       k:byte;
Begin
  for k:=1 to 4 do writeln(fill);
  writeln(fill,chr(14),'  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');
  writeln(fill,chr(14),'    ÄîéãéàóëÜ ïóêéëíÄáãàâéì Éàâíìéì');
  writeln(fill,' ':18,'*** ãÑ íÜå ãÑáéÉé ãÑíÄÅéäÜë ìñéãÑíêóå ***');
  writeln(fill,chr(14),'  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');
  writeln(fill); writeln(fill);
  writeln(fill,' ':10,'ÑêÇÄëàÄ : ',title);
  writeln(fill);
  writeln(fill,' ':10,'èäÜáéë ëÜãÑàóå Éàâíìéì : ',nall:1);
  writeln(fill);
  writeln(fill,' ':10,'èäÜáéë ÄÇåóëíóå : ',nnew:1);
  writeln(fill);
  writeln(fill,' ':10,'èäÜáéë èÄêÄíÜêÜëÑóå  (ãÑíêÜãÑåóå ìñéãÑíêàâóå ÉàÄîéêóå) : ',MetrD:1);
  writeln(fill);
  writeln(fill,' ':10,'ÉàÄëíÄëÑàë èàåÄâÄ KÄåéåàâéì ëìëíÜãÄíéë : ',Diast:1,' X ',Diast:1);
  writeln(fill);
  writeln(fill,' ':10,'ÉàÄëíÄëÑàë ÅÑäíàëíéèéàÜãÑåéì èàåÄâÄ : ',Evr:1,' X ',Evr:1);
  writeln(fill);
  writeln(fill,' ':10,'ãÑíÄÅäÜíéíÜíÄ ãéåÄÉÄë ÅÄêéìë : ',so);
  writeln(fill);
  writeln(fill,' ':10,'ÄáêéàëãÄ ìèéäéàèóå [vv] : ',vv:4:3);
  writeln(fill);
end;
Procedure epikef2;
Begin
  writeln(fill,'=======================================================================');
  writeln(fill,'   Ñ  ç  à  ë  ó  ë  Ñ  à  ë      è  Ä  ê  Ä  í  Ü  ê  Ü  ë  Ñ  ó  å');
  writeln(fill,'=======================================================================');
  writeln(fill,'           âóÉàâéà                 ëìåíÑäÑëíÑë ëìëíÜãÄíéë');
  writeln(fill,'   Ä/Ä    Äèé  èêéë     ÅÄêéë      âÄà  ëíÜäÜ èéì ÄåÜâéìå    Å ãÑäéë');
  writeln(fill,'   ---    ---- ----    --------       --------    ----       -------');
               { 3 *** 4  **** **** 4  *****.**              30              ****.**
                                           38         ********  5  ***}
end;
Procedure epikef3;
Begin
  writeln(fill,'    ============================================');
  writeln(fill,'      Ä î é ã é à ó ã Ñ å Ä    ì ñ é ã Ñ í ê Ä');
  writeln(fill,'    ============================================');
  writeln(fill,'        âóÉàâéë    ìñéãÑíêé    ã.í. ëîÄäãÄ');
  writeln(fill,'        -------    --------    -----------');
               {    10    ****  5  ****.***    9    **.***}
end;
Procedure RESULTS;
var       i,gram:integer;
          st80:string[80];
Begin
  IF SW6=0 THEN AR_GRAM:=66;
  selida;
  epikef1(irband,nobs,ir);
  write(fill,#12);
  selida; epikef2; gram:=9; reset(txta);
  repeat
    readln(txta,st80); writeln(fill,st80); gram:=gram+1;
    if gram >= ar_gram-2 then
    begin
      write(fill,#12); selida; epikef2; gram:=9;
    end;
  until eof(txta);
  close(txta);
  write(fill,#12);
  selida; epikef3; gram:=8;
  for i:=1 to nfix do
  begin
    writeln(fill,' ':10,igeodf^[i],' ':9-length(igeodf^[i]),h^[ifixx^[i]]:8:3,
            ' ':10,'0.000');
    gram:=gram+1;
    if gram >= ar_gram-2 then
    begin
      write(fill,#12); selida; epikef3; gram:=8;
    end;
  end;
  for i:=1 to nnew do
  begin
    writeln(fill,' ':10,igeodn^[i],' ':9-length(igeodn^[i]),
            HNew^[knewal^[i]]:8:3,' ':9,sh^[i]:6:3);
    gram:=gram+1;
    if gram >= ar_gram-2 then
    begin
      write(fill,#12); selida; epikef3; gram:=8;
    end;
  end;
  writeln(fill,#12);
end;


Procedure epex_menu;
var       j,k:integer;
          ok :boolean;
label     e1,10,e2,e3,e4,e5,25;
Begin
    case menu of
       1:begin
           if (sw1 = 1) or (sw3 = 1) then epex_menu;
           cursor(true,false);
           seek(k041_scr,1);    read(k041_scr,rec1);
           move(rec1.xx[0],mem[$b000:ofs1],3680);
e2:        input(buff,10,25,48.1,bit);
           if bit then goto e2 else title:=buff;
e4:        input(buff,12,33,3,bit);
           if bit then goto e2 else val(buff,nnew,cod);
           if not (nnew in [1..70]) then goto e4;
e5:        input(buff,14,33,3,bit);
           if bit then goto e4 else val(buff,nfix,cod);
           if not (nfix in [1..70]) then goto e5;
           nall:=nnew+nfix;
           seek(k041_scr,2);    read(k041_scr,rec1);
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
             assign(in_k041,name);
             {$i-}
             reset(in_k041);
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
             rewrite(in_k041);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 titleY:=title; nnewY:=nnew; nfixY:=nfix;
                 igeodY:=igeod^[j]; hY:=h^[j];
               end;
               write(in_k041,in1_rec);
             until j=nall;
             j:=0;
             repeat
               j:=j+1;
               with in2_rec do
               begin
                 nfixY:=nfix; igeodfY:=igeodf^[j];
               end;
               write(in_k041,in1_rec);
             until j=nfix;
             reset(temp1);
             j:=0;
             repeat
               j:=j+1;
               with in3_rec do
               begin
                 igdY:=igd^[j]; ndhY:=ndh^[j];
                 readln(temp1,buff1); kgdhY:=buff1;
                 readln(temp1,buff2); arith_input(buff2,dstr);
                                      val(dstr,ddhY,cod);
                 readln(temp1,buff3); arith_input(buff3,dstr);
                                      val(dstr,ppsY,cod);
               end;
               write(in_k041,in1_rec);
             until j=parathr;
             close(in_k041); close(temp1);
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
             assign(in_k041,filename);
             {$i-}
             reset(in_k041);
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
             delete_all_input;
             reset(in_k041);
             seek(in_k041,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k041,in1_rec);
               with in1_rec do
               begin
                 if j=1 then begin title:=titleY; nnew:=nnewY; nfix:=nfixY; end;
                 igeod^[j]:=igeodY; h^[j]:=hY;
               end;
             until j=nnew+nfix;
             nall:=nnew+nfix; j:=0;
             repeat
               j:=j+1;
               read(in_k041,in1_rec);
               with in2_rec do
               begin
                 igeodf^[j]:=igeodfY;
               end;
             until j=nfix;
             j:=0; parathr:=0; assign(temp1,'temp1'); rewrite(temp1);
             repeat
               j:=j+1;
               read(in_k041,in1_rec);
               with in3_rec do
               begin
                 igd^[j]:=igdY; ndh^[j]:=ndhY; writeln(temp1,kgdhY);
                 writeln(temp1,ddhY); writeln(temp1,ppsY);
               end;
               parathr:=succ(parathr);
             until eof(in_k041);
             close(in_k041); close(temp1);
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
             delete_all_input;
             reset(f);
             readln(f,title);
             readln(f,b); arith_input(b,dstr); val(dstr,nnew,cod);
             readln(f,b); arith_input(b,dstr); val(dstr,nfix,cod);
             nall:=nnew+nfix;
             j:=0;
             repeat
               j:=j+1;
               readln(f,b); igeod^[j]:=b;
               readln(f,b); arith_input(b,dstr); val(dstr,h^[j],cod);
             until (j=nall);
             j:=0;
             repeat
               j:=j+1;
               readln(f,b); igeodf^[j]:=b;
             until (j=nfix);
             j:=0; parathr:=0;
             assign(temp1,'temp1'); rewrite(temp1);
             repeat
               j:=j+1;
               readln(f,b); igd^[j]:=b;
               readln(f,b); arith_input(b,dstr); val(dstr,ndh^[j],cod);
               l:=0;
               repeat
                 l:=l+1;
                 readln(f,b); writeln(temp1,b); readln(f,b);
                 writeln(temp1,b); readln(f,b); writeln(temp1,b);
                 parathr:=succ(parathr);
               until l=ndh^[j];
             until eof(f);
             close(f); close(temp1);
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
           seek(k041_scr,2);    read(k041_scr,rec1);
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
             sel:=0; clrscr;
             cursor(false,true);
             wrt(9,12,240,'  â Ä í Ä ï ó ê ó   Ä è é í Ñ ä Ñ ë ã Ä í Ä   ë Ñ   Ä ê ï Ñ à é  ');
             rewrite(fill);
             results;
             close(fill);
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
25:          wrt_screen(OthPrint,1,4,45,17);
             gotoxy(32,13); read(ar_gram);
             if ad then goto 25;
             gotoxy(3,15); write('ÑåÑêÇéèéàÜëÑ íéå ÑâíìèóíÜ ëE ÄêïÜ ëÑäàÉÄë');
             gotoxy(10,16); write('èÄíÜëÑ RETURN ÇàÄ ÑâíìèóëÜ..');
             repeat read(kbd,cha) until cha in [#10,#13];
             cursor(false,true);
             assign(fill,'prn');
             rewrite(fill);
             clrscr;
             wrt(29,12,240,'Ñ  â  í  ì  è  ó  å  ó..');
             write(fill,#27,#67,chr(ar_gram));
             sel:=0; results; write(fill,#12);
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
end;     { Procedure }

BEGIN
  clrscr;
  ofs1:=$8000;
  if mem[0:1040] and 48 = 48 then ofs1:=$0000;
  assign(k041_scr,'LALS.scr');
  reset(k041_scr);
  seek(k041_scr,4); read(k041_scr,rec1);
  for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
  for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
  sw1:=0; sw3:=0; sw4:=0; sw6:=0; sel:=0;
  new(igeod); new(igeodf); new(igd); new(kgdh); new(igeodn); new(h);
  new(ddh); new(pps); new(HNew); new(sh); new(ifixx); new(knewal); new(ndh);
  delete_all_input;
  cursor(false,true);
  epex_menu;
END.

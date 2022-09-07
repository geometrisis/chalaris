{******************************************************************************
*       TALS ¡÷œÃœ…Ÿ”« ƒ… ‘’œ’ ’ÿœÃ≈‘—… œ’ , ‘—…√ŸÕœÃ≈‘—… «” ’ÿœÃ≈‘—…¡”      *
*                  WRITTEN BY G.XALARIS                         *
*                              28-02-1987                                     *
*******************************************************************************}
Type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k038=record  {30 Bytes}
             nmaxY:integer;
           numeroY:string[4];
       xY,yY,hpraY:real;
             Dummy:string[4];
         end;
         rec2_k038=record  {30 Bytes}
             imaxY:integer;
           ioY,ieY:string[4];
     dtY,zobsY,dmY:real;
         end;
         rec3_k038=record  {30 Bytes}
           nipfixY:integer;
            ipfixY:string[4];
             Dummy:string[22];
         end;

         string40 =string[40];
         string255=string[255];
         string4  =string[4];
         string20 =string[20];

         matr1 = array[1..50] of string[4];
         matr2 = array[1..200] of byte;
         matr3 = array[1..200] of string[4];
         matr4 = array[1..50] of real;
         matr5 = array[1..200] of real;
         matr6 = array[1..200] of real;
         matr7 = array[1..200] of byte;
         matr7b= array[1..50] of byte;

Var      nmax,imax,iall,nipfix,nbmax:integer;
         numero,ipfix            : ^matr1;
         nb                      : ^matr2;
         io,ie                   : ^matr3;
         x,y                     : ^matr4;
         dt,dm,zobs,hm,fkreel,
         zred,zfin,fkprov,correc : ^matr5;
         hdef,hdss,hpra          : ^matr6;
         io1,ie1                 : ^matr7;
         numero1,ipfix1          : ^matr7b;
         falou:real;
         OthInp,OthPrint:array[1..3680] of byte;
         k038_scr  : file of rec;
         rec1      : rec;
         ofs1,cod,j: integer;
         buff      : string40;
         bit,ok    : boolean;
         name,filename:string[66];
         fill: text;
         dstr: string[20];
         f : text;
         b : string[12];
         in_k038:file of rec2_k038;
         in2_rec:rec2_k038;
         in1_rec:rec1_k038 absolute in2_rec;
         in3_rec:rec3_k038 absolute in2_rec;
         sw1,sw3,sw4,sw6,SwRead:byte;
         cha     :char;
         sel     :integer;
         gram    :integer;
         ar_gram :integer;

  {$I WRT-MON.PRC}
  {$I REPSTR.FNC}
  {$I UDIP.PRC}
  {$I AD.FNC}
  {$I CURSOR.PRC}
  {$I ARITH.INP}
  {$I WRTSCR.PRC}

procedure delete_all_input;
begin
    fillchar(numero^,sizeof(numero^),0); fillchar(ipfix^,sizeof(ipfix^),0);
    fillchar(nb^,sizeof(nb^),0);         fillchar(io^,sizeof(io^),0);
    fillchar(ie^,sizeof(ie^),0);         fillchar(x^,sizeof(x^),0);
    fillchar(y^,sizeof(x^),0);           fillchar(dt^,sizeof(dt^),0);
    fillchar(dm^,sizeof(dm^),0);         fillchar(zobs^,sizeof(zobs^),0);
    fillchar(hm^,sizeof(hm^),0);         fillchar(fkreel^,sizeof(fkreel^),0);
    fillchar(zred^,sizeof(zred^),0);     fillchar(zfin^,sizeof(zfin^),0);
    fillchar(fkprov^,sizeof(fkprov^),0); fillchar(correc^,sizeof(correc^),0);
    fillchar(hdef^,sizeof(hdef^),0);     fillchar(hdss^,sizeof(hdss^),0);
    fillchar(hpra^,sizeof(hpra^),0);     fillchar(numero1^,sizeof(numero1^),0);
    fillchar(io1^,sizeof(io1^),0);       fillchar(ie1^,sizeof(ie1^),0);
    fillchar(ipfix1^,sizeof(ipfix1^),0);
end;

Procedure DisposePtrs;
Begin
  dispose(numero); dispose(ipfix); dispose(nb);     dispose(io);
  dispose(ie);     dispose(x);     dispose(y);      dispose(dt);
  dispose(dm);     dispose(zobs);  dispose(hm);     dispose(fkreel);
  dispose(zred);   dispose(zfin);  dispose(fkprov); dispose(correc);
  dispose(hdef);   dispose(hdss);  dispose(hpra);   dispose(numero1);
  dispose(io1);    dispose(ie1);   dispose(ipfix1);
end;

procedure beep(freq,dur:integer);
begin
  sound(freq); delay(dur); nosound;
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
            for i:=1 to rows do wrt(ca,i+ra-1,att,chr(cols));
          end;
begin
     seek(k038_scr,0);     read(k038_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         clrscr;
         close(k038_scr);
         cursor(true,false);
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
                    clrscr; close(k038_scr); cursor(true,false);
                    DisposePtrs; halt;
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

{----------------------------EPEXERGASIA--------------------------------------}
procedure arc(dx,dy:real; var az:real);
var       p,a1:real;
begin
  p:=arctan(1)*4;
  if dx<0 then
  begin
    if dy<0 then begin a1:=arctan(abs(dx/dy)); az:=p+a1; end;
    if dy=0 then az:=3*p/2;
    if dy>0 then begin a1:=arctan(abs(dx/dy)); az:=2*p-a1; end;
  end;
  if dx=0 then begin
                 if dy<0 then az:=p; if dy>0 then az:=0;
               end;
  if dx>0 then
  begin
    if dy<0 then begin a1:=arctan(abs(dx/dy)); az:=p-a1; end;
    if dy=0 then az:=p/2;
    if dy>0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
  end;
end;
PROCEDURE EPEX;
const     r     =6366000.0;
type      matr8 = array [1..200] of real;
          matr9 = array [1..100,1..100] of real;
          matr10= array [1..100,1..100] of real;
          matr11= array [1..100,1..100] of real;
          matr12= array [1..5000] of real;
          matr13= array [1..200] of integer;
var       i,k,it,iv,tkb,ii,j,n,ij,nk,kk,iz,ki,ji,jp,
          jk,ik,kj,jq,jr,iresol,m1,m2,ivf,ikf,ib,itub,
          itab,i1,inn,im,jim,lim:integer;
          ivo,a1:byte;
          coef,afat,fina,total,qmoy,skk,biga,absb,absa,
          diaf,hold,d,purit,parit,pi:real;
          hpro,delth,c6,q,para,c1,c2,zc : ^matr8;
          c   : ^matr9;
          aa  : ^matr10;
          dd  : ^matr11;
          a   : ^matr12;
          l,m : ^matr13;
label     550,630,810,890,920,930,1270,1320,1700,1960,2020,2280,2560,
          2880,3060,3120,5850;
Procedure NewDispose;
Begin
  dispose(hpro); dispose(delth); dispose(c6); dispose(q);
  dispose(para); dispose(c1);    dispose(c2); dispose(zc);
  dispose(c);    dispose(aa);    dispose(dd); dispose(a);
  dispose(l);    dispose(m);
End;
begin
    clrscr;
    cursor(false,true);
    wrt(23,11,112,'                                 ');
    wrt(23,12,112,'  ú  ®  ö  ò  ù  ¶  £  ò  † ...  ');
    wrt(23,13,112,'                                 ');
    new(hpro); new(delth); new(c6); new(q);
    new(para); new(c1);    new(c2); new(zc);
    new(c);    new(aa);    new(dd); new(a);
    new(l);    new(m);
    fillchar(hpro^,sizeof(hpro^),0); fillchar(delth^,sizeof(delth^),0);
    fillchar(c6^,sizeof(c6^),0);     fillchar(q^,sizeof(q^),0);
    fillchar(para^,sizeof(para^),0); fillchar(c1^,sizeof(c1^),0);
    fillchar(c2^,sizeof(c2^),0);     fillchar(zc^,sizeof(zc^),0);
    fillchar(c^,sizeof(c^),0);       fillchar(aa^,sizeof(aa^),0);
    fillchar(dd^,sizeof(dd^),0);     fillchar(a^,sizeof(a^),0);
    fillchar(l^,sizeof(l^),0);       fillchar(m^,sizeof(m^),0);
    pi:=arctan(1)*4.0; coef:=2000000.0/pi;
 {  CALCULATION ON SIDES  }
    for i:=1 to imax do
    begin
      for k:=1 to nmax do if (numero1^[k]=io1^[i]) then goto 550;
      clrscr; gotoxy(1,1); write('äÄáéë ÉÑå ìèÄêïÑà ëâéèÑìëÜ Äèé ',io^[i]);
      cursor(true,false); DisposePtrs; NewDispose; halt;
550:  hpro^[i]:=hpra^[k];
      it:=k;
      for k:=1 to nmax do if (numero1^[k]=ie1^[i]) then goto 630;
      clrscr; gotoxy(1,1); write('äÄáéë ÉÑå ìèÄêïÑà ëâéèÑìëÜ Äèé ',ie^[i]);
      cursor(true,false); DisposePtrs; NewDispose; halt;
630:  iv:=k;
      fkprov^[i]:=sqrt(sqr((x^[it]-x^[iv]))+sqr((y^[it]-y^[iv])));
    end;
    for i:=1 to imax do
    begin
      ivo:=0;
      for k:=1 to imax do
      begin
        if (io1^[k]-ie1^[i] <> 0) then
        begin
          if ((k=imax) and (ivo <> 1)) then
          begin
            write('èêéëéïÜ  Äèé íéå âóÉàâé ',ie1^[i],'ÉÑå ìèÄêïÑà âÄããàÄ ëâéèÑìëÜ');
            writeln('èÄíÜëÑ ÑåÄ èäÜâíêé..');
            repeat until keypressed; goto 810;
          end
          ELSE GOTO 810;
        end;
        if (ivo <> 0) then goto 810;
        ivo:=1;
        hm^[i]:=(hpro^[k]+hpro^[i])/2.0;
        delth^[i]:=hpro^[k]-hpro^[i];
        correc^[i]:=fkprov^[i]*hm^[i]/r;
        fkreel^[i]:=fkprov^[i]+correc^[i];
        afat:=zobs^[i]*pi/200.0;
        c6^[i]:=(((dm^[i]-dt^[i])/fkreel^[i])*coef)*sin(afat);
        zred^[i]:=zobs^[i]+(c6^[i]/10000.0);
810:  end;
    end;
    for i:=1 to imax do
    begin
      for k:=1 to imax do
      begin
        if (io1^[k] <> ie1^[i]) then goto 890;
        if (ie1^[k]=io1^[i]) then goto 920;
890:  end;
      q^[i]:=0;
      goto 930;
920:  q^[i]:=((((zred^[i]+zred^[k])-200)*10000.0)/(2*fkreel^[i]))*pi/2;
930:end;
    for i:=1 to imax do
    begin
      ivo:=0;
      for k:=1 to imax do
      begin
        if (io1^[k]=ie1^[i]) then
        begin
          if (ivo=0) then
          begin
            ivo:=1;
            para^[i]:=636620.0/fkreel^[i];
            c1^[i]:=q^[i]*sqr(fkreel^[i])/1000000.0;
            c2^[i]:=delth^[i]-c1^[i];
            fina:=(delth^[i]-c1^[i])/fkreel^[i];
            arc((1/fina),1.0,zc^[i]);
            if (fina >= 0) then
            begin
              zc^[i]:=zc^[i]*200.0/pi;
              while (zc^[i] >= 400.0) do zc^[i]:=zc^[i]-400;
            end
            else
            begin
              zc^[i]:=200.0+(zc^[i]*200.0/pi);
              while (zc^[i] >= 400) do zc^[i]:=zc^[i]-400;
            end;
            zfin^[i]:=(zc^[i]-zred^[i])*10000.0;
          end;
        end;
      end;
    end;
    total:=0; tkb:=0;
    for i:=1 to imax do
    begin
      for k:=1 to imax do
      begin
        if (io1^[k]=ie1^[i]) then
        begin
          if (ie1^[k]=io1^[i]) then goto 1270;
        end;
      end;
      goto 1320;
1270: if ((q^[i]-0.03) >= 0) then
      begin
        if ((q^[i]-(9.000001E-02)) <= 0) then
        begin
          tkb:=tkb+1;
          total:=total+q^[i];
        end;
      end;
1320:
    end;
    qmoy:=total/tkb;
    skk:=(1-2*(qmoy/1000000.0)*r);
 {  M    A    T    R    I    X  }
 {  CALCULATION OF THE NUMBER OF UNKNOWNS OF THE SYSTEM  }
    for k:=1 to (nmax+1) do nb^[k]:=0;
    k:=1;
    for i:=1 to imax do
    begin
      if (i <> 1) then
      begin
        ii:=i-1;
        if (io1^[i]=io1^[ii]) then goto 1700;
      end;
      if (io1^[i]=nb^[k]) then goto 1700;
      for j:=1 to k do if (io1^[i]=nb^[j]) then goto 1700;
      for j:=1 to nipfix do if (io1^[i]=ipfix1^[j]) then goto 1700;
      nb^[k]:=io1^[i];
      k:=k+1;
1700:
    end;
    nbmax:=k-1;
 {  FORMING THE UNKNOWNS MATRIX  }
    for i:=1 to nbmax do
    begin
      a1:=nb^[i];
      i1:=i;
      for k:=i to nbmax do
      begin
        if (nb^[k] < a1) then
        begin
          a1:=nb^[k]; i1:=k;
        end;
      end;
      nb^[i1]:=nb^[i];
      nb^[i]:=a1;
    end;
    for ik:=1 to imax do for it:=1 to nbmax do c^[ik,it]:=0;
    for inn:=1 to imax do
    begin
      for im:=1 to nbmax do
      begin
        if (io1^[inn]=nb^[im]) then begin c^[inn,im]:=para^[inn]; goto 1960; end;
      end;
1960: for im:=1 to nbmax do
      begin
        if (ie1^[inn]=nb^[im]) then begin c^[inn,im]:=-para^[inn]; goto 2020; end;
      end;
2020:
    end;
 {  CALCULATION OF THE TRANSPOSED MATRIX  }
    for jim:=1 to imax do for lim:=1 to nbmax do dd^[lim,jim]:=c^[jim,lim];
 {  CALCULATION OF THE NORMAL MATRIX  }
    for k:=1 to  nbmax do
    begin
      for i:=1 to nbmax do
      begin
        aa^[k,i]:=0;
        for j:=1 to imax do aa^[k,i]:=aa^[k,i]+dd^[k,j]*c^[j,i];
      end;
    end;
 {  INVERSION OF THE MATRIX  }
    n:=nbmax;
    for j:=1 to n do
    begin
      for i:=1 to n do
      begin
        ij:=n*(j-1)+i; a^[ij]:=aa^[i,j];
      end;
    end;
 {  I    N    V    E    R    T  }
 {  SEARCH FOR LARGEST ELEMENT  }
    d:=1; nk:=-n;
    for k:=1 to n do
    begin
      nk:=nk+n; l^[k]:=k; m^[k]:=k; kk:=nk+k; biga:=a^[kk];
      for j:=k to n do
      begin
        iz:=n*(j-1);
        for i:=k to n do
        begin
          ij:=iz+i;
          absb:=abs(biga);
          absa:=abs(a^[ij]);
          diaf:=absb-absa;
          if (diaf < 0) then
          begin
            biga:=a^[ij]; l^[k]:=i; m^[k]:=j;
          end;
        end;
      end;
   {  INTERCHANGE ROWS  }
      j:=l^[k];
      if ((j-k) > 0) then
      begin
        ki:=k-n;
        for i:=1 to n do
        begin
          ki:=ki+n;
          hold:=-a^[ki];
          ji:=ki-k+j;
          a^[ki]:=a^[ji];
          a^[ji]:=hold;
        end;
      end;
   {  INTERCHANGE COLUMNS  }
      i:=m^[k];
      if (i-k > 0) then
      begin
        jp:=n*(i-1);
        for j:=1 to n do
        begin
          jk:=nk+j;
          ji:=jp+j;
          hold:=-a^[jk];
          a^[jk]:=a^[ji];
          a^[ji]:=hold;
        end;
      end;
   {  DIVIDE COLUMN BY MINUS PIVOT  }
      if biga=0 then begin d:=0; goto 2280; end;
      for i:=1 to n do
      begin
        if ((i-k) <> 0) then begin ik:=nk+i; a^[ik]:=a^[ik]/(-biga); end;
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
                                                      a^[ij]:=a^[ik]*a^[kj]+a^[ij];
                                                    end;
        end;
      end;
   {  DIVIDE ROW BY PIVOT  }
      kj:=k-n;
      for j:=1 to n do
      begin
        kj:=kj+n;
        if ((j-k) <> 0) then a^[kj]:=a^[kj]/biga;
      end;
      d:=d*(biga/1000.0);
{      d:=d*1000.0;}
      a^[kk]:=1/biga;
    end;
 {  FINAL ROW AND COLUMN INTERCHANGE  }
    k:=n;
5850:
    k:=k-1;
    if (k > 0) then
    begin
      i:=l^[k];
      if ((i-k) > 0) then
      begin
        jq:=n*(k-1);
        jr:=n*(i-1);
        for j:=1 to n do
        begin
          jk:=jq+j;
          hold:=a^[jk];
          ji:=jr+j;
          a^[jk]:=-a^[ji];
          a^[ji]:=hold;
        end;
      end;
      j:=m^[k];
      if ((j-k) <= 0) then goto 5850;
      ki:=k-n;
      for i:=1 to n do
      begin
        ki:=ki+n;
        hold:=a^[ki];
        ji:=ki-k+j;
        a^[ki]:=-a^[ji];
        a^[ji]:=hold;
      end;
      goto 5850;
    end;
2280:
    iresol:=0;
    if (d <> 0) then iresol:=1;
    for j:=1 to nbmax do
    begin
      for i:=1 to nbmax do
      begin
        ij:=nbmax*(j-1)+i; aa^[i,j]:=a^[ij];
      end;
    end;
    if (iresol=0) then begin
                         clrscr; writeln('âÄåéåàâé ãÜíêóé ãéåÄÉàÄàé,',
                         ' íé ëìëíÜãÄ ÉÑå ÑïÑà äìëÜ ***CHECK DATA***');
                         cursor(true,false); DisposePtrs;
                         NewDispose; halt;
                       end;
    for k:=1 to nbmax do
    begin
      for j:=1 to imax do
      begin
        c^[j,k]:=0;
        for i:=1 to nbmax do c^[j,k]:=c^[j,k]+aa^[k,i]*dd^[i,j];
      end;
    end;
 {  YPOLOGISMOS DH  }
    k:=nbmax; m1:=1; m2:=10;
2560:
    if ((k-m2) <= 0) then m2:=k;
    for i:=1 to imax do for j:=m1 to m2 do c^[i,j]:=-c^[i,j];
    if ((m2-k) <> 0) then begin m1:=m1+10; m2:=m2+10; goto 2560; end;
 {  PINAKAS DH  }
    for i:=1 to imax do for j:=1 to nbmax do c^[i,j]:=c^[i,j]*zfin^[i];
    for j:=1 to nbmax do for i:=2 to imax do begin
                                               c^[1,j]:=c^[1,j]+c^[i,j];
                                               hdef^[j]:=c^[1,j];
                                             end;
 {  YPOLOGISMOS TELIKWN YPSOMETRWN  }
    for ivf:=1 to nbmax do
    begin
      for ikf:=1 to imax do if (nb^[ivf]=io1^[ikf]) then goto 2880;
      clrscr;
      writeln('***CHECK DATA***');
      cursor(true,false);
      DisposePtrs; NewDispose;
      halt;
2880: hdef^[ivf]:=hpro^[ikf]+c^[1,ivf];
    end;
 {  CALCULATION OF ADJUSTMENTS CORRECTIONS  }
    total:=0;
    for ib:=1 to imax do
    begin
      for k:=1 to nbmax do if (io1^[ib]=nb^[k]) then begin
                                                    purit:=c^[1,k];
                                                    goto 3060;
                                                  end;
      purit:=0;
3060: for k:=1 to nbmax do if (ie1^[ib]=nb^[k]) then begin
                                                    parit:=c^[1,k];
                                                    goto 3120;
                                                  end;
      parit:=0;
3120: fkprov^[ib]:=purit*para^[ib]+parit*(-para^[ib])+zfin^[ib];
      correc^[ib]:=zred^[ib]+(fkprov^[ib]/10000.0);
      total:=total+sqr(fkprov^[ib]);
    end;
    itub:=imax; itab:=nbmax;
    falou:=sqrt(total/(itub-itab));
 {  METABLHTOTHTES YPSOMETRWN  }
    for i:=1 to nbmax do hdss^[i]:=falou*sqrt(aa^[i,i]);
    NewDispose;
end;
{----------------------------DISPLAY--DATA------------------------------------}
procedure display_data1(j:integer);
begin
    wrt(15,8,15,'     ');         gotoxy(15,8); write(numero^[j]);
    wrt(27,8,15,'            ');  gotoxy(27,8); write(x^[j]:4:3);
    wrt(42,8,15,'             '); gotoxy(42,8); write(y^[j]:4:3);
    wrt(60,8,15,'         ');     gotoxy(60,8); write(hpra^[j]:4:3);
end;
procedure display_data2(j:integer);
begin
    wrt(13,12,15,'     ');     gotoxy(13,12); write(io^[j]);
    wrt(23,12,15,'     ');     gotoxy(23,12); write(ie^[j]);
    wrt(34,12,15,'     ');     gotoxy(34,12); write(dt^[j]:3:2);
    wrt(46,12,15,'         '); gotoxy(46,12); write(zobs^[j]:5:4);
    wrt(62,12,15,'     ');     gotoxy(62,12); write(dm^[j]:3:2);
end;
procedure display_data3(j:integer);
begin
    wrt(21,15,15,'    ');  gotoxy(21,15); write(nipfix:1);
    wrt(21,16,15,'    ');  gotoxy(21,16); write(j:1);
    wrt(21,17,15,'     '); gotoxy(21,17); write(ipfix^[j]);
end;
{------------------------------INPUT------------------------------------------}
function seartch(str:string4):byte;
var      k:integer;
begin
    for k:=1 to nmax do
      if str=numero^[k] then begin
                               seartch:=numero1^[k]; exit;
                             end;
    clrscr; write('***CHECK DATA***'); cursor(true,false);
    if SwRead=1 then close(in_k038);
    if SwRead=2 then close(f);
    DisposePtrs;
    halt;
end;
procedure inp;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11;
var       l:integer;
begin
     l:=1;
     while l <= nmax do
     begin
       wrt(15,8,15,'     '); wrt(27,8,15,'            ');
       wrt(41,8,15,'            '); wrt(60,8,15,'         ');
       if ((sw1 = 1) or (sw3 = 1)) then display_data1(l);
i1:    input(buff,8,14,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data1(l);
           goto i4;
         end
         else begin end
       else numero^[l]:=buff;
i2:    input(buff,8,26,11,bit);
       if bit then goto i1 else val(buff,x^[l],cod);
i3:    input(buff,8,41,12,bit);
       if bit then goto i2 else val(buff,y^[l],cod);
i4:    input(buff,8,59,9,bit);
       if bit then goto i3 else val(buff,hpra^[l],cod);
       numero1^[l]:=l;
       l:=succ(l);
     end;
     l:=1;
     while l <= imax do
     begin
       wrt(13,12,15,'     '); wrt(23,12,15,'     '); wrt(34,12,15,'     ');
       wrt(46,12,15,'         '); wrt(61,12,15,'     ');
       if ((sw1 = 1) or (sw3 = 1)) then display_data2(l);
i5:    input(buff,12,12,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l = 0 then l:=1;
           display_data2(l);
           goto i9;
         end
         else begin end
       else io^[l]:=buff;
i6:    input(buff,12,22,4.1,bit);
       if bit then goto i5 else ie^[l]:=buff;
i7:    input(buff,12,33,5,bit);
       if bit then goto i6 else val(buff,dt^[l],cod);
i8:    input(buff,12,45,9,bit);
       if bit then goto i7 else val(buff,zobs^[l],cod);
i9:    input(buff,12,61,5,bit);
       if bit then goto i8 else val(buff,dm^[l],cod);
       io1^[l]:=seartch(io^[l]); ie1^[l]:=seartch(ie^[l]);
       l:=succ(l);
     end;
     l:=1;
     while l <= nipfix do
     begin
{       wrt(21,16,15,'     '); wrt(21,17,15,'     ');}
       if ((sw1 = 1) or (sw3 = 1)) then display_data3(l);
       if l=1 then begin
i10:   input(buff,15,20,4,bit);
       if bit then goto i10 else val(buff,nipfix,cod); end;
i11:   gotoxy(21,16); write(l:1);
       input(buff,17,20,5.1,bit);
       if bit then
         if ((sw1 = 1) or (sw3 = 1)) then
         begin
           l:=pred(l);
           if l=0 then l:=1;
           display_data3(l);
           goto i11;
         end
         else begin end
       else ipfix^[l]:=buff;
       ipfix1^[l]:=seartch(ipfix^[l]);
       l:=succ(l);
     end;
     epex;
end;
{--------------------------WRITE--SCREEN--------------------------------------}
procedure AnalGrScr1(grammi,k:integer);
begin
  gotoxy(19,grammi); write(numero^[nb^[k]]);
  gotoxy(28,grammi); write(x^[k]:11:3);
  gotoxy(41,grammi); write(y^[k]:12:3);
  gotoxy(56,grammi); write(hdef^[k]:10:3);
end;
procedure AnalGrScr2(grammi,k:integer);
begin
  gotoxy(13,grammi); write(io^[k]);
  gotoxy(20,grammi); write(ie^[k]);
  gotoxy(33,grammi); write(zred^[k]:8:4);
  gotoxy(45,grammi); write(fkprov^[k]:10:4);
  gotoxy(62,grammi); write(correc^[k]:8:4);
end;
procedure write_screen;
label     r1;
var       k,scr_line:integer;
begin
  clrscr; scr_line:=6;
  seek(k038_scr,3);    read(k038_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  for k:=1 to nbmax do
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
  if nbmax <= 15 then
  begin
    wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    goto r1;
  end;
  wrt(24,23,143,'ÇàÄ ëìåÑïÑàÄ èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
r1:  seek(k038_scr,2);    read(k038_scr,rec1);
  move(rec1.xx[0],mem[$b000:ofs1],3680);
  scr_line:=7;
  for k:=1 to imax do
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
  if imax <= 15 then
  begin
    wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    exit;
  end;
  wrt(19,23,143,'ÇàÄ ëìåÑïÑàÄ ëíé ãÑåU èÄíÜëÑ ÑåÄ èäÜâíêé..');
  repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
end;
{------------------------------OUTPUT-----------------------------------------}
procedure selida;
begin
    sel:=sel + 1;
    writeln(fill);
    writeln(fill,' ':68,'ëÑäàÉÄ : ',sel:1);
    writeln(fill);
end;
procedure epikef1;
begin
    writeln(fill,chr(14),'  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');
    writeln(fill,chr(14),'     ÄîéãéàóëÜ ìñéãÑíêàâéì Éàâíìéì');
    writeln(fill,chr(14),'  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ');
    writeln(fill);
    writeln(fill,'    ======================================');
    writeln(fill,'       ëìåíÑíÄÇãÑåÑë  âéêìîóå  Éàâíìéì');
    writeln(fill,'    ======================================');
    writeln(fill);
    writeln(fill,'    âóÉàâéë     íÑíãÜãÑåÜ       íÑíÄÇãÑåÜ');
    writeln(fill,'    -------    -----------    ------------');
                 {  6   ****  5  *********** 4  ************}
end;
procedure epikef2;
begin
    writeln(fill,'==================================================');
    writeln(fill,'  ã  Ñ  í  ê  Ü  ã  Ñ  å  Ä     ã  Ñ  Ç  Ñ  á  Ü');
    writeln(fill,'==================================================');
    writeln(fill,' ë Ü ã Ñ à é     ìñéë       ìñéë      èÄêÄíÜêÜãÑåÜ');
    writeln(fill,' Äèé    èêéë    éêÇÄåéì    ëÜãÄíéë     âÄíÄâéêìîÜ');
    writeln(fill,' ----   ----    -------    -------    ------------');
                 { **** 3 ****  6   *****  6   *****   7   ********}
end;
procedure epikef3;
begin
    writeln(fill,'=====================================================');
    writeln(fill,'Ä å Ä Ç ó Ç Ñ ë   ã Ñ í ê Ü ã Ñ å ó å   ã Ñ Ç Ñ á ó å');
    writeln(fill,'=====================================================');
    writeln(fill,'    ë Ü ã Ñ à é         Ü          ÄèéëíÄëÜ ëíé');
    writeln(fill,'    Äèé    èêéë        ãÑëé        ÑääÑàñéÑàÉÑë');
    writeln(fill,'    ----   ----      --------      ------------');
                 {  4 **** 3 ****   6  ********    8   **********}
end;
procedure epikef4;
begin
    writeln(fill,'======================================================');
    writeln(fill,'   Ä å Ü Ç ã Ñ å Ñ ë    è Ä ê Ä í Ü ê Ü ë Ñ à ë');
    writeln(fill,'======================================================');
    writeln(fill,'    ë Ü ã Ñ à é         ÄåÜÇãÑåÜ          ëíÄáÑêéë');
    writeln(fill,'    Äèé    èêéë        âÄíÄâéêìîÜ           éêéë');
    writeln(fill,'    ----   ----        ----------        ----------');
                 { 4  **** 3 ****    10    ********   8    **********}
end;
procedure epikef5;
begin
    writeln(fill,'    =============================');
    writeln(fill,'    í Ñ ä à â Ä   ì ñ é ã Ñ í ê Ä');
    writeln(fill,'    =============================');
    writeln(fill,'        âóÉàâéë     ìñéãÑíêO');
    writeln(fill,'        -------     --------');
                 {    10    ****  6   ********}
end;
procedure epikef6;
begin
    writeln(fill,'========================================================');
    writeln(fill,'  í Ñ ä à â Ä    Ä î é ã é à ó ã Ñ å Ä    ã Ñ Ç Ñ á Ü');
    writeln(fill,'========================================================');
    writeln(fill,'  ë Ü ã Ñ à é     ÄåÜÇãÑåÜ                 ÄîéãéàóãÑåÜ');
    writeln(fill,'  Äèé    èêéë    âÄíÄâéêìîÜ    ÉàéêáóëÜ    âÄíÄâéêìîÜ');
    writeln(fill,'  ----   ----    ----------    --------    -----------');
                 {2 **** 3 ****  6   ********  4 ********   7   ********}
end;
procedure epikef7;
begin
    writeln(fill,'============================');
    writeln(fill,'  ãÑíÄÅäÜíéíÜíÑë  ÄÇåóëíóå');
    writeln(fill,'============================');
    writeln(fill,'  âóÉàâéë    ãÑíÄÅäÜíéíÜíÄ');
    writeln(fill,'  -------    -------------');
                 { 4  ****             *****}
end;
procedure RESULTS;
var       i,gram:integer;
begin
    IF SW6=0 THEN AR_GRAM:=72;
    selida;
    epikef1; gram:=13;
    for i:=1 to iall do
    begin
      writeln(fill,' ':6,numero^[i],' ':9-length(numero^[i]),
              x^[i]:11:3,' ':4,y^[i]:12:3);
      gram:=gram+1;
      if gram >= ar_gram-2 then
      begin
        write(fill,#12); selida; epikef1; gram:=13;
      end;
    end;
    if gram+8 >= ar_gram then begin write(fill,#12); selida; epikef2; gram:=9; end
      else begin writeln(fill); epikef2; gram:=gram+7; end;
    for i:=1 to imax do
    begin
      writeln(fill,' ',io^[i],' ':7-length(io^[i]),ie^[i],' ':10-length(ie^[i]),
              dt^[i]:5:2,' ':6,dm^[i]:5:2,' ':7,zobs^[i]:8:4);
      gram:=gram+1;
      if gram >= ar_gram-2 then
      begin
        write(fill,#12); selida; epikef2; gram:=9;
      end;
    end;
    if gram+8 >= ar_gram then begin write(fill,#12); selida; epikef3; gram:=9; end
      else begin writeln(fill); epikef3; gram:=gram+7; end;
    for i:=1 to imax do
    begin
      writeln(fill,' ':4,io^[i],' ':7-length(io^[i]),ie^[i],
              ' ':10-length(ie^[i]),hm^[i]:8:2,' ':8,fkreel^[i]:10:3);
      gram:=gram+1;
      if gram >= ar_gram-2 then
      begin
        write(fill,#12); selida; epikef3; gram:=9;
      end;
    end;
    if gram+8 >= ar_gram then begin write(fill,#12); selida; epikef4; gram:=9; end
      else begin writeln(fill); epikef4; gram:=gram+7; end;
    for i:=1 to imax do
    begin
      writeln(fill,' ':4,io^[i],' ':7-length(io^[i]),ie^[i],
              ' ':14-length(ie^[i]),zred^[i]:8:4,' ':8,zfin^[i]:10:6);
      gram:=gram+1;
      if gram >= ar_gram-2 then
      begin
        write(fill,#12); selida; epikef4; gram:=9;
      end;
    end;
    write(fill,#12); selida; epikef5; gram:=8;
    for i:=1 to nbmax do
    begin
      writeln(fill,' ':10,numero^[nb^[i]],' ':10-length(numero^[nb^[i]]),
              hdef^[i]:8:3);
      gram:=gram+1;
      if gram >= ar_gram-2 then
      begin
        write(fill,#12); selida; epikef5; gram:=8;
      end;
    end;
    if gram+7 >= ar_gram then begin write(fill,#12); selida; epikef7; gram:=8; end
      else begin writeln(fill); epikef7; gram:=gram+6; end;
    for i:=1 to nbmax do
    begin
      writeln(fill,' ':4,numero^[nb^[i]],' ':17-length(numero^[nb^[i]]),hdss^[i]:5:3);
      gram:=gram+1;
      if gram >= ar_gram-2 then
      begin
        write(fill,#12); selida; epikef7; gram:=8;
      end;
    end;
    if gram+3 >= ar_gram then
    begin
      write(fill,#12); selida; writeln(fill);
      writeln(fill,'  ãÑíÄÅäÜíéíÜíÄ ãéåÄÉÄë ÅÄêéìë : ',falou);
      write(fill,#12);
    end
    else begin
      writeln(fill);
      writeln(fill,'  ãÑíÄÅäÜíéíÜíÄ ãéåÄÉÄë ÅÄêéìë : ',falou);
    end;
    write(fill,#12); selida; epikef6; gram:=9;
    for i:=1 to imax do
    begin
      writeln(fill,'  ',io^[i],' ':7-length(io^[i]),ie^[i],' ':10-length(ie^[i]),
              zred^[i]:8:4,' ':4,fkprov^[i]:8:4,' ':7,correc^[i]:8:4);
      gram:=gram+1;
      if gram >= ar_gram-2 then
      begin
        write(fill,#12); selida; epikef6; gram:=9;
      end;
    end;
    write(fill,#12);
end;


procedure epex_menu;
var       j,k:integer;
          ok :boolean;
label     e1,10,e2,e3,e4,25;
begin
    case menu of
       1:begin
           if (sw1=1) or (sw3=1) then epex_menu;
           cursor(true,false);
e2:        wrt(5,21,15,'ÉóëÑ èäÜáéë ëÜãÑàóå Éàâíìéì :');
           input(buff,21,34,3,bit);
           if bit then goto e2 else val(buff,nmax,cod);
           if not (nmax in [1..70]) then goto e2;
           wrt(5,22,15,'ÉóëÑ èäÜáéë èÄêÄíÜêÜëÑóå :');
e4:        input(buff,22,31,3,bit);
           if bit then goto e2 else val(buff,imax,cod);
           if not (imax in [1..200]) then goto e4;
           iall:=nmax;
           clrscr;
           seek(k038_scr,1);    read(k038_scr,rec1);
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
             assign(in_k038,name);
             {$i-}
             reset(in_k038);
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
             rewrite(in_k038);
             j:=0;
             repeat
               j:=j+1;
               with in1_rec do
               begin
                 nmaxY:=nmax; numeroY:=numero^[j]; xY:=x^[j]; yY:=y^[j]; hpraY:=hpra^[j];
               end;
               write(in_k038,in2_rec);
             until j=nmax;
             j:=0;
             repeat
               j:=j+1;
               with in2_rec do
               begin
                 imaxY:=imax; ioY:=io^[j]; ieY:=ie^[j];
                 dtY:=dt^[j]; zobsY:=zobs^[j]; dmY:=dm^[j];
               end;
               write(in_k038,in2_rec);
             until j=imax;
             j:=0;
             repeat
               j:=j+1;
               with in3_rec do
               begin
                 nipfixY:=nipfix; ipfixY:=ipfix^[j];
               end;
               write(in_k038,in2_rec);
             until j=nipfix;
             close(in_k038);
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
             assign(in_k038,filename);
             {$i-}
             reset(in_k038);
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
             SwRead:=1;
             reset(in_k038);
             seek(in_k038,0);
             j:=0;
             repeat
               j:=j+1;
               read(in_k038,in2_rec);
               with in1_rec do
               begin
                 nmax:=nmaxY; numero^[j]:=numeroY; numero1^[j]:=j;
                 x^[j]:=xY; y^[j]:=yY; hpra^[j]:=hpraY;
               end;
             until j=nmax;
             j:=0;
             repeat
               j:=j+1;
               read(in_k038,in2_rec);
               with in2_rec do
               begin
                 if j=1 then imax:=imaxY; io^[j]:=ioY; io1^[j]:=seartch(io^[j]);
                 ie^[j]:=ieY; ie1^[j]:=seartch(ie^[j]); dt^[j]:=dtY;
                 zobs^[j]:=zobsY; dm^[j]:=dmY;
               end;
             until j=imax;
             j:=0;
             repeat
               j:=j+1;
               read(in_k038,in2_rec);
               with in3_rec do
               begin
                 if j=1 then nipfix:=nipfixY;
                 ipfix^[j]:=ipfixY; ipfix1^[j]:=seartch(ipfix^[j]);
               end;
             until eof(in_k038);
             close(in_k038); SwRead:=0; iall:=nmax;
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
             reset(f); SwRead:=2;
             readln(f,b); arith_input(b,dstr); val(dstr,nmax,cod);
             readln(f,b); arith_input(b,dstr); val(dstr,imax,cod); iall:=nmax;
             j:=0;
             repeat
               j:=j+1;
               readln(f,b); numero^[j]:=b; numero1^[j]:=j;
               readln(f,b); arith_input(b,dstr); val(dstr,x^[j],cod);
               readln(f,b); arith_input(b,dstr); val(dstr,y^[j],cod);
               readln(f,b); arith_input(b,dstr); val(dstr,hpra^[j],cod);
             until (j=nmax);
             j:=0;
             repeat
               j:=j+1;
               readln(f,b); io^[j]:=b; io1^[j]:=seartch(io^[j]);
               readln(f,b); ie^[j]:=b; ie1^[j]:=seartch(ie^[j]);
               readln(f,b); arith_input(b,dstr); val(dstr,dt^[j],cod);
               readln(f,b); arith_input(b,dstr); val(dstr,zobs^[j],cod);
               readln(f,b); arith_input(b,dstr); val(dstr,dm^[j],cod);
             until (j=imax);
             j:=0;
             repeat
               j:=j+1;
               readln(f,b); ipfix^[j]:=b; ipfix1^[j]:=seartch(ipfix^[j]);
             until eof(f);
             close(f); nipfix:=j; Swread:=0;
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
           seek(k038_scr,1);    read(k038_scr,rec1);
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
             sel:=0;
             rewrite(fill);
             results;
             close(fill);
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
             sel:=0;
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
  assign(k038_scr,'TALS.scr');
  reset(k038_scr);
  seek(k038_scr,4); read(k038_scr,rec1);
  for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
  for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
  new(numero); new(ipfix); new(nb);     new(io);
  new(ie);     new(x);     new(y);      new(dt);
  new(dm);     new(zobs);  new(hm);     new(fkreel);
  new(zred);   new(zfin);  new(fkprov); new(correc);
  new(hdef);   new(hdss);  new(hpra);   new(numero1);
  new(io1);    new(ie1);   new(ipfix1);
  delete_all_input;
  sw1:=0; sw3:=0; sw4:=0; sw6:=0; SwRead:=0; sel:=0;
  cursor(false,true);
  epex_menu;
END.
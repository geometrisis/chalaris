{******************************************************************************
*               k020  ÅĞÉËÕÓÇ ÏÄÅÕÓÇÓ ÏĞÏÉÁÓÄÇĞÏÔÅ ÌÏÑÖÇÓ                     *
*     ÌÅ ÔÇÍ ÌÅÈÏÄÏ ÔÙÍ ÅËÁ×ÉÓÔÙÍ ÔÅÔÑÁÃÙÍÙÍ ÊÁÉ ÌÅ Ó×ÇÌÁÔÉÓÌÏ ÅÎÉÓÙÓÅÙÍ      *
*                         ÓÕÍÈÇÊÙÍ ÓÔÏ ÅĞÉĞÅÄÏ                                        *
*                  WRITTEN BY G.XALARIS                       *
*                       VERSION 1.1   16-01-1987                              *
*                       VERSION 1.2   13-02-1987                              *
*******************************************************************************}
const    SyntRegSize    = 123;
         MaxDataRecSize = SyntRegSize;
         MaxKeyLen      = 4;
         PageSize       = 16;
         Order          = 8;
         PageStackSize  = 5;
         MaxHeight      = 5;
         d1             = 200.0;
         dpr            = 100.0;
         ddf            = 1000.0;
         pan            = 636619.7723;

type     rec=record
           xx:array [0..3679] of byte;
         end;
         rec1_k020=record
           i_o:integer;
           xa_o,ya_o,xb_o,yb_o,xk_o,yk_o,xl_o,yl_o:real;
         end;
         rec2_k020=record
           kwd_o:string[4];
           b_o,s_o:real;
           dummy:string[32];
         end;
         rec_syntetagmenwn=record
           kwd_syn          :string[4];
           x_syn,y_syn,h_syn:real;
           eidos_point      :string[3];
           job              :string[20];
           xronol           :string[8];
           who_idrise       :string[20];
           axiopistia       :string[10];
           comments         :string[32];
         end;
         string40 =string[40];
         string255=string[255];

var      xa,ya,xb,yb,xk,yk,xl,yl      : real;
         kwd                          : array [1..50] of string[4];
         b,s,x,y,azr,ar,ma,ia,da,mam,
         iam,dam,v3,fr,sm,amts,
         bh,sh,smts,v,xh,yh           : array [1..50] of real;
         mm,ll,ak,w,w2,ww             : array [1..3] of real;
         a                            : array [1..6] of real;
         cta                          : array [1..50,1..30] of real;
         c                            : array [1..3,1..99] of real;
         ctac                         : array [1..50,1..50] of real;
         aa                           : array [1..3,1..3] of real;
         {$I ACCESS3.BOX}
         {$I GETKEY.BOX}
         {$I ADDKEY.BOX}
         {$I DELKEY.BOX}

var      x1,y1,xll,yll,dx,dy,xt,yt,xw,
         yw,p,pi,pi2,a1,az,azar,azftt,
         azrm,azri,dazr,
         gkl,wb,db,ss,bb,cc,
         azft,aztm,azti,dazt,
         azyt,wgrad,vpv,so,daa,sll,sl,
         asl,slx,sxx,prota,gon,deytera,
         deyteraola,gong,fia,giaa,
         dazt2,wgrad2,dazr2           : real;

         nlysi,icol,maa,iaa,mkk,idkk,
         idjk,idkm,idjm,idjj,idij,idii,
         m,idim,idmj,imoires,iprota,k,
         k1,n,j,i1,idmi,j1,ij,idkmkk,
         mazt,mazt2,iazt,iazt2,mazr,
         mazr2,iazr,iazr2,metr        :integer;

         k020_scr:file of rec;
         rec1    :rec;
         ofs1,cod:integer;
         i,l,ar_gram:integer;
         buff    :string40;
         bit,okk :boolean;
         name,filename:string[66];
         fill    :text;

         file_syntetagmenwn:string[40];
         rec_syn           :rec_syntetagmenwn;
         file_syn          :DataFile;
         IndexName         :IndexFile;
         DatRef : integer;
         DumFile: file;
         f                   :text;
         b1,b2,b3,b4,b5,b6,
         b7,b8,b9,b10,b11,b12:string[10];
         OthInp,OthPrint:array[1..3680] of byte;
         in_k020 :file of rec1_k020;
         in1_rec :rec1_k020;
         in2_rec :rec2_k020 absolute in1_rec;
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
  xa:=0; ya:=0; xb:=0; yb:=0; xk:=0; yk:=0; xl:=0; yl:=0;
  fillchar(kwd,sizeof(kwd),' ');
  fillchar(b,sizeof(b),0); fillchar(s,sizeof(s),0);
end;

procedure beep(freq,dur:integer);
begin sound(freq); delay(dur); nosound; end;
function menu:byte;
label    5;
var      deik,row,col,i_m:byte;
         ch:char;
procedure paint_box(ra,ca,rt,ct,att:byte);
          var rows,cols,i_m:byte;
          begin
            rows:=rt-ra+1; cols:=ct-ca+1;
            for i_m:=1 to rows do wrt(ca,i_m+ra-1,att,chr(cols));
          end;
begin
     seek(k020_scr,0);
     read(k020_scr,rec1);
     move(rec1.xx[0],mem[$b000:ofs1],3680);
     deik:=1;    col:=21;    row:=4;
     paint_box(row,col,row+2,col+17,112);
 5:  read(kbd,ch);
     if ch in [#13,#10] then          { return }
     begin
       if deik=8 then
       begin
         close(k020_scr);
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
                    clrscr; close(k020_scr); cursor(true,false); halt;
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
                    if ((ch=#72) or (ch='8')) then if row>4 then row:=row-4
                      else row:=16
                    else
                      if row<16 then row:=row+4 else row:=4;
                    paint_box(row,col,row+2,col+17,112);
                    deik:=(row div 4 * 2) - 1;
                    if col=40 then deik:=deik+1;
                  end;
              else for i_m:=3 to 6 do beep(i*500,50);
       end; {case}
     end {if}
     else
       for i_m:=3 to 6 do beep(i_m*500,50);
     goto 5;
end;

procedure arctan;
begin
    p:=arctan(1) * 4;
    if dx < 0 then
    begin
      if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p+a1; end;
      if dy = 0 then az:=3*p/2;
      if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=2*p-a1; end;
    end;
    if dx = 0 then begin if dy < 0 then az:=p; if dy > 0 then az:=0; end;
    if dx > 0 then
    begin
      if dy < 0 then begin a1:=arctan(abs(dx/dy)); az:=p-a1; end;
      if dy = 0 then az:=p/2;
      if dy > 0 then begin a1:=arctan(abs(dx/dy)); az:=a1; end;
    end;
end;
procedure cholesky;
begin
    for k:=1 to n do
    begin
      k1:=k-1;
      for j:=k to n do
      begin
        if (j=k) then
        begin
          idkk:=trunc((k-1)*k/2+k);
          sl:=0;
          if (k=1) then
          begin
            asl:=a[idkk]-sl; if (asl < 0) then asl:=0; a[idkk]:=sqrt(asl);
          end
          else
          begin
            for mkk:=1 to k1 do
            begin
              idkmkk:=trunc((k-1)*k/2+mkk);
              sl:=sl+sqr(a[idkmkk]);
            end;
            asl:=a[idkk]-sl;
            if (asl < 0) then asl:=0;
            a[idkk]:=sqrt(asl);
          end;
        end
        else
        begin
          idjk:=trunc((j-1)*j/2+k);
          sll:=0;
          if (k <> 1) then
          begin
            for m:=1 to k1 do
            begin
              idjm:=trunc((j-1)*j/2+m);
              idkm:=trunc((k-1)*k/2+m);
              sll:=sll + a[idjm] * a[idkm];
            end;
            a[idjk]:=(a[idjk] - sll) / a[idkk];
          end
          else
          begin
            a[idjk]:=(a[idjk] - sll) / a[idkk];
          end;
        end;
      end;
    end;
    for j:=1 to n do
    begin
      idjj:=trunc((j - 1) * j / 2 + j);
      a[idjj]:=1 / a[idjj];
      for l:=j to n do
      begin
        if (l <> j) then
        begin
          idij:=trunc((l - 1) * l / 2 + j);
          idii:=trunc((l - 1) * l / 2 + l);
          slx:=0;
          i1:=l - 1;
          for m:=j to i1 do
          begin
            idim:=trunc((l - 1) * l / 2 + m);
            idmj:=trunc((m - 1) * m / 2 + j);
            slx:=slx + a[idim] * a[idmj];
          end;
          a[idij]:= -slx / a[idii];
        end;
      end;
    end;
    for l:=1 to n do
    begin
      for j:=1 to l do
      begin
        idij:=trunc((l - 1) * l / 2 + j);
        sxx:=0;
        for m:=l to n do
        begin
          idmi:=trunc((m - 1) * m / 2 + l);
          idmj:=trunc((m - 1) * m / 2 + j);
          sxx:=sxx + a[idmi] * a[idmj];
        end;
        a[idij]:=sxx;
      end;
    end;
end;
procedure epex;
begin
    cursor(false,true);
    clrscr;
    wrt(20,11,112,'                                          ');
    wrt(20,12,112,'   „      ‚   €   …      ‹   €   ˆ...   ');
    wrt(20,13,112,'                                          ');
    pi:=arctan(1) * 4;
    pi2:=2 * pi;
    x1:=xa;    y1:=ya;    xll:=xb;    yll:=yb;
    dx:=xll - x1;    dy:=yll - y1;
    arctan;
    azar:=az;
    xt:=xk;    yt:=yk;    xw:=xl;    yw:=yl;
    dx:=xw - xt;    dy:=yw - yt;
    arctan;
    azftt:=az;
    while (azftt > pi2) do azftt:=azftt - pi2;
    icol:=i + i - 1;
    nlysi:=0;
    azr[1]:=azar;
    x[1]:=x1;
    y[1]:=y1;
{   COMPUTE SIDE BEARINGS   }
    for l:=1 to i do
    begin
      ar[l]:=b[l] * pi / 200;
      while (ar[l] >= pi2) do ar[l]:=ar[l] - pi2;
      if (ar[l] < 0) then ar[l]:=ar[l] + pi2;
      azr[l]:=azr[l] + ar[l];
      while (azr[l] > pi2) do azr[l]:=azr[l] - pi2;
      if (l <> i) then
      begin
        dx:=s[l] * sin(azr[l]);
        dy:=s[l] * cos(azr[l]);
        x[l+1]:=x[l] + dx;
        y[l+1]:=y[l] + dy;
        azr[l+1]:=azr[l] + pi;
        while (azr[l+1] > pi2) do azr[l+1]:=azr[l+1] - pi2;
      end;
    end;
    azrm:=azr[i] * d1 / pi;
    mazr:=trunc(azrm);
    azri:=(azrm - mazr) * dpr;
    iazr:=trunc(azri);
    dazr:=(azri - iazr) * dpr;
{   COMPUTE ‘”€Š‹€ WX,WY,WAZ   }
    w[2]:=xt - x[i];
    w[3]:=yt - y[i];
    azft:=(azftt * d1 / pi) * ddf;
    aztm:=azft / ddf;
    mazt:=trunc(aztm);
    azti:=(aztm - mazt) * dpr;
    iazt:=trunc(azti);
    dazt:=(azti - iazt) * dpr;
    azyt:=azr[i] * d1 / pi;
    azyt:=azyt * ddf;
    w[1]:=azft - azyt;
    wgrad:=w[1] / 1000;
    ww[1]:=w[1] * 10;
    ww[2]:=w[2] * 100;
    ww[3]:=w[3] * 100;
{   FORMING CONDITION EQUATIONS   }
    for l:=1 to 3 do
    begin
      j1:=0;
      for j:=1 to icol do
      begin
        case l of
          1:begin
              c[l,j]:=1;
              if (j > i) then c[l,j]:=0;
            end;
          2:begin
              if (j <= i) then
              begin
                c[l,j]:=(yt - y[j]) / pan;
                c[l,j]:=c[l,j] * 100;
              end
              else
              begin
                j1:=j1 + 1;
                c[l,j]:=(x[j1+1] - x[j1]) / s[j1];
              end;
            end;
          3:begin
              if (j <= i) then
              begin
                c[l,j]:=-(xt - x[j]) / pan;
                c[l,j]:=c[l,j] * 100;
              end
              else
              begin
                j1:=j1 + 1;
                c[l,j]:=(y[j1+1] - y[j1]) / s[j1];
              end;
            end;
        end;  {  CASE  }
      end;
    end;
{   FORMING THE NORMALS.   ‘•†‹€’ˆ‘‹‘ ‰€ŒŒˆ‰—Œ „ˆ‘—‘„—Œ   }
    for l:=1 to 3 do
    begin
      for j:=1 to 3 do
      begin
        aa[l,j]:=0;
        for k:=1 to icol do
        begin
          aa[l,j]:=aa[l,j] + c[l,k] * c[j,k];
        end;
      end;
    end;
{   CREATING THE TRIANGULAR MATRIX
    FOR THE APPLICATION OF CHOLESKY INVERSION OF 3X3 MATRIX A[L,J]   }
    for l:=1 to 3 do
    begin
      for j:=1 to l do
      begin
        ij:=trunc(l * (l - 1) / 2 + j);
        a[ij]:=aa[l,j];
      end;
    end;
{   CALLING CHOLESKY. €Œ’ˆ‘’”† ˆŒ€‰€   }
    n:=3;
    cholesky;
    for l:=1 to 3 do
    begin
      for j:=1 to l do
      begin
        ij:=trunc((l - 1) * l / 2 + j);
        aa[l,j]:=a[ij];
        aa[j,l]:=aa[l,j];
      end;
    end;
{   Š“‘† ‰€ŒŒˆ‰—Œ „•ˆ‘—‘„—Œ   }
    for l:=1 to 3 do
    begin
      ak[l]:=0;
      for j:=1 to 3 do
      begin
        ak[l]:=ak[l] + aa[l,j] * ww[j];
      end;
    end;
{   “Š‚ˆ‘‹‘ ‘”€Š‹€’—Œ
    ‘’ ARRAY ’€ ‘”€Š‹€’€ € 1 - ˆ „ˆŒ€ˆ ‚Œˆ—Œ, € ˆ+1 - 2*ˆ-1 Š„“—Œ   }
    for l:=1 to icol do
    begin
      v[l]:=0;
      v3[l]:=0;
      for j:=1 to 3 do
      begin
        v[l]:=v[l] + c[j,l] * ak[j];
      end;
      if (l > i) then v[l]:=v[l] / 100;
      v3[l]:=v3[l] + v[l];
    end;
{   ‹„’€Š†’’†’„‘ ‘“Œ’„’€‚‹„Œ—Œ   }
    vpv:=0;
    for l:=1 to 3 do vpv:=vpv + ak[l] * ww[l];
    so:=vpv / 3;
    for l:= 1 to icol do
    begin
      for j:=1 to 3 do
      begin
        cta[l,j]:=0;
        for k:=1 to 3 do
        begin
          cta[l,j]:=cta[l,j] + c[k,l] * aa[k,j];
        end;
      end;
    end;
{   “Š‚ˆ…„’€ˆ ’ ‚ˆŒ‹„Œ   }
    for l:=1 to icol do
    begin
      for j:=1 to icol do
      begin
        ctac[l,j]:=0;
        for k:=1 to 3 do
        begin
          ctac[l,j]:=ctac[l,j] + cta[l,k] * c[k,j];
        end;
      end;
    end;
{   ƒˆ€‚—Œˆ€ ‘’ˆ•„ˆ€....VARIANCES
    “Š‚ˆ‘‹„Œ€ ‹.’. ‘”€Š‹€’€ ‹„’†‹„Œ—Œ ‹„‚„‡—Œ   }
    for l:=1 to icol do
    begin
      ctac[l,l]:=1 - ctac[l,l];
    end;
    j:=0;
    for l:=1 to icol do
    begin
      if (l > i) then
      begin
        j:=j + 1;
        smts[j]:=so * ctac[l,l];
        if (smts[j] < 0) then smts[j]:=abs(smts[j]);
        smts[j]:=sqrt(smts[j]);
        smts[j]:=smts[j] / 100;
      end
      else
      begin
        amts[l]:=so * ctac[l,l];
        amts[l]:=sqrt(amts[l]);
      end;
    end;
    so:=sqrt(so);
{   “Š‚ˆ‘‹‘ €”‹ˆ—‹„Œ—Œ ‚—Œˆ—Œ ‰€ˆ Š„“—Œ   }
    for l:=1 to icol do
    begin
      if (l <= i) then bh[l]:=b[l] + (v[l] / 10000)
        else sh[l-i]:=s[l-i] + v[l];
    end;
{   “Š‚ˆ‘‹‘ ‘“Œ’„’€‚‹„Œ—Œ ‰€ˆ ‘”€Š‹€’—Œ ‹„ €”‹ˆ—‘†   }
    azr[1]:=azar;
    xh[1]:=x1;
    yh[1]:=y1;
{   COMPUTE SIDE BEARINGS   }
    for l:=1 to i do
    begin
      xh[l]:=x[l];
      yh[l]:=y[l];
    end;
    for l:=1 to i do
    begin
      ar[l]:=bh[l] * pi / 200;
      while (ar[l] >= pi2) do ar[l]:=ar[l] - pi2;
      while (ar[l] < 0) do ar[l]:=ar[l] + pi2;
      azr[l]:=azr[l] + ar[l];
      while (azr[l] > pi2) do azr[l]:=azr[l] - pi2;
      if (l <> i) then
      begin
        dx:=sh[l] * sin(azr[l]);
        dy:=sh[l] * cos(azr[l]);
        xh[l+1]:=xh[l] + dx;
        yh[l+1]:=yh[l] + dy;
        azr[l+1]:=azr[l] + pi;
        while (azr[l+1] > pi2) do azr[l+1]:=azr[l+1] - pi2;
      end;
    end;
    azrm:=azr[i] * d1 / pi;
    mazr2:=trunc(azrm);
    azri:=(azrm - mazr2) * dpr;
    iazr2:=trunc(azri);
    dazr2:=(azri - iazr2) * dpr;
{   COMPUTE ‘”€Š‹€ WX,WY,WAZ   }
    w2[2]:=xt - xh[i];
    w2[3]:=yt - yh[i];
    azft:=(azftt * d1 / pi) * ddf;
    aztm:=azft / ddf;
    mazt2:=trunc(aztm);
    azti:=(aztm - mazt2) * dpr;
    iazt2:=trunc(azti);
    dazt2:=(azti - iazt2) * dpr;
    azyt:=azr[i] * d1 / pi;
    azyt:=azyt * ddf;
    w2[1]:=azft - azyt;
    wgrad2:=w2[1] / 1000;
end;

procedure display_data(l:byte);
begin
    wrt(21,16,15,'     ');     gotoxy(21,16); write('(',l:1,')');
    wrt(32,16,15,'    ');      gotoxy(32,16); write(kwd[l]);
    wrt(21,18,15,'     ');     Gotoxy(21,18); write('(',l:1,')');
    wrt(32,18,15,'        ');  gotoxy(32,18); write(b[l]:5:4);
    wrt(21,20,15,'         '); gotoxy(21,20); write('(',l:1,'-',l+1:1,')');
    wrt(32,20,15,'            ');
    if (l <> i) then begin gotoxy(32,20); write(s[l]:4:3); end;
end;
procedure inp;
label     i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13;
begin
     if ((sw1 = 1) or (sw3 = 1)) then
     begin
       gotoxy(22,5); Write(i:1);     gotoxy(6,11); write(xa:4:3);
       gotoxy(6,14); write(ya:4:3);  gotoxy(25,11); write(xb:4:3);
       gotoxy(25,14); write(yb:4:3); gotoxy(45,11); write(xk:4:3);
       gotoxy(45,14); write(yk:4:3); gotoxy(64,11); write(xl:4:3);
       gotoxy(64,14); write(yl:4:3);
     end;
i1:  input(buff,5,21,4,bit); val(buff,i,cod);
i2:  input(buff,11,5,12,bit);
     if bit then goto i1 else val(buff,xa,cod);
i3:  input(buff,14,5,13,bit);
     if bit then goto i2 else val(buff,ya,cod);
i4:  input(buff,11,24,12,bit);
     if bit then goto i3 else val(buff,xb,cod);
i5:  input(buff,14,24,13,bit);
     if bit then goto i4 else val(buff,yb,cod);
     dx:=xb-xa; dy:=yb-ya;
     if ((dx = 0) and (dy = 0)) then
     begin
       cursor(false,true);
       wrt(10,23,112,' † €•† ’€“’ˆ…„’€ˆ ‹„ ’†Œ „€’†‘† €•†‘. €’†‘„ „Œ€ Š†‰’.. ');
       repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
       wrt(10,23,15,'                                                               ');
       cursor(true,false);
       goto i2;
     end;
i6:  input(buff,11,44,12,bit);
     if bit then goto i5 else val(buff,xk,cod);
i7:  input(buff,14,44,13,bit);
     if bit then goto i6 else val(buff,yk,cod);
i8:  input(buff,11,63,12,bit);
     if bit then goto i7 else val(buff,xl,cod);
i9:  input(buff,14,63,13,bit);
     if bit then goto i8 else val(buff,yl,cod);
     dx:=xl-xk; dy:=yl-yk;
     if ((dx = 0) and (dy = 0)) then
     begin
       cursor(false,true);
       wrt(8,23,112,' ’ ’„Š‘ ’€“’ˆ…„’€ˆ ‹„ ’†Œ „€’†‘† ’„Š“‘. €’†‘„ „Œ€ Š†‰’.. ');
       repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
       wrt(8,23,15,'                                                                  ');
       cursor(true,false);
       goto i6;
     end;
     l:=1;
     while (l <= i) do
     begin
       if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
       wrt(21,16,15,'     ');
       gotoxy(21,16); write('(',l:1,')');
i10:   input(buff,16,31,5.1,bit);
       if bit then
       begin
         if l = 1 then goto i9
         else
         begin
           l:=pred(l);
           if ((sw1 = 1) or (sw3 = 1)) then display_data(l);
           goto i12;
         end;
       end
       else kwd[l]:=buff;
       wrt(21,18,15,'     ');
       gotoxy(21,18); write('(',l:1,')');
i11:   input(buff,18,31,9,bit);
       if bit then goto i10 else val(buff,b[l],cod);
       if l = i then begin l:=succ(l); goto i13; end;
       wrt(21,20,15,'         ');
       gotoxy(21,20);    write('(',l:1,'-',l+1:1,')');
i12:   input(buff,20,31,12,bit);
       if bit then goto i11 else val(buff,s[l],cod);
       wrt(32,16,15,'     ');
       wrt(32,18,15,'            ');
       wrt(32,20,15,'             ');
       l:=succ(l);
i13: end;
     epex;
end;

procedure epikef1;
begin
  writeln(fill,'**********************************************************************');
  writeln(fill,'„ˆŠ“‘† ƒ„“‘†‘ ˆ€‘ƒ†’„ ‹”†‘ ‹„ ’†Œ ‹„‡ƒ „Š€•ˆ‘’—Œ ’„’€‚—Œ—Œ');
  writeln(fill,'**********************************************************************');
  writeln(fill);
  writeln(fill,'               €    •  ˆ  ‰  †     „    ˆ  Š  “  ‘  †');
  writeln(fill,'======================================================================');
  writeln(fill,'  ‰—ƒˆ‰‘     ‚—Œˆ„‘       ‹†‰‘         ‘ “ Œ ’ „ ’ € ‚ ‹ „ Œ „ ‘');
  writeln(fill,'  ‘†‹„ˆ“     ‡Š€‘†‘      Š„“—Œ        ’„’‹†‹„Œ†        ’„’€‚‹„Œ†');
  writeln(fill,'  -------    --------    ----------    -------------    -------------');
               { 3 ****  6   ***.**** 4  **********   7   **********   6  ***********}
end;
procedure epikef2;
begin
  writeln(fill,'======================================================================');
  writeln(fill,'        €  • ˆ ‰ €   ‘ ” € Š ‹ € ’ €   ‰ Š „ ˆ ‘ ˆ ‹ € ’  ‘');
  writeln(fill,'======================================================================');
end;
procedure epikef3;
begin
  writeln(fill,'======================================================================');
  writeln(fill,'     ƒˆ‡—‘„ˆ‘ ‘’€ ‹„’†‹„Œ€ ‹„‚„‡†  (‘„ ƒ„“’. €‡‹“ ‰€ˆ ‹„’€)');
  writeln(fill,'======================================================================');
end;
procedure epikef4;
begin
  writeln(fill,'======================================================================');
  writeln(fill,'            “Š‚ˆ‘‹„Œ€ ‹„‘€ ’„’€‚—Œˆ‰€ ‘”€Š‹€’€ ‹„‚„‡—Œ');
  writeln(fill,'======================================================================');
end;
procedure epikef5;
begin
  writeln(fill,'***********************************************************************');
  writeln(fill,'„ˆŠ“‘† ƒ„“‘†‘ ˆ€‘ƒ†’„ ‹”†‘ ‹„ ’†Œ ‹„‡ƒ „Š€•ˆ‘’—Œ ’„’€‚—Œ—Œ');
  writeln(fill,'***********************************************************************');
  writeln(fill);
  writeln(fill,'’ „ Š ˆ ‰ †  „  ˆ Š “ ‘ †  ‹ „  € ”  ‹ „ ˆ — ‹ „ Œ €  ‘ ’  ˆ • „ ˆ €');
  writeln(fill,'=======================================================================');
  writeln(fill,'  ‰—ƒˆ‰‘     ‚—Œˆ„‘       ‹†‰‘         ‘ “ Œ ’ „ ’ € ‚ ‹ „ Œ „ ‘');
  writeln(fill,'  ‘†‹„ˆ“     ‡Š€‘†‘      Š„“—Œ        ’„’‹†‹„Œ†        ’„’€‚‹„Œ†');
  writeln(fill,'  -------    --------    ----------    -------------    -------------');
end;
procedure epikef6;
begin
  writeln(fill,'======================================================================');
  writeln(fill,'        ’ „ Š ˆ ‰ €   ‘ ” € Š ‹ € ’ €   ‰ Š „ ˆ ‘ ˆ ‹ € ’  ‘');
  writeln(fill,'======================================================================');
end;

procedure input_results_in_file;
var   k  :integer;
begin
  rewrite(fill);
  epikef1;
  for k:=1 to i do
  begin
    writeln(fill,'   ',kwd[k],' ':10-length(kwd[k]),b[k]:8:4,' ':21,x[k]:10:3,' ':6,y[k]:11:3);
    if (k <> i) then writeln(fill,' ':25,s[k]:10:3);
  end;
  writeln(fill);    writeln(fill);
  epikef2;
  writeln(fill,' ‚à¤ ˜¡¦ ©­˜¢£˜         = (',mazt:1,' ',iazt:1,' ',dazt:5:4,
               ') - (',mazr:1,' ',iazr:1,' ',dazr:5:4,') = ',wgrad:5:4);
  writeln(fill,' ‚¨˜££ ¡¦ ©­˜¢£˜ ¡˜«˜ X = (',xt:4:3,') - (',x[i]:4:3,') = ',w[2]:4:3);
  writeln(fill,' ‚¨˜££ ¡¦ ©­˜¢£˜ ¡˜«˜ “ = (',yt:4:3,') - (',y[i]:4:3,') = ',w[3]:4:3);
  writeln(fill);    writeln(fill);
  epikef3;
  writeln(fill,'  V  ‚à¤ à¤   ',v[1]:7:3);
  for l:=2 to i do writeln(fill,'  V           ',v[l]:7:3);
  writeln(fill,'  V  ¢œ¬¨à¤  ',v[l+1]:7:3);
  for k:=l+2 to icol do writeln(fill,'  V           ',v[k]:7:3);
  writeln(fill);    writeln(fill);
  epikef4;
  for l:=1 to i do writeln(fill,'  ‚à¤ ˜   ',l:2,' ©­˜¢£˜ (ñ) ',amts[l]:5:2,'  ›œ¬«.™˜Ÿ£¦¬');
  for j:=1 to i - 1 do writeln(fill,'  ¢œ¬¨˜  ',j:2,' ©­˜¢£˜ (ñ) ',smts[j]:5:2,'  œ¡˜«¦©«˜');
  writeln(fill);    writeln(fill);
  epikef5;
  for k:=1 to i do
  begin
    writeln(fill,'   ',kwd[k],' ':10-length(kwd[k]),bh[k]:8:4,' ':21,xh[k]:10:3,' ':6,yh[k]:11:3);
    if (k <> i) then writeln(fill,' ':25,sh[k]:10:3);
  end;
  writeln(fill);    writeln(fill);
  epikef6;
  writeln(fill,' ‚à¤ ˜¡¦ ©­˜¢£˜         = (',mazt2:1,' ',iazt2:1,' ',dazt2:5:4,
               ') - (',mazr2:1,' ',iazr2:1,' ',dazr2:5:4,') = ',wgrad2:5:4);
  writeln(fill,' ‚¨˜££ ¡¦ ©­˜¢£˜ ¡˜«˜ X = (',xt:4:3,') - (',xh[i]:4:3,') = ',w2[2]:4:3);
  writeln(fill,' ‚¨˜££ ¡¦ ©­˜¢£˜ ¡˜«˜ “ = (',yt:4:3,') - (',yh[i]:4:3,') = ',w2[3]:4:3);
  close(fill);
end;

procedure anal_gr_scr1(grammi,k:integer);
begin
  gotoxy(13,grammi); write(kwd[k]);    gotoxy(20,grammi); write(b[k]:8:4);
  gotoxy(45,grammi); write(x[k]:11:3); gotoxy(58,grammi); write(y[k]:12:3);
  if (k <> i) then begin gotoxy(31,grammi+1); write(s[k]:11:3); end;
end;
procedure anal_gr_scr2(grammi,k:integer);
begin
  gotoxy(13,grammi); write(kwd[k]);     gotoxy(20,grammi); write(bh[k]:8:4);
  gotoxy(45,grammi); write(xh[k]:11:3); gotoxy(58,grammi); write(yh[k]:12:3);
  if (k <> i) then begin gotoxy(31,grammi+1); write(sh[k]:11:3); end;
end;

procedure write_screen(m,scr_line:integer);
var       k:integer;
begin
    clrscr;
    seek(k020_scr,2);    read(k020_scr,rec1);
    move(rec1.xx[0],mem[$b000:ofs1],3680);
    scr_line:=8;
    for k:=1 to m do
    begin
      anal_gr_scr1(scr_line,k);
      scr_line:=scr_line + 2;
      if scr_line >= 21 then
      begin
        wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
        repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
        move(rec1.xx[0],mem[$b000:ofs1],3680);
        scr_line:=8;
      end;
    end;
    wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
    seek(k020_scr,3);    read(k020_scr,rec1);
    move(rec1.xx[0],mem[$b000:ofs1],3680);
    scr_line:=8;
    for k:=1 to m do
    begin
      anal_gr_scr2(scr_line,k);
      scr_line:=scr_line + 2;
      if scr_line >= 21 then
      begin
        wrt(24,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ €’†‘„ „Œ€ Š†‰’..');
        repeat read(kbd,cha) until ((cha <> #10) or (cha <> #13));
        move(rec1.xx[0],mem[$b000:ofs1],3680);
        scr_line:=8;
      end;
    end;
    wrt(19,23,143,'‚ˆ€ ‘“Œ„•„ˆ€ ‘’ MENU €’†‘„ „Œ€ Š†‰’..');
    repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
end;

procedure selida;
begin
  sel:=sel + 1;
  writeln(fill);
  writeln(fill,' ':68,'‘„Šˆƒ€ : ',sel:1);
  writeln(fill);
end;

procedure lprint;
var       k:integer;
begin
  selida;
  epikef1;
  gram:=12;
  for k:=1 to i do
  begin
    writeln(fill,'   ',kwd[k],' ':10-length(kwd[k]),b[k]:8:4,' ':21,x[k]:10:3,' ':6,y[k]:11:3);
    if (k <> i) then writeln(fill,' ':25,s[k]:10:3);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin
      writeln(fill);
      writeln(fill);
      selida;
      epikef1;
      gram:=12;
    end;
  end;
  writeln(fill);
  if gram >= ar_gram - 8 then
  begin
    write(fill,#12);
    selida;
    epikef2;
    gram:=6;
  end
  else
  begin
    epikef2;
  end;
  writeln(fill,' ‚à¤ ˜¡¦ ©­˜¢£˜         = (',mazt:1,' ',iazt:1,' ',dazt:5:4,
               ') - (',mazr:1,' ',iazr:1,' ',dazr:5:4,') = ',wgrad:5:4);
  writeln(fill);
  writeln(fill,' ‚¨˜££ ¡¦ ©­˜¢£˜ ¡˜«˜ X = (',xt:4:3,') - (',x[i]:4:3,') = ',w[2]:4:3);
  writeln(fill);
  writeln(fill,' ‚¨˜££ ¡¦ ©­˜¢£˜ ¡˜«˜ “ = (',yt:4:3,') - (',y[i]:4:3,') = ',w[3]:4:3);
  write(fill,#12);
  selida;
  epikef3;
  gram:=6;
  writeln(fill,'  V  ‚à¤ à¤   ',v[1]:7:3);
  gram:=gram + 1;
  for l:=2 to i do
  begin
    writeln(fill,'  V           ',v[l]:7:3);
    gram:=gram + 1;
    if gram >= ar_gram - 2 then
    begin
      writeln(fill);
      writeln(fill);
      selida;
      epikef3;
      gram:=6;
    end;
  end;
  writeln(fill,'  V  ¢œ¬¨à¤  ',v[l+1]:7:3);
  gram:=gram + 1;
  for k:=l+2 to icol do
  begin
    writeln(fill,'  V           ',v[k]:7:3);
    gram:=gram + 1;
    if gram >= ar_gram - 2 then
    begin
      writeln(fill);
      writeln(fill);
      selida;
      epikef3;
      gram:=6;
    end;
  end;
  if gram >= ar_gram - 6 then
  begin
    write(fill,#12);
    selida;
    epikef4;
    gram:=6;
  end;
  writeln(fill);
  epikef4;
  gram:=gram + 4;
  for l:=1 to i do
  begin
    writeln(fill,'  ‚à¤ ˜   ',l:2,' ©­˜¢£˜ (ñ) ',amts[l]:5:2,'  ›œ¬«.™˜Ÿ£¦¬');
    gram:=gram + 1;
    if gram >= ar_gram - 2 then
    begin
      writeln(fill);
      writeln(fill);
      selida;
      epikef4;
      gram:=6;
    end;
  end;
  for j:=1 to i - 1 do
  begin
    writeln(fill,'  ¢œ¬¨˜  ',j:2,' ©­˜¢£˜ (ñ) ',smts[j]:5:2,'  œ¡˜«¦©«˜');
    gram:=gram + 1;
    if gram >= ar_gram - 2 then
    begin
      writeln(fill);
      writeln(fill);
      selida;
      epikef4;
      gram:=6;
    end;
  end;
  write(fill,#12);
  selida;
  epikef5;
  gram:=12;
  for k:=1 to i do
  begin
    writeln(fill,'   ',kwd[k],' ':10-length(kwd[k]),bh[k]:8:4,' ':21,xh[k]:10:3,' ':6,yh[k]:11:3);
    if (k <> i) then writeln(fill,' ':25,sh[k]:10:3);
    gram:=gram + 2;
    if gram >= ar_gram - 2 then
    begin
      writeln(fill);
      writeln(fill);
      selida;
      epikef5;
      gram:=12;
    end;
  end;
  writeln(fill);
  if gram >= ar_gram - 8 then
  begin
    write(fill,#12);
    selida;
    epikef6;
    gram:=6;
  end
  else
  begin
    epikef6;
  end;
  writeln(fill,' ‚à¤ ˜¡¦ ©­˜¢£˜         = (',mazt2:1,' ',iazt2:1,' ',dazt2:5:4,
               ') - (',mazr2:1,' ',iazr2:1,' ',dazr2:5:4,') = ',wgrad2:5:4);
  writeln(fill);
  writeln(fill,' ‚¨˜££ ¡¦ ©­˜¢£˜ ¡˜«˜ X = (',xt:4:3,') - (',xh[i]:4:3,') = ',w2[2]:4:3);
  writeln(fill);
  writeln(fill,' ‚¨˜££ ¡¦ ©­˜¢£˜ ¡˜«˜ “ = (',yt:4:3,') - (',yh[i]:4:3,') = ',w2[3]:4:3);
  write(fill,#12);
  close(fill);
end;

procedure epex_menu;
var  j,k:byte;
     okk :boolean;
label    e1,e2,e3,10,25;
begin
     case menu of
        1:begin
            if ((sw1=1) or (sw3=1)) then goto e2;
            clrscr;
            cursor(true,false);
            seek(k020_scr,1);     read(k020_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            inp;
            sw1:=1;
            clrscr;
            cursor(false,true);
e2:         epex_menu;
            sw4:=0;
          end;
        2:begin
            cursor(true,false);
            if ((sw1=1) or (sw3=1)) then
            begin
              wrt_screen(OthInp,1,20,80,22);
              gotoxy(13,21); read(name);
              assign(in_k020,name);
              {$i-}
              reset(in_k020);
              {$i+}
              okk:=(ioresult=0);
              if okk then
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
              wrt(11,12,240,'  ‰ € ’ € • —  —   ƒ „ ƒ  ‹ „ Œ €   ‘ „   €  • „ ˆ   ');
              rewrite(in_k020);
              with in1_rec do
              begin
                i_o:=i; xa_o:=xa; ya_o:=ya; xb_o:=xb; yb_o:=yb;
                xk_o:=xk; yk_o:=yk; xl_o:=xl; yl_o:=yl;
              end;
              write(in_k020,in1_rec);
              j:=0;
              repeat
                j:=j+1;
                with in2_rec do
                begin
                  kwd_o:=kwd[j]; b_o:=b[j]; s_o:=s[j];
                  write(in_k020,in1_rec);
                end;
              until j = i;
              close(in_k020);
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
            gotoxy(73,20); read(cha);
            wrt_screen(OthInp,1,20,80,22);
            gotoxy(13,21); read(filename);
            if cha in ['F','f','”','­'] then
            begin
              assign(in_k020,filename);
              {$i-}
              reset(in_k020);
              {$i+}
              okk:=(ioresult=0);
              if not okk then
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
              reset(in_k020);
              seek(in_k020,0);
              with in1_rec do
              begin
                read(in_k020,in1_rec);
                i:=i_o; xa:=xa_o; ya:=ya_o; xb:=xb_o; yb:=yb_o;
                xk:=xk_o; yk:=yk_o; xl:=xl_o; yl:=yl_o;
              end;
              l:=0;
              repeat
                l:=l+1;
                read(in_k020,in1_rec);
                with in2_rec do
                begin
                  if (l <> i) then
                  begin
                    kwd[l]:=kwd_o; b[l]:=b_o; s[l]:=s_o;
                  end
                  else
                  begin
                    kwd[l]:=kwd_o; b[l]:=b_o;
                  end
                end;
              until  l = i;
              close(in_k020);
              epex;
            end
            else
            begin
              assign(f,filename);
              {$i-}
              reset(f);
              {$i+}
              okk:=(ioresult=0);
              if not okk then
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
              readln(f,b1); val(b1,i,cod);  readln(f,b2); val(b2,xa,cod);
              readln(f,b3); val(b3,ya,cod); readln(f,b4); val(b4,xb,cod);
              readln(f,b5); val(b5,yb,cod); readln(f,b6); val(b6,xk,cod);
              readln(f,b7); val(b7,yk,cod); readln(f,b8); val(b8,xl,cod);
              readln(f,b9); val(b9,yl,cod);
              j:=0;
              repeat
                j:=j+1;
                readln(f,b10); kwd[j]:=b10; readln(f,b11); val(b11,b[j],cod);
                if (j <> i) then begin  readln(f,b12); val(b12,s[j],cod); end;
              until j = i;
              close(f);
              epex;
            end;
            epex_menu;
          end;
        4:begin
            if ((sw1 <> 1) and (sw3 <> 1)) then
            begin
              wrt(12,21,240,'  ƒEN EX— ƒEƒOMENA.  €’†‘„ „Œ€ Š†‰’..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              goto 10;
            end;
            cursor(true,false);
            sw4:=1;
            seek(k020_scr,1);    read(k020_scr,rec1);
            move(rec1.xx[0],mem[$b000:ofs1],3680);
            inp;
            cursor(false,true);
10:         epex_menu;
          end;
        5:begin
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              CURSOR(true,false);
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
                if cha in ['O','o','','¦'] then goto e1 else input_results_in_file;
              end
              else
              begin
                cursor(false,true);
                input_results_in_file;
              end;
e1:           cursor(true,false);
              gotoxy(2,23); clreol;
              gotoxy(2,23);
              write('‡„Š„ˆ‘ €’„Š„‘‹€’€ ‘„ €•„ˆ ‘“Œ’„’€‚‹„Œ—Œ; (N/O) : ');
              READ(CHA);
              if cha in ['O','o','','¦'] then goto e3
              else
              begin
                wrt_screen(OthInp,1,20,80,22);
                gotoxy(13,21); read(file_syntetagmenwn);
                assign(DumFile,file_syntetagmenwn+'.dat');
                {$i-}
                reset(DumFile);
                {$i+}
                okk:=(ioresult=0);
                if okk then
                begin
                  close(DumFile);
                  OpenFile(file_syn,file_syntetagmenwn+'.dat',sizeof(rec_syn));
                  OpenIndex(IndexName,file_syntetagmenwn+'.ind',4,1);
                end
                else
                begin
                  MakeFile(file_syn,file_syntetagmenwn+'.dat',sizeof(rec_syn));
                  MakeIndex(IndexName,file_syntetagmenwn+'.ind',4,1);
                end;
                fillchar(rec_syn,sizeof(rec_syn),0);
                for l:=2 to i-1 do
                begin
                  with rec_syn do
                  begin
                    kwd_syn:=kwd[l]; x_syn:=xh[l]; y_syn:=yh[l]; h_syn:=0;
                    eidos_point:=' '; job:=' '; xronol:=' ';
                    who_idrise:=' '; axiopistia:=' '; comments:=' ';
                  end;
                  AddRec(file_syn,DatRef,rec_syn);
                  AddKey(IndexName,DatRef,rec_syn.kwd_syn);
                end;
                CloseFile(file_syn);
                CloseIndex(IndexName);
              end;
e3:           cursor(false,true);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
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
              assign(fill,'prn');
              rewrite(fill);
              write(fill ,#27,#67,chr(ar_gram));  { Set Page Length }
              clrscr;
              wrt(26,12,240,'   „  ‰  ’  “    —  Œ  —..   ');
              write(fill,#12);    { Formfeed }
              sel:=0;
              lprint;
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
        7:begin
            if ((sw1=1) or (sw3=1) or (sw4=1)) then
            begin
              cursor(false,true);
              write_screen(i,7);
              epex_menu;
            end
            else
            begin
              cursor(false,true);
              wrt(12,21,240,'  ƒEN EX— ƒEƒOMENA.  ATH‘E ENA ŠHKTO..  ');
              repeat read(kbd,cha) until ((cha <> #13) or (cha <> #10));
              clrscr;
              epex_menu;
            end;
          end;
     end; { case }
end; { procedure }

BEGIN
clrscr;
InitIndex;
ofs1:=$8000;
if mem[0:1040] and 48 = 48 then ofs1:=$0000;
assign(k020_scr,'TRAVMET.scr');
reset(k020_scr);
seek(k020_scr,4); read(k020_scr,rec1);
for j:=1 to 3 do move(rec1.xx[(j-1)*160],OthInp[(j-1)*160+1],160);
for j:=4 to 17 do move(rec1.xx[(j-1)*160],OthPrint[(j-4)*90+1],90);
sw1:=0;    sw3:=0;    sw4:=0;    i:=0;    sel:=0;    gram:=0;
delete_all_input;
cursor(false,true);
epex_menu;
END.

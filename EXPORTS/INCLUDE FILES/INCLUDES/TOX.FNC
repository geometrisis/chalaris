(********************************************************)
(* TÑÉÃÙÍÏÌÅÔÑÉÊÅÓ ÓÕÍÁÑÔÇÓÅÉÓ ÃÉÁ ÔÇÍ BCD-TURBO PASCAL *)
(*         GIORGOS XALARHS - ÉÏÕÍÉÏÓ 1986          *)
(********************************************************)

function atan(x:real):real;  { ’ŽŽ „”€’Ž‹„Œ†‘ }
var r : real;
 function _atan(f:real):real;
 const
      a : array [0..3] of real =
                                 (  0.0,
                                    0.523598775598298,
                                    1.570796326794896,
                                    1.047197551196597
                                 );
 var
      n : integer;
      g, gpg, qg, r : real;

 begin
      if f > 1.0 then
      begin
           f := 1 / f;
           n := 2;
      end
      else
           n := 0;
      if f > 0.267949192431122 then
      begin
           g := 0.732050807568877 * f - 0.5;
           g := g - 0.5;
           f := (g + f) / (f + 1.732050807568877);
           n := n + 1;
      end;
      if abs(f) > 1.0e-08 then
      begin
           g := f * f;
           gpg := (((-0.837582993681500 * g - 0.849462403513206e01) * g -
                  0.205058551958616e02) * g - 0.136887688941919e02) * g;
           qg := (((g + 0.150240011600285e02) * g + 0.595784361425973e02) *
                 g + 0.861573495971302e02) * g + 0.410663066825757e02;
           r := gpg / qg;
           f := f + f * r;
      end;
      if n > 1 then f := (-f);
      f := f + a[n];
      _atan := f;
 end;

begin
     r := _atan(abs(x));
     if x < 0.0 then
          r := (-r);
     atan := r;
end;

function asin(x : real) : real;         { ’ŽŽ †‹ˆ’ŽŒŽ“ }
const halfpi = 1.57079632679489661923;
var sign : boolean;
    temp : real;
begin
    if x < 0.0 then begin
        x := (-x);    sign:=true;
    end
    else sign := false;
    if x > 1.0 then asin := 0.0;
    temp := sqrt(1.0 - x * x);
    if x > 0.7 then temp := halfpi - atan(temp / x)
    else temp := atan(x / temp);
    if sign then temp := (-temp);
    asin := temp;
end;

function acos(x:real) : real;     { ’ŽŽ ‘“Œ†‹ˆ’ŽŒŽ“ }
const halfpi = 1.57079632679489661923;
begin
    if (x > 1.0) or (x < -1.0) then acos := 0.0
    else acos := halfpi - asin(x);
end;

function modf(value : real; var ivp : real) : real;
begin
    ivp := int(value);
    modf := abs(frac(value));
end;

function _sincos(x, y : real; sgn, cosflag : boolean) : real;
const r : array [0..7] of real =
                                ( -0.16666666666666665052e+00,
                                   0.83333333333331650314e-02,
                                  -0.19841269841201840457e-03,
                                   0.27557319210152756119e-05,
                                  -0.25052106798274584544e-07,
                                   0.16058936490371589114e-09,
                                  -0.76429178068910467734e-12,
                                   0.27204790957888846175e-14
                                );
var j, n : integer;
    xn, f, g, rg : real;
begin
    if y > 1.0e+08 then _sincos := 0.0;
    if modf(y * 0.318309886183790, xn) >= 0.5 then xn := xn + 1.0;
    n := trunc(xn);
    if (n and 1) <> 0 then sgn := not sgn;
    if cosflag then xn := xn - 0.5;
    f := abs(x) - 3.1416015625 * xn;
    f := f + 8.90891020676154e-06 * xn;
    if abs(f) > 1.0e-08 then begin
        g := f * f;
        rg := 0.0;
        for j := 7 downto 0 do
            rg := (rg + r[j]) * g;
        f := f + f * rg;
    end;
    if sgn then f := -f;
    _sincos := f;
end;

{//////////////////////////////////////////////////////
// Copyright (C)  - George Xalaris July/1986 //
//////////////////////////////////////////////////////}
function force(x,y:real):real;
var bit:real;
begin
     if (frac(y) <> 0.0) and (x < 0.0) then
     begin
          writeln(^G,#10,#13,'.. Error in FORCE function.');
          Halt
     end;
     if x = 0  then
    begin
         force:=0.0;  exit;
     end;
     bit:=1.0;
     if (frac(y/2)) <> 0.0 then bit:=x/abs(x);
     force:=exp(y*ln(abs(x)))*bit;
end;


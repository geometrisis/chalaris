function acos(x : real) : real;
begin
    if x<>1 then
        acos:=pi/2-arctan(x/sqrt(1-sqr(x)))
    else acos:=0;
end;
procedure arc(dx,dy:real; var az:real);
var       p,a1:real;
begin
  p:=arctan(1) * 4;
  if dx < 0 then
  begin
    if dy < 0 then
    begin
      a1:=arctan(abs(dx / dy));
      az:=p + a1;
    end;
    if dy =  then az:= 3 * p / 2;
    if dy > 0 then
    begin
      a1:=arctan(abs(dx / dy));
      az:=2 * p - a1;
    end;
  end;
  if dx = 0 then
  begin
    if dy < 0 then az:=p;
    if dy > 0 then az:=0;
  end;
  if dx > 0 then
  begin
    if dy < 0 then
    begin
      a1:=arctan(abs(dx / dy));
      az:=p - a1;
    end;
    if dy = 0 then az:= p / 2;
    if dy > 0 then
    begin
      a1:=arctan(abs(dx / dy));
      az:=a1;
    end;
  end;
end;

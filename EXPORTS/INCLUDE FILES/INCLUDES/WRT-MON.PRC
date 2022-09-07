{//////////////////////////////////////////////////////
// Copyright (C)  - George Xalaris July/1986 //
//////////////////////////////////////////////////////}
procedure wrt(x,y,k : Byte; st : string255);
var i,j : integer;
begin
    j:=((y-1)*160)+((x-1)*2);
    if length(st) > 1  then
    for i:=1 to length(st)  do
    begin
        mem[$B000:ofs1+j]:=ord(st[i]);
       j:=j+2;
        mem[$B000:ofs1+j-1]:=k;
    end
    else
    for i:=1 to ord(st[1])  do
    begin
        j:=j+2;   mem[$B000:ofs1+j-1]:=k;
    end;
end;

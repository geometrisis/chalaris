{//////////////////////////////////////////////////////
// Copyright (C)  - George Xalaris July/1986 //
//////////////////////////////////////////////////////}
Function RepStr(ct,cr : byte) : string255;
var  i : byte;
   rep : string255;
begin
    rep:='';
    for i:=1 to ct  do  rep:=rep+chr(cr);
    RepStr:=rep;
end;
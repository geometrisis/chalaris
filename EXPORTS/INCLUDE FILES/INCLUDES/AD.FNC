{//////////////////////////////////////////////////////
// Copyright (C)  - George Xalaris July/1986 //
//////////////////////////////////////////////////////}
function ad : boolean;
var ch : char;
begin
     if mem[0:1097] in [4,5,6] then
     begin
          gotoxy(2,25);     write(' ƒIOP‡—‘H ');
          gotoxy(12,25);    write(' ; (N/ )');
     end
     else begin
          rt(2,25,240,' ƒIOP‡—‘H ');  wrt(12,25,15,' ; (N/ )');
     end;
     gotoxy(18,25);               read(kbd,ch);
     if ch in ['n','N','¤','Œ',#8]  then ad:=true   else ad:=false;
end;

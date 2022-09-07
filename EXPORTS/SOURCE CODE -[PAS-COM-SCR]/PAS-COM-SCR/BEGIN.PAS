  seek(k031_scr,3); read(k031_scr,rec1);   {*** š ˜ : printer,input ˜¨®œ ¦ ***}
  for l:=1 to 3 do move(rec1.xx[(l-1)*160],OthInp[(l-1)*160+1],160);
  for l:=4 to 17 do move(rec1.xx[(l-1)*160],OthPrint[(l-4)*90+1],90);

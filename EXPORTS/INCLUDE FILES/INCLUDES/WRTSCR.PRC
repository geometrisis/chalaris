{//////////////////////////////////////////////////////
// Copyright (C)  - George Xalaris July/1986 //
//////////////////////////////////////////////////////}

Type entirescreen=array [1..3680] of byte;
{----------------------------------------------------------------------------}
     Procedure MoveToScreen(Var Source,Dest;LENGTH:INTEGER);
     Begin
          MOVE(Source,Dest,LENGTH);
     End;
{----------------------------------------------------------------------------}
     Procedure MoveFromScreen(Var Source,Dest;LENGTH:INTEGER);
     Begin
          MOVE(Source,Dest,LENGTH);
     End;
{----------------------------------------------------------------------------}
     Procedure Wrt_Screen(Var A;x1,y1,x2,y2:INTEGER);
     Var i,j,scr1,scr2:INTEGER;
     Var B:entirescreen Absolute A;
     Begin
          if x1<1 then x1:=1;
          if x1>80 then x1:=80;
          if x2<1 then x2:=1;
          if x2>80 then x2:=80;
          if y1<1 then y1:=1;
          if y1>25 then y1:=25;
          if y2<1 then y2:=1;
          if y2>25 then y2:=25;
          If (y1>y2) Or (Not(y1 In [1..25])) Or (Not(y2 In [1..25])) Then EXIT;
          If ((x1>x2) And (y1=y2)) Or (Not(x1 In [1..80])) Or
          (Not(x2 In [1..80])) Then EXIT;
          If (x1=1) And (x2=80) Then Begin
               MoveToScreen(B[1],MEM[$B000:ofs1+pred(y1)*160]
               ,succ(y2-y1)*160);
               EXIT;
          End;
          scr1:=pred(x1) Shl 1;
          scr2:=succ(x2-x1) Shl 1;
          For i:=0 To y2-y1 Do
               Begin
                    j:=pred(y1+i)*160+scr1;
                    moveToScreen(B[succ(i*scr2)],MEM[$B000:ofs1+j],scr2);
               End;
     End;
{----------------------------------------------------------------------------}
     Procedure Read_Screen(Var A;x1,y1,x2,y2:INTEGER);
     Var i,j,scr1,scr2:INTEGER;
     Var B:entirescreen Absolute A;
     Begin
          if x1<1 then x1:=1;
          if x1>80 then x1:=80;
          if x2<1 then x2:=1;
          if x2>80 then x2:=80;
          if y1<1 then y1:=1;
          if y1>25 then y1:=25;
          if y2<1 then y2:=1;
          if y2>25 then y2:=25;
          If (y1>y2) Or (Not(y1 In [1..25])) Or (Not(y2 In [1..25])) Then EXIT;
          If ((x1>x2) And (y1=y2)) Or (Not(x1 In [1..80])) Or
          (Not(x2 In [1..80])) Then EXIT;
          If (x1=1) And (x2=80) Then Begin
             moveFromScreen(MEM[$B000:ofs1+pred(y1)*160],B[1]
            ,succ(y2-y1)*160);
             EXIT;
          End;
          scr1:=pred(x1) Shl 1;
          scr2:=succ(x2-x1) Shl 1;
          For i:=0 To y2-y1 Do
               Begin
                    j:=pred(y1+i)*160+scr1;
                    moveFromScreen(MEM[$B000:ofs1+j],B[succ(i*scr2)],scr2);
               End;

     End;
{----------------------------------------------------------------------------}

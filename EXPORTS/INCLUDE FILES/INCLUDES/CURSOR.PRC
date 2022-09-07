{//////////////////////////////////////////////////////
// Display or hide Cursor depending on variable : On //
// On = True  ->  Cursor is displayed                //
// On = False -> Cursor is disappeared               //
// Copyright (C)  - George Xalaris July/1986     //
//////////////////////////////////////////////////////}

Procedure Cursor(On,Typ : Boolean);
Type Registers = Record
                     AX,BX,CX,DX,BP,SI,DI,DS,ES,Flags : integer;
                 End;
Var ColorDisplay : Boolean;
    RegPack      : Registers;

Begin
     If Mem[0:1040] And 48 = 48 Then     { Check Display Adaptor }
          ColorDisplay := False
     Else ColorDisplay := True;

     With RegPack do
     Begin
          AX := $0100;                   { Set Cursor Type }
          If On Then
               If ColorDisplay Then
                  if Typ then
                    cx:=$0407
                  else
                    CX := $0607          { Cursor On for Color Display }
               Else
                  if Typ then
                    cx:=$070c
                  else
                    CX := $0B0C          { Cursor On for Monochrome Display }
          Else
               CX := $2000;              { Disappear Cursor }
     End;

     Intr($10,RegPack);                  { Call Video Interrupt 10H }

End;

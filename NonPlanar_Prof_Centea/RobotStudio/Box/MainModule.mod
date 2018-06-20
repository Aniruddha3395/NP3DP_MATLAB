MODULE MainModule
PERS wobjdata Workobject_1:=[FALSE,TRUE,"",[[349,99.8,313.6],[0.707106781,0,0,-0.707106781]],[[0,0,0],[1,0,0,0]]];
PERS tooldata Extruder:=[TRUE,[[-32.5,-6.5,85.6],[0,-0.707106781,0.707106781,0]],[0.5,[-3,-15,42],[1,0,0,0],0,0,0]];
CONST robtarget p1 := [ [0,0,0], [1, 0, 0, 0], [0,0,0,0], [9E9,9E9, 9E9, 9E9, 9E9, 9E9] ];
VAR speeddata vel1 := [10,10,10,10];



PROC main()
AccSet 10,10;
SingArea\Wrist;
ConfL\On;

MoveL RelTool (p1,0,0,5.5),vel1,fine,Extruder\WObj:=Workobject_1;
WaitTime 5;
MoveL RelTool (p1,0,0,30),vel1,fine,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,85.83,0,30),vel1,fine,Extruder\WObj:=Workobject_1;

MoveL RelTool (p1,85.83,0,5.5),vel1,fine,Extruder\WObj:=Workobject_1;
WaitTime 5;
MoveL RelTool (p1,85.83,0,30),vel1,fine,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,85.83,19,30),vel1,fine,Extruder\WObj:=Workobject_1;

MoveL RelTool (p1,85.83,19,5.5),vel1,fine,Extruder\WObj:=Workobject_1;
WaitTime 5;
MoveL RelTool (p1,85.83,19,30),vel1,fine,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,0,19,30),vel1,fine,Extruder\WObj:=Workobject_1;

MoveL RelTool (p1,0,19,5.5),vel1,fine,Extruder\WObj:=Workobject_1;
WaitTime 5;
MoveL RelTool (p1,0,19,30),vel1,fine,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,0,0,30),vel1,fine,Extruder\WObj:=Workobject_1;

ConfL\Off;



    ENDPROC
ENDMODULE
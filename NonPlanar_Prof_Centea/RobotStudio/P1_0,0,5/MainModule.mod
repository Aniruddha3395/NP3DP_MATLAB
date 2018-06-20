MODULE MainModule
PERS wobjdata Workobject_1:=[FALSE,TRUE,"",[[350,100,313.6],[0.707106781,0,0,-0.707106781]],[[0,0,0],[1,0,0,0]]];
PERS tooldata Extruder:=[TRUE,[[-32.5,-6.5,85.6],[0,-0.707106781,0.707106781,0]],[0.5,[-3,-15,42],[1,0,0,0],0,0,0]];
CONST robtarget p1 := [ [0,0,0], [1, 0, 0, 0], [0,0,0,0], [9E9,9E9, 9E9, 9E9, 9E9, 9E9] ];
VAR speeddata vel1 := [10,10,10,10];



PROC main()
AccSet 10,10;
SingArea\Wrist;
ConfL\On;

MoveL RelTool (p1,0,0,5),vel1,z0,Extruder\WObj:=Workobject_1;




ConfL\Off;



    ENDPROC
ENDMODULE
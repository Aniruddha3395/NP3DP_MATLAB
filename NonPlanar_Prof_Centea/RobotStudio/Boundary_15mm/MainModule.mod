MODULE MainModule
PERS wobjdata Workobject_1:=[FALSE,TRUE,"",[[349,99.8,314.2],[0.707106781,0,0,-0.707106781]],[[0,0,0],[1,0,0,0]]];
PERS tooldata Extruder:=[TRUE,[[-32.5,-6.5,85.6],[0,-0.707106781,0.707106781,0]],[0.5,[-3,-15,42],[1,0,0,0],0,0,0]];
CONST robtarget p1 := [ [0,0,0], [1, 0, 0, 0], [0,0,0,0], [9E9,9E9, 9E9, 9E9, 9E9, 9E9] ];
VAR speeddata vel1 := [20,20,10,10];



PROC main()
AccSet 10,10;
SingArea\Wrist;
ConfL\On;

MoveL RelTool (p1,40.000000,20.000000,70.00000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,3.000000,3.000000,70.00000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;


MoveL RelTool (p1,3.000000,3.000000,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,16.889791,3.000000,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,17.853737,3.000000,5.577939,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,18.792639,3.000000,5.809731,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,19.682108,3.000000,6.189353,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,20.499031,3.000000,6.706944,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,21.222189,3.000000,7.349056,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,21.832792,3.000000,8.099009,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,22.650812,3.000000,9.100924,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,23.772598,3.000000,10.134887,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,25.193590,3.000000,11.154757,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,26.920465,3.000000,12.134054,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,28.913099,3.000000,13.027472,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,31.207542,3.000000,13.834116,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,33.752945,3.000000,14.511310,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,36.464352,3.000000,15.020040,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,39.327492,3.000000,15.352818,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,42.311409,3.000000,15.495806,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,44.728676,3.000000,15.462437,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,47.680168,3.000000,15.240072,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,50.559189,3.000000,14.821335,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,53.271854,3.000000,14.220007,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,55.736549,3.000000,13.469051,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,57.964592,3.000000,12.584953,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,59.858608,3.000000,11.625971,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,61.453785,3.000000,10.599978,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,62.719948,3.000000,9.559821,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,63.667679,3.000000,8.544519,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,63.999577,3.000000,8.099009,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,64.610184,3.000000,7.349056,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,65.333344,3.000000,6.706944,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,66.150261,3.000000,6.189353,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,67.039734,3.000000,5.809731,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,67.978638,3.000000,5.577939,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,68.942581,3.000000,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,82.832375,3.000000,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,82.832375,16.000000,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,68.942581,16.000000,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,67.978638,16.000000,5.577939,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,67.039734,16.000000,5.809731,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,66.150261,16.000000,6.189353,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,65.333344,16.000000,6.706944,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,64.610184,16.000000,7.349056,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,63.999577,16.000000,8.099009,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,63.667679,16.000000,8.544519,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,62.719948,16.000000,9.559821,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,61.453785,16.000000,10.599978,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,59.858608,16.000000,11.625971,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,57.964592,16.000000,12.584953,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,55.736549,16.000000,13.469051,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,53.271854,16.000000,14.220007,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,50.559189,16.000000,14.821335,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,47.680168,16.000000,15.240072,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,44.728676,16.000000,15.462437,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,42.311409,16.000000,15.495806,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,39.327492,16.000000,15.352818,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,36.464352,16.000000,15.020040,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,33.752945,16.000000,14.511310,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,31.207542,16.000000,13.834116,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,28.913099,16.000000,13.027472,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,26.920465,16.000000,12.134054,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,25.193590,16.000000,11.154757,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,23.772598,16.000000,10.134887,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,22.650812,16.000000,9.100924,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,21.832792,16.000000,8.099009,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,21.222189,16.000000,7.349056,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,20.499031,16.000000,6.706944,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,19.682108,16.000000,6.189353,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,18.792639,16.000000,5.809731,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,17.853737,16.000000,5.577939,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,16.889791,16.000000,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,3.000000,16.000000,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,3.000000,3.000000,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;

MoveL RelTool (p1,3.000000,3.000000,70.00000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;





ConfL\Off;



    ENDPROC
ENDMODULE
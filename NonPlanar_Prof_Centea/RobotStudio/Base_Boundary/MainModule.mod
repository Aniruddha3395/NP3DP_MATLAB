MODULE MainModule
PERS wobjdata Workobject_1:=[FALSE,TRUE,"",[[350,100.5,313.6],[0.707106781,0,0,-0.707106781]],[[0,0,0],[1,0,0,0]]];
PERS tooldata Extruder:=[TRUE,[[-32.5,-6.5,85.6],[0,-0.707106781,0.707106781,0]],[0.5,[-3,-15,42],[1,0,0,0],0,0,0]];
CONST robtarget p1 := [ [0,0,0], [1, 0, 0, 0], [0,0,0,0], [9E9,9E9, 9E9, 9E9, 9E9, 9E9] ];
VAR speeddata vel1 := [10,10,10,10];



PROC main()
AccSet 10,10;
SingArea\Wrist;
ConfL\On;

MoveL RelTool (p1,0.000000,0.335062,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,16.889791,0.335062,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,17.853737,0.335062,5.577939,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,18.792639,0.335062,5.809731,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,19.682108,0.335062,6.189353,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,20.499031,0.335062,6.706944,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,21.222189,0.335062,7.349056,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,21.832792,0.335062,8.099009,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,22.684334,0.335062,9.136209,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,23.870852,0.335062,10.213911,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,25.379631,0.335062,11.271954,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,27.220497,0.335062,12.282537,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,29.349672,0.335062,13.197302,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,31.802635,0.335062,14.011397,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,34.508900,0.335062,14.673716,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,37.376209,0.335062,15.147603,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,40.412663,0.335062,15.428386,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,43.525230,0.335062,15.495747,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,46.623795,0.335062,15.342882,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,49.656624,0.335062,14.975295,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,52.547928,0.335062,14.402096,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,55.186882,0.335062,13.655252,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,57.561073,0.335062,12.762100,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,59.404564,0.335062,11.877610,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,61.152596,0.335062,10.813431,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,62.531181,0.335062,9.732833,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,63.566975,0.335062,8.667627,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,63.999577,0.335062,8.099009,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,64.610184,0.335062,7.349056,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,65.333344,0.335062,6.706944,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,66.150261,0.335062,6.189353,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,67.039734,0.335062,5.809731,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,67.978638,0.335062,5.577939,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,68.942581,0.335062,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,85.832375,0.335062,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,85.832375,19.335062,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,68.942581,19.335062,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,67.978638,19.335062,5.577939,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,67.039734,19.335062,5.809731,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,66.150261,19.335062,6.189353,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,65.333344,19.335062,6.706944,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,64.610184,19.335062,7.349056,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,63.999577,19.335062,8.099009,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,63.566975,19.335062,8.667627,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,62.531181,19.335062,9.732833,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,61.152596,19.335062,10.813431,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,59.404564,19.335062,11.877610,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,57.561073,19.335062,12.762100,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,55.186882,19.335062,13.655252,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,52.547928,19.335062,14.402096,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,49.656624,19.335062,14.975295,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,46.623795,19.335062,15.342882,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,43.525230,19.335062,15.495747,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,40.412663,19.335062,15.428386,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,37.376209,19.335062,15.147603,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,34.508900,19.335062,14.673716,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,31.802635,19.335062,14.011397,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,29.349672,19.335062,13.197302,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,27.220497,19.335062,12.282537,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,25.379631,19.335062,11.271954,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,23.870852,19.335062,10.213911,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,22.684334,19.335062,9.136209,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,21.832792,19.335062,8.099009,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,21.222189,19.335062,7.349056,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,20.499031,19.335062,6.706944,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,19.682108,19.335062,6.189353,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,18.792639,19.335062,5.809731,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,17.853737,19.335062,5.577939,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,16.889791,19.335062,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,0.000000,19.335062,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;
MoveL RelTool (p1,0.000000,0.335062,5.500000,\Rx:=0.000000,\Ry:=0.000000),vel1,z0,Extruder\WObj:=Workobject_1;



ConfL\Off;



    ENDPROC
ENDMODULE
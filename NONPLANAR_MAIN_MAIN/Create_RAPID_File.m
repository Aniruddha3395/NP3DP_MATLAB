function [] = Create_RAPID_File(pathptsnew,Generate_Transform,WorkObject_Points,RobotBase_Points)

%This function is for putting data into text file. data is prepared in RAPID
%script which will be used in ABB. Simply copy the data from output_to_RAPID.txt file to RobotStudio file.

% INPUT = Points for tool travel in ordely manner along
% with tcp orientation in the form of n-by-5 matrix
% OUTPUT = text file containing data for RobotStudio


tcp_travel = fopen('output_to_RAPID.txt','wt');

fprintf(tcp_travel,'MODULE MainModule\n');

if Generate_Transform == 1
    %%%%Use this code for getting workObject data for RAPID
    % touch 4 or more points on the plane required (or obect on which printing will be done)
    % and get values of co-ordinates of these points w.r.t. robot base frame
    % and values of co-ordinates of these points w.r.t. desired work-object frame
    % format: input: WorkObject_Points = [x1, y1, z1;
    %                                     x2, y2, z2;
    %                                       :
    %                                       :
    %                                     xn, yn, zn]
    
    Transform_Mat = Get_Transformation_Matrix(WorkObject_Points,RobotBase_Points);
    Transl = [Transform_Mat(1,4),Transform_Mat(2,4),Transform_Mat(3,4)];
    quat = tform2quat(Transform_Mat);
    fprintf(tcp_travel,'PERS wobjdata Workobject_1:=[FALSE,TRUE,"",[[%f,%f,%f],[%f,%f,%f,%f]],[[0,0,0],[1,0,0,0]]];\n',Transl(1),Transl(2),Transl(3),quat(1),quat(2),quat(3),quat(4));
else
    fprintf(tcp_travel,'PERS wobjdata Workobject_1:=[FALSE,TRUE,"",[[300,99.9,313.2],[0.707106781,0,0,-0.707106781]],[[0,0,0],[1,0,0,0]]];\n');
end

fprintf(tcp_travel,'PERS tooldata tool_new:=[TRUE,[[-25.2038,-6.63467,85.9117],[0,-0.707106781,0.707106781,0]],[0.5,[-3,-15,42],[1,0,0,0],0,0,0]];\n');
fprintf(tcp_travel,'CONST robtarget p1 := [ [0,0,0], [1, 0, 0, 0], [0,0,0,0], [9E9,9E9, 9E9, 9E9, 9E9, 9E9] ];\n');
fprintf(tcp_travel,'VAR speeddata vel1 := [25,25,10,10];\n');
fprintf(tcp_travel,'VAR zonedata zoneval:=[FALSE,10,30,30,10,10,10];\n\n\n');

fprintf(tcp_travel,'PROC main()\n');
fprintf(tcp_travel,'AccSet 10,10;\n');
fprintf(tcp_travel,'SingArea%srist;\n','\W');
fprintf(tcp_travel,'ConfL%sn;\n','\O');

fprintf(tcp_travel,'MoveL RelTool (p1,0,0,70,%sx:=0,%sy:=0),vel1,zoneval,tool_new%sObj:=Workobject_1;\n\n','\R','\R','\W');

fprintf(tcp_travel,'MoveL RelTool (p1,%f,%f,%f,%sx:=0,%sy:=0),vel1,zoneval,tool_new%sObj:=Workobject_1;\n\n',pathptsnew(1,1),pathptsnew(1,2),pathptsnew(1,3)+50,'\R','\R','\W');



for i=1:size(pathptsnew,1)
    px = pathptsnew(i,1);       %x
    py = pathptsnew(i,2);       %x
    pz = pathptsnew(i,3);       %x
    rx = pathptsnew(i,4);       %Rx
    ry = pathptsnew(i,5);       %Ry
    % rx = 0;
    % ry = 0;
    % rz = 0;
    fprintf(tcp_travel,'MoveL RelTool (p1,%f,%f,%f,%sx:=%f,%sy:=%f),vel1,zoneval,tool_new%sObj:=Workobject_1;\n',px,py,pz,'\R',rx,'\R',ry,'\W');
end

fprintf(tcp_travel,'MoveL RelTool (p1,%f,%f,%f,%sx:=%f,%sy:=%f),vel1,zoneval,tool_new%sObj:=Workobject_1;\n\n',pathptsnew(i,1),pathptsnew(i,2),pathptsnew(i,3)+50,'\R',pathptsnew(i,4),'\R',pathptsnew(i,5),'\W');

fprintf(tcp_travel,'MoveL RelTool (p1,0,0,70,%sx:=0,%sy:=0),vel1,zoneval,tool_new%sObj:=Workobject_1;\n\n','\R','\R','\W');


fprintf(tcp_travel,'\tENDPROC\n');
fprintf(tcp_travel,'ENDMODULE\n');

fclose(tcp_travel);

end
function [] = Create_PointsData_In_RAPID_Format(pathptsnew)

%This function is for putting data into text file. data is prepared in RAPID
%script which will be used in ABB. Simply copy the data from output_to_RAPID.txt file to RobotStudio file.

% INPUT = Points for tool travel in ordely manner along
% with tcp orientation in the form of n-by-5 matrix
% OUTPUT = text file containing data for RobotStudio

tcp_travel = fopen('output_to_RAPID.txt','wt');

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

fclose(tcp_travel);

end
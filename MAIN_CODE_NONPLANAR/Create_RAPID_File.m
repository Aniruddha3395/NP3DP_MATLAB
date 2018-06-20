function [] = Create_RAPID_File(pathptsnew)

%This function is for putting data into text file. data is prepared in RAPID
%script. Simply copy the data from output_to_RAPID.txt file to RobotStudio file.

% INPUT = Points for tool travel in ordely manner along
% with tcp orientation in the form of n-by-5 matrix
% OUTPUT = text file containing data for RobotStudio

tcp_travel = fopen('output_to_RAPID.txt','wt');
% fprintf(tcp_travel,'MODULE MainModule\n');
a = '\R';
b = '\W';
c = '\O';


% delete this -  make sure you take it from the top
% delete this - add other sufficient lines of texts for o/p if required

for i=1:size(pathptsnew,1)
    px = pathptsnew(i,1);
    py = pathptsnew(i,2);
    pz = pathptsnew(i,3)-0.5+1.3;
    rx = pathptsnew(i,4)/1.5;
    ry = pathptsnew(i,5)/3;
    % rx = 0;
    % ry = 0;
    fprintf(tcp_travel,'MoveL RelTool (p1,%f,%f,%f,%sx:=%f,%sy:=%f),vel1,zoneval,tool_new%sObj:=Workobject_1;\n',px,py,pz,a,rx,a,ry,b);
end

% fprintf(tcp_travel,'ENDMODULE\n');

fclose(tcp_travel);

end
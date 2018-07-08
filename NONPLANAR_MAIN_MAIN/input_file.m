clc;
clear;
close all;
warning off;
tic;        %start time
%% INPUTS

%%% STL file name -
STL_File = 'L1.stl';

%%% Gap between 2 hatching lines -
pathgap = 0.5;

%%% Gap between 2 layers -
pathgapz = 1;

%%% Path to generate -
% 1 - Boundary
% 2 - Along X-direction, i.e. 0 degree hatching
% 3 - Along Y-direction, i.e. 90 degree hatching
% 4 - Along the line Y=X, i.e. 45 degree hatching
% 5 - Along the line Y=-X, i.e. 135 degree hatching
Path_Number = 3;    %put number from above
FlipTravel = 0;     %1 for yes, 0 for No
space = 2;          %number of points to skip for smoother path

%%% Make Complete Rapid File or Points file for Rapid
% 1 - Complete File
% 2 - Points File
FileType = 2;

%%% Generate Transformation for Robot Work Co-ordinates Setup
% 1 - Yes
% 2 - No
Generate_Transform = 2;     % check 'Transformation_Setup.m' function


%% Robot Work-Object Frame Setup
if Generate_Transform == 1
    % Add points
    WorkObject_Points = [0, 0, 0;
        203.2, 0, 0;
        203.2, 203.2, 0;
        0, 203.2, 0;
        203.2, 0, -4;
        0, 0, -4;
        0, 203.2, -4;
        203.2, 203.2, -4];
    % Add points
    RobotBase_Points = [228.41, 62.57, 285.33;
        217.55, -125.14, 357.75;
        419.30, -135.32, 361.07;
        429.84, 52.60, 288.29;
        219.22, -119.90, 357.06;
        229.33, 60.44, 282.77;
        426.30, 50.44, 285.63;
        417.51, -132.37, 356.93];
else
    WorkObject_Points = [];
    RobotBase_Points = [];
end


%% bottom layer generation

% using the stlread function from Mathworks File Exchange to get the
% vertices v, faces f and normals n from stl file
[v, f, n, stltitle] = stlRead(STL_File);
% reference: https://www.mathworks.com/matlabcentral/fileexchange/51200-stltools

%%%%%%%%% put this only when body is shifted...
v(:,1) = v(:,1);
v(:,2) = v(:,2);


%% xmax and ymax to get the grid size

xmax = max(v(:,1));
ymax = max(v(:,2));


%% identifying the co-ordinates of bottom layer first

fnew = Identify_Bottom_Layer(v,f,n);

%%%%%%%%%%%%% grid pts in triangle %%%%%%%%%%%

pts = Generate_Grid_Points(pathgap,xmax,ymax);

[fillpts] = Project_Grid_Points(fnew,v,pts);


%% use input to make specific infill or boundary ...also delete this

switch Path_Number
    case 1
        bdry = Boundary_Path(fillpts);
        %for making RAPID code for ABB
        if FileType==1
            Create_RAPID_File(bdry,Generate_Transform,WorkObject_Points,RobotBase_Points);
        elseif FileType==2
            Create_PointsData_In_RAPID_Format(bdry);
        end
        fprintf('Output file "output_to_RAPID.txt" is created for Boundary Path!\n');
    case 2
        infill = Infill_Path_0_Degree(fillpts,FlipTravel,space);
        %for making RAPID code for ABB
        if FileType==1
            Create_RAPID_File(infill,Generate_Transform,WorkObject_Points,RobotBase_Points);
        elseif FileType==2
            Create_PointsData_In_RAPID_Format(infill);
        end
        fprintf('Output file "output_to_RAPID.txt" is created for 0 degree path!\n');
    case 3
        infill = Infill_Path_90_Degree(fillpts,FlipTravel,space);
        %for making RAPID code for ABB
        if FileType==1
            Create_RAPID_File(infill,Generate_Transform,WorkObject_Points,RobotBase_Points);
        elseif FileType==2
            Create_PointsData_In_RAPID_Format(infill);
        end
        fprintf('Output file "output_to_RAPID.txt" is created for 90 degree path!\n');
    case 4
        infill = Infill_Path_45_Degree(fillpts,pathgap,FlipTravel,space);
        %for making RAPID code for ABB
        if FileType==1
            Create_RAPID_File(infill,Generate_Transform,WorkObject_Points,RobotBase_Points);
        elseif FileType==2
            Create_PointsData_In_RAPID_Format(infill);
        end
        fprintf('Output file "output_to_RAPID.txt" is created for 45 degree path!\n');
    case 5
        infill = Infill_Path_135_Degree(fillpts,pathgap,FlipTravel,space);
        %for making RAPID code for ABB
        if FileType==1
            Create_RAPID_File(infill,Generate_Transform,WorkObject_Points,RobotBase_Points);
        elseif FileType==2
            Create_PointsData_In_RAPID_Format(infill);
        end
        fprintf('Output file "output_to_RAPID.txt" is created for 135 degree path!\n');
end
toc;        %end time
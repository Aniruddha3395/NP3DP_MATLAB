clc;
clear;
close all;
warning off;
tic;        %start time
%% INPUTS

% STL file name - 
STL_File = 'Convex.stl';

% Gap between 2 hatching lines - 
pathgap = 0.5;

% Gap between 2 layers - 
pathgapz = 1;

% Path to generate - 
% 1 - Boundary
% 2 - Along X-direction, i.e. 0 degree hatching
% 3 - Along Y-direction, i.e. 90 degree hatching
% 4 - Along the line Y=X, i.e. 45 degree hatching
% 5 - Along the line Y=-X, i.e. 135 degree hatching
Path_Number = 5;    %put number from above
FlipTravel = 0;     %1 for yes, 0 for No
space = 5;          %number of points to skip for smoother path

%%%%%%%%%%%%%% give if else fo images...want to show or not

%% bottom layer generation

% using the stlread function from Mathworks File Exchange to get the
% vertices v, faces f and normals n from stl file
[v, f, n, c, stltitle] = stlread(STL_File);
% put this only when body is shifted...also for x code, it is -3
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
        Create_RAPID_File(bdry);
        fprintf('Output file "output_to_RAPID.txt" is created for Boundary Path!\n');
    case 2
        infill = Infill_Path_0_Degree(fillpts,FlipTravel,space);
        Create_RAPID_File(infill);
        fprintf('Output file "output_to_RAPID.txt" is created for 0 degree path!\n');
    case 3
        infill = Infill_Path_90_Degree(fillpts,FlipTravel,space);
        Create_RAPID_File(infill);
        fprintf('Output file "output_to_RAPID.txt" is created for 90 degree path!\n');
    case 4
        infill = Infill_Path_45_Degree(fillpts,pathgap,FlipTravel,space);
        Create_RAPID_File(infill);
        fprintf('Output file "output_to_RAPID.txt" is created for 45 degree path!\n');
    case 5
        infill = Infill_Path_135_Degree(fillpts,pathgap,FlipTravel,space);
        Create_RAPID_File(infill);
        fprintf('Output file "output_to_RAPID.txt" is created for 135 degree path!\n');
end
toc;        %end time
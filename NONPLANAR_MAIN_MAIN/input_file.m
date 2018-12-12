clc;
clear;
close all;
warning off;
set(0, 'DefaultFigureRenderer', 'opengl');

tic;        %start time

%% INPUTS
% -----------------------------------------------------------------------%
% write data to file
write_data = false;
calculate_number_of_layers = true;

% STL file name -
STL_File = 'test_part4.STL';

% Gap between 2 hatching lines -
pathgap_x = 2;                %mm
pathgap_y = 2;                %mm
start_hatch_angle = 0;       %degrees
hatch_angle_change = 45;      %consecutive layers will have this much change in hatching angle (degrees)
grid_addition = 70;           %higher number for higher aspect ratio of part in xy plane

% Gap between 2 layers -
pathgapz = 0.5;           %mm

% Path to generate -
% 1 - Boundary
% 2 - Hatching
Path_Number = 2;    %put number from above
FlipTravel = 0;     %1 for yes, 0 for No
space = 2;          %number of points to skip for smoother path
% -----------------------------------------------------------------------%

%% bottom layer generation
% using the stlread function from Mathworks File Exchange to get the
% vertices v, faces f and normals n from stl file
[v, f, n, stltitle] = stlRead(STL_File);
% reference: https://www.mathworks.com/matlabcentral/fileexchange/51200-stltools

%% xmax and ymax to get the grid size
xmax = max(v(:,1))+grid_addition;
ymax = max(v(:,2))+grid_addition;
xmin = min(v(:,1))-grid_addition;
ymin = min(v(:,2))-grid_addition;

%% finding thickness of shell part and number of layers required for printing
if calculate_number_of_layers==true
    num_of_layers = number_of_layers(v,f,n,pathgapz);
else
    num_of_layers = input('specify number of layers = \n');
end

%% identifying the co-ordinates of bottom layer first
fnew = Identify_Bottom_Layer(v,f,n);

%% generating the tool path
all_traj_pts = {};
for layer = 1:num_of_layers
    
    hatch_angle = start_hatch_angle + (layer-1)*hatch_angle_change;
    
    % generate planar grid points
    pts = Generate_Grid_Points(pathgap_x,pathgap_y,xmin,ymin,xmax,ymax,hatch_angle);
    
    % project grid points on the non planar surface
    [fillpts] = Project_Grid_Points(fnew,v,pts,hatch_angle);
    
    switch Path_Number
        case 1
            tool_path = Boundary_Path(fillpts,hatch_angle);
        case 2
            tool_path = Infill_Path(fillpts,FlipTravel,space,hatch_angle);
    end
    tool_path(:,3) = tool_path(:,3) + (layer-1)*pathgapz;
    hold on;
    plot3(tool_path(:,1),tool_path(:,2),tool_path(:,3))
    xlabel('x');
    ylabel('y');
    zlabel('z');
    daspect([1 1 1]);
    
    % append data
    start_pt = tool_path(1,:);
    start_pt(1,3) = start_pt(1,3)+50;
    end_pt = tool_path(end,:);
    end_pt(1,3) = end_pt(1,3)+50;
    all_traj_pts{layer,1} = [start_pt;tool_path;end_pt];
end

%% write data to file
if write_data
    % Create_RAPID_File(cell2mat(all_traj_pts));
    dlmwrite('complete_tool_path.csv',cell2mat(all_traj_pts));
    fprintf('Output file is created!\n');
end

toc;        %end time



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
calculate_number_of_layers = false;
enable_MEX = true;

% STL file name -
STL_File = 'data_files/test_part4.STL';

% Gap between 2 hatching lines -
pathgap_x = 1;                %mm
pathgap_y = 1;                %mm
start_hatch_angle = 0;          %degrees
hatch_angle_change = 0;         %consecutive layers will have this much change in hatching angle (degrees)
grid_addition = 100;            %higher number for higher aspect ratio of part in xy plane

% Gap between 2 layers -
pathgapz = 25;           %mm

% Path to generate -
% 1 - Boundary
% 2 - Hatching
Path_Number = 2;    %put number from above
FlipTravel = 0;     %1 for yes, 0 for No
space = 4;          %number of points to skip for smoother path
skip_lines = 0;    %skip number of lines without scarificing edge points
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
    if enable_MEX
        num_of_layers = number_of_layers_mex(v,f,n,pathgapz);
    else
        num_of_layers = number_of_layers(v,f,n,pathgapz);
    end
else
    num_of_layers = input('specify number of layers = \n');
end
%% identifying the co-ordinates of bottom layer first
if enable_MEX
    fnew = Identify_Top_Layer_mex(v,f,n);
else
    fnew = Identify_Bottom_Layer(v,f,n);
end
%% generating the tool path
all_traj_pts = {};
for layer = 1:num_of_layers    
    hatch_angle = start_hatch_angle + (layer-1)*hatch_angle_change;
    
    % generate planar grid points
    if enable_MEX
        pts = Generate_Grid_Points_mex(pathgap_x,pathgap_y,xmin,ymin,xmax,ymax);
    else
        pts = Generate_Grid_Points(pathgap_x,pathgap_y,xmin,ymin,xmax,ymax);
    end
    
    % apply rotation to points
    x_avg = sum(pts(:,1))/size(pts,1);
    y_avg = sum(pts(:,2))/size(pts,1);
    if enable_MEX
        pts = rotate_pts_mex(pts,hatch_angle,x_avg,y_avg);
    else
        pts = rotate_pts(pts,hatch_angle,x_avg,y_avg);
    end
    
    % project grid points on the non planar surface
    if enable_MEX
        fillpts = Project_Grid_Points_mex(fnew,v,pts,hatch_angle,x_avg,y_avg);
    else
        fillpts = Project_Grid_Points(fnew,v,pts,hatch_angle,x_avg,y_avg);
    end
    %------------------plot the projected grid points------------------------%
%     hold on;
%     scatter3(fillpts(:,1),fillpts(:,2),fillpts(:,3),'.');
    %------------------------------------------------------------------------%
    switch Path_Number
        case 1
            tool_path = Boundary_Path(fillpts,hatch_angle,x_avg,y_avg);
        case 2
            if enable_MEX
                tool_path = Infill_Path_with_normals_mex(fillpts,FlipTravel,space,hatch_angle,x_avg,y_avg,skip_lines);
            else
                tool_path = Infill_Path(fillpts,FlipTravel,space,hatch_angle,x_avg,y_avg,skip_lines);
            end   
    end    
    tool_path(:,3) = tool_path(:,3) + (layer-1)*pathgapz;
    
    %--------------------- plot the final points ----------------------------%
    hold on;
    plot3(tool_path(:,1),tool_path(:,2),tool_path(:,3));
%     hold on;
%     scatter3(tool_path(:,1),tool_path(:,2),tool_path(:,3),'filled');
    %------------------------------------------------------------------------%
    xlabel('x');
    ylabel('y');
    zlabel('z');
    daspect([1 1 1]);
    
end

%% write data to file
if write_data
    % Create_RAPID_File(cell2mat(all_traj_pts));
    dlmwrite('complete_tool_path.csv',cell2mat(all_traj_pts));
    fprintf('Output file is created!\n');
end

toc;        %end time



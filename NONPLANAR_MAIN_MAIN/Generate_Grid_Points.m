function [pts] = Generate_Grid_Points(pathgap_x,pathgap_y,xmin,ymin,xmax,ymax,hatch_angle);
global x_avg y_avg;

% Function to generate the uniform mesh grid of points along the x-y plane.
% INPUT = gap between the adjacent points and maximum value
% in x and y direction. Gap along x and y is same.
% OUTPUT = All points consisting the uniform grid.

pts = [];                               % empty matrix for storage
for i = floor(xmin):pathgap_x:ceil(xmax)            % iteration along x direction
    j = [floor(ymin):pathgap_y:ceil(ymax)]';        % iteration along y direction
    pts= [pts;[[i*ones(size(j,1),1)],j]];
end

% apply rotation to points
x_avg = sum(pts(:,1))/size(pts,1);
y_avg = sum(pts(:,2))/size(pts,1);
pts = rotate_pts(pts,hatch_angle,x_avg,y_avg);

end
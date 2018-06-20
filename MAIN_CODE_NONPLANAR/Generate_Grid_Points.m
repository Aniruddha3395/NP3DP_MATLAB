function [pts] = Generate_Grid_Points(pathgap,xmax,ymax)

% Function to generate the uniform mesh grid of points along the x-y plane.
% INPUT = gap between the adjacent points and maximum value
% in x and y direction. Gap along x and y is same.
% OUTPUT = All points consisting the uniform grid.


pts = [];                               % empty matrix for storage
for i = 0:pathgap:ceil(xmax)            % iteration along x direction
    j = [0:pathgap:ceil(ymax)]';        % iteration along y direction
    pts= [pts;[[i*ones(size(j,1),1)],j]];
end

end
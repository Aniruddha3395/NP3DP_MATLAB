function [pts_T] = rotate_pts(pts,theta,x_avg,y_avg)

% Function for applying rotation to points about their centroid
% INPUT : xyz points, rotation angle, x-avg and y-avg
% OUTPUT : rotated points about their centroid

% translate points so that origin matches with the centroid
pts(:,1) = pts(:,1) - x_avg;
pts(:,2) = pts(:,2) - y_avg;

% rotate points about centroid
r = rotz(theta);
t = [0;0;0];
T = [r,t;0 0 0 1];
pts = [pts,zeros(size(pts,1),1)];
pts_T = apply_transformation(pts,T);

% translate points back to the original position 
pts_T(:,1) = pts_T(:,1) + x_avg;
pts_T(:,2) = pts_T(:,2) + y_avg;
pts_T = pts_T(:,1:2);
end
function [storesort0x1tp] = Infill_Path_with_euler(fillpts,FlipTravel,space,hatch_angle,x_avg,y_avg,skip_lines)

% function for creating path from projected points for tcp travel
% along x direction
% INPUT: projected points on the surface (equally spaced along x and y axes)
% OUTPUT: points arranged along 0 degree path with their Rx and Ry value

storesort0x1 = align_pts(fillpts);

% getting Euler angles

[bx,by,bz] = compute_TCP_new(storesort0x1(:,1:3),-storesort0x1(:,4:6));
[abc] = bxbybz_to_euler(bx,by,bz);
storesort0x1 = [storesort0x1(:,1:3),abc];

storesort0x1tp = smoothened_traj_by_pts_skip(storesort0x1,space);

% skipping the toolpath lines
storesort0x1tp = skip_toolpath_lines(storesort0x1tp,skip_lines);

%% flip the direction of travel
if FlipTravel==1
    storesort0x1tp = flipud(storesort0x1tp);
end

%% apply hatching angle
storesort0x1tp_new = rotate_pts(storesort0x1tp(:,1:2),hatch_angle,x_avg,y_avg);
storesort0x1tp(:,1:2) = storesort0x1tp_new;
% figure;
% scatter3(storesort0x1tp(:,1),storesort0x1tp(:,2),storesort0x1tp(:,3),'r','.')
% xlabel('x');
% ylabel('y');
% zlabel('z');
% hold on;
% plot3(storesort0x1tp(:,1),storesort0x1tp(:,2),storesort0x1tp(:,3))
% xlabel('x');
% ylabel('y');
% zlabel('z');
% daspect([1 1 1]);

end
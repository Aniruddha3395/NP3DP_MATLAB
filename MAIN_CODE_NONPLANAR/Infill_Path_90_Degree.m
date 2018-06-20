function [storesort1y0tp] = Infill_Path_90_Degree(fillpts,FlipTravel,space)
% function for creating path from projected points for tcp travel 
% along y direction
% INPUT: projected points on the surface (equally spaced along x and y axes)
% OUTPUT: points arranged along 90 degree path with their Rx and Ry value

dir1 = 1;
dir2 = 2; 
allpts = [fillpts];
allpts = sortrows(allpts,dir1);
flip = 0; 
storeset = [];
storesort = [];
% making sets of points with same x value 
for i = 1:size(allpts,1)-1
    if allpts(i,dir1)==allpts(i+1,dir1)
        storeset = [storeset;allpts(i,:)];
    else
        storeset = [storeset;allpts(i,:)];
        storeset = sortrows(storeset,dir2);
        if (flip/2) == round(flip/2)        %means even
            storeset = flipud(storeset);
        end
        flip = flip+1;
        storesort = [storesort;storeset];
        storeset = [];
    end
end
storeset = [storeset;allpts(size(allpts,1),:)];
storeset = sortrows(storeset,dir2);
% this is to get the direction of last line travel
if storesort(size(storesort,1),dir2)==storeset(1,dir2)
storesort = [storesort;storeset];
else
storeset = flipud(storeset);
storesort = [storesort;storeset];
end        
storesort1y0 = storesort;
% plotting hatch
figure('Name','Hatching along y-axis');  
scatter3(storesort1y0(:,1),storesort1y0(:,2),storesort1y0(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
figure;
plot3(storesort1y0(:,1),storesort1y0(:,2),storesort1y0(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
Rx = -atan(storesort1y0(:,5)./storesort1y0(:,6))*180/pi;% Rx value for tcp
Ry = atan(storesort1y0(:,4)./storesort1y0(:,6))*180/pi;% Ry value for tcp
storesort1y0 = [storesort1y0(:,1:3),Rx,Ry];

%% storing every n'th point to smoothen out the path 
count = 0;
store_spaced_pt = [storesort1y0(1,:)];
flagg = 0;
for i = 2:size(storesort1y0,1)-1
    if flagg == 1
        flagg = 0;
        continue;
    end
    if storesort1y0(i,1)==storesort1y0(i+1,1)
        count = count + 1;
        if count/space == round(count/space)
            store_spaced_pt = [store_spaced_pt;storesort1y0(i,:)];
            count = 0;
        end
    else
        store_spaced_pt = [store_spaced_pt;storesort1y0(i,:)];
        store_spaced_pt = [store_spaced_pt;storesort1y0(i+1,:)];
        flagg = 1;
    end
end
%adding last point
store_spaced_pt = [store_spaced_pt;storesort1y0(i+1,:)];

storesort1y0tp = store_spaced_pt;
figure;
scatter3(storesort1y0tp(:,1),storesort1y0tp(:,2),storesort1y0tp(:,3),'r','.')
xlabel('x');
ylabel('y');
zlabel('z');
hold on;
plot3(storesort1y0tp(:,1),storesort1y0tp(:,2),storesort1y0tp(:,3))
xlabel('x');
ylabel('y');
zlabel('z');

%% flip the direction of travel 
if FlipTravel==1
    storesort1y0tp = flipud(storesort1y0tp);
end
end
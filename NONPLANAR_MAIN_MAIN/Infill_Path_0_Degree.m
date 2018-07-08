function [storesort0x1tp] = Infill_Path_0_Degree(fillpts,FlipTravel,space)
% function for creating path from projected points for tcp travel 
% along x direction
% INPUT: projected points on the surface (equally spaced along x and y axes)
% OUTPUT: points arranged along 0 degree path with their Rx and Ry value

dir1 = 2;
dir2 = 1; 
allpts = [fillpts];
allpts = sortrows(allpts,dir1);
flip = 0; 
storeset = [];
storesort = [];
% making sets of points with same y value 
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
storesort0x1 = storesort;
% plotting hatch
figure('Name','Hatching along x-axis');  
scatter3(storesort0x1(:,1),storesort0x1(:,2),storesort0x1(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
figure;
plot3(storesort0x1(:,1),storesort0x1(:,2),storesort0x1(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
Rx = -atan(storesort0x1(:,5)./storesort0x1(:,6))*180/pi;% Rx value for tcp
Ry = atan(storesort0x1(:,4)./storesort0x1(:,6))*180/pi;% Ry value for tcp
storesort0x1 = [storesort0x1(:,1:3),Rx,Ry];

%% storing every n'th point to smoothen out the path 
count = 0;
store_spaced_pt = [storesort0x1(1,:)];
flagg = 0;
for i = 2:size(storesort0x1,1)-1
    if flagg == 1
        flagg = 0;
        continue;
    end
    if storesort0x1(i,2)==storesort0x1(i+1,2)
        count = count + 1;
        if count/space == round(count/space)
            store_spaced_pt = [store_spaced_pt;storesort0x1(i,:)];
            count = 0;
        end
    else
        store_spaced_pt = [store_spaced_pt;storesort0x1(i,:)];
        store_spaced_pt = [store_spaced_pt;storesort0x1(i+1,:)];
        flagg = 1;
    end
end
%adding last point
store_spaced_pt = [store_spaced_pt;storesort0x1(i+1,:)];

storesort0x1tp = store_spaced_pt;
figure;
scatter3(storesort0x1tp(:,1),storesort0x1tp(:,2),storesort0x1tp(:,3),'r','.')
xlabel('x');
ylabel('y');
zlabel('z');
hold on;
plot3(storesort0x1tp(:,1),storesort0x1tp(:,2),storesort0x1tp(:,3))
xlabel('x');
ylabel('y');
zlabel('z');

%% flip the direction of travel 
if FlipTravel==1
    storesort0x1tp = flipud(storesort0x1tp);
end
end
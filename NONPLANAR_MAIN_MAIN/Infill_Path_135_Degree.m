function [storesorts1tp] = Infill_Path_135_Degree(fillpts,pathgap,FlipTravel,space)
% function for creating path from projected points for tcp travel 
% along 135 degree slope to x-axis
% INPUT: projected points on the surface (equally spaced along x and y axes)
% OUTPUT: points arranged along 135 degree path with their Rx and Ry value

allpts = [fillpts];
allpts = sortrows(allpts,1);
% making sets of points with same x+y value
allptsside = [allpts,allpts(:,1)+allpts(:,2)];
n = 0;
storeset = [];
flip = 0;
while n <= max(allptsside(:,size(allptsside,2)))   
    store = [];
    for i = 1:size(allptsside,1)
    if allptsside(i,size(allptsside,2))==n
        store = [store;allpts(i,:)];
    end
    end
    if flip/2==round(flip/2)      %means even
        storeset = [storeset;store];
    else
        store = flipud(store); 
        storeset = [storeset;store];
    end
    flip = flip+1;
    n = n+pathgap;
end
storesorts1 = storeset;
% plotting hatch
figure('Name','Hatching along y = -x');
scatter3(storesorts1(:,1),storesorts1(:,2),storesorts1(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
figure;
plot3(storesorts1(:,1),storesorts1(:,2),storesorts1(:,3))
xlabel('x');
ylabel('y');
zlabel('z');

Rx = -atan(storesorts1(:,5)./storesorts1(:,6))*180/pi;% Rx value for tcp
Ry = atan(storesorts1(:,4)./storesorts1(:,6))*180/pi;% Ry value for tcp
storesorts1 = [storesorts1(:,1:3),Rx,Ry];

%% storing every n'th point to smoothen out the path 
count = 0;
store_spaced_pt = [storesorts1(1,:)];
flagg = 0;
for i = 2:size(storesorts1,1)-1
    if flagg == 1
        flagg = 0;
        continue;
    end
    if storesorts1(i,1)+storesorts1(i,2)==storesorts1(i+1,1)+storesorts1(i+1,2)
        count = count + 1;
        if count/space == round(count/space)
            store_spaced_pt = [store_spaced_pt;storesorts1(i,:)];
            count = 0;
        end
    else
        store_spaced_pt = [store_spaced_pt;storesorts1(i,:)];
        store_spaced_pt = [store_spaced_pt;storesorts1(i+1,:)];
        flagg = 1;
    end
end
%adding last point
store_spaced_pt = [store_spaced_pt;storesorts1(i+1,:)];

storesorts1tp = store_spaced_pt;
figure;
scatter3(storesorts1tp(:,1),storesorts1tp(:,2),storesorts1tp(:,3),'r','.')
xlabel('x');
ylabel('y');
zlabel('z');
hold on;
plot3(storesorts1tp(:,1),storesorts1tp(:,2),storesorts1tp(:,3))
xlabel('x');
ylabel('y');
zlabel('z');


%% flip the direction of travel 
if FlipTravel==1
    storesorts1tp = flipud(storesorts1tp);
end

end
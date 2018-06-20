clc;
clear;
close all;
warning off;
%% bottom layer generation

% using the stlread function from Mathworks File Exchange to get the
% vertices v, faces f and normals n from stl file

[v, f, n, c, stltitle] = stlread('Main_Component_15mm.stl');
% [v, f, n, c, stltitle] = stlread('test1.stl');


%% finding the shell thickness
zdstore = [];
for i=1:size(v,1)
   for j=i+1:size(v,1)
        if v(i,1)==v(j,1)&&v(i,2)==v(j,2)
            zd = abs(v(j,3)-v(i,3));
            zdstore = [zdstore;zd];
   end
   end
end
zdstore = max(zdstore);
zdstore = round(zdstore);

%% xmax and ymax to get the grid size

xmax = max(v(:,1));
ymax = max(v(:,2));

%how much fineness of layer is required depends on 'pathgap' and how much
%gap between 2 layers depends on 'pathgapz'
pathgap = 0.5;
pathgapz = 1;

%% identifying the co-ordinates of bottom layer first
indexv = [1:size(v,1)]';        %indexing v
indexn = [1:size(n,1)]';        %indexing n...same as indexing f
nnew = [n,f,indexn];        
vnew = [v,indexv];
store = [];
% storing index of only those normals whose z direction is negative, 
% i.e normal pointing downwards... i.e normals from bottom layer 
for i = 1:size(nnew,1)
    if nnew(i,3)<0
        store =[store;nnew(i,:)];
    end
end
store;
% using index of those normals to get the faces and hence the points
% associated with those faces.
fnew = [store(:,4),store(:,5),store(:,6)];
fnew1 = [fnew(:,1);fnew(:,2);fnew(:,3)];
vnew1 = unique(fnew1);            % removing the repeating points
storenew =[];
% getting unique bottom points and their co-ordinates
for i = 1:size(vnew1,1)
    for j =1:size(vnew,1)
        if vnew(j,4)==vnew1(i,1)
            storenew = [storenew;vnew(j,:)];
        end
    end
end
storenew;
basepts = [storenew(:,1),storenew(:,2),storenew(:,3)];
basepts = unique(basepts,'rows');          % removing the repeating co-ordinates
scatter3(basepts(:,1),basepts(:,2),basepts(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
x = basepts(:,1);
y = basepts(:,2);
z = basepts(:,3);


%%%%%%%%%%%%% grid pts in triangle %%%%%%%%%%%

pts = [];
for i = 0:pathgap:ceil(xmax)
    j = [0:pathgap:ceil(ymax)]';
    pts= [pts;[[i*ones(size(j,1),1)],j]];
end

 
fillpts = [];
for j = 1:size(fnew,1)
store = [];
p1 = v(fnew(j,1),:);
p2 = v(fnew(j,2),:);
p3 = v(fnew(j,3),:);

tri = [p1;p2;p3;p1];

% plot3(tri(:,1),tri(:,2),tri(:,3))
% hold on;
% scatter(pts(:,1),pts(:,2),'.')

in = inpolygon(pts(:,1),pts(:,2),tri(:,1),tri(:,2));
loc = find(in);
store = [[pts(loc,1),pts(loc,2)]];

if isempty(store)

else
%creating plane
a = ((p2(2)-p1(2))*(p3(3)-p1(3)))-((p3(2)-p1(2))*(p2(3)-p1(3)));
b = ((p2(3)-p1(3))*(p3(1)-p1(1)))-((p3(3)-p1(3))*(p2(1)-p1(1)));
c = ((p2(1)-p1(1))*(p3(2)-p1(2)))-((p3(1)-p1(1))*(p2(2)-p1(2)));
d = -(a*p1(1))-(b*p1(2))-(c*p1(3));
storez = [];
for i = 1:size(store,1)
zval = ((-d-(a*store(i,1))-(b*store(i,2)))/c)-0.08;
if zval<0
storez = [storez;0];
else
storez = [storez;zval];   
end

end
store = [store,storez];
% hold on;
% scatter3(store(:,1),store(:,2),store(:,3),'b','.');
% hold on;
end
fillpts = [fillpts;store];

end


%%%%%%%%%%%%%%%% travelling along the x path from 0 %%%%%%%%%%%%%%%%%%%%


dir1 = 1;
dir2 = 2;
    
allpts = [fillpts];
allpts = sortrows(allpts,dir1);
flip = 0; 

storeset = [];
storesort = [];
for i = 1:size(allpts,1)-1
    if allpts(i,dir1)==allpts(i+1,dir1)
        storeset = [storeset;allpts(i,:)];
    else
        storeset = [storeset;allpts(i,:)];
        storeset = sortrows(storeset,dir2);
        
%         storeset = flipud(storeset);
        
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

figure;
scatter3(storesort1y0(:,1),storesort1y0(:,2),storesort1y0(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
figure;
plot3(storesort1y0(:,1),storesort1y0(:,2),storesort1y0(:,3))
xlabel('x');
ylabel('y');
zlabel('z');

vecstore = [];
for i = 1:size(storesort1y0,1)-1
    if storesort1y0(i,dir1)==storesort1y0(i+1,dir1)
        vec = storesort1y0(i+1,:)-storesort1y0(i,:);
        uvec = vec/sqrt((vec(1)^2)+(vec(2)^2)+(vec(3)^2));
        vecstore = [vecstore;uvec];
    else
        if isempty(vecstore)==1
            vecstore = [vecstore;[1 1 0]];
        else
        vecstore = [vecstore;vecstore(size(vecstore,1),:)];
        end
    end
end
vecstore = [vecstore;vecstore(size(vecstore,1),:)];
vecstore;

theta = atan(vecstore(:,3)./vecstore(:,2));
theta = theta*180/pi;
theta = theta/1.5;
storesort1y0 = [storesort1y0,theta,zeros(size(storesort1y0,1),1)];

storesort1y0tp = storesort1y0(1:4:size(storesort1y0,1),:);

%% creating RAPID file
% pathptsnew=flipud(storesort0x1);
pathptsnew=flipud(storesort1y0tp);
toolpath = fopen('aniruddha.txt','wt');


% fprintf(toolpath,'MODULE MainModule\n');


a = '\R';
b = '\W';
c = '\O';


% make sure you take it from the top 


for i=1:size(pathptsnew,1)
px = pathptsnew(i,1); 
py = pathptsnew(i,2); 
pz = pathptsnew(i,3)+0.58;
% rx = 0;
% ry = pathptsnew(i,5)/2; 
rx = pathptsnew(i,4)/2;
ry = pathptsnew(i,5)/2; 


fprintf(toolpath,'MoveL RelTool (p1,%f,%f,%f,%sx:=%f,%sy:=%f),vel1,zoneval,Extruder%sObj:=Workobject_1;\n',px,py,pz,a,rx,a,ry,b);
end



% fprintf(toolpath,'ENDMODULE\n');

fclose(toolpath);

fprintf('done!\n');
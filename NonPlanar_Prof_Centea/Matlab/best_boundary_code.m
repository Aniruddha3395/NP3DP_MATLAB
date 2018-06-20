clc;
clear;
close all;
warning off;

%% bottom layer generation

% using the stlread function from Mathworks File Exchange to get the
% vertices v, faces f and normals n from stl file

% [v, f, n, c, stltitle] = stlread('Test_Component_Base_Shape.stl');
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
pathgap = 1;
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
    if nnew(i,3)<-0.0112
        store =[store;nnew(i,:)];
    end
end
store;
% using index of those normals to get the faces and hence the points
% associated with those faces.


figure;

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
scatter3(basepts(:,1),basepts(:,2),basepts(:,3),'.')
xlabel('x');
ylabel('y');
zlabel('z');
x = basepts(:,1);
y = basepts(:,2);
z = basepts(:,3);

ind = [1:size(basepts,1)]';
basepts = [basepts,ind];

hold on;
a = boundary(x,y,0.8);

plot3(x(a),y(a),z(a),'r');

bdry = [x(a),y(a),z(a)];



vecstore = [];
n = 0;
for i = 1:size(bdry,1)-1
        vec = bdry(i+1,:)-bdry(i,:);
        uvec = vec/sqrt((vec(1)^2)+(vec(2)^2)+(vec(3)^2));
        vecstore = [vecstore;uvec];
end
vecstore = [vecstore;vecstore(1,:)];
vecstore;

thetax = atan(vecstore(:,3)./vecstore(:,2));
thetax = thetax*180/pi;
thetax = thetax*1.5/4;


thetay = atan(vecstore(:,3)./vecstore(:,1));
thetay = thetay*180/pi;
thetay = -thetay/2;


bdry = [bdry,thetax,thetay];

for i = 2:size(bdry)
    if bdry(i,4)<1 && bdry(i,4)>-1
        bdry(i,4)=bdry(i-1,4);
    end
    if bdry(i,5)<1 && bdry(i,5)>-1
        bdry(i,5)=bdry(i-1,5);
    end
    if abs(bdry(i,4)-bdry(i-1,4))>10
        bdry(i,4)=bdry(i-1,4);
    end
    if abs(bdry(i,5)-bdry(i-1,5))>10
        bdry(i,5)=bdry(i-1,5);
    end
end


a = [vecstore,thetax,thetay];


%% creating RAPID file
pathptsnew=bdry;
toolpath = fopen('aniruddha.txt','wt');


a = '\R';
b = '\W';
c = '\O';




for i=1:size(pathptsnew,1)
px = pathptsnew(i,1); 
py = pathptsnew(i,2); 
pz = pathptsnew(i,3)+0.5;
% rx=pathptsnew(i,4);
% ry=pathptsnew(i,5);
rx = 0;
ry = 0;
fprintf(toolpath,'MoveL RelTool (p1,%f,%f,%f,%sx:=%f,%sy:=%f),vel1,z0,Extruder%sObj:=Workobject_1;\n',px,py,pz,a,rx,a,ry,b);
end


fclose(toolpath);



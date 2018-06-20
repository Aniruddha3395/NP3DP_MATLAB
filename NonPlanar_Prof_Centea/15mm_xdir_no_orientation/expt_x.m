clc;
clear;
close all;
warning off;
%% bottom layer generation

% using the stlread function from Mathworks File Exchange to get the
% vertices v, faces f and normals n from stl file

% [v, f, n, c, stltitle] = stlread('Test_Component_Base_Shape.stl');
% [v, f, n, c, stltitle] = stlread('Main_Component_15mm.stl');
% [v, f, n, c, stltitle] = stlread('test1.stl');
[v, f, n, c, stltitle] = stlread('L8.stl');

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


scatter3(fillpts(:,1),fillpts(:,2),fillpts(:,3));

% removing pts which are included in boundary
x = fillpts(:,1);
y = fillpts(:,2);
z = fillpts(:,3);
ind = [1:size(fillpts,1)]';
% figure;
a = boundary(x,y,0.8);
% plot3(x(a),y(a),z(a),'r');
bdry_val = [x(a),y(a),z(a)];

fillpts = setdiff(fillpts,bdry_val,'rows');

% fillpts = [fillpts(storeunique,1),fillpts(storeunique,2),fillpts(storeunique,3)];
% hold on;
% scatter3(fillpts(:,1),fillpts(:,2),fillpts(:,3));




%%%%%%%%%%%%%%%% travelling along the x path from 0 %%%%%%%%%%%%%%%%%%%%


dir1 = 2;
dir2 = 1;
    
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
        
        storeset = flipud(storeset);
        
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
% storept = [];
% storept = [];
% for i = 1:size(storesort0x1,1)-1
%     if abs(storesort0x1(i,1)-storesort0x1(i+1,1))>=10
%         storept = [storept;storesort0x1(i,:)];
%         upp = storesort0x1(i,:);
%         upp(1,3) = upp(1,3)+10;
%         downn =  storesort0x1(i+1,:);
%         downn(1,3) = downn(1,3)+10;
%         storept = [storept;upp;downn];
%     else
%         storept = [storept;storesort0x1(i,:)];
%         
%     end
% end
% storept = [storept;storesort0x1(size(storesort0x1,1),:)]


figure;
scatter3(storesort0x1(:,1),storesort0x1(:,2),storesort0x1(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
figure;
plot3(storesort0x1(:,1),storesort0x1(:,2),storesort0x1(:,3))
xlabel('x');
ylabel('y');
zlabel('z');
% hold on;
% scatter3(storept(:,1),storept(:,2),storept(:,3));




vecstore = [];
for i = 1:size(storesort0x1,1)-1
    if storesort0x1(i,dir1)==storesort0x1(i+1,dir1)
        vec = storesort0x1(i+1,:)-storesort0x1(i,:);
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

storex = [];
storexmain = [];
for i = 1:size(storesort0x1,1)-1
    if storesort0x1(i,dir1)==storesort0x1(i+1,dir1)
        storex = [storex;storesort0x1(i,:)];
    else
        storex = [storex;storesort0x1(i,:)];
        zc = storesort0x1(i+1,3)-storesort0x1(i,3);
        storexmain = [storexmain;zc*ones(size(storex,1),1)];
        storex = [];
    end
end
storexmain = [storexmain;zc*ones(size(storex,1)+1,1)];
vecstore(:,2) = storexmain;

thetay = atan(vecstore(:,3)./vecstore(:,1));
thetay = thetay*180/pi;
thetay = -thetay/1.5;
thetax = atan(vecstore(:,2));
thetax = thetax*180/pi;
thetax = thetax;

storesort0x1 = [storesort0x1,thetax,thetay];

storesort0x1tp = storesort0x1(1:1:size(storesort0x1,1),:);
hold on;
scatter3(storesort0x1tp(:,1),storesort0x1tp(:,2),storesort0x1tp(:,3));


%% creating RAPID file
% pathptsnew=flipud(storesort0x1);
pathptsnew=flipud(storesort0x1tp);
pathptsnew=flipud(pathptsnew);
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
rx = 0;
% ry = pathptsnew(i,5)/2; 
% rx = pathptsnew(i,4)/2;
ry = 0; % pathptsnew(i,5)/3; 


fprintf(toolpath,'MoveL RelTool (p1,%f,%f,%f,%sx:=%f,%sy:=%f),vel1,zoneval,Extruder%sObj:=Workobject_1;\n',px,py,pz,a,rx,a,ry,b);
end



% fprintf(toolpath,'ENDMODULE\n');

fclose(toolpath);

fprintf('done!\n');
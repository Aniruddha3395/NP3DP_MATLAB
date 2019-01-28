% function to find the number of layers form the shell CAD model (stl file)
%INPUT : vertices, faces, normals and layer thickness
%OUTPUT : number of layers  

function num_of_layers = number_of_layers(v,f,n,pathgap_z)  
n = round(n,2);
n_new = [n,[1:size(n,1)]'];
np = [];nn = [];
%sorting normals for top and bottom face
for i=1:size(n,1)
    if n(i,3)<0     %bottom surface
        nn = [nn;n_new(i,:)];
    elseif n(i,3)>0     %top surface
        np = [np;n_new(i,:)];
    end
end
% getting normals which are opposite ot each other and forming pairs of
% parallel faces 
t = [];
for i = 1:size(nn,1)
    idx = ismember(np(:,1:3),-nn(i,1:3),'rows');
    store_idx = find(idx==1,1);
    if isempty(store_idx)==0
% calculating the gap between parallel faces by plane to plane distance formaula
        pair = [np(store_idx,4),nn(i,4)];
        p11 = v(f(pair(1),1),:);
        p12 = v(f(pair(1),2),:);
        p13 = v(f(pair(1),3),:);
        p21 = v(f(pair(2),1),:);
        a = ((p12(2)-p11(2))*(p13(3)-p11(3)))-((p13(2)-p11(2))*(p12(3)-p11(3)));
        b = ((p12(3)-p11(3))*(p13(1)-p11(1)))-((p13(3)-p11(3))*(p12(1)-p11(1)));
        c = ((p12(1)-p11(1))*(p13(2)-p11(2)))-((p13(1)-p11(1))*(p12(2)-p11(2)));
        d = -(a*p11(1))-(b*p11(2))-(c*p11(3));
        t = [t;abs(a*p21(1)+b*p21(2)+c*p21(3)+d)/sqrt(a^2+b^2+c^2)];
    end
end
t_f = median(t);
num_of_layers = round(t_f/pathgap_z);
if num_of_layers ==0
    num_of_layers =1;
end
end
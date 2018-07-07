function [fillpts] = Project_Grid_Points(fnew,v,pts)

% this function projects the uniform grid on the curved surface and also
% preserves the normal associated with each vertex. These normals are useful
% in creating the Euler angle for tcp. 
% INPUT = bottom surface vertcies (k-by-3 matrix) and grid points (m-by-2 matrix) 
% OUTPUT = j-by-6 matrix of points wihc are projected on the bottom surface of the STL file. 


fillpts = [];
for j = 1:size(fnew,1)
store = [];
% vertcies for each triangle
p1 = v(fnew(j,1),:);
p2 = v(fnew(j,2),:);
p3 = v(fnew(j,3),:);

tri = [p1;p2;p3;p1];                    % forming the face with vertices

in = inpolygon(pts(:,1),pts(:,2),tri(:,1),tri(:,2));    %projecting triagles 
% on to the xy plane and storing all grid points which are inside triangle 
loc = find(in);
store = [[pts(loc,1),pts(loc,2)]];

if isempty(store)

else
%creating plane eqaution to get z value of stored points
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
store = [store,storez,(a/sqrt(a^2+b^2+c^2))*ones(size(storez,1),1),b/sqrt(a^2+b^2+c^2)*ones(size(storez,1),1),c/sqrt(a^2+b^2+c^2)*ones(size(storez,1),1)];
% along with points, storing unit normal associated with each point from
% which, tcp orientation is calculated.
end
fillpts = [fillpts;store];

end

figure('Name','Surface with normals');
scatter3(fillpts(:,1),fillpts(:,2),fillpts(:,3),'.');
hold on;
quiver3(fillpts(:,1),fillpts(:,2),fillpts(:,3),-fillpts(:,4),-fillpts(:,5),-fillpts(:,6))
fillpts = [fillpts(:,1),fillpts(:,2),fillpts(:,3),-fillpts(:,4),-fillpts(:,5),-fillpts(:,6)];

end
function [Transformation] = Get_Transformation_Matrix(WorkObject_Points,RobotBase_Points)

% WorkObject_Points: co-ordinates with respect to new/desired frame
% RobotBase_Points: points with respect to world/robot base frame

%input: WorkObject_Points = [x1, y1, z1;
%                            x2, y2, z2;
%                               :
%                               :
%                            xn, yn, zn]

%input: RobotBase_Points = [x1, y1, z1;
%                           x2, y2, z2;
%                               :
%                               :
%                           xn, yn, zn]


centroid_WorkObject_Points = mean(WorkObject_Points);
centroid_RobotBase_Points = mean(RobotBase_Points);
WorkObject_Points = WorkObject_Points - centroid_WorkObject_Points;
RobotBase_Points = RobotBase_Points - centroid_RobotBase_Points;

CrossCovariance_Mat = WorkObject_Points'*RobotBase_Points;
[U,S,V] = svd(CrossCovariance_Mat);         % singular value decomposition
R = V*[1 0 0;0 1 0;0 0 det(V*U')]*U'       % to take care of reflection case due to negative eigen vectors

if det(R)>0
    T = -R*centroid_WorkObject_Points' + centroid_RobotBase_Points';
    Transformation = [[R,T];0 0 0 1];
else
    fprintf('Determinant of rotation matrix is negative...')
end







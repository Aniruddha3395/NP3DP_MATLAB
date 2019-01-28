function [z_max] = Find_Thickness(v)
% This is the function for finding the shell thickness when the thickness
% is uniform

% INPUT = vertices in n-by-3 matrix 
% OUTPUT = thickness of the shell
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
z_max = round(zdstore);

end
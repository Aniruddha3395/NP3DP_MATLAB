function storesort0x1 = align_pts(fillpts)

dir1 = 2;
dir2 = 1;
allpts = fillpts;
allpts = sortrows(allpts,dir1);
flip = 0;
storeset = [];

storesort = [];
% making sets of points with same y value
for i = 1:size(allpts,1)-1
    if abs(allpts(i,dir1)-allpts(i+1,dir1))<0.00001
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
if (flip/2) == round(flip/2)        %means even
    storeset = flipud(storeset);
end
storesort = [storesort;storeset];
storesort0x1 = storesort;

end
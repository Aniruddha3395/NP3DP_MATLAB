function storesort0x1tp = skip_toolpath_lines(storesort0x1tp,skip_lines)

% skipping lines 
dir1 = 2;
dir2 = 1;
flip = 0;
storeset = [];
storesort = [];
storesort_mid_pts = [];
skip_lines_counter = 0;

for i = 1:size(storesort0x1tp,1)-1
    if abs(storesort0x1tp(i,dir1)-storesort0x1tp(i+1,dir1))<0.00001
        storeset = [storeset;storesort0x1tp(i,:)];
    else
        storeset = [storeset;storesort0x1tp(i,:)];
        storeset = sortrows(storeset,dir2);
        if skip_lines~=0
            if isempty(storesort)~=1
                if skip_lines_counter<skip_lines
                    skip_lines_counter = skip_lines_counter+1;
                    if (flip/2) == round(flip/2)
                            storesort_mid_pts = [storesort_mid_pts;storeset(end,:)];
                    else
                        storesort_mid_pts = [storesort_mid_pts;storeset(1,:)];
                    end
                    storeset = [];
                    continue;
                else
                    skip_lines_counter = 0;
                end
            end
        end
        if (flip/2) == round(flip/2)        %means even
            storeset = flipud(storeset);
        end
        flip = flip+1;
        storesort = [storesort;storesort_mid_pts];
        storesort = [storesort;storeset];
        storesort_mid_pts = [];
        storeset = [];
    end
end
if skip_lines_counter>=skip_lines
    storesort = [storesort;storesort_mid_pts];
    storeset = [storeset;storesort0x1tp(end,:)];
    storeset = sortrows(storeset,dir2);
    % this is to get the direction of last line travel
    if (flip/2) == round(flip/2)        %means even
        storeset = flipud(storeset);
    end
    storesort = [storesort;storeset];
end
storesort0x1tp = storesort;

end

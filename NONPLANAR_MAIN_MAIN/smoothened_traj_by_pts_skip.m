function storesort0x1tp = smoothened_traj_by_pts_skip(storesort0x1,space)
% storing every n'th point to smoothen out the path

count = 0;
store_spaced_pt = [storesort0x1(1,:)];
flagg = 0;
for i = 2:size(storesort0x1,1)-1
    if flagg == 1
        flagg = 0;
        continue;
    end
    if abs(storesort0x1(i,2)-storesort0x1(i+1,2))<0.00001
        count = count + 1;
        if count/space == round(count/space)
            store_spaced_pt = [store_spaced_pt;storesort0x1(i,:)];
            count = 0;
        end
    else
        store_spaced_pt = [store_spaced_pt;storesort0x1(i,:)];
        store_spaced_pt = [store_spaced_pt;storesort0x1(i+1,:)];
        flagg = 1;
    end
end
%adding last point
store_spaced_pt = [store_spaced_pt;storesort0x1(i+1,:)];
storesort0x1tp = store_spaced_pt;


end
clc;
clear;
close all;

% code for finding values of array which are not found in the other array 


fillpts = [1:10]';
a = [1:5]';
store = [];
for i = 1:100
        flag = 0;
    for j = 1:50
        if i==j
            flag =1;
            break;
        end
    end
    if flag==1
        continue;
    else
        store = [store;i];
    end

    
end
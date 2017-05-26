function [csize,L,n,num] = wjn_max_cluster(c)
    [L,num]=bwlabeln(c>0,26);
    
    for a = 1:num
        cs(a) = numel(find(L==a));
    end
    try
        [csize,n]=max(cs);
    catch
        csize = 0;
        n = 0;
    end
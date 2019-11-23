function nT = wjn_table_collapse(T,foi,field)

u = unique(T.(field));
for a = 1:length(u)
    nT(a,1) = nanmean(T.(foi)(T.(field)==u(a)),1);
end
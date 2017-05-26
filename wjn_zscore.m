function z=wjn_zscore(d)

if size(d,1)>1 && size(d,2)>1
m = nanmean(nanmean(d));
s = nanmean(nanstd(d));
else
    m=nanmean(d);
    s = nanstd(d);
end
z = (d - m)./s;

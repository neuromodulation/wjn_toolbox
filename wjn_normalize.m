function ndata = wjn_normalize(data)

for a = 1:size(data,2)
    ndata(:,a) = data(:,a)./nanmax(data(:,a));
    ndata(:,a) = ndata(:,a)-nanmean(ndata(:,a));
end
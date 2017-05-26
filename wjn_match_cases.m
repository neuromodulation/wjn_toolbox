function [ndata,i] = wjn_match_cases(data,cases)

data(cases==0) = [];
cases(cases==0) =[];

[scases,icases] = sort(cases);
sdata = data(icases);
ndata = nan(1,max(scases));
for a = 1:max(scases)
    ndata(a) = nanmean(sdata(scases == a));
    i(a) = a;
end
    
i(isnan(ndata))=[];
ndata(isnan(ndata))=[];
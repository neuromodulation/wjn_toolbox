function tbl = wjn_ecog_feature_table(D,chanstring,fr,fbands)

if ~exist('chanstring','var')
    chanstring = {'Strip','ecog'};
end
i = ci(chanstring,D.chanlabels);
tbl = [];

if ~exist('fr','var')
    fr = [3 6; 7 13; 13 20; 20 30;45 95; 100 185];
    fbands = {'theta','alpha','lowbeta','highbeta','lowgamma','highgamma'};
end
n=0;
for b = 1:length(fbands)
    
for a = 1:length(i)
        n=n+1;
        data = squeeze(nanmean(D(i(a),fr(b,1):fr(b,end),:,1),2));
        d.([D.chanlabels{i(a)} '_' fbands{b}]) = wjn_zscore(data);
   
    
end
end
    
tbl = struct2table(d);
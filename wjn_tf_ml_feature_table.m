function tbl = wjn_tf_ml_feature_table(D,chanstring,fr,fbands)

if ~exist('chanstring','var')
    chanstring = {'Strip','ecog'};
end
i = ci(chanstring,D.chanlabels);
tbl = [];

if ~exist('fr','var')
    fr = [3 6; 7 13; 13 20; 20 30;60 90];
    fbands = {'theta','alpha','low_beta','high_beta','gamma'};
end
n=0;
for a = 1:length(i)
    for b = 1:length(fbands)
        n=n+1;
        d.([D.chanlabels{i(a)} '_' fbands{b}]) = squeeze(nanmean(D(i(a),fr(b,1):fr(b,end),:,1),2));
   
    end
end
    
tbl = struct2table(d);
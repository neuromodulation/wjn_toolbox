function tbl = wjn_nn_feature_table(D,chanstring,isamples,fr,fbands)

if ~exist('chanstring','var') || isempty(chanstring)
    chanstring = {'Strip','ecog','STN','raw','CLFP','CMacro'};
end
if ~isnumeric(chanstring)
    i = ci(chanstring,D.chanlabels);
else
    i = chanstring;
end
tbl = [];

if ~exist('fr','var') || isempty(fr)
    fr = [1 D.nfrequencies;1 D.nfrequencies ;3 6; 7 13; 13 20; 20 30;45 95; 100 200];
    fbands = {'full' 'sfull' 'theta','alpha','lowbeta','highbeta','lowgamma','highgamma'};
end

if ~exist('isamples','var') || isempty(isamples)
    isamples = 1:D.nsamples;
end

n=0;
for b = 1:length(fbands)
    
for a = 1:length(i)+1
    if a <=length(i)
        
        n=n+1;
        if strcmp(fbands{b},'sfull')
            data = squeeze(nanstd(D(i(a),D.indfrequency(fr(b,1)):D.indfrequency(fr(b,end)),isamples,1),[],2));
        else
            data = squeeze(nansum(D(i(a),D.indfrequency(fr(b,1)):D.indfrequency(fr(b,end)),isamples,1),2));
        end
        zd = wjn_zscore(log(data));
        d.([strrep(D.chanlabels{i(a)},'_','') '_' fbands{b}]) = zd./max(zd);
                n=n+1;
        if strcmp(fbands{b},'sfull')
            data = squeeze(nanstd(D(i(a),D.indfrequency(fr(b,1)):D.indfrequency(fr(b,end)),isamples,1),[],2));
        else
            data = squeeze(nanmean(D(i(a),D.indfrequency(fr(b,1)):D.indfrequency(fr(b,end)),isamples,1),2));
        end
        zd = wjn_zscore(log(data));
        d.([strrep(D.chanlabels{i(a)},'_','') '_' fbands{b}]) = zd./max(zd);
   
    elseif a>2
                n=n+1;
        if strcmp(fbands{b},'sfull')
            data = squeeze(nanstd(nanmean(D(i,D.indfrequency(fr(b,1)):D.indfrequency(fr(b,end)),isamples,1)),[],2));
        else
            data = squeeze(nanmean(nanmean(D(i,D.indfrequency(fr(b,1)):D.indfrequency(fr(b,end)),isamples,1)),2));
        end
        zd = wjn_zscore(log(data));
        d.([strrep('avg','_','') '_' fbands{b}]) = zd./max(zd);
   
    end
   
    
end
end
%     keyboard
tbl = struct2table(d);
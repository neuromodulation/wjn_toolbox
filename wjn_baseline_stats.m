function [mp,mpc,mpmc,mfdr,md,t,f,d] = wjn_baseline_stats(fname,files,channels,baseline,conds,method,freq,timewindow,nshuffle)
%function [mp,mpc,mpmc,mfdr,md,t,f,d] = wjn_baseline_stats(fname,files,channels,baseline,conds,method,freq,timewindow,nshuffle)

if ~exist('threshold','var') && ~strcmp(method,'ttest')
    threshold = 0.95;
elseif ~exist('threshold','var') && strcmp(method,'ttest')
    threshold = abs(tinv(1-.05/2,numel(files)-1));
end


if ~exist('nshuffle','var')
    nshuffle = 0;
end

if ~exist('method','var')
    method = 'permutation';
end

switch method
    case 'permutation'
        mstring='wjn_pt(cs(:,1),cs(:,2),1000)';
    case 'ttest'
        mstring='ttestp(cs(:,1),cs(:,2))';
    case 'signrank'
        mstring='signrankp(cs(:,1),cs(:,2))';
end

D=spm_eeg_load(files{1});

if ~exist('freq','var')
    freq = [D.frequencies(1) D.frequencies(end)];
end

if ~exist('timewindow','var')
    timewindow = [D.time(1) D.time(end)];
end

if ~exist('channels','var')
   channels = D.chanlabels;
end

if exist('conds','var')
    for a = 1:length(conds)
        ics{a} = ci(conds{a},D.conditions);
    end
        c = length(ics);
else
    c = D.nconditions;
    for a = 1:D.nconditions
        ics{a} = a;
    end
end

for a  =1:length(files)
    D=spm_eeg_load(files{a});
    ifi = D.indfrequency(freq(1)):D.indfrequency(freq(2));
    iti = D.indsample(timewindow(1)):D.indsample(timewindow(2));
    ichsi = ci(channels,D.chanlabels); 
    for b = 1:length(ics)
        d(a,:,:,b) = squeeze(nanmean(nanmean(D(ichsi,ifi,iti,ics{b}),1),4));
    end
    if iscell(baseline) || ischar(baseline)
        dbs(a,:,:) = squeeze(nanmean(nanmean(D(ichsi,ifi,iti,ci(baseline,D.conditions)),1),4));
    end
        
end
    
f = D.frequencies(ifi);
t = D.time(iti);

if isnumeric(baseline)
    ibsi = sc(t,baseline(1)):sc(t,baseline(2));
end

ss=logical(randi(2,[size(d,1) nshuffle])-1);
p=nan([nshuffle+1 length(f) length(t) c]);
clear cs bs cbs crs
 for ifi=1:length(f)
     for ici = 1:c
         if isnumeric(baseline)
            bs = squeeze(nanmean(nanmean(d(:,ifi,ibsi,ici),3),4)); 
         end
                for iti = 1:length(t)
                    if ~isnumeric(baseline)
                        bs = squeeze(dbs(:,ifi,iti));
                    end
                    cs = [bs,squeeze(nanmean(d(:,ifi,iti,ici),4))];
                    
                    for ini = 1:nshuffle+1
                        if ini>1
                            cs(ss(:,ini-1),[1 2]) = cs(ss(:,ini-1),[2 1]);
                        end                      
                        [p(ini,ifi,iti,ici),np(ini,ifi,iti,ici)]=eval(mstring);
                    end
                end
     end
     disp(['F: ' num2str(f(ifi)) ' Hz ']);
 end


 np = abs(np);

 for ici = 1:size(p,4)
 
mp(ici,:,:) = p(1,:,:,ici);
mfdr(ici,:,:) = squeeze(p(1,:,:,ici)<=fdr_bh(squeeze(p(1,:,:,ici))));

if nshuffle
 cp = squeeze(np(:,:,:,ici));
 allclusters = [];
 for ini = 1:nshuffle+1
     [l,m]=bwlabel(squeeze(cp(ini,:,:))>=threshold);
     clusters = nan(1,m);
     for imi = 1:m
         allclusters = [allclusters nansum(cp(ini,l==imi))];
         clusters(imi) = sum(cp(ini,l==imi));
     end
     maxcluster(ini) = nanmax(clusters);
 end
     
allclusters = sort(allclusters);
maxcluster = sort(maxcluster);
[l,m]=bwlabel(squeeze(cp(1,:,:))>=threshold);
 

 for a =1:m
     oclusters(a) = nansum(cp(1,l==a));
     pclusters(a) = 1-(find(allclusters==oclusters(a),1,'last')/numel(allclusters));
     pmaxclusters(a) = 1-(sc(maxcluster,oclusters(a))/numel(maxcluster));
 end
 
 
 isig = find(pclusters<=.05);
 imsig = find(pmaxclusters<=.05);
 
 
pc = nan(size(l));
pmc = pc;
for a = 1:length(isig)
    pc(l==isig(a))=pclusters(isig(a));
end

for a = 1:length(imsig)
    pmc(l==imsig(a))=pmaxclusters(imsig(a));
end
mpc(ici,:,:)=pc;
mpmc(ici,:,:) = pmc;

end
end

if ~nshuffle
 mpc = nan(size(mp));
 mpmc = mpc;
end

mp = squeeze(mp);
mfdr = squeeze(mfdr);

mpc = squeeze(mpc);
mpmc=squeeze(mpmc);

if exist('dbs','var')
    d(:,:,:,end+1)=dbs;
end
md = squeeze(nanmean(d,1));

if ~exist('fname','var') || isempty(fname)
    fname = ['TF_baseline_stats_' strrep(strrep(datestr(datetime),':','-'),' ','_')];
end
% keyboard
save(fname,'files','mp','mpc','mpmc','mfdr','md','t','f','d')

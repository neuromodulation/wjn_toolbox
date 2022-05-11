function [D,BST,T]=wjn_recon_bursts(filename,freqband)
disp('RECONSTRUCT BURST FEATURES.')

D=spm_eeg_load(filename);


BST=[];
chs = 1:D.nchannels;
alltimes=[];
allconds=[];
T=table;
if isfield(D,'BST')
    D=rmfield(D,'BST');
end
iev = round(0.25*D.fsample);
for a = 1:D.nchannels
    tic
    data=D(a,:);

    good = data~=0;
    data(isnan(data))=0;

    if exist('freqband','var')
        data(good) = smooth(abs(hilbert(ft_preproc_bandpassfilter(data(good),D.fsample,freqband))),round(D.fsample*0.25));
    else
        data(good) = smooth(abs(hilbert(data(good)))',round(D.fsample*0.25));
    end
    data(round([1:D.fsample end-D.fsample+1:end]))=0;
    data = wjn_zscore(data);
    
    alldata(a,:)=data;
    d = mydiff(squeeze(data)>=prctile(data,75));d(round([1:D.fsample end-D.fsample+1:end]))=0;
    
    i = find(d==1);
    s = find(d==-1);
    % figure,plot(D.time,data),hold on,scatter(D.time(i),data(i))
    if isempty(i) || isempty(s)
        bdur = nan;
        n = 0;
        bamp = nan;
        btime = nan;
        return
    end
    if s(1)<i(1)
        s(1)=[];
    end
    
    i = i(1:length(s));
    n= numel(i);
    
    
    istart = i;
    istop = s;
    bdur = (s-i)./D.fsample*1000;
    if exist('minlength','var')
        irm=find(bdur<minlength);
        istart(irm)=[];
        istop(irm)=[];
        bdur(irm)=[];
    end
    
    n = numel(bdur);
    ibidur=[(i(2:end)-(s(1:end-1)-1)); nan];
    
    bamp=[];bmax=[];imaxtime=[];
    for b = 1:length(bdur)
        bamp(b,1) = sum(data(istart(b):istop(b)));
        if b>1
            ibiamp=nanmean(data(istop(b-1):istart(b)));
        end
        [bmax(b,1),itime] = max(data(istart(b):istop(b)));
        imaxtime(b,1) = istart(b)+itime-1;
    end
    
    
    disp(['CH=' num2str(a) '/' num2str(length(chs))])
    
    BST(a).i=imaxtime;
    BST(a).istart=istart;
    BST(a).istop=istop;
    BST(a).Tmax = 1000.*D.time(imaxtime)';
    BST(a).Tstart = 1000.*D.time(istart)';
    BST(a).Tstop = 1000.*D.time(istop)';
    BST(a).Tfull = bdur;
    BST(a).Tdecay = BST(a).Tstop-BST(a).Tmax;
    BST(a).Trise = BST(a).Tmax-BST(a).Tstart;
    BST(a).Tasymmetry = BST(a).Trise./ BST(a).Tfull;
    
    BST(a).Bmax = bmax;
    BST(a).Bsum = bamp;
    
    BST(a).Imean=ibidur;
    BST(a).Channel = repmat(D.chanlabels(chs(a)),size(i));
    BST(a).cond = repmat({['BST_' D.chanlabels{chs(a)}]},size(i));
    toc
end
D.BST.bursts=BST;
for a = 1:D.nchannels
    D.BST.results.N(a,:) = numel(D.BST.bursts(a).i);
    D.BST.results.Nr(a,:) = D.BST.results.N(a,:)./max(D.time);
    D.BST.results.Tfull(a,:) = [nanmean(D.BST.bursts(a).Tfull)];
    D.BST.results.Tdecay(a,:) = [nanmean(D.BST.bursts(a).Tdecay)];
    D.BST.results.Trise(a,:) = [nanmean(D.BST.bursts(a).Trise)];
    D.BST.results.Bmax(a,:) = nanmean(D.BST.bursts(a).Bmax);
    D.BST.results.Bsum(a,:) = nanmean(D.BST.bursts(a).Bsum);
    D.BST.results.Imean(a,:) = [nanmean(D.BST.bursts(a).Imean)];
    D.BST.results.Tasymmetry(a,:) =nanmean(D.BST.bursts(a).Tasymmetry);
    D.BST.results.Ifanofactor(a,:)=[nanstd(D.BST.bursts(a).Imean.^2)/nanmean(D.BST.bursts(a).Imean)];
    D.BST.results.Icov(a,:)=[nanstd(D.BST.bursts.Imean)/nanmean(D.BST.bursts(a).Imean)];
    
    alltimes=[alltimes;D.time(D.BST.bursts(a).i)'];
    allconds = [allconds;D.BST.bursts(a).cond];
    T=[T;struct2table(D.BST.bursts(a))];
end

D.BST.alltimes=alltimes;
D.BST.allconds = allconds;

T=T(:,[end-1 7:end-2]);

trl = D.indsample(alltimes);
conds = allconds;
uconds = unique(allconds);
seg = [-iev:iev];
nseg = seg(end:-1:1);
tBST = linspace(-250,250,length(seg));
d=alldata;
ppwavg=ones(D.nchannels,length(seg),length(uconds));
BSTavg=ppwavg;
pprwavg=ppwavg;
ttwavg=ppwavg;
ttrwavg=ttwavg;
tic

for a = 1:length(uconds)
    ic=ci(uconds{a},conds,1);
    it=trl(ic);
    
    
    for b = 1:length(seg)
        
        BSTavg(:,b,a)=nanmean(d(:,it+seg(b)),2);
        ishuffle=randi(D.nsamples,size(it));
        [~,ppwavg(:,b,a),~,statss]=ttest(d(:,it+seg(b))',d(:,ishuffle)');
        [~,pprwavg(:,b,a),~,statsn]=ttest(d(:,it+seg(b))',d(:,it+nseg(b))');
        ttwavg(:,b,a)=statss.tstat;
        ttrwavg(:,b,a)=statsn.tstat;
    end
    disp([num2str(a) '/' num2str(length(uconds))])
end
toc



D.BST.avg.p = ppwavg;
D.BST.avg.reverse_p = pprwavg;
D.BST.avg.reverse_tvalue = ttrwavg;
D.BST.avg.tvalue=ttwavg;
D.BST.avg.data = BSTavg;
D.BST.avg.rdata = BSTavg-BSTavg(:,end:-1:end,:);
D.BST.avg.conditions = uconds;
D.BST.avg.time = tBST;
D.BST.chanlabels = D.chanlabels;
D.BST.fsample = D.fsample;
D.BST = wjn_recon_spwpeaks(D.BST);
BST = D.BST;
save(D)
[fpath,fname] = wjn_recon_fpath(D.fullfile,'BST');
writetable(T,fullfile(fpath,['BST_table_' fname '.csv']))




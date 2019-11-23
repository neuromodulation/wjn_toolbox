function d=wjn_eeg_burst_analysis(filename,fhz,timewin,chs,conds,type,plotit,outname)

% timewin: time window in trials for burst analysis; chs:channels; conds:
% ci; type: graybiel (2* median for peak, 1* median for burst length),
% brown (75th percentile = length threshold, not peak), plotit: open figure
% per channel 0-1; outname: save file as.

D=wjn_sl(filename); %spm_eeg_load
% 
keep D fhz timewin conds chs type plotit outname

if ~exist('plotit','var')
    plotit = 0;
end

if ~exist('type','var')
    type = 'graybiel';
end

if ~exist('conds','var') || isempty(conds)
    conds = D.condlist;
end

if ~exist('chs','var') || isempty(chs)
    chs = D.chanlabels;
end

if ~exist('timewin','var') || isempty(timewin)
    timewin = [D.time(1) D.time(end)]; %default: over entire trial
end

chi = ci(chs,D.chanlabels);
iconds = ci(conds,D.conditions); 
nch = length(chi);
chs = D.chanlabels(chi);
ntr = length(iconds);

fs=D.fsample; %sampling rate


if sum(abs(timewin))<100 %sec transfrom to msec
    timewin = timewin.*1000;
end
ti = D.indsample(timewin(1)/1000):D.indsample(timewin(2)/1000); %indsample: name time get sample

data = D.fttimelock(chi);
cfg = [];
cfg.trials = iconds; 
cfg.padding = .5; %filtereckeneffekt aus
cfg.lpfilter = 'yes';
cfg.lpfreq = fhz(2);
cfg.hpfilter = 'yes';
cfg.hpfreq = fhz(1);
cfg.detrend = 'yes'; %ultralowe schwankungen rausrechnen
cfg.demean = 'yes'; %s.o.
if strcmp(type,'graybiel')
    cfg.hilbert ='abs'; %envelope in neg und pos amps
else
    cfg.rectify = 'yes'; %absolute amp (no neg)
end
fdata = ft_preprocessing(cfg,data); %cfg= config script

sm = 1000/nanmean(fhz)*8;%*((400/(1000/21.5))); smoothing kernel

for a=1:nch   
    if nch>1
    thrd=squeeze(fdata.trial(:,1,ti))';
    thrd=[thrd squeeze(fdata.trial(:,a,ti))'];
    else
    thrd=squeeze(fdata.trial(:,a,ti))';
    end
end

if strcmp(type,'graybiel')
    thresh = 2*median(thrd(:));
elseif isnumeric(type)
    thresh=type;
else
    thresh= prctile(thrd(:),75);
end

for a = 1:nch
    
    nd=squeeze(fdata.trial(:,a,ti))';

    t = repmat(fdata.time(ti)',[1 size(nd,2)]);
%     d=d';
    nd(:) = wjn_smoothn(nd(:),round(sm/1000*fs));
    
    thresh(a)=thresh;
    
    [bdur,bamp,n,btime]=wjn_burst_duration(nd(:),thresh(a),fs,1000/nanmean(fhz),type);
    bursttime = t(btime);
    d.bursttime{a} = bursttime;
    d.rawamp(a,:,:) = nd';
    [d.ratehist(a,:),d.timebins] = hist(bursttime,D.time(1):.5:D.time(end));
    d.ratehist(a,:) = d.ratehist(a,:)./ntr;

    bt = nan(size(t));
    br = bt;
    bd = bt;
    ba = bt;
    br(btime) = 1;
    ba(btime) = bamp;
    bd(btime) = bdur;
    
    d.burstamplitude(a,:,:) = ba';
    d.burstduration(a,:,:) = bd';
    d.burstraster(a,:,:) = br';
    
    for b = 1:length(d.timebins)
        cti = wjn_sc(D.time(ti),d.timebins(b)-.25):wjn_sc(D.time(ti),d.timebins(b)+.25);
        d.durhist(a,b) = nanmean(nanmean(d.burstduration(a,:,cti)));
        d.amphist(a,b) = nanmean(nanmean(d.burstamplitude(a,:,cti)));
    end
    
    d.bdur{a} = bdur;
    d.mdur(a) = nanmean(bdur);
    d.mamp(a) = nanmean(bamp);
    d.bamp{a} = bamp;
    d.nbursts(a) = n;
    d.burstrate(a) = n/(ntr*(D.time(ti(end))-D.time(ti(1))));
    d.btime{a} = btime;
    d.thresh(a) = thresh(a);
%     bt(isnan(bt))=0;
    bt(btime) =1;
    cbt = bt';
    if plotit
        figure
    %     subplot(1,2,1)
%         wjn_contourf(D.time(ti),1:ntr,cbt,3)
        for b = 1:ntr
            plot(D.time(ti),cbt(b,:)-1+b,'LineStyle','none','Marker','sq','MarkerFaceColor','k','MarkerEdgeColor','none','MarkerSize',2)
            hold on
        end
%             colormap([1 1 1;0 0 0])
        hold on
    %     plot(D.time(ti),sum(cbt),'color','k')
    %     hist(bursttime)
        title(chs{a})
        figone(7)
    %     subplot(1,2,2)
        [y,x]=hist(bursttime);
        h = bar(x,y./max(max(y))*ntr);
        set(h,'FaceColor','w')
%         set(h,'FaceAlpha',.5)
        mamp = nanmean(squeeze(d.burstamplitude(a,:,:)))./max(nanmean(squeeze(d.burstamplitude(a,:,:))))*.5*ntr;
        mdur = nanmean(squeeze(d.burstduration(a,:,:)))./max(nanmean(squeeze(d.burstduration(a,:,:))))*ntr;
        mraw = nanmean(squeeze(d.rawamp(a,:,:)))./max(nanmean(squeeze(d.rawamp(a,:,:))))*ntr;
        
        plot(D.time(ti),wjn_smoothn(mdur,sm),'color',[.6 .6 .6],'LineWidth',2)
        plot(D.time(ti),wjn_smoothn(mamp,sm),'color',[.2 .2 .2],'LineWidth',2)
        plot(D.time(ti),wjn_smoothn(mraw,sm),'color',[0 0 0],'LineWidth',2)
        xlabel('Time [s]');
        ylabel('Trials');
%         keyboard
    end
end

d.type = type;
d.ntrials = ntr;
d.trials = D.conditions(iconds);
d.t = D.time;
d.tmatrix = t;
d.fhz = fhz;
d.timewin = timewin;
d.channels = chs;
% keyboard
if exist('outname','var')   
    save([outname '_burst_' D.fname],'-struct','d')
end
% wjn_plot(fdata.time(ti),d(4,:,:))


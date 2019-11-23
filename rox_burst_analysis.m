function d=rox_burst_analysis(filename,fhz,timewin,chs,conds,type,onethresh,plotit,outname,side)

% timewin: time window in trials for burst analysis; chs:channels; conds:
% ci; type: graybiel (2* median for peak, 1* median for burst length),
% brown (75th percentile = length threshold, not peak), plotit: open figure
% per channel 0-1; outname: save file as.


D=wjn_sl(filename); %spm_eeg_load

if ~strfind(filename,'tf_');
D=wjn_downsample(D.fullfile,200,150,'d');
end
% 
keep D fhz timewin conds chs type plotit outname onethresh filename side

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

if ~exist('onethresh','var') || isempty(onethresh)
   onethresh=0; 
end

chi = ci(chs,D.chanlabels);

iconds = ci(conds,D.conditions); 

if isempty(iconds)
    iconds=1;
end
    
nch = length(chi);
chs = D.chanlabels(chi);
ntr = length(iconds);

fs=D.fsample; %sampling rate


if sum(abs(timewin))<100 || (strcmp(conds,'none') && sum(abs(timewin))<300) %sec transfrom to msec
    timewin = timewin.*1000;
end

ti = D.indsample(timewin(1)/1000):D.indsample(timewin(2)/1000); %indsample: name time get sample

if isempty(strfind(filename,'tf_'));

if strcmp(conds,'none');
    data=D.ftraw;
else
data = D.fttimelock(chi);
end

cfg = [];

if ~strcmp(conds,'none');
cfg.trials = iconds; 
end

cfg.padding = .5; %filtereckeneffekt aus
cfg.lpfilter = 'yes';
cfg.lpfreq = fhz(2);
cfg.hpfilter = 'yes';
cfg.hpfreq = fhz(1);
% cfg.detrend = 'yes'; %ultralowe schwankungen rausrechnen
% cfg.demean = 'yes'; %s.o.

if strcmp(type,'graybiel')
    cfg.hilbert ='abs'; %envelope in neg und pos amps
else
    cfg.rectify = 'yes'; %absolute amp (no neg)
end

fdata = ft_preprocessing(cfg,data); %cfg= config script

cfg = [];
cfg.detrend = 'yes';
cfg.demean = 'yes';
fdata = ft_preprocessing(cfg,fdata)
else
    data=squeeze(nanmean(D(:,fhz,:,:),2));
end

% sm = fs/nanmean(fhz)*8;%*((400/(1000/21.5))); smoothing kernel
sm = 500;

thrd=[];
thrd_r=[];
thrd_l=[];
tthresh=[];
tthresh_r=[];
tthresh_l=[];

if onethresh && nch>1;

    ch_r=ci('R', D.chanlabels);
    ch_l=ci('L', D.chanlabels);
    
    if ch_r
    for a=1:length(ch_r)   
        if ~strcmp(conds,'none');
            if ~strfind(filename,'tf_');
            onethrd=squeeze(fdata.trial(ch_r(a),ti))';
            else
             onethrd=squeeze(data(ch_r(a),ti))';   
            end
            thrd_r=[thrd_r;onethrd];
        else
            if ~strfind(filename,'tf_');
            onethrd=squeeze(fdata.trial{1,1}(ch_r(a),:)');
            else
             onethrd=squeeze(data(ch_r(a),ti))';   
            end
            thrd_r=[thrd_r;onethrd];
        end   
    end
    end
    
    if ch_l
    for a=1:length(ch_l)
        if ~strcmp(conds,'none');
             if ~strfind(filename,'tf_');
            onethrd=squeeze(fdata.trial(ch_l(a),ti))';
             else
            onethrd=squeeze(data(ch_l(a),ti,:))'; % wie bei epochiertem file?   
             end
            thrd_l=[thrd_l;onethrd];
        else
             if ~strfind(filename,'tf_');
            onethrd=squeeze(fdata.trial{1,1}(ch_l(a),:)');
             else
            onethrd=squeeze(data(ch_l(a),ti))';   
             end
            thrd_l=[thrd_l;onethrd];
        end   
    end
    end

if strcmp(type,'graybiel')
    if thrd_l
        tthresh_l = 2*median(thrd_l(:));
    end
    if thrd_r
        tthresh_r = 2*median(thrd_r(:));
    end
elseif iscell(type)
    if thrd_l
        tthresh_l=type{1};
        type = type{2};
    end
    if thrd_r
        tthresh_r=type{1};
        type = type{2};
    end
else
    if thrd_l
        tthresh_l= prctile(thrd_l(:),75);
    end
    if thrd_r
        tthresh_r= prctile(thrd_r(:),75);
    end
end
end

d.noburst = [];

for a = 1:nch
    
    if ~strcmp(conds,'none');
      if isempty(strfind(filename,'tf_'));
        nd=squeeze(fdata.trial(:,a,ti))';
      else
         nd=data(a,:);
      end
    else
         if isempty(strfind(filename,'tf_'));
            nd=fdata.trial{1}(a,ti);
         else
             nd=data(a,:);
         end
    end
    
    if ~onethresh || onethresh && nch<1;  
        if strcmp(type,'graybiel')
            tthresh = 2*median(nd(:));
        elseif iscell(type)
            tthresh=type{1};
            type = type{2};
        else
        tthresh= prctile(nd(:),75);
        end
    end
    
    if ~strcmp(conds,'none');
        t = repmat(fdata.time(ti)',[1 size(nd,2)]);
    else
        if ~strfind(filename,'tf_');
%     t = repmat(fdata.time{1,1}(1,ti)',[1 size(nd,2)]);
        t = fdata.time{1}(ti);
        else
        t=D.time;
        end
    end
%     d=d';
    if isempty(strfind(filename,'tf_'));
    nd(:) = wjn_smoothn(nd(:),sm);
    end
    
    if tthresh;
        thresh(a)=tthresh;
    end
    
    if ~isempty(ci('R',chs(a))) && ~isempty(tthresh_r)
        thresh(a)=tthresh_r;
    end
    
    if ~isempty(ci('L',chs(a))) && ~isempty(tthresh_l)
        thresh(a)=tthresh_l;
    end
    
    [bdur,bamp,n,btime,ibiamp,ibidur]=rox_burst_duration(nd(:),thresh(a),fs,1000/nanmean(fhz),type);
    
    if ~n
        warning(filename)
        warning([chs{a} ' no burst found!'])
        d.noburst = [d.noburst a];
        continue  
    end
    
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
    
    if ~strcmp(conds,'none')

        for b = 1:length(d.timebins)
            cti = wjn_sc(D.time(ti),d.timebins(b)-.25):wjn_sc(D.time(ti),d.timebins(b)+.25);
            d.durhist(a,b) = nanmean(nanmean(d.burstduration(a,:,cti)));
            d.amphist(a,b) = nanmean(nanmean(d.burstamplitude(a,:,cti)));
        end
    else
        for b = 1:length(d.timebins)
            cti = wjn_sc(D.time(ti),d.timebins(b)-.25):wjn_sc(D.time(ti),d.timebins(b)+.25);
            d.durhist(a,b) = nanmean(nanmean(d.burstduration(a,cti)));
            d.amphist(a,b) = nanmean(nanmean(d.burstamplitude(a,cti)));
        end
    end
    d.bdur{a} = bdur;
    d.mdur(a) = nanmean(bdur);
    d.mamp(a) = nanmean(bamp);
    d.bamp{a} = bamp;
    d.nbursts(a) = n;
    d.burstrate(a) = n/(ntr*(D.time(ti(end))-D.time(ti(1))));
    d.btime{a} = btime;
    d.thresh(a) = thresh(a);
    
    d.ibiamp{a}=ibiamp;
    d.ibidur{a}=ibidur;
    
%     bt(isnan(bt))=0;
    bt(btime) =1;
    cbt = bt';
    if plotit
        figure
    %     subplot(1,2,1)
%         wjn_contourf(D.time(ti),1:ntr,cbt,3)
        if ntr>1;
        for b = 1:ntr
            plot(D.time(ti),cbt(b,:)-1+b,'LineStyle','none','Marker','sq','MarkerFaceColor','k','MarkerEdgeColor','none','MarkerSize',2)
            hold on
        end
        else
            plot(D.time(ti),cbt ,'LineStyle','none','Marker','sq','MarkerFaceColor','k','MarkerEdgeColor','none','MarkerSize',2)
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
        if ntr>1;
        h = bar(x,y./max(max(y))*ntr);
        else
        h = bar(x,y./max(max(y)));
        end
        set(h,'FaceColor','w');
        ylim([0 1.2])
%         set(h,'FaceAlpha',.5)
        
        if ntr>1
        mamp = nanmean(squeeze(d.burstamplitude(a,:,:)))./max(nanmean(squeeze(d.burstamplitude(a,:,:))))*.5*ntr;
        mdur = nanmean(squeeze(d.burstduration(a,:,:)))./max(nanmean(squeeze(d.burstduration(a,:,:))))*ntr;
        mraw = nanmean(squeeze(d.rawamp(a,:,:)))./max(nanmean(squeeze(d.rawamp(a,:,:))))*ntr;
        
        plot(D.time(ti),wjn_smoothn(mdur,sm),'color',[.6 .6 .6],'LineWidth',2)
        plot(D.time(ti),wjn_smoothn(mamp,sm),'color',[.2 .2 .2],'LineWidth',2)
        plot(D.time(ti),wjn_smoothn(mraw,sm),'color',[0 0 0],'LineWidth',2)
        
        else
        
        mamp = (squeeze(d.burstamplitude(a,:)))./max(squeeze(d.burstamplitude(a,:)))*.5*ntr;
        mdur = (squeeze(d.burstduration(a,:)))./max(squeeze(d.burstduration(a,:)))*ntr;
        mraw = (squeeze(d.rawamp(a,:)))./max(squeeze(d.rawamp(a,:)))*ntr;
        
        plot(D.time(ti),wjn_smoothn(mdur,sm),'color',[.6 .6 .6],'LineWidth',2)
        plot(D.time(ti),wjn_smoothn(mamp,sm),'color',[.2 .2 .2],'LineWidth',2)
        plot(D.time(ti),wjn_smoothn(mraw,sm),'color',[0 0 0],'LineWidth',2)
        
        end
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

d.gc = 1:length(d.channels);
d.gc(d.noburst) = [];

    if tthresh_l
        d.thresh_l=tthresh_l;
    end
    
    if tthresh_r
       d.thresh_r=tthresh_r;
    end

i200=length(d.bdur{1,1} (d.bdur{1,1}>=200&d.bdur{1,1}<300));
i300=length(d.bdur{1,1} (d.bdur{1,1}>=300&d.bdur{1,1}<400));
i400=length(d.bdur{1,1} (d.bdur{1,1}>=400&d.bdur{1,1}<500));
i500=length(d.bdur{1,1} (d.bdur{1,1}>=500&d.bdur{1,1}<600));
i600=length(d.bdur{1,1} (d.bdur{1,1}>=600&d.bdur{1,1}<700));
i700=length(d.bdur{1,1} (d.bdur{1,1}>=700&d.bdur{1,1}<800));
i800=length(d.bdur{1,1} (d.bdur{1,1}>=800&d.bdur{1,1}<900));
i900=length(d.bdur{1,1} (d.bdur{1,1}>=900));

d.nburstdur=[i200 i300 i400 i500 i600 i700 i800 i900];
% d.ratehist(d.noburst,:)  =nan;
% d.burstamplitude(d.noburst,:,:) = nan;
% d.burstduration(d.noburst,:,:) = nan;
% d.burstraster(d.noburst,:,:) = nan;
% d.durhist(d.noburst,:) = nan;


% keyboard
if exist('outname','var')   
    save([outname '_burst_' filename(1:end-4) '_' side '.mat'],'-struct','d')
end
% wjn_plot(fdata.time(ti),d(4,:,:))


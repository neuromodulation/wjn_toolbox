function D = wjn_reconall(filename,stage)

normfreq = [5 45; 55 95];
D=spm_eeg_load(filename);

if length(unique(D.chantype)) == 1 && strcmp(unique(D.chantype),'Other') 
    D=wjn_fix_chantype(D.fullfile);
end

if ~strcmp(D.type,'continuous')
    error('Only continuous data')
end

fname =  D.fname;fname = fname(1:end-4);
fpath = fullfile(D.path,['reconall_' fname]);
mkdir(fpath)


Dc = D;
Dd = wjn_downsample(Dc.fullfile,60);
figure('visible','off')
wjn_plot_raw_signals(Dd.time,Dd(:,:),strrep(Dd.chanlabels,'_',' '))
xlabel('Time [s]')
figone(40,40)
savefig(fullfile(fpath,['raw_' fname '.fig']))
close
Dd.delete()
figure('visible','off')
wjn_plot_raw_signals(Dc.time,Dc(:,:),strrep(Dc.chanlabels,'_',' '))
xlabel('Time [s]')
figone(40,40)
myprint(fullfile(fpath,['raw_' fname]));
ix = randi(round(Dc.time(end)-10)-1);
xlim([ix ix+10])
myprint(fullfile(fpath,['raw_zoom_' fname]));
close

De=wjn_epoch(D.fullfile,2);
Ddelete = De;

D=De;
data = D.ftraw(0);
cfg =[];
data=ft_preprocessing(cfg,data);
Ntrials = D.ntrials;

cfg.method = 'mtmfft';
cfg.output = 'pow';
cfg.taper = 'dpss';
cfg.tapsmofrq=2;
cfg.keeptrials = 'yes';
cfg.keeptapers='no';
cfg.pad = 'nextpow2';
cfg.padding = 2;
inp = ft_freqanalysis(cfg,data);

pow = inp.powspctrm;
pow(:,:,wjn_sc(inp.freq,normfreq(1,2)):wjn_sc(inp.freq,normfreq(2,1))) = 0;
mpow = squeeze(nanmean(pow,1));

if min(size(mpow))==1
    mpow=mpow';
end

sump = nansum(mpow(:,searchclosest(inp.freq,normfreq(1,1)):searchclosest(inp.freq,normfreq(2,2))),2);
stdp = nanstd(mpow(:,searchclosest(inp.freq,normfreq(1,1)):searchclosest(inp.freq,normfreq(2,2))),[],2);
logfit = fftlogfitter(inp.freq',mpow)';

for a=1:size(mpow,1)
    rpow(a,:) = (mpow(a,:)./sump(a)).*100;
    spow(a,:) = (mpow(a,:)./stdp(a));
    for b = 1:size(pow,1)
        for c = 1:size(pow,3)
            srpow(a,c) = pow(b,a,c)/sum(pow(b,a,searchclosest(inp.freq,normfreq(1,1)):searchclosest(inp.freq,normfreq(2,2))))*100;
        end
    end
end


fname = D.fname;
COH = [];
COH.name = fname(1:length(fname)-4);
COH.dir = cd;
fnsave = ['COH_' strrep(D.condlist{1},' ','_') '_' fname];
COH.fname = fnsave;
COH.fs = D.fsample;
COH.condition = D.condlist;
COH.chantype = D.chantype;
COH.badchannels = D.badchannels;
COH.nseg = Ntrials;
COH.tseg = D.nsamples/D.fsample;
COH.time = linspace(0,COH.tseg*COH.nseg,COH.nseg);
COH.channels = inp.label;
COH.f = inp.freq;
COH.freq = [inp.freq(1) inp.freq(2)];

COH.rpow = rpow;
COH.spow = spow;
COH.srpow = srpow;
COH.logfit = logfit;
COH.pow = permute(pow,[2,3,1]);
COH.mpow = mpow;


for a=1:length(COH.channels)
    rtf(a,:,:) = bsxfun(@rdivide,...
        bsxfun(@minus,...
        squeeze(COH.pow(a,:,:))',...
        squeeze(nanmean(COH.pow(a,:,:),3))),...
        nanmean(squeeze(COH.pow(a,:,:))')).*100;
    COH.rtf(a,:,:) = squeeze(rtf(a,:,:))';
end

COH.rtf = rtf;

figure('visible','off')
plot(COH.f,COH.rpow)
legend(strrep(COH.channels,'_',' '))
xlim([1 COH.f(end)])
ylim([0 10])
ylabel('PSD [%]')
xlabel('Frequency [Hz]')
figone(20,26)
savefig(fullfile(fpath,['rpow_' fname '.fig']))
xlim([3 45])
myprint(fullfile(fpath,['rpow_' fname]))
close
Dc.COH = COH;
save(Dc)

figint = 4;
nfig = 1:figint:D.nchannels;

figure('visible','off')
for a = nfig
    for b = 0:figint-1
        if a+b <= D.nchannels
            subplot(figint,1,b+1)
            imagesc(COH.time,COH.f,log(squeeze(COH.pow(a+b,:,:))))
            axis xy
            TFaxes
            title(strrep(COH.channels{a+b},'_',' '))
            ylim([3 45])
            figone(30,40)
        end
    end
    myprint(fullfile(fpath,['TF_' num2str(a) '_' fname]))
end
close

save(fullfile(fpath,['POW_' fname]),'COH','-v7.3');
if stage <= 1
    D=Dc;
end
if stage >= 2
    
    D = wjn_spw(Dc,1.96,1);
    spw = D.spw;
    
    figint = 4;
    nfig = 1:figint:D.nchannels;
    
    figure('visible','off')
    for a = nfig
        for b = 0:figint-1
            if a+b <= D.nchannels
                subplot(figint,1,b+1)
                plot(D.time,D(a+b,:))
                hold on
                scatter(D.time(D.spw.neg(a+b).i),D(a+b,D.spw.neg(a+b).i))
                scatter(D.time(D.spw.neg(a+b).ipre),D(a+b,D.spw.neg(a+b).ipre))
                scatter(D.time(D.spw.neg(a+b).ipost),D(a+b,D.spw.neg(a+b).ipost)')
                xlim([ix ix+10])
                hold off
                title(strrep(D.chanlabels{a+b},'_',' '))
            end
        end
        
        
        ylabel('Amplitude [Z]')
        xlabel('Time [s]')
        figone(30,50)
        savefig(fullfile(fpath,['spw_raw_' num2str(a) '_' fname '.fig']))
        myprint(fullfile(fpath,['spw_raw_' num2str(a) '_' fname]))
    end
    close
    
    figure('visible','off')
    wjn_plot_spw(spw.wvt,spw.wvn,D.chanlabels)
    figone(40,20)
    myprint(fullfile(fpath,['spw_wv_' fname]))
    close
    
    
    ffs = fieldnames(spw.results);
    figure('visible','off')
    for a = 1:length(ffs)
        subplot(1,length(ffs),a)
        barh(spw.results.(ffs{a}))
        if a == 1
            set(gca,'YTick',1:D.nchannels,'YTickLabel',strrep(D.chanlabels,'_',' '))
            ylim([0 D.nchannels+1]);
        else
            set(gca,'YTick',[])
            ylim([0 D.nchannels+1]);
        end
        title(ffs{a})
    end
    figone(40,40)
    myprint(fullfile(fpath,['SPW_results_' fname]))
    close
    spw.channels = D.chanlabels;
    save(fullfile(fpath,['SPW_' fname]),'spw','-v7.3');
end

if stage > 2 && D.nchannels>1
    
    D=De;
    data=D.ftraw(0);
    cfg =[];
    cfg.method = 'mtmfft';
    cfg.output = 'powandcsd';
    cfg.taper = 'dpss';
    cfg.tapsmofrq=2;
    cfg.output ='powandcsd';
    cfg.keeptrials = 'yes';
    cfg.keeptapers='no';
    cfg.pad = 'nextpow2';
    cfg.padding = 2;
    inp = ft_freqanalysis(cfg,data);
    
    cfg1 = [];
    cfg1.method = 'coh';
    coh = ft_connectivityanalysis(cfg1, inp);
    cfg2 = cfg1;
    cfg2.complex = 'imag';
    icoh = ft_connectivityanalysis(cfg2, inp);
    
    % keyboard
    Ntrials = D.ntrials;
    shift=randi(Ntrials,1,Ntrials);
    scoh=coh;
    scoh.cohspctrm=zeros(size(scoh.cohspctrm));
    for c=1:length(data.label)
        sdata=data;
        tr = data.trial(shift);
        for nt =1:numel(tr)
            sdata.trial{nt}(c,:)=tr{nt}(c,:);
        end
        cfg.channelcmb = {data.label{c}, 'all'};
        inp = ft_freqanalysis(cfg, sdata);
        sscoh = ft_connectivityanalysis(cfg1, inp);
        for i=1:size(sscoh.labelcmb, 1)
            ind=[intersect(strmatch(sscoh.labelcmb(i,1),scoh.labelcmb(:,1),'exact'), ...
                strmatch(sscoh.labelcmb(i,2),scoh.labelcmb(:,2),'exact'))...
                intersect(strmatch(sscoh.labelcmb(i,1),scoh.labelcmb(:,2),'exact'), ...
                strmatch(sscoh.labelcmb(i,2),scoh.labelcmb(:,1),'exact'))];
            scoh.cohspctrm(ind, :)=sscoh.cohspctrm(i, :);
        end
    end
    clear sdata sicoh ssicoh
    sicoh=scoh;
    sicoh.cohspctrm=zeros(size(scoh.cohspctrm));
    for c=1:length(data.label)
        sdata=data;
        tr = data.trial(shift);
        for nt =1:numel(tr)
            sdata.trial{nt}(c,:)=tr{nt}(c,:);
        end
        cfg.channelcmb = {data.label{c}, 'all'};
        inp = ft_freqanalysis(cfg, sdata);
        ssicoh = ft_connectivityanalysis(cfg2, inp);
        for i=1:size(ssicoh.labelcmb, 1)
            ind=[intersect(strmatch(ssicoh.labelcmb(i,1),sicoh.labelcmb(:,1),'exact'), ...
                strmatch(ssicoh.labelcmb(i,2),sicoh.labelcmb(:,2),'exact'))...
                intersect(strmatch(ssicoh.labelcmb(i,1),sicoh.labelcmb(:,2),'exact'), ...
                strmatch(ssicoh.labelcmb(i,2),sicoh.labelcmb(:,1),'exact'))];
            sicoh.cohspctrm(ind, :)=ssicoh.cohspctrm(i, :);
        end
    end
    
    
    
    for a = 1:size(coh.cohspctrm,1)
        cohZ(a,:) = 0.5*log((1+coh.cohspctrm(a,:))./(1-coh.cohspctrm(a,:)));
        seZ(a,:) = 0.5*log((1+scoh.cohspctrm(a,:))./(1-scoh.cohspctrm(a,:)));
        icohZ(a,:) = 0.5*log((1+abs(icoh.cohspctrm(a,:)))./(1-abs(icoh.cohspctrm(a,:))));
        sicohZ(a,:) = 0.5*log((1+abs(sicoh.cohspctrm(a,:)))./(1-abs(sicoh.cohspctrm(a,:))));
    end
    
    
    
    
    
    COH.coh = coh.cohspctrm;
    COH.icoh = abs(icoh.cohspctrm);
    COH.icohZ = icohZ;
    COH.sicohZ = sicohZ;
    COH.cohZ = cohZ;
    COH.scoh = scoh.cohspctrm;
    COH.scohZ = seZ;
    COH.sicoh = abs(sicoh.cohspctrm);
    
    COH.chancomb = coh.labelcmb;
    
    
    figure('visible','off')
    for a = 1:D.nchannels
        subplot(1,D.nchannels,a)
        i = wjn_cohfinder(D.chanlabels{a},D.chanlabels(setdiff(1:D.nchannels,a)),COH.chancomb,0);
        p=plot(COH.f,COH.icoh(i,:));
        ylabel('Imaginary part of coherence')
        xlabel('Frequency [Hz]')
        hold on
        legend(p,strrep(D.chanlabels(setdiff(1:D.nchannels,a)),'_',' '),'Location','SouthOutside')
        xlim([3 45])
        title(strrep(D.chanlabels{a},'_',' '))
    end
    figone(40,60)
    savefig(fullfile(fpath,['iCOH_all_' fname '.fig']))
    close
    
    figure('visible','off')
    figone(20,30)
    for a = 1:D.nchannels
        subplot(1,3,1:2)
        i = wjn_cohfinder(D.chanlabels{a},D.chanlabels(setdiff(1:D.nchannels,a)),COH.chancomb,0);
        p=plot(COH.f,COH.icoh(i,:));
        ylabel('Imaginary part of coherence')
        xlabel('Frequency [Hz]')
        legend(p,strrep(D.chanlabels(setdiff(1:D.nchannels,a)),'_',' '),'Location','SouthOutside')
        xlim([3 45])
        title(strrep(D.chanlabels{a},'_',' '))
        subplot(1,3,3)
        wjn_plot_raw_signals(COH.f,COH.icoh(i,:),D.chanlabels(setdiff(1:D.nchannels,a)))
        xlim([3 45])
        xlabel('Frequency [Hz]')
        myprint(fullfile(fpath,['iCOH_' D.chanlabels{a} '_' fname]))
        hold off
    end
    close
    
     figure('visible','off')
    for a = 1:D.nchannels
        subplot(1,D.nchannels,a)
        i = wjn_cohfinder(D.chanlabels{a},D.chanlabels(setdiff(1:D.nchannels,a)),COH.chancomb,0);
        p=plot(COH.f,COH.coh(i,:));
        ylabel('Coherence')
        xlabel('Frequency [Hz]')
        hold on
        legend(p,strrep(D.chanlabels(setdiff(1:D.nchannels,a)),'_',' '),'Location','SouthOutside')
        xlim([3 45])
        title(strrep(D.chanlabels{a},'_',' '))
    end
    figone(40,60)
    savefig(fullfile(fpath,['COH_all_' fname '.fig']))
    close
    
    figure('visible','off')
    figone(20,30)
    for a = 1:D.nchannels
        subplot(1,3,1:2)
        i = wjn_cohfinder(D.chanlabels{a},D.chanlabels(setdiff(1:D.nchannels,a)),COH.chancomb,0);
        p=plot(COH.f,COH.coh(i,:));
        ylabel('Coherence')
        xlabel('Frequency [Hz]')
        legend(p,strrep(D.chanlabels(setdiff(1:D.nchannels,a)),'_',' '),'Location','SouthOutside')
        xlim([3 45])
        title(strrep(D.chanlabels{a},'_',' '))
        subplot(1,3,3)
        wjn_plot_raw_signals(COH.f,COH.icoh(i,:),D.chanlabels(setdiff(1:D.nchannels,a)))
        xlim([3 45])
        xlabel('Frequency [Hz]')
        myprint(fullfile(fpath,['COH_' D.chanlabels{a} '_' fname]))
        hold off
    end
    close
    
    save(fullfile(fpath,['COH_' fname]),'COH','-v7.3');
    if stage >= 4
        
        clear inp coh icoh stat
        odata = D.ftraw(0);
        rdata = odata(:,1:end);
        
        for a =1:length(rdata.trial)
            rdata.trial{a} = rdata.trial{a}(:, end:-1:1);
        end
        data = {odata, rdata};
        
        for i = 1:numel(data)
            
            cfg = [];
            cfg.output ='fourier';
            cfg.keeptrials = 'yes';
            cfg.keeptapers='yes';
            cfg.taper = 'dpss';
            cfg.tapsmofrq=2;
            cfg.pad = 'nextpow2';
            cfg.padding = 2;
            cfg.method          = 'mtmfft';
            inp{i} = ft_freqanalysis(cfg, data{i});
            %
            cfg1 = [];
            cfg1.method  = 'coh';
            %           coh{i} = ft_connectivityanalysis(cfg1, inp{i});
            
            cfg2=cfg1;
            cfg2.method = 'granger';
            stat{i} = ft_connectivityanalysis(cfg2, inp{i});
            
            
        end
        
        
        COH.granger = stat{1}.grangerspctrm;
        COH.rgranger = stat{2}.grangerspctrm;
        COH.rcgranger = stat{1}.grangerspctrm-stat{2}.grangerspctrm;
        COH.grangerchannelcmb = stat{1}.label;
        
        figure('visible','off')
        for a = 1:D.nchannels
            subplot(1,D.nchannels,a)
            i = setdiff(1:D.nchannels,a);
            p=plot(COH.f,squeeze(COH.rcgranger(a,i,:))-squeeze(COH.rcgranger(i,a,:)));
            hold on
            ylabel('Corrected granger causality')
            xlabel('Frequency [Hz]')
            legend(p,strrep(D.chanlabels(i),'_',' '),'Location','SouthOutside')
            xlim([3 45])
            title(strrep(D.chanlabels{a},'_',' '))
        end
        figone(40,60)
        savefig(fullfile(fpath,['GRANGER_all_' fname '.fig']))
        close
        
        figure('visible','off')
        figone(20,30)
        for a = 1:D.nchannels
            subplot(1,3,1:2)
            i = setdiff(1:D.nchannels,a);
            p=plot(COH.f,squeeze(COH.rcgranger(a,i,:))-squeeze(COH.rcgranger(i,a,:)));
            legend(p,strrep(D.chanlabels(i),'_',' '),'Location','SouthOutside')
            ylabel('Corrected granger causality')
            xlabel('Frequency [Hz]')
            xlim([3 45])
            title(strrep(D.chanlabels{a},'_',' '))
            subplot(1,3,3)
            wjn_plot_raw_signals(COH.f,squeeze(COH.rcgranger(a,i,:))-squeeze(COH.rcgranger(i,a,:)),D.chanlabels(setdiff(1:D.nchannels,a)))
            xlim([3 45])
            xlabel('Frequency [Hz]')
            myprint(fullfile(fpath,['GRANGER_' D.chanlabels{a} '_' fname]))
            hold off
        end
        close
        save(fullfile(fpath,['GRANGER_' fname]),'COH','-v7.3');
    end
    
end

D=Dc;




if exist('Ddelete','var')
    Ddelete.delete();
end

if stage == 5
    trl = spw.alltimes;
    conds = spw.allconds;
    De=wjn_epoch(Dc.fullfile,[-125 125],conds,trl,'spw');
    De=wjn_average(De.fullfile,0);
    
    figure('visible','off')
    for a = 1:De.ntrials
        
        [peak(:,a),delays(:,a)]=wjn_plot_spw(De.time.*1000,squeeze(De(:,:,a)),De.chanlabels);
        title(strrep(De.conditions{a},'_',' '))
        figone(30,10)
        hold off
        myprint(fullfile(fpath,['SPW_ERP_' De.conditions{a} '_' fname]))
    end
    close
    
  
    
    figure('visible','off')
    subplot(1,2,1)
    imagesc(delays')
    cb=colorbar;ylabel(cb,'Delay [ms]')
    set(gca,'XTick',1:size(delays,1),'XTickLabel',strrep(De.chanlabels,'_',' '),'XTickLabelRotation',90)
    set(gca,'YTick',1:size(delays,2),'YTickLabel',strrep(De.conditions,'_',' '))
    subplot(1,2,2)
    imagesc(peak')
    cb=colorbar;ylabel(cb,'Z')
    set(gca,'XTick',1:size(peak,1),'XTickLabel',strrep(De.chanlabels,'_',' '),'XTickLabelRotation',90)
    set(gca,'YTick',1:size(peak,2),'YTickLabel',strrep(De.conditions,'_',' '))
    figone(35,55)
    myprint(fullfile(fpath,['SPW_ERP_results_' De.conditions{a} '_' fname]))
    close 
    
    
    spw = rmfield(spw,'T');
    spw = rmfield(spw,'neg');
    spw = rmfield(spw,'pos');
    spw.avg.data = De(:,:,:);
    spw.avg.condlist = De.conditions;
    spw.avg.time = De.time.*1000;
    spw.avg.peak = peak;
    spw.avg.delays = delays;
    save(fullfile(fpath,['SPW_ERP_' fname]),'spw','-v7.3');
    
end


D=Dc;
D.COH=COH;
save(D)






function D = wjn_reconall(filename,printit,stage)

if ~exist('stage','var')
    stage = 4;
end
if ~exist('printit','var')
    printit=1;
end

normfreq = [5 45; 55 95];

iempty = D.chanlabels(find(sum(D(:,:)')==0));
if ~isempty(iempty)
    disp('REMOVING EMPTY CHANNELS')
    D=wjn_remove_channels(D.fullfile,D.chanlabels(iempty));
end
if length(unique(D.chantype)) == 1 && strcmp(unique(D.chantype),'Other') 
    D=wjn_fix_chantype(D.fullfile);
end

if ~strcmp(D.type,'continuous')
    error('Only continuous data')
end

fname =  D.fname;fname = fname(1:end-4);
fpath = fullfile(D.path,['recon_all_' fname]);
mkdir(fpath)


if printit
raw=D.ftraw(0);
cfg=[];
cfg.resamplefs =60; 
cfg.detrend = 'yes';      
cfg.demean  ='yes';    
raw=ft_resampledata(cfg,raw);
disp('Print raw time series.')
figure('visible','off')
wjn_plot_raw_signals(raw.time{1},raw.trial{1},strrep(D.chanlabels,'_',' '));
xlabel('Time [s]')
figone(40,40)
myprint(fullfile(fpath,['raw_' fname]));
savefig(fullfile(fpath,['raw_' fname '.fig']))
close

ix = randi(round(D.time(end)-10)-1);
figure('visible','off')
wjn_plot_raw_signals(D.time(D.indsample(ix):D.indsample(ix+10)),D(:,D.indsample(ix):D.indsample(ix+10)),strrep(D.chanlabels,'_',' '));
xlabel('Time [s]')
figone(40,40)
myprint(fullfile(fpath,['raw_zoom_' fname]));
close
end

data = D.ftraw(0);
cfg            = []; 
cfg.continuous = 'yes';
cfg.lpfilter='yes';
cfg.lpfreq = D.fsample/2.5;
cfg.padding = 2;
data           = ft_preprocessing(cfg,data);

cfg         = [];
cfg.length  = 2;
cfg.overlap = 0.5;
data        = ft_redefinetrial(cfg, data);

Ntrials = length(data.trial);

cfg.method = 'mtmfft';
cfg.output = 'pow';
cfg.taper = 'dpss';
cfg.tapsmofrq=5;
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

freqbands  = {'all','lowfreq','theta','alpha','beta','low_beta','high_beta'};
bandfreqs = [3 35;4 12;4 8;8 12;13 35;13 20;20 35];
measures = {'mpow','rpow','logfit'};

close all
for a = 1:length(COH.channels)
    for b = 1:length(measures)
        for c = 1:length(freqbands)
            COH.bandaverage.data(a,b,c) = nanmean(COH.(measures{b})(b,wjn_sc(COH.f,bandfreqs(c,1)):wjn_sc(COH.f,bandfreqs(c,2))));
            COH.bandaverage.freqbands = freqbands;
            COH.bandaverage.bandfreqs = bandfreqs;
            COH.bandaverage.measures = measures;
            COH.bandaverage.channels = COH.channels;
            COH.bandaverage.(measures{b})(a,c) = COH.bandaverage.data(a,b,c);
        end
    end
end

keyboard    
%         COH.bandaverage.freqband.all = [3 35];
%         [m,i,w]=findpeaks(cpow,'Minpeakdistance',wjn_sc(COH.f,3)-wjn_sc(COH.f,1));
%            irm=COH.f(i)<3;
%             i(irm)=[];m(irm)=[];w(irm)=[];
%         if ~isempty(m)
%             [mm,mi]=nanmax(m);
%             COH.peaks.(measures{b}).('freqband').all = [3 35];
%             COH.peaks.(measures{b}).('freq').all{c} = COH.f(i);
%             COH.peaks.(measures{b}).('amp').all{c} = m;
%             COH.peaks.(measures{b}).('width').all{c} = COH.f(round(w));
%             COH.peaks.(measures{b}).('maxfreq').all(c,1) = COH.f(i(mi));
%             COH.peaks.(measures{b}).('maxamp').all(c,1) = mm;
%             COH.peaks.(measures{b}).('maxwidth').all(c,1) = w(mi);
%         end
%         for a = 1:length(freqbands)
%             ib=wjn_sc(COH.f,bandfreqs(a,1)):wjn_sc(COH.f,bandfreqs(a,2));
%             COH.bandaverage.(measures{b}).(freqbands{a})(c,:) =nanmean(cpow(wjn_sc(COH.f,3):end));
%             COH.bandaverage.freqband.(freqbands{a}) = bandfreqs(a,:);
%             ip = find(ismember(i,ib));
%            
%             [mm,mi]=nanmax(m(ip));
%             if ~isempty(ip)
%                 COH.([measures{b} '_peakfreq']).(freqbands{a}){c} = COH.f(i(ip));
%                 COH.([measures{b} '_peakamp']).(freqbands{a}){c} = m(ip);
%                 COH.([measures{b} '_peakwidth']).(freqbands{a}){c} = COH.f(round(w(ip)));
%                 COH.([measures{b} '_maxpeakfreq']).(freqbands{a}){c} = COH.f(i(ip(mi)));
%                 COH.([measures{b} '_maxpeakamp']).(freqbands{a}){c} = mm;
%                 COH.([measures{b} '_maxpeakwidth']).(freqbands{a}){c} = w(ip(mi));
%             end
%         end
%             
%     end
% end




for a=1:length(COH.channels)
    rtf(a,:,:) = bsxfun(@rdivide,...
        bsxfun(@minus,...
        squeeze(COH.pow(a,:,:))',...
        squeeze(nanmean(COH.pow(a,:,:),3))),...
        nanmean(squeeze(COH.pow(a,:,:))')).*100;
    COH.rtf(a,:,:) = squeeze(rtf(a,:,:))';
end

COH.rtf = rtf;

if printit
disp('Print power spectra.')
figure('visible','off')
subplot(1,2,1)
plot(COH.f,COH.rpow)
legend(strrep(COH.channels,'_',' '))
xlim([1 COH.f(end)])
ylim([0 10])
ylabel('PSD')
xlabel('Frequency [Hz]')
subplot(1,2,2)
plot(COH.f,COH.logfit)
legend(strrep(COH.channels,'_',' '))
xlim([1 COH.f(end)])
ylabel('PSD')
xlabel('Frequency [Hz]')
figone(20,52)
savefig(fullfile(fpath,['pow_' fname '.fig']))
xlim([3 45])
myprint(fullfile(fpath,['rpow_' fname]))
close
end
if stage >= 2
    
    D = wjn_spw(D,1.96,0);
    spw = D.spw;
    if printit
    figint = 4;
    nfig = 1:figint:D.nchannels;
    disp('Print exemplar waveform identification.')
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
    disp('Print waveform characteristics.')
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
    figone(40,80)
    myprint(fullfile(fpath,['SPW_results_' fname(1:end-4)]))
    close
    end
    R=struct2table(D.spw.results);
    R.channels=D.chanlabels';
    R=R(:,[end 1 3:end-1]);
    disp('Write waveform shape result table.')
    writetable(R,fullfile(fpath,['spw_results_' fname(1:end-4) '.csv']))
    if printit
    disp('Print ERPs.')
    figure('visible','off')
    end
    
    for a = 1:length(D.spw.avg.conditions)
        [peaks(:,a),delays(:,a)]=wjn_plot_spw(D.spw.avg.time,D.spw.avg.tvalue(:,:,a),D.chanlabels,printit,1);
       if printit
        title(strrep(D.spw.avg.conditions{a},'_',' '))
        figone(40,20)
        hold off
        myprint(fullfile(fpath,['SPW_ERP_' D.spw.avg.conditions{a} '_' fname]))
       end
    end
    close
    
    if printit
    disp('Print delay and peaks.')
    figure('visible','off')
    subplot(1,2,1)
    imagesc(delays')
    cb=colorbar;ylabel(cb,'Delay [ms]')
    set(gca,'XTick',1:size(delays,1),'XTickLabel',strrep(D.chanlabels,'_',' '),'XTickLabelRotation',90)
    set(gca,'YTick',1:size(delays,2),'YTickLabel',strrep(D.spw.avg.conditions,'_',' '))
    subplot(1,2,2)
    imagesc(peaks')
    cb=colorbar;ylabel(cb,'Z')
    set(gca,'XTick',1:size(peaks,1),'XTickLabel',strrep(D.chanlabels,'_',' '),'XTickLabelRotation',90)
    set(gca,'YTick',1:size(peaks,2),'YTickLabel',strrep(D.spw.avg.conditions,'_',' '))
    figone(40,65)
    myprint(fullfile(fpath,['SPW_ERP_results_' D.spw.avg.conditions{a} '_' fname]))
    close 
    end
    Rd=table('RowNames',D.chanlabels);
    Rp=Rd;
    for a=1:length(D.spw.avg.conditions)
        Rd.(D.spw.avg.conditions{a})=delays(:,a);
        Rp.(D.spw.avg.conditions{a})=peaks(:,a);
    end
    writetable(Rd,fullfile(fpath,['SPW_delays_' fname(1:end-4) '.csv']))
    writetable(Rp,fullfile(fpath,['SPW_peaks' fname(1:end-4) '.csv']))
end

if stage > 2 && D.nchannels>1
    
    disp('Compute connectivity.')
    cfg =[];
    cfg.method = 'mtmfft';
    cfg.output = 'powandcsd';
    cfg.taper = 'dpss';
    cfg.tapsmofrq=5;
    cfg.output ='powandcsd';
    cfg.keeptrials = 'yes';
    cfg.keeptapers='no';
    cfg.pad = 'nextpow2';
    cfg.padding = 0.5;
    inp = ft_freqanalysis(cfg,data);
    
    cfg1 = [];
    cfg1.method = 'coh';
    coh = ft_connectivityanalysis(cfg1, inp);
    cfg2 = cfg1;
    cfg2.complex = 'imag';
    icoh = ft_connectivityanalysis(cfg2, inp);
    cfg3=[];
    cfg3.method = 'wpli_debiased';
    wpli = ft_connectivityanalysis(cfg3, inp);
    cfg4=[];
    cfg4.method = 'plv';
    plv = ft_connectivityanalysis(cfg4, inp);
    
    
    for a = 1:size(coh.cohspctrm,1)
        cohZ(a,:) = 0.5*log((1+coh.cohspctrm(a,:))./(1-coh.cohspctrm(a,:)));
        icohZ(a,:) = 0.5*log((1+abs(icoh.cohspctrm(a,:)))./(1-abs(icoh.cohspctrm(a,:))));       
    end
    
    
    
    
    COH.wpli=wpli.wpli_debiasedspctrm;
    COH.plv = plv.plvspctrm;
    COH.coh = coh.cohspctrm;
    COH.icoh = abs(icoh.cohspctrm);
    COH.icohZ = icohZ;
    COH.cohZ = cohZ;
    COH.chancomb = coh.labelcmb;
    if printit
    disp('Print icoh.')
    figure('visible','off')
    for a = 1:D.nchannels
        subplot(1,D.nchannels,a)
        i = wjn_cohfinder(D.chanlabels{a},D.chanlabels(setdiff(1:D.nchannels,a)),COH.chancomb,0);
        p=plot(COH.f,COH.icoh(i,:));
        ylabel('Imaginary part of coherence')
        xlabel('Frequency [Hz]')
        hold on
        legend(p,strrep(D.chanlabels(setdiff(1:D.nchannels,a)),'_',' '),'Location','WestOutside')
        xlim([3 45])
        title(strrep(D.chanlabels{a},'_',' '))
    end
    figone(50,80)
    savefig(fullfile(fpath,['iCOH_all_' fname '.fig']))
    close
    
    figure('visible','off')
    figone(50,80)
    for a = 1:D.nchannels
        subplot(1,3,1:2)
        i = wjn_cohfinder(D.chanlabels{a},D.chanlabels(setdiff(1:D.nchannels,a)),COH.chancomb,0);
        p=plot(COH.f,COH.icoh(i,:));
        ylabel('Imaginary part of coherence')
        xlabel('Frequency [Hz]')
        legend(p,strrep(D.chanlabels(setdiff(1:D.nchannels,a)),'_',' '),'Location','WestOutside')
        xlim([3 45])
        title(strrep(D.chanlabels{a},'_',' '))
        subplot(1,3,3)
        wjn_plot_raw_signals(COH.f,COH.icoh(i,:),D.chanlabels(setdiff(1:D.nchannels,a)));
        xlim([3 45])
        xlabel('Frequency [Hz]')
        myprint(fullfile(fpath,['iCOH_' D.chanlabels{a} '_' fname]))
        hold off
    end
    close
    end

    if stage >= 4
      
        disp('Compute granger causality.')
        clear inp coh icoh stat
        odata = data;
        rdata = data;
        
        for a =1:length(rdata.trial)
            rdata.trial{a} = rdata.trial{a}(:, end:-1:1);
        end
        bdata = {odata, rdata};
        
        for i = 1:numel(bdata)
            
            cfg = [];
            cfg.output ='fourier';
            cfg.keeptrials = 'yes';
            cfg.keeptapers='yes';
            cfg.taper = 'dpss';
            cfg.tapsmofrq=3;
            cfg.pad = 'nextpow2';
            cfg.padding = 2;
            cfg.method          = 'mtmfft';
            inp{i} = ft_freqanalysis(cfg, bdata{i});

               
     
            cfg=[];
            cfg.method = 'granger';
            stat{i} = ft_connectivityanalysis(cfg, inp{i});
            
            
        end
        
        
        COH.granger = stat{1}.grangerspctrm;
        COH.rgranger = stat{2}.grangerspctrm;
        COH.rcgranger = stat{1}.grangerspctrm-stat{2}.grangerspctrm;
        COH.grangerchannelcmb = stat{1}.label;
        if printit
        disp('Print Granger causality.')
        figure('visible','off')
        for a = 1:D.nchannels
            subplot(1,D.nchannels,a)
            i = setdiff(1:D.nchannels,a);
            p=plot(COH.f,squeeze(COH.rcgranger(a,i,:))-squeeze(COH.rcgranger(i,a,:)));
            hold on
            ylabel('Corrected granger causality')
            xlabel('Frequency [Hz]')
            legend(p,strrep(D.chanlabels(i),'_',' '),'Location','WestOutside')
            xlim([3 45])
            title(strrep(D.chanlabels{a},'_',' '))
        end
        figone(50,80)
        savefig(fullfile(fpath,['GRANGER_all_' fname '.fig']))
        close
        
        figure('visible','off')
        figone(50,80)
        for a = 1:D.nchannels
            subplot(1,3,1:2)
            i = setdiff(1:D.nchannels,a);
            p=plot(COH.f,squeeze(COH.rcgranger(a,i,:))-squeeze(COH.rcgranger(i,a,:)));
            legend(p,strrep(D.chanlabels(i),'_',' '),'Location','WestOutside')
            ylabel('Corrected granger causality')
            xlabel('Frequency [Hz]')
            xlim([3 45])
            title(strrep(D.chanlabels{a},'_',' '))
            subplot(1,3,3)
            wjn_plot_raw_signals(COH.f,squeeze(COH.rcgranger(a,i,:))-squeeze(COH.rcgranger(i,a,:)),D.chanlabels(setdiff(1:D.nchannels,a)));
            xlim([3 45])
            xlabel('Frequency [Hz]')
            myprint(fullfile(fpath,['GRANGER_' D.chanlabels{a} '_' fname]))
            hold off
        end
        close
        end
     
    end
    
end
save(fullfile(fpath,['COH_' fname]),'COH','-v7.3');
D.COH=COH;
save(D)






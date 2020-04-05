function wjn_recon_print_spw(filename,SPW,fpath)
disp('PRINT WAVEFORM CHARACTERISTICS.')

try
    D=spm_eeg_load(filename);
catch
    D=filename;
end

if ~exist('SPW','var')
    try
        SPW = D.SPW;
    catch
        [D,SPW]=wjn_recon_spw(D.fullfile);
    end
end

fname = D.fname;
fname =  fname(1:end-4);
if ~exist('fpath','var')
    fpath = wjn_recon_fpath(D.fullfile,'SPW');
end


ffs = sort(fieldnames(SPW.results));
figure('visible','off')
for a = 1:length(ffs)
    subplot(1,length(ffs),a)
    barh(SPW.results.(ffs{a}))
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
print(fullfile(fpath,['SPW_results_' fname(1:end-4) '.png']),'-dpng','-r90')
close


disp('WRITE WAVEFORM SHAPE RESULTS TO TABLE.')
T=struct2table(D.SPW.results,'RowNames',D.chanlabels);
T.Properties.DimensionNames{1} = 'Channels';
writetable(T,fullfile(fpath,['spw_results_' fname(1:end-4) '.csv']),'WriteRowNames',1)

disp('PRINT WAVE EVOKED POTENTIALS.')
figure('visible','off')

measures = {'data','tvalue'};
for n = 1:length(measures)
    for a = 1:length(D.SPW.avg.conditions)
        imagesc(SPW.avg.time,1:D.nchannels,squeeze(SPW.avg.(measures{n})(:,:,a)));
        axis xy
        title(strrep(D.SPW.avg.conditions{a},'_',' '))
        set(gca,'YTick',1:D.nchannels,'YTickLabel',wjn_strrep(D.chanlabels),'YTickLabelRotation',45)
        xlabel('Time [ms]')
        figone(40,20)
        hold off
        cb=colorbar;ylabel(cb,'T')
        print(fullfile(fpath,['SPW_WEP_' measures{n} '_' D.SPW.avg.conditions{a} '_' fname]),'-dpng','-r90')
        caxis([-3 3]);
    end
end
close

disp('PRINT WEP DELAYS AND PEAKS.')

for a = 1:length(measures)
    figure('visible','off')
    delays = SPW.avg.([measures{a} '_delays']);
    peaks = SPW.avg.([measures{a} '_peaks']);
    subplot(1,2,1)
    imagesc(delays')
    cb=colorbar;ylabel(cb,'Delay [ms]')
    set(gca,'XTick',1:size(delays,1),'XTickLabel',strrep(D.chanlabels,'_',' '),'XTickLabelRotation',90)
    set(gca,'YTick',1:size(delays,2),'YTickLabel',strrep(D.SPW.avg.conditions,'_',' '))
    if D.nchannels<20
        for b=1:size(delays,1)
            for c = 1:size(delays,2)
                text(b,c,num2str(delays(b,c),2),'color','w','FontSize',12)
            end
        end
    end
    title(measures{a})
    subplot(1,2,2)
    imagesc(peaks')
    cb=colorbar;ylabel(cb,'Z')
    set(gca,'XTick',1:size(peaks,1),'XTickLabel',strrep(D.chanlabels,'_',' '),'XTickLabelRotation',90)
    set(gca,'YTick',1:size(peaks,2),'YTickLabel',strrep(D.SPW.avg.conditions,'_',' '))
    if D.nchannels<20
        for b=1:size(delays,1)
            for c = 1:size(delays,2)
                text(b,c,num2str(peaks(b,c),2),'color','w','FontSize',12)
            end
        end
    end
    figone(40,80)
    
    print(fullfile(fpath,['SPW_' measures{a} '_peaks_' D.SPW.avg.conditions{a} '_' fname '.png']),'-dpng','-r90')
    close
    T=array2table([delays peaks],'RowNames',D.chanlabels,'VariableNames',[strcat('delay_',D.SPW.avg.conditions)' strcat('peak_',D.SPW.avg.conditions)']');
    writetable(T,fullfile(fpath,['SPW_peaks_' measures{a} '_' fname(1:end-4) '.csv']),'WriteRowNames',1)
end


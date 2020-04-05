function wjn_recon_print_bandpeaks(filename,fpath)
disp('PRINT BAND PEAKS.')

try
    D=spm_eeg_load(filename);
    try
        COH=D.COH;
    catch
        [~,COH]=wjn_recon_power(D.fullfile);
    end
    try
        bandpeaks = COH.bandpeaks;
    catch
        [~,bandpeaks]=wjn_recon_bandpeaks(COH);
    end
catch
    D=filename;
    try
        try
            COH=D.COH;
            try
                bandpeaks = COH.bandpeaks;
            catch
                [~,bandpeaks]=wjn_recon_bandpeaks(COH);
            end
        catch
            [~,COH]=wjn_recon_power(D.fullfile);
            [~,bandpeaks]=wjn_recon_bandpeaks(COH);
        end
    catch
        COH=D;
        try
            bandpeaks = COH.bandpeaks;
        catch
            [~,bandpeaks]=wjn_recon_bandpeaks(COH);
        end
    end
end



fname =  COH.fname(5:end-4);
if ~exist('fpath','var')
    fpath = wjn_recon_fpath(D.fullfile,'POW');
end

figure('visible','off')
for a = 1:length(bandpeaks.measures)
    cfname = ['bandpeaks_' bandpeaks.measures{a} '_' fname]; 
    subplot(2,1,1)
    data = bandpeaks.(bandpeaks.measures{a}).freq';
    imagesc(data)
    axis xy
    set(gca,'XTick',1:length(bandpeaks.channels),'XTickLabel',wjn_strrep(bandpeaks.channels),'XTickLabelRotation',45)
    set(gca,'YTick',1:length(bandpeaks.freqbands),'YTickLabel',wjn_strrep(bandpeaks.freqbands),'YTickLabelRotation',45)
    for b=1:size(data,1)
        for c = 1:size(data,2)
            text(c,b,num2str(data(b,c),2),'color','w','FontSize',20)
        end
    end
    title({wjn_strrep(fname);bandpeaks.measures{a};'Frequency'})
    colorbar
    subplot(2,1,2)
    data = bandpeaks.(bandpeaks.measures{a}).amp';
    imagesc(data)
    axis xy
    set(gca,'XTick',1:length(bandpeaks.channels),'XTickLabel',wjn_strrep(bandpeaks.channels),'XTickLabelRotation',45)
    set(gca,'YTick',1:length(bandpeaks.freqbands),'YTickLabel',wjn_strrep(bandpeaks.freqbands),'YTickLabelRotation',45)
    for b=1:size(data,1)
        for c = 1:size(data,2)
            text(c,b,num2str(data(b,c),2),'color','w','FontSize',20)
        end
    end
    title('Amplitude')
    colorbar
    figone(80,80)
    print(fullfile(fpath,[cfname '.png']),'-dpng','-r90');
    T=struct2table(bandpeaks.(bandpeaks.measures{a}),'RowNames',COH.channels);
    writetable(T,fullfile(fpath,['all_' cfname '.csv']))
    pf=strrep(strcat('PeakFreq_',bandpeaks.freqbands',num2str(bandpeaks.bandfreqs(:,1)),'_',num2str(bandpeaks.bandfreqs(:,2)),'Hz'),' ','');
    pa=strrep(strcat('PeakAmp_',bandpeaks.freqbands',num2str(bandpeaks.bandfreqs(:,1)),'_',num2str(bandpeaks.bandfreqs(:,2)),'Hz'),' ','');
    T=[array2table(bandpeaks.(bandpeaks.measures{a}).amp,'RowNames',COH.channels,'VariableNames',pa') array2table(bandpeaks.(bandpeaks.measures{a}).freq,'RowNames',COH.channels,'VariableNames',pf)];
    writetable(T,fullfile(fpath,[cfname '.csv']))
end
close 
    

function wjn_recon_print_bandaverage(filename,fpath)
disp('PRINT BAND AVERAGES.')
try
    D=spm_eeg_load(filename);
    try
        COH=D.COH;
    catch
        [~,COH]=wjn_recon_power(D.fullfile);
    end
    try
        bandaverage = COH.bandaverage;
    catch
        [~,bandaverage]=wjn_recon_bandaverage(COH);
    end
catch
    D=filename;
    try
        try
            COH=D.COH;
            try
                bandaverage = COH.bandaverage;
            catch
                [~,bandaverage]=wjn_recon_bandaverage(COH);
            end
        catch
            [~,COH]=wjn_recon_power(D.fullfile);
            [~,bandaverage]=wjn_recon_bandaverage(COH);
        end
    catch
        COH=D;
        try
            bandaverage = COH.bandaverage;
        catch
            [~,bandaverage]=wjn_recon_bandaverage(COH);
        end
    end
end



fname =  COH.fname(5:end-4);
if ~exist('fpath','var')
    try
        fpath = wjn_recon_fpath(D.fullfile,'BANDS');
    catch
        fpath='.';
    end
end

figure('visible','off')
for a = 1:length(bandaverage.measures)
    cfname = ['bandaverage_' bandaverage.measures{a} '_' fname]; 
    data = bandaverage.(bandaverage.measures{a})';
    if size(data,2) ~= length(bandaverage.channels)
        chans = bandaverage.cchannels;
    else
        chans = bandaverage.channels;
    end
    imagesc(data)
    axis xy
    set(gca,'XTick',1:length(chans),'XTickLabel',wjn_strrep(chans),'XTickLabelRotation',45)
    set(gca,'YTick',1:length(bandaverage.freqbands),'YTickLabel',wjn_strrep(bandaverage.freqbands),'YTickLabelRotation',45)
    for b=1:size(data,1)
        for c = 1:size(data,2)
            text(c,b,num2str(data(b,c),2),'color','w','FontSize',20)
        end
    end
    title({wjn_strrep(fname);bandaverage.measures{a}})
    colorbar
    figone(40,80)
    print(fullfile(fpath,[cfname '.png']),'-dpng','-r90')
    T=array2table(data,'VariableNames',chans,'RowNames',strrep(strcat(bandaverage.freqbands',' [',num2str(bandaverage.bandfreqs(:,1)),'-',num2str(bandaverage.bandfreqs(:,2)),' Hz]'),' ',''));
    writetable(T,fullfile(fpath,[cfname '.csv']))
end
close 
    

function wjn_recon_print_connectivity(filename,fpath)
disp('PRINT CONNECTIVITY.')

try
    D=spm_eeg_load(filename);
    try
        COH=D.COH;
    catch
        [~,COH]=wjn_recon_connectivity(D.fullfile);
    end
catch
    D=filename;
    try
        try
            COH=D.COH;
        catch
            [~,COH]=wjn_recon_connectivity(D.fullfile);
        end
    catch
        COH=D;
    end
end


fname =  COH.fname(5:end-4);
if ~exist('fpath','var')
    fpath = fullfile('.',['recon_connectivty_' fname]);
    mkdir(fpath)
end
measures = {'coh','icoh','plv','wpli','ccgranger'};

figure('visible','off')
for a = 1:length(measures)
    
    cfname = [measures{a} '_' fname];
    data = COH.(measures{a})';
    
    imagesc(1:length(COH.cchannels),COH.f,data)
    axis xy
    set(gca,'XTick',1:length(COH.cchannels),'XTickLabel',wjn_strrep(COH.cchannels),'XTickLabelRotation',45)
    ylabel('Frequency [Hz]')
    ylim([1 45])
    title({wjn_strrep(fname);measures{a}})
    colorbar
    figone(40,80)
    print(fullfile(fpath,[cfname '.png']),'-dpng','-r90')
    T=array2table(data,'VariableNames',COH.cchannels,'RowNames',cellstr(num2str(COH.f',4)));
    T.Properties.DimensionNames{1}='Frequency';
    writetable(T,fullfile(fpath,[cfname '.csv']),'WriteRowNames',1)
end
close


function wjn_recon_print_power(filename,fpath)
disp('PRINT POWER SPECTRA.')
try
    D=spm_eeg_load(filename);
    try
        COH=D.COH;
    catch
        [~,COH]=wjn_recon_power(D.fullfile);
    end
catch
    D=filename;
    try
        try
            COH=D.COH;
        catch
            [~,COH]=wjn_recon_power(D.fullfile);
        end
    catch
        COH=D;
    end
end


fname =  COH.fname(5:end-4);
if ~exist('fpath','var')
    try
        fpath = wjn_recon_fpath(D.fullfile,'POW');
    catch
        fpath='.';
    end
end
measures = {'mpow','rpow','logfit'};

figure('visible','off')
for a = 1:length(measures)
    cfname = ['power_' measures{a} '_' fname];
    data = COH.(measures{a})';
    imagesc(1:length(COH.channels),COH.f,data)
    axis xy
    set(gca,'XTick',1:length(COH.channels),'XTickLabel',wjn_strrep(COH.channels),'XTickLabelRotation',45)
    ylabel('Frequency [Hz]')
    ylim([1 90])
    title({wjn_strrep(fname);measures{a}})
    colorbar
    figone(40,80)
    print(fullfile(fpath,[cfname '.png']),'-dpng','-r90')
    rnum = 1+length(num2str(max(round(COH.f))));
    T=array2table(data,'VariableNames',COH.channels,'RowNames',cellstr(num2str(COH.f',rnum)));
    writetable(T,fullfile(fpath,[cfname '.csv']))
end
close


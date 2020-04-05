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

if ~isfield(COH,'cchannels')
    COH.cchannels = strcat(COH.chancomb(:,1),'__',COH.chancomb(:,2));
end

fname =  COH.fname(5:end-4);
if ~exist('fpath','var')
     fpath = wjn_recon_fpath(D.fullfile,'COH');
end
measures = {'coh','icoh','plv','wpli','ccgranger'};

figure('visible','off')
for a = 1:length(measures)
    data = COH.(measures{a})';
    for b = 1:length(COH.channels)
        cfname = [measures{a} '_' COH.channels{b} '_' fname];
        i=wjn_cohfinder(COH.channels{b},COH.channels,COH.chancomb,1);

        imagesc(1:length(i),COH.f,data(:,i))
        axis xy
        set(gca,'XTick',1:length(i),'XTickLabel',wjn_strrep(COH.cchannels(i)),'XTickLabelRotation',45)
        ylabel('Frequency [Hz]')
        ylim([1 45])
        title({wjn_strrep(fname);wjn_strrep(COH.channels{b});measures{a}})
        colorbar
        figone(40,80)
        print(fullfile(fpath,[cfname '.png']),'-dpng','-r90')
    end
    rnum = 1+length(num2str(max(round(COH.f))));
    T=array2table(data,'VariableNames',COH.cchannels,'RowNames',cellstr(num2str(COH.f',rnum)));
    T.Properties.DimensionNames{1}='Frequency';
    writetable(T,fullfile(fpath,[cfname '.csv']),'WriteRowNames',1)
end
close


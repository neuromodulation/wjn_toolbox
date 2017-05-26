[files,dir] = uigetfile('*.mat','Select SPM file','MultiSelect','on')
files = cellstr(files)
for nfiles = 1:length(files);
    try
        S=[];
        D=spm_eeg_load(files{nfiles})
        S.D = D.fullfile;
        S.condition = D.condlist;
        S.channels = D.chanlabels(D.indchantype('LFP'));
    catch
        S=[];
        F = load(files{nfiles});
        channels = fieldnames(F);
        cond = spm_input('Condition: ',[],'s');
        S.D = files{nfiles};
        S.condition = cond;
        S.channels = channels;
    end
    S.freq = [1 100];
    S.freqd = 300;
    S.timewin = 3.41;
    S.normfreq = [5 95];
    C=spm_eeg_fft(S)
    %% tf
    for nc = 1:length(S.channels);
    figure
    imagesc(C.time,C.f,log(squeeze(C.pow(:,nc,:))'));axis xy;
    xlabel('Time [s]');
    ylabel('Frequency [Hz]');
    figone(7,14);
    colorbar;
    ID = files{nfiles}(1:5);
    title(strrep([ID '_' D.condlist{1} '_' S.channels{nc}],'_',' '));
    myprint([ID '_' D.condlist{1} '_' S.channels{nc} '_TF']);
    
    figure
    myline(C.f,C.rpow(nc,:));
    figone(7);
    xlabel('Frequency [Hz]');
    ylabel('Relative spectral power [%]');
    xlim([3 40]);
    ylim([0 20]);
    title(strrep([ID '_' D.condlist{1} '_' S.channels{nc}],'_',' '))
    myprint([ID '_' D.condlist{1} '_' S.channels{nc} '_Power_Spectrum']);
    end
end
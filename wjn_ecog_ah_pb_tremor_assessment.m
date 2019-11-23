close all
files = ffind('tf*.mat')
for a = 1:length(files)
    D=wjn_sl(files{a});
    figure
    subplot(2,1,1)
    f=squeeze(D.nforce(:,D.timeind.no_move));
    
    ff = wjn_quickfilter(f,D.fsample,[1 9]);
    plot(D.time(D.timeind.no_move),ff);
    hold on
    %     plot(D.time(D.timeind.move_both),D.force(:,D.timeind.move_both))
    title(D.id)
    subplot(2,1,2);
    [pow,f]=wjn_raw_fft(ff(:,D.fsample:end-D.fsample),D.fsample,2048);
    plot(f,pow);
    xlim([2 10])
    
    if strcmp(D.id(1:2),'WO')
        D.ftremor = 2.7;
    elseif strcmp(D.id(1:2),'VK')
        D.ftremor = 3.9;
    elseif strcmp(D.id(1:2),'SE')
        D.ftremor = 4.1;
    elseif strcmp(D.id(1:2),'MK')
        D.ftremor = 5.5;
    elseif strcmp(D.id(1:2),'MM')
        D.ftremor = 2.7;
    elseif strcmp(D.id(1:2),'JM')
        D.ftremor = 3.9;
    else
        D.ftremor = nan;
    end
    %     save(D)
    
end

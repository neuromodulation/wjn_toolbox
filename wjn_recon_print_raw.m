function wjn_recon_print_raw(filename,fpath)
disp('PRINT RAW DATA.')
try
    D=spm_eeg_load(filename);
catch
    D=filename;
end

fname =  D.fname;fname = fname(1:end-4);
if ~exist('fpath','var')
    fpath = wjn_recon_fpath(D.fullfile,'RAW');
end


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
print(fullfile(fpath,['raw_' fname]),'-dpng','-r90');
savefig(fullfile(fpath,['raw_' fname '.fig']))
close


ix = randi([round(D.time(1)) round(D.time(end)-10)-1]);
figure('visible','off')
wjn_plot_raw_signals(D.time(D.indsample(ix):D.indsample(ix+10)),D(:,D.indsample(ix):D.indsample(ix+10)),strrep(D.chanlabels,'_',' '));
xlabel('Time [s]')
figone(40,40)
print(fullfile(fpath,['raw_zoom_' fname '.png']),'-dpng','-r90');

if D.time(end)>20
    ix = randi(round(D.time(end)-10)-1);
    figure('visible','off')
    wjn_plot_raw_signals(D.time(D.indsample(ix):D.indsample(ix+10)),D(:,D.indsample(ix):D.indsample(ix+10)),strrep(D.chanlabels,'_',' '));
    xlabel('Time [s]')
    figone(40,40)
    print(fullfile(fpath,['raw_zoom_' fname '.png']),'-dpng','-r90');
    close
end


function wjn_plot_tf_sensor(filename,cond,timerange,freqranges)

D=wjn_sl(filename);


freq = D.fttimelock;
freq.powspctrm = freq.powspctrm(ci(cond,D.conditions),:,:,:);
cfg = [];
cfg.layout = D.sensors('eeg');
cfg.xlim = timerange;
for c = 1:size(freqranges,1)
    cfg.ylim = freqranges(c,:);
    cfg.elec = D.sensors('eeg');
    ft_topoplotTFR(cfg,freq)
    drawnow
%     myprint(['topoTFR_' cond '_' fname(1:end-4)])
end
function bfreq = wjn_ft_baseline(freq,baseline)
cfg = [];
cfg.baselinetype = 'relchange';
cfg.baseline = baseline;
bfreq = ft_freqbaseline(cfg,freq);
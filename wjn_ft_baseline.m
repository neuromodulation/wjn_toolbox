function bfreq = wjn_ft_baseline(tf,baseline)
for a = 1:length(tf)
    if iscell(tf)
        freq = tf{a};
    else
        freq = tf;
    end
    cfg = [];
    cfg.baselinetype = 'relchange';
    cfg.baseline = baseline;
    bfreq{a} = ft_freqbaseline(cfg,freq);
end
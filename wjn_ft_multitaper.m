function freq=wjn_ft_multitaper(data,freq)

if ~exist('freq','var')
    freq = 1:100;
end


if length(data.trial)==1
    cfg=[];
    cfg.refchannel = 'LFPR1';
    data = ft_preprocessing(cfg,data);
    cfg = [];
    cfg.length = 1024/data.fsample;
    cfg.overlap = .5;
    data = ft_redefinetrial(cfg,data);
end


cfg =[];
cfg.method = 'mtmfft';
cfg.output = 'pow';
cfg.taper = 'hanning';
cfg.keeptrials = 'no';
cfg.keeptapers='no';
cfg.pad = 'nextpow2';
cfg.padding = 2;
inp = ft_freqanalysis(cfg,sdata);



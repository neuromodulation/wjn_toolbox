function [pow,f,freq]=wjn_ft_multitaper(data)


cfg =[];
cfg.method = 'mtmfft';
cfg.output = 'pow';
cfg.taper = 'dpss';
cfg.tapsmofrq=2;
cfg.keeptrials = 'no';
cfg.keeptapers='no';
cfg.pad = 'nextpow2';
cfg.padding = 2;
freq = ft_freqanalysis(cfg,data);
pow=freq.powspctrm;
f=freq.freq;


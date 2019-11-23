function data = wjn_ft_filt_hilbert(data,fhz)



cfg = [];
cfg.padding = .5; %filtereckeneffekt aus
cfg.lpfilter = 'yes';
cfg.lpfreq = fhz(2);
cfg.hpfilter = 'yes';
cfg.hpfreq = fhz(1);
cfg.detrend = 'yes'; %ultralowe schwankungen rausrechnen
cfg.demean = 'yes'; %s.o. %envelope in neg und pos amps
data = ft_preprocessing(cfg,data); 

cfg = [];
cfg.hilbert = 'abs';
data = ft_preprocessing(cfg,data); 
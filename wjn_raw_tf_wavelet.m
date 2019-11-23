function [tf,f,t,pow] = wjn_raw_tf_wavelet(idata,fsample,f,nfsample)


data.trial{1} = idata;
data.time{1} = linspace(0,length(idata)/fsample,length(idata));
data.label = {'raw'};
data.fsample = fsample;

cfg = [];
cfg.trials = 1;
cfg.channel = 'all';
cfg.method = 'wavelet';
cfg.width = 10;
cfg.output = 'pow';
cfg.foi = f;
cfg.pad = 'nextpow2';
% cfg.pa
cfg.toi = [data.time{1}(1) :1/nfsample:data.time{1}(end)];
tf=ft_freqanalysis(cfg,data);

t = tf.time;
f = tf.freq;
tf = squeeze(tf.powspctrm);
pow = nanmean(tf,2);
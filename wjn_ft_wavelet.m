function freq=wjn_ft_wavelet(data,fsample)

if ~exist('fsample','var')
    fsample = 20;
end


if length(data.trial)==1
    cfg = [];
    cfg.length = 2048/data.fsample;
    cfg.overlap = .5;
    tdata = ft_redefinetrial(cfg,data);
end



cfg = [];
cfg.method = 'wavelet';
cfg.output = 'pow';
cfg.foi = [1:100];
cfg.pad = 'nextpow2';
cfg.toi = [data.time{1}(1) :1/fsample:data.time{1}(end)];
freq = ft_freqanalysis(cfg,data);


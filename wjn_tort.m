
D=wjn_downsample(D.fullfile,600);

data = D.ftraw(0);

data = ft_preprocessing([],data)

cfg = [];
% cfg.method = 'hilbert';
    cfg = [];
%     cfg.trials = find(data.trialinfo==conds(a));
%     cfg.channel = chs;
    cfg.method = 'wavelet';
    cfg.width = 10;
    cfg.output = 'fourier';
    cfg.foi = [15:35];
    cfg.pad = 'nextpow2';
    cfg.toi = [data.time{1}(1) :1/data.fsample:data.time{1}(end)];
freqlow=ft_freqanalysis(cfg,data)
    
freqlow.freq = round(freqlow.freq)
% cfg.method = 'hilbert';
    cfg = [];
%     cfg.trials = find(data.trialinfo==conds(a));
%     cfg.channel = chs;
    cfg.method = 'wavelet';
    cfg.width = 10;
    cfg.output = 'fourier';
    cfg.foi = [35:120];
    cfg.pad = 'nextpow2';
    cfg.toi = [data.time{1}(1) :1/data.fsample:data.time{1}(end)];
freqhigh=ft_freqanalysis(cfg,data)

freqhigh.freq = round(freqhigh.freq)

cfg = [];
cfg.freqlow = [25];
cfg.freqhigh = [60];
cfg.chanlow = 'all';
cfg.chanhigh = 'all';
cfg.keeptrials = 'yes';
cfg.method = 'mvl';
pac = ft_crossfrequencyanalysis(cfg,freqlow,freqhigh);


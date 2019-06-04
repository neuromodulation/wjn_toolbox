function freq=wjn_ft_wavelet(data,fsample,chs,conds)

if ~exist('fsample','var')
    fsample = 20;
end




if length(data.trial)==1
    cfg = [];
    cfg.length = 2048/data.fsample;
    cfg.overlap = .5;
    tdata = ft_redefinetrial(cfg,data);
    data = tdata;
end

% keyboard
if ~exist('conds','var')
    conds= unique(data.trialinfo);
end

if ~exist('chs','var')
    chs= 'all';
end

for a = 1:length(conds)
    cfg = [];
    cfg.trials = find(data.trialinfo==conds(a));
    cfg.channel = chs;
    cfg.method = 'wavelet';
    cfg.width = 10;
    cfg.output = 'pow';
    cfg.foi = [1:200];
    cfg.pad = 'nextpow2';
    cfg.toi = [data.time{1}(1) :1/fsample:data.time{1}(end)];
    freq{a} = ft_freqanalysis(cfg,data);
end

% layout = D.sensors('EEG');

% save(['ft_' D.fname],freq,layout)

function wjn_eeg_fft(filename)

D=wjn_sl(filename);
data = D.ftraw(0);
data.elec = D.sensors('EEG');

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

ntrials = unique(data.trialinfo);

for a = 1:length(ntrials)
    cfg = [];
    cfg.trials = find(data.trialinfo==a);
    cfg.method = 'wavelet';
    cfg.output = 'pow';
    cfg.foi = [1:100];
    cfg.pad = 'nextpow2';
    cfg.toi = [data.time{1}(1) :1/fsample:data.time{1}(end)];
    freq{a} = ft_freqanalysis(cfg,data);
end

layout = D.sensors('EEG');

save(['ft_' D.fname],freq,layout)
% 
% freq{3} = freq{1};
% freq{3}.powspctrm = freq{1}.powspctrm-freq{2}.powspctrm;
% 
% cfg = [];
% cfg.layout = layout;
% cfg.xlim = [0 .5];
% cfg.ylim = [60 80];
% cfg.highlight = 'labels'
% cfg.highlightchannel = {'Cz','C3','C4'};
% % cfg.baseline = [-2.25 -1.5];
% % cfg.baselinetype = 'relative';
% cfg.highlightsize=8;
% ft_topoplotTFR(cfg,freq{3})
% 
% 

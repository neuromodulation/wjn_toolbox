function wjn_eeg_topoplot(filename,freqrange)

D=spm_eeg_load(filename);

%%
data=    D.fttimelock;

cfg=[];
cfg.detrend = 'yes';
% cfg.demean = 'yes';
% cfg.reref = 'yes';
% % cfg.refchannel = 'Fz';
data = ft_preprocessing(cfg,data);

cfg=[];
cfg.method='mtmfft';
cfg.foilim =[2 47]; 
cfg.tapsmofrq = 4;
freq=ft_freqanalysis(cfg,data);
cfg=[];
if exist('freqrange','var')
    cfg.xlim=freqrange;
end
ft_topoplotER(cfg,freq)
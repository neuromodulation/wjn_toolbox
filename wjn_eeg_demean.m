function D=wjn_eeg_demean(filename)

D=wjn_sl(filename);
data = D.ftraw;
sens = D.sensors('EEG');
cfg = [];
cfg.demean='yes';
cfg.detrend = 'yes';
cfg.standardize = 'yes';
ndata = ft_preprocessing(cfg,data);
% keyboard

% keyboard
D=clone(D,fullfile(D.path,['z' D.fname]));
for a = 1:length(ndata.trial)
    D(:,:,a)=ndata.trial{a};
end
save(D)

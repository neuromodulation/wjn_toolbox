function D=wjn_linefilter(filename)

D=spm_eeg_load(filename);


cfg = [];
cfg.dftfilter = 'yes';
cfg.dftfreq = [47 53; 97 103];
data = ft_preprocessing(cfg,D.ftraw(0));

for a = 1:length(data.trial)
    d(:,:,a) = data.trial{a};
end

D=wjn_spm_copy(D.fullfile,['lf' D.fname]);
D(:,:,:)=d;
save(D);


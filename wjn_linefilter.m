function D=wjn_linefilter(filename)

D=spm_eeg_load(filename);

chans = 1:D.nchannels;

iother = D.indchantype('Other');
chans(iother)=[];

cfg = [];
cfg.dftfilter = 'yes';
cfg.dftfreq = [47 53; 97 103;147 153;197 203;247 253];
% cfg.bsfilter = 'yes';
% cfg.bsfreq = [48 52;98 102];
cfg.channel = chans;
data = ft_preprocessing(cfg,D.ftraw(0));

for a = 1:length(data.trial)
    d(chans,:,a) = data.trial{a};
end

D=wjn_spm_copy(D.fullfile,['lf' D.fname]);
D(chans,:,:)=d;
save(D);


function [D,COH]=wjn_recon_power(filename,normfreq)
disp('COMPUTE POWER SPECTRA.')
try
    D=spm_eeg_load(filename);
catch
    D=filename;
end

if ~exist('normfreq','var')
    normfreq = [5 45; 55 95];
end


data = D.ftraw(0);
cfg            = []; 
cfg.continuous = 'yes';
cfg.lpfilter='yes';
cfg.lpfreq = D.fsample/2.5;
cfg.padding = 2;
data           = ft_preprocessing(cfg,data);

cfg         = [];
cfg.length  = 2;
cfg.overlap = 0.5;
data        = ft_redefinetrial(cfg, data);

Ntrials = length(data.trial);
cfg.method = 'mtmfft';
cfg.output = 'pow';
cfg.taper = 'dpss';
cfg.tapsmofrq=3;
cfg.keeptrials = 'yes';
cfg.keeptapers='no';
cfg.pad = 'nextpow2';
cfg.padding = 2;
inp = ft_freqanalysis(cfg,data);

pow = inp.powspctrm;
mpow = squeeze(nanmean(pow,1));

if min(size(mpow))==1
    mpow=mpow';
end
inorm=[wjn_sc(inp.freq,normfreq(1,1)):wjn_sc(inp.freq,normfreq(1,2)) wjn_sc(inp.freq,normfreq(1,2)):wjn_sc(inp.freq,normfreq(2,2))];
sump = nansum(mpow(:,inorm),2);
stdp = nanstd(mpow(:,inorm),[],2);
logfit = fftlogfitter(inp.freq',mpow)';

for a=1:size(mpow,1)
    rpow(a,:) = (mpow(a,:)./sump(a)).*100;
    spow(a,:) = (mpow(a,:)./stdp(a));
end

fname = D.fname;
COH = [];
COH.name = fname(1:length(fname)-4);
COH.dir = cd;
fnsave = ['COH_' strrep(D.condlist{1},' ','_') '_' fname];
COH.fname = fnsave;
COH.fs = D.fsample;
COH.condition = D.condlist;
COH.chantype = D.chantype;
COH.badchannels = D.badchannels;
COH.nseg = Ntrials;
COH.tseg = D.nsamples/D.fsample;
COH.time = linspace(0,COH.tseg*COH.nseg,COH.nseg);
COH.channels = inp.label;
COH.f = inp.freq;
COH.freq = [inp.freq(1) inp.freq(2)];
COH.rpow = rpow;
COH.spow = spow;
COH.logfit = logfit;
COH.pow = permute(pow,[2,3,1]);
COH.mpow = mpow;
D.COH=COH;
save(D)
[fpath,fname] = wjn_recon_fpath(D.fullfile,'POW');
save(fullfile(fpath,['POW_' fname '.mat']),'COH');

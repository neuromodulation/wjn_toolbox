function [Dpow,Dcoh,Dicoh,Dspow,Dsicoh]=wjn_tf_wavelet_coherence(filename,chancomb,f,nfsample)

if ~exist('f','var')
    f=1:100;
end
D=spm_eeg_load(filename);

if ~exist('nfsample','var')
    subsample = 1;
else
    subsample = D.fsample/nfsample;
end


data = D.fttimelock;




cfg = [];
cfg.output = 'powandcsd';
cfg.method = 'wavelet';
cfg.foi = f;
cfg.toi = linspace(D.time(1),D.time(end),D.nsamples/subsample);
cfg.keeptrials = 'yes';
cfg.channel = D.chanlabels;
cfg.channelcmb = chancomb;
freq = ft_freqanalysis(cfg,data);

spow = [];

for a = 1:length(D.conditions);
    spow(:,:,:,a) = freq.powspctrm(a,:,:,:);  
end
Dspow = clone(D,['tf' D.fname],size(spow));
Dspow(:,:,:,:) = spow;
Dspow = frequencies(Dspow, ':', freq.freq);
Dspow = fsample(Dspow, 1./mean(diff(freq.time)));
Dspow = timeonset(Dspow, freq.time(1));
Dspow = check(Dspow);

save(Dspow);

clear spow 

pow = [];
coh = [];
icoh =[];
for a = 1:length(D.condlist);
    i = ci(D.condlist{a},D.conditions); 
    pow(:,:,:,a) = nanmean(freq.powspctrm(i,:,:,:),1);  
end

dim = size(pow);
if a == 1;
    dim(4) = 1;
end

Dpow = clone(D,['mtf' D.fname],dim);

    Dpow(:,:,:,:) = pow(:,:,:,:);

Dpow = conditions(Dpow,':',D.condlist);
Dpow = frequencies(Dpow, ':', freq.freq);
Dpow = fsample(Dpow, 1./mean(diff(freq.time)));
Dpow = timeonset(Dpow, freq.time(1));
Dpow = check(Dpow);
save(Dpow);
clear pow

for a = 1:length(D.condlist);
    i = ci(D.condlist{a},D.conditions); 
    cfg = [];
    cfg.method = 'coh';
    cfg.trials = i;
    fd = ft_connectivityanalysis(cfg,freq);
    coh(:,:,:,a) = fd.cohspctrm(:,:,:);
end
clear chs
for a = 1:size(fd.labelcmb,1)
    chs{a} = [fd.labelcmb{a,1} '-' fd.labelcmb{a,2}];
end

Dcoh = clone(Dpow,['mcoh' D.fname],size(coh));
Dcoh(:,:,:,:) = coh(:,:,:,:);
Dcoh = chanlabels(Dcoh,':',chs);
Dcoh = check(Dcoh);
save(Dcoh);
clear coh fd

for a = 1:length(D.condlist);
    cfg = [];
    cfg.method = 'coh';
    cfg.trials = i;
    cfg.complex = 'imag';
    id = ft_connectivityanalysis(cfg,freq);
    icoh(:,:,:,a) = abs(id.cohspctrm(:,:,:));
end
clear id

Dicoh = clone(Dcoh,['micoh' D.fname],size(icoh));
Dicoh(:,:,:,:) = icoh(:,:,:,:);
Dicoh = chanlabels(Dicoh,':',chs);
Dicoh = check(Dicoh);
save(Dicoh);

for a = 1:length(D.conditions);
    cfg = [];
    cfg.method = 'coh';
    cfg.trials = a;
    cfg.complex = 'imag';
    id = ft_connectivityanalysis(cfg,freq);
    sicoh(:,:,:,a) = abs(id.cohspctrm(:,:,:));
end
clear id

Dsicoh = clone(Dcoh,['icoh' D.fname],size(sicoh));
Dsicoh(:,:,:,:) = sicoh(:,:,:,:);
Dsicoh = conditions(Dsicoh,':',D.conditions);
Dsicoh = chanlabels(Dsicoh,':',chs);
Dsicoh = check(Dsicoh);
save(Dsicoh);
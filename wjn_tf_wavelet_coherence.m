function [Dicoh,Dwpli,Dcoh,Dpow]=wjn_tf_wavelet_coherence(filename,chancomb,f,nfsample,keeptrials)

if ~exist('keeptrials','var')
    keeptrials = 0;
end

if ~exist('f','var')
    f=1:100;
end
D=spm_eeg_load(filename);

origname = D.fname;

if ~exist('nfsample','var')
    subsample = D.fsample/25;
else
    subsample = D.fsample/nfsample;
end

% keyboard

try
    data = D.fttimelock;
    raw=0;
catch
    data = D.ftraw;
    
    raw = 1;
end



cfg = [];
cfg.output = 'powandcsd';
cfg.method = 'wavelet';

% cfg.method     = 'mtmfft';
% cfg.foilim     = [1 100];
% cfg.tapsmofrq  = 5;

% cfg.
cfg.foi = f;
cfg.toi = linspace(D.time(1),D.time(end),D.nsamples/subsample);
if ~raw
    cfg.keeptrials = 'yes';
end


cfg.pad = 'nextpow2';
cfg.channel = D.chanlabels;
cfg.channelcmb = chancomb;
cfg.width = 10;
cfg.gwidth = 5;
freq = ft_freqanalysis(cfg,data);

if keeptrials && ~raw
spow = [];
for a = 1:length(D.conditions)
    spow(:,:,:,a) = freq.powspctrm(a,:,:,:);  
end
Dspow = clone(D,['tf' D.fname],size(spow));
Dspow(:,:,:,:) = spow;
Dspow = frequencies(Dspow, ':', freq.freq);
Dspow = fsample(Dspow, 1./mean(diff(freq.time)));
Dspow = timeonset(Dspow, freq.time(1));
% Dspow = check(Dspow);
% save(Dspow);
clear spow 
end

pow = [];
coh = [];
icoh =[];
for a = 1:length(D.condlist)
    i = ci(D.condlist{a},D.conditions,1); 
    pow(:,:,:,a) = nanmean(freq.powspctrm(i,:,:,:),1);  
end


dim = size(pow);
if a == 1
    dim(4) = 1;
end

Dpow = clone(D,['mtf' D.fname],dim);
Dpow = frequencies(Dpow,':',f);
    Dpow(:,:,:,:) = pow(:,:,:,:);

Dpow = conditions(Dpow,':',D.condlist);
Dpow = frequencies(Dpow, ':', freq.freq);
Dpow = fsample(Dpow, 1./mean(diff(freq.time)));
Dpow = timeonset(Dpow, freq.time(1));
Dpow = check(Dpow);
save(Dpow);
clear pow

% keyboard
for a = 1:length(D.condlist)
    i = ci(D.condlist{a},D.conditions,1); 
    cfg = [];
    cfg.method = 'coh';
    cfg.trials = i;
    fd = ft_connectivityanalysis(cfg,freq);
    coh(:,:,:,a) = fd.cohspctrm(:,:,:);
    cfg.method = 'wpli';
    cfg.debias =1;
    fd = ft_connectivityanalysis(cfg,freq);
    fd.cohspctrm(fd.wplispctrm==0)=nan;
    wpli(:,:,:,a) = fd.wplispctrm(:,:,:);
end

dim = size(coh);
if a==1
    dim(4) = 1;
end

clear chs
for a = 1:size(fd.labelcmb,1)
    chs{a} = [fd.labelcmb{a,1} '-' fd.labelcmb{a,2}];
end
% keyboard
Dcoh = clone(Dpow,['mcoh' D.fname],dim);
Dcoh(:,:,:,:) = coh(:,:,:,:);
Dcoh = chanlabels(Dcoh,':',chs);
Dcoh = check(Dcoh);
save(Dcoh);

Dwpli = clone(Dcoh,['mwpli' D.fname],dim);
wpli(wpli<0)=0;
Dwpli(:,:,:,:) = wpli(:,:,:,:);
Dwpli=check(Dwpli);
save(Dwpli);
clear coh fd

for a = 1:length(D.condlist)
    cfg = [];
    cfg.method = 'coh';
    i = ci(D.condlist{a},D.conditions,1); 
    cfg.trials = i;
    cfg.complex = 'imag';
    id = ft_connectivityanalysis(cfg,freq);
    id.cohspctrm(id.cohspctrm==0)=nan;
    icoh(:,:,:,a) = abs(id.cohspctrm(:,:,:));
end
clear id

Dicoh = clone(Dcoh,['micoh' D.fname],dim);
Dicoh(:,:,:,:) = abs(icoh(:,:,:,:));
Dicoh = chanlabels(Dicoh,':',chs);
Dicoh = check(Dicoh);
save(Dicoh);


if keeptrials
    for a = 1:length(D.conditions)
        cfg = [];
        cfg.method = 'coh';
        cfg.trials = a;
        cfg.complex = 'imag';
        id = ft_connectivityanalysis(cfg,freq);
        id.cohspctrm(id.cohspctrm==0)=nan;
        sicoh(:,:,:,a) = abs(id.cohspctrm(:,:,:));
    end
    clear id

    Dsicoh = clone(Dcoh,['icoh' D.fname],size(sicoh));
    Dsicoh(:,:,:,:) = sicoh(:,:,:,:);
    Dsicoh = conditions(Dsicoh,':',D.conditions);
    Dsicoh = chanlabels(Dsicoh,':',chs);
    Dsicoh = check(Dsicoh);
    save(Dsicoh);
    
end

if ~strcmp(origname(1:9),'shuffled_')
sD = wjn_spm_copy(filename,['shuffled_' D.fname]);
% 
for a = 1:sD.nchannels
    sD(a,:,:) = sD(a,randperm(sD.nsamples),:);
end
save(sD);
[sDicoh,sDwpli,sDcoh]=wjn_tf_wavelet_coherence(sD.fullfile,chancomb,f,nfsample,keeptrials);
% % keyboard
Dicoh.sicoh = sDicoh(:,:,:,:);
Dwpli.swpli = sDwpli(:,:,:,:);
Dcoh.scoh = sDcoh(:,:,:,:);
save(Dicoh)
save(Dwpli)
save(Dcoh)
% keyboard
end
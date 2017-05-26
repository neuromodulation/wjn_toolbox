function [Dtf,Dcoh,Dicoh]=wjn_tf_wavelet_coherence(filename,freqrange,timewin)

data = D.fttimelock;




cfg = [];
cfg.output = 'powandcsd';
cfg.method = 'wavelet';
cfg.foi = [1:400];
cfg.toi = [-2:.05:2];
cfg.keeptrials = 'yes';
cfg.channel = D.chanlabels;
cfg.channelcmb = [coherence_finder(sources{1},'LFP',Df.chanlabels); coherence_finder([sources{1} 'LFP'],'EMG',Df.chanlabels)]; 

freq = ft_freqanalysis(cfg,data);
pow = [];
coh = [];
icoh =[];
for a = 1:length(D.condlist);
    i = ci(D.condlist{a},D.conditions); 
    pow(:,:,:,a) = nanmean(freq.powspctrm(i,:,:,:),1);  
    cfg = [];
    cfg.method = 'coh';
    cfg.trials = i;
    fd = ft_connectivityanalysis(cfg,freq);
    coh(:,:,:,a) = fd.cohspctrm(:,:,:);
    cfg.complex = 'imag';
    id = ft_connectivityanalysis(cfg,freq);
    icoh(:,:,:,a) = id.cohspctrm(:,:,:);
end


figure
imagesc(fd.time,fd.freq,squeeze(mean(mean(coh(1,:,:,ci('left-bp',D.conditions)),1),4))),axis xy

Dpow = clone(D,['mtf' D.fname],size(pow));
Dpow(:,:,:,:) = pow(:,:,:,:);
Dpow = conditions(Dpow,':',D.condlist);
Dpow = frequencies(Dpow, ':', freq.freq);
Dpow = fsample(Dpow, 1./mean(diff(freq.time)));
Dpow = timeonset(Dpow, freq.time(1));
Dpow = check(Dpow);
save(Dpow);

for a = 1:size(fd.labelcmb)
    chs{a} = [fd.labelcmb{a,1} '-' fd.labelcmb{a,2}];
end

Dcoh = clone(Dpow,['mcoh' D.fname],size(coh));
Dcoh(:,:,:,:) = coh(:,:,:,:);
Dcoh = chanlabels(Dcoh,':',chs);
Dcoh = check(Dcoh);
save(Dcoh);

Dicoh = clone(Dcoh,['micoh' D.fname],size(coh));
Dicoh(:,:,:,:) = icoh(:,:,:,:);
Dicoh = chanlabels(Dicoh,':',chs);
Dicoh = check(Dicoh);
save(Dicoh);
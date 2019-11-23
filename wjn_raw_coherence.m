function [icoh,f,tf,t]=wjn_raw_coherence(d1,d2,fs)

%%
clear mcoh icoh micoh sicoh scoh
data = [];
data.label = {'one','two'};
data.trial{1} = [d1;d2];
data.time{1} = linspace(1,length(d1)./fs,length(d1));
data.trialinfo = 1;

% cfg = [];
% cfg.resamplefs = 50;
% data=ft_resampledata(cfg,data);

for a=1:1
    cdata = data;
    if a>1
        cdata.trial{1}(1,:)=cdata.trial{1}(1,randperm(size(cdata.trial{1},2)));
    end
    
% 
% cfg = [];
% cfg.length    = 1;
% cfg.overlap  = .3;
% data = ft_redefinetrial(cfg,data);



cfg =[];
% cfg.method = 'mtmfft';
% cfg.taper = 'hanning';

cfg.method = 'wavelet';


cfg.output ='powandcsd';
cfg.toi = data.time{1};
cfg.foi = [1:80];
cfg.width = 7;
cfg.keeptrials = 'yes';
cfg.keeptapers='no';
cfg.pad = 'nextpow2';
cfg.padding = 2;
inp = ft_freqanalysis(cfg,cdata);

cfg1 = [];
cfg1.method = 'coh';
% coh = ft_connectivityanalysis(cfg1, inp);
cfg2 = cfg1;
cfg2.complex = 'imag';
icoh = ft_connectivityanalysis(cfg2, inp);
if a==1
% mcoh(a,:) = abs(squeeze(nanmean(coh.cohspctrm,3)));
micoh(a,:) = abs(squeeze(nanmean(icoh.cohspctrm,3)));
tf = squeeze(icoh.cohspctrm);
t = icoh.time;
else
%     scoh(a-1,:)=abs(squeeze(nanmean(coh.cohspctrm,3)));
    sicoh(a-1,:) = abs(squeeze(nanmean(icoh.cohspctrm,3)));
end
end

f = icoh.freq;
icoh = micoh;

function [icoh,f,tf,t]=wjn_raw_wpli(d1,d2,fs)

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
    

cfg = [];
cfg.length    =2;
cfg.overlap  = .5;
data = ft_redefinetrial(cfg,data);

cfg =[];
% cfg.foi=1:80;
cfg.method = 'mtmfft';
cfg.output = 'fourier';
cfg.taper = 'hanning';
cfg.keeptrials = 'yes';
cfg.keeptapers='no';
cfg.tapsmofrq=5;
cfg.pad = 'nextpow2';
cfg.padding = 2;
inp = ft_freqanalysis(cfg,data);


cfg1 = [];
cfg1.method = 'coh';
coh = ft_connectivityanalysis(cfg1, inp);
cfg2 = cfg1;
cfg2.complex = 'imag';
icoh = ft_connectivityanalysis(cfg2, inp);

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

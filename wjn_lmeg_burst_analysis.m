D=wjn_sl('efspm*.mat')

data = D.fttimelock(2);

cfg = [];
cfg.resamplefs = 200;
data = ft_resampledata(cfg,data);

cfg = [];
cfg.hpfilter = 'yes';
cfg.hpfreq = 10;
cfg.lpfilter = 'yes';
cfg.lpfreq = 35;
% cfg.hilbert = 'abs';
cfg.rectify = 'yes';
cfg.demean = 'yes';
cfg.detrend = 'yes';
beta = ft_preprocessing(cfg,data);

cfg.hpfreq = 45;
cfg.lpfreq = 95;
gamma = ft_preprocessing(cfg,data);

for a = 1:size(beta.trial,1)
    beta.trial(a,1,:) = wjn_smoothn(beta.trial(a,1,:),20);
    gamma.trial(a,1,:) = wjn_smoothn(gamma.trial(a,1,:),20);
end
i = ci('cue',D.conditions);
baseline = beta.trial(i,1,wjn_sc(beta.time,-2):wjn_sc(beta.time,-.5));
baseline = reshape(squeeze(baseline)',[size(baseline,1)*size(baseline,3),1]);

bthresh = prctile(baseline,75);
[bduration,n] = bwlabeln(baseline>=bthresh);

for a = 1:length(i)
    d = beta.trial    
end

t = linspace(0,length(baseline)/200,length(baseline));
%%
figure
plot(t,baseline)
hold on
plot(t([1,end]),[bthresh bthresh])
% 
% 
% 
% figure
% mypower(beta.time,squeeze(nanmean(beta.trial(ci('velocity-gross',D.conditions),1,:),1)))
% hold on
% mypower(beta.time,squeeze(nanmean(gamma.trial(ci('velocity-gross',D.conditions),1,:),1)))
% 
% 

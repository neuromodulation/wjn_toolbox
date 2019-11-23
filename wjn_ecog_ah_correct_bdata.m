function wjn_ecog_ah_correct_bdata(fname)

%% correct pacflow pacfhigh peakrange betaStrip RegressionStrip cmlpac cmspac

load(fname)

chs = [sSTN sStrip];
[~,ibetaStrip] = max(nanmean(nanmean(lnd(:,ipowraw,2:end))+nanmean(snd(:,ipowraw,2:end)),2))
ibetaStrip = ibetaStrip+1;
betaStrip = chs{ibetaStrip}
ss=betaStrip;
ms= table2array(models.fullls.Coefficients(:,{'Estimate','pValue'}))

ms(ms(:,1)<=0,:) = nan;

[~,irStrip]=nanmin(ms(2:end,2));

irStrip = irStrip+1;
regressionStrip = chs{irStrip};

pacflow=[5:3:40];
pacfhigh = [40:5:200];
Dp=wjn_sl(pacfile);
% Dcont = wjn_sl(['d' efile(3:end)])


smspac = squeeze(nanmean(Dp(ci(sSTN,Dp.chanlabels),:,:,ci('short',Dp.conditions)),1));
smlpac = squeeze(nanmean(Dp(ci(sSTN,Dp.chanlabels),:,:,ci('long',Dp.conditions)),1));

%
ich = ci(ss,Dp.chanlabels);

cmspac = squeeze(nanmean(Dp(ich,:,:,ci('short',Dp.conditions)),1));
cmlpac = squeeze(nanmean(Dp(ich,:,:,ci('long',Dp.conditions)),1));




figure
subplot(1,2,1)
[rl,pl]=wjn_corr_plot(mspow(:,1),mspow(:,ci(regressionStrip,chs)));
title('Short bursts')
xlabel('Subthalamic beta power [a.u.]')
ylabel('Cortical beta power [a.u.]')
% set(gca,'MarkerFaceColor',cc(3,:))
subplot(1,2,2)
[rs,ps]=wjn_corr_plot(mlpow(:,1),mlpow(:,ci(ss,chs)));
title('Long bursts')
xlabel('Subthalamic beta power [a.u.]')
ylabel('Cortical beta power [a.u.]')
figone(9,15)

myprint(['../ecog_figures/' id '_Burst_power_correlations'])


srawstn = squeeze(sraw(:,1,ipowraw))';
srawstrip = squeeze(sraw(:,ci(ss,chs),ipowraw))';
lrawstn = squeeze(lraw(:,1,ipowraw))';
lrawstrip = squeeze(lraw(:,ci(ss,chs),ipowraw))';

Dcont=wjn_sl(['dcont_' filename]);
contfile = Dcont.fullfile;

[lepow,f,rlepow]=wjn_raw_fft(lrawstrip(:)',Dcont.fsample);
[sepow,f,rsepow]=wjn_raw_fft(srawstrip(:)',Dcont.fsample);
[lspow,f,rlspow]=wjn_raw_fft(lrawstn(:)',Dcont.fsample);
[sspow,f,rsspow]=wjn_raw_fft(srawstn(:)',Dcont.fsample);
[lcoh,fc]=wjn_raw_coherence(lrawstrip(:)',lrawstn(:)',Dcont.fsample);
[scoh,fc]=wjn_raw_coherence(srawstrip(:)',srawstn(:)',Dcont.fsample);


% cc= colorlover(1);
% cc=cc([2:4],:);
figure
subplot(1,3,1)
plot(f,sspow,f,lspow,'linewidth',3)
legend('short bursts','long bursts')
xlim([5 40])
title('STN')
subplot(1,3,2)
plot(f,sepow,f,lepow,'linewidth',3)
title('ECOG')
xlim([5 40])
subplot(1,3,3)
% figure
% mybar([scoh(1,15:30)' lcoh(1,15:30)'],cc([3;2],:))
plot(fc,scoh,fc,lcoh,'linewidth',3)
title('Coherence')
xlim([5 40])
figone(7,30)
myprint(['../ecog_figures/' id '_Burst_power_comparison'])
clear pacd
clear D*
save(fname)


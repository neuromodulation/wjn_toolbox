function D=wjn_error_bar_speed_events(filename,dsample)
%%
keep filename dsample
load(filename,'pen','target','turn','slow','fast')
%
timewin = [-1 1.5];

wjn_thresh_event(filename,'turn',2);
wjn_thresh_event(filename,'slow',2);
wjn_thresh_event(filename,'fast',2);

[~,D]=wjn_spikeconvert(filename,timewin);

S=[];
S.D =D.fullfile;
S.fsample_new=dsample;
D=spm_eeg_downsample(S);
Draw=D;
D=wjn_tf_wavelet(D.fullfile,[1:dsample/2]);
D=wjn_tf_baseline(D.fullfile);

S.D = D.fullfile;    
S.trl = ceil(D.ttrl*dsample);
S.conditionlabels = D.conditionlabels;
D=spm_eeg_epochs(S);
S.D = Draw.fullfile;
Draw=spm_eeg_epochs(S);
D.errortrials = squeeze(abs(Draw(Draw.indchannel('pen'),:,:)-Draw(Draw.indchannel('target'),:,:)));
D.target = squeeze(abs(Draw(Draw.indchannel('target'),:,:)));
D.pen = squeeze(abs(Draw(Draw.indchannel('pen'),:,:)));
for a = 1:size(D.pen,2);
D.speed(:,a) = smooth(abs(mydiff(D.pen(:,a))),.05*D.fsample);
D.derror(:,a) = smooth(abs(mydiff(D.errortrials(:,a))),.05*D.fsample);
end
save(D);

%%

close all
D=spm_eeg_load('ertf_dspmeeg_wjn_error_speed_c3.mat');
timewin = [D.time(1) D.time(end)]
iturn = D.indtrial('turn');
turn = iturn;
slow = D.indtrial('slow');
fast = D.indtrial('fast');
iturn = [slow fast];
alltrials = iturn;
ic = D.indchannel('C3');
conds = {'turn','slow','fast'};
cc=colorlover(6);
figure
for a = 1:length(conds);
subplot(2,3,a)
itrial = D.indtrial(conds{a});
imagesc(D.time,D.frequencies,squeeze(mean(D(ic,:,:,itrial),4)))
title({conds{a},['N = ' num2str(numel(itrial))]})
axis xy
caxis([-50 50])
subplot(2,3,a+3)
he=mypower(D.time,D.errortrials(:,itrial)',cc(1,:));
hold on
ht=mypower(D.time,D.target(:,itrial)'./4,cc(2,:));
hp=mypower(D.time,D.pen(:,itrial)'./4,cc(3,:));
hs=mypower(D.time,D.speed(:,itrial)'*40,cc(4,:))

ylim([0 4]);
xlim(timewin);
legend([hp,ht,he,hs],{'pen','target','error','speed'})

end
cc=colorlover(6)
figure
mypower(D.time,D.pen(:,slow),cc(1,:).*.9)
hold on
mypower(D.time,D.pen(:,fast),cc(4,:).*.9)
mypower(D.time,D.errortrials(:,slow),cc(4,:))
mypower(D.time,D.errortrials(:,fast),cc(2,:))

mypower(D.time,squeeze(mean(D(ic,4:12,:,fast),2)./10),cc(4,:).*.8)
mypower(D.time,squeeze(mean(D(ic,4:12,:,slow),2))./10,cc(1,:).*.8)

% clear r p
% for a = 1:length(D.frequencies);
%     for b = 1:length(D.time);
%         [r(a,b),p(a,b)]=corr(squeeze(D(ic,a,b,iturn)),D.errortrials(a,iturn)','type','spearman');
%     end
% end
% 
% figure
% imagesc(D.time,D.frequencies,r)
% caxis([-1 1])
% axis xy
% hold on
% contour(D.time,D.frequencies,p<=0.05,1,'color','k','linewidth',3)
% % 
%

clear r p rp rt rs pe pp pt ps
iturn = slow;
for a = 1:length(D.frequencies)
    
    [re(a),pe(a)]=corr(squeeze(mean(D(ic,a,:,iturn),4)),mean(D.errortrials(:,iturn),2),'type','spearman');
    [rp(a),pp(a)]=corr(squeeze(mean(D(ic,a,:,iturn),4)),mean(D.pen(:,iturn),2),'type','spearman');
    [rt(a),pt(a)]=corr(squeeze(mean(D(ic,a,:,iturn),4)),mean(D.target(:,iturn),2),'type','spearman');
    [rs(a),ps(a)]=corr(squeeze(mean(D(ic,a,:,iturn),4)),mean(D.speed(:,iturn),2),'type','spearman');
end
%
figure
subplot(4,1,1)
myline(D.frequencies,re,'color',cc(1,:))
ylabel('ERROR \rho')
xlabel('FREQUENCY')
hold on
sigbar(D.frequencies,pe<=fdr_bh(pe,.05))
myline(D.frequencies,re,'color',cc(1,:))
subplot(4,1,2)
myline(D.frequencies,rt,'color',cc(2,:))
ylabel('TARGET \rho')
xlabel('FREQUENCY')
hold on
sigbar(D.frequencies,pt<=fdr_bh(pt,.05));
myline(D.frequencies,rt,'color',cc(2,:))
subplot(4,1,3)
myline(D.frequencies,rp,'color',cc(3,:))
ylabel('PEN \rho')
xlabel('FREQUENCY')
hold on 
sigbar(D.frequencies,pp<=fdr_bh(pp,.05))
myline(D.frequencies,rp,'color',cc(3,:))
subplot(4,1,4)
myline(D.frequencies,rs,'color',cc(4,:))
ylabel('SPEED \rho')
xlabel('FREQUENCY')
hold on
sigbar(D.frequencies,ps<=fdr_bh(ps,.05))
myline(D.frequencies,rs,'color',cc(4,:))


%%
close all
f = D.frequencies;
freqrange = {'theta','alpha','low beta','high beta','low gamma','broadband gamma'};
behav = {'errortrials','target','pen','speed'};
fr = [4 8;8 12; 12 20;21 30; 30 45; 55 90; 45 140];
iturn = alltrials;
clear m
for a = 1:numel(freqrange)
    figure
    m(:,a) = squeeze(mean(mean(D(ic,sc(f,fr(a,1)):sc(f,fr(a,2)),:,iturn),2),4));
    for c=1:numel(behav);
    b = mean(D.(behav{c})(:,iturn),2);
    [r,p]=corr(m(:,a),b);
    subplot(1,4,c)
    scatter(m(:,a),b,'k+')
    [x,y]=mycorrline(m(:,a),b,min(m(:,a)),max(m(:,a)));
    hold on
    plot(x,y,'color',[.5 .5 .5],'linewidth',2)
    title([freqrange{a} ' \rho = ' num2str(r,3) ' P = ' num2str(p,3)])
    xlabel([freqrange{a} ' activity'])
    ylabel([behav{c}])
    end
    figone(7,30);
end

%%
f=D.frequencies;
for a = 1:D.nsamples;
    for b=1:length(f);
    [r(a,b),p(a,b)]=corr(squeeze(D(ic,b,a,nturn)),D.errortrials(a,nturn)');
    end
end

figure
imagesc(D.time,f,r'),axis xy
hold on
contour(D.time,f,p'<=.05,1,'color','k','linewidth',2)

%% 
close all
D=spm_eeg_load('rtf_dspmeeg_wjn_error_c3s.mat');
Draw=spm_eeg_load('dspmeeg_wjn_error_c3s.mat');


D.errortrials = squeeze(abs(Draw(Draw.indchannel('pen'),:,:)-Draw(Draw.indchannel('target'),:,:)));
D.derror = abs(mydiff(D.errortrials));
D.target = squeeze(abs(Draw(Draw.indchannel('target'),:,:)));
D.pen = squeeze(abs(Draw(Draw.indchannel('pen'),:,:)));
% D.speed = smooth(abs(mydiff(D.pen)),.05*D.fsample);
D.rspeed = abs(mydiff(mydiff(D.pen)));
save(D);
clear r p
f=D.frequencies;
xr = rand(D.nsamples,1);
for a = 1:length(f);
    [r(a),p(a)]=corr(squeeze(D(ic,a,:,1)),D.errortrials'	,'rows','pairwise');
%     [r(a),p(a)]=corr(squeeze(D(ic,a,:,1)),xr,'rows','pairwise');
end

figure,
plot(f,r)
hold on
sigbar(f,p<=fdr_bh(p))
plot(f,r)

%%

D=spm_eeg_load('rtf_dspmeeg_wjn_error_speed_c3.mat');
ic = D.indchannel('C3')
theta = squeeze(nanmean(D(ic,4:8,:,1),2));
alpha = squeeze(nanmean(D(ic,8:12,:,1),2));
beta = squeeze(nanmean(D(ic,16:30,:,1),2));
gamma = squeeze(nanmean(D(ic,30:45,:,1),2));

[ic,lag]=xcorr(theta,D.errortrials',D.fsample)
figure
plot(lag/D.fsample,ic)

[m,im]=max(ic);
il = lag(im)

[r,p]=corr(beta(il:end),D.errortrials(1:end-il+1)')


%%
figure,imagesc(D.time,f,squeeze(D(2,:,:,1)))
axis xy
caxis([-500 500])
hold on
plot(D.time,D.errortrials*100)

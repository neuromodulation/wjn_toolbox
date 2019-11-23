close all
clear all

p = wjn_vm_list;
patlist = wjn_vm_list('list');
n=[patlist{:,1}];

baseline = [-2000 -1000];
foi = 15:25;
toi = [0 .25];

% sk = [4 250];

% baseline = [-500 500];
sk = [3 100];
tr = [-1 1];
freqrange = [3:49];

patlist = wjn_vm_list('list');
n = [patlist{:,1}];
root = wjn_vm_list('eegroot');
cd(root)
[~,chans]=wjn_mni_list;
chans = chans(1:4);
D=wjn_sl(wjn_vm_list(n(1),'fullfile','mtf_B'));
for a  =1:length(n)
    
    D=wjn_sl(wjn_vm_list(n(a),'fullfile','mtf_B'));
    rt(a,:) = D.mrt;
    mt(a,:) = D.mmt;
    te(a,:) = 10.*D.mmerr;
    av(a,:) = 100*D.mavg_v;
    mv(a,:) = 100*D.mmax_v;
    
    
    
    %     D=wjn_tf_baseline(D.fullfile,baseline);
    D=wjn_tf_sep_common_baseline(D.fullfile,baseline,'go');
    %     D=wjn_tf_sep_baseline(D.fullfile,baseline,{'mov_aut');
    D=wjn_tf_smooth(D.fullfile,sk(1),sk(2));
    tf(a,:,:,:,:) = D(ci(chans,D.chanlabels),:,:,ci({'go_aut','go_con','move_aut','move_con','stop_aut','stop_con'},D.conditions));
    
end



%%
cmap = colorlover(19);
mdl_betas = [];
mdl_pvals =[];
behav = {'drt','dmt','dte','dav','dmv'};

for a = 1:length(D.time)
    for b = 1:D.nfrequencies
        beta = squeeze(nanmean(nanmean(tf(:,1:4,b,a,[3 4]),3),4));
        
        trt = [rt(:,1);rt(:,2)];
        tmt = [mt(:,1);mt(:,2)];
        tte = [te(:,1);te(:,2)];
        tav = [av(:,1);av(:,2)];
        tmv = [mv(:,1);mv(:,2)];
        tbeta = [beta(:,:,1);beta(:,:,2)];
        
        drt = [rt(:,2)-rt(:,1)];
        dmt = [mt(:,2)-mt(:,1)];
        dte = [te(:,2)-te(:,1)];
        dav = [av(:,1)-av(:,2)];
        dmv = [mv(:,1)-mv(:,2)];
        dbeta = [beta(:,:,2)-beta(:,:,1)];
        for c = 1:length(behav)
%         mdl=fitlm(dbeta,eval(behav{c}));
%         mdl_betas(c,:,b,a) = mdl.Coefficients.tStat(2:end);
%         mdl_pvals(c,:,b,a) = mdl.Coefficients.pValue(2:end);
          [mdl_betas(c,:,b,a),mdl_pvals(c,:,b,a)] = corr(dbeta,eval(behav{c}),'rows','pairwise','type','spearman');
        end
    end
end

%
figure
nf=0;
for a = 1:5
    for b = 1:4
        nf = nf+1;
    subplot(5,4,nf)
    wjn_contourf(D.time,D.frequencies,squeeze(mdl_betas(a,b,:,:)));
    hold on
    wjn_contourp(D.time,D.frequencies,squeeze(mdl_pvals(a,b,:,:))<.05);
    caxis([-3 3])
    xlim([-.75 .25])
    ylim([3 40])
    if a ==1
        title(D.chanlabels{b});
    end
    if b == 1
        ylabel(behav{a})
    end
    end
end
figone(20,30)

%%
% figure
% mypower(D.time,mdl_betas(1,:),cmap(7,:));
% hold on
% % sigbar(D.time(timerange),pl(3,:)<.05)
% mypower(D.time,mdl_betas(2,:),cmap(9,:));
% mypower(D.time,mdl_betas(3,:),cmap(1,:));
% mypower(D.time,mdl_betas(4,:),cmap(3,:));
% % xlim([-1 1])
% pl = mdl_pvals;
% hpl=[];
% hpl(1,:) = pl(1,:)<.05;
% hpl(2,:) = 2.*(pl(2,:)<.05);
% hpl(3,:) = 3.*(pl(3,:)<.05);
% hpl(4,:) = 4.*(pl(4,:)<.05);
%
% imagesc(D.time,-4:.25:-3.25,hpl)
% colormap([1 1 1; cmap(7,:); cmap(9,:); cmap(1,:);cmap(3,:)])
% % xlim([-1.1 1.1])

%%

cb = colorlover(19);


figure
data = rt;
h1= raincloud_plot('X',data(:,1), 'box_on', 1, 'color', cb(9,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .25, 'dot_dodge_amount', .5,...
    'bandwidth',.05,'bxcl',[ 0 0 0]);
h2= raincloud_plot('X',data(:,2), 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', 1, 'dot_dodge_amount', 1.25,...
    'bandwidth',.05,'bxcl',[ 0 0 0]);
h3= raincloud_plot('X',data(:,3), 'box_on', 1, 'color', cb(3,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .65, 'dot_dodge_amount', .85,...
    'bandwidth',.05,'bxcl',[ 0 0 0]);
h1{3}.FaceColor = cb(9,:);
h2{3}.FaceColor = cb(1,:);
h3{3}.FaceColor = cb(3,:);
xlabel('Reaction Time [s]')
figone(6)
xlim([-.1 1.2])
ylim([-7.5 5])
box off
myprint('RT')
legend([h1{1} h2{1} h3{1}], {'Automatic', 'Controlled','\Delta Controlled-Automatic'})
myprint('RT_legend')


figure
data = mt;
h1= raincloud_plot('X',data(:,1), 'box_on', 1, 'color', cb(9,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .25, 'dot_dodge_amount', .5,...
    'bandwidth',.05,'bxcl',[ 0 0 0]);
h2= raincloud_plot('X',data(:,2), 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', 1, 'dot_dodge_amount', 1.25,...
    'bandwidth',.05,'bxcl',[ 0 0 0]);
h3= raincloud_plot('X',data(:,3), 'box_on', 1, 'color', cb(3,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .65, 'dot_dodge_amount', .85,...
    'bandwidth',.05,'bxcl',[ 0 0 0]);
h1{3}.FaceColor = cb(9,:);
h2{3}.FaceColor = cb(1,:);
h3{3}.FaceColor = cb(3,:);
xlabel('Movement Time [s]')
figone(6)
box off
ylim([-5 5])
xlim([-.1 1.2])
myprint('MT')
legend([h1{1} h2{1} h3{1}], {'Automatic', 'Controlled','\Delta Controlled-Automatic'})

figure
data = te;
h1= raincloud_plot('X',data(:,1), 'box_on', 1, 'color', cb(9,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .25, 'dot_dodge_amount', .5,...
    'bandwidth',.05,'bxcl',[ 0 0 0]);
h2= raincloud_plot('X',data(:,2), 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', 1, 'dot_dodge_amount', 1.25,...
    'bandwidth',.05,'bxcl',[ 0 0 0]);
h3= raincloud_plot('X',data(:,3), 'box_on', 1, 'color', cb(3,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .65, 'dot_dodge_amount', .85,...
    'bandwidth',.05,'bxcl',[ 0 0 0]);
h1{3}.FaceColor = cb(9,:);
h2{3}.FaceColor = cb(1,:);
h3{3}.FaceColor = cb(3,:);
xlabel('Trajectory Error [a.u.]')
figone(6)
box off
ylim([-3.5 3])
xlim([-.5 2])
myprint('TE')

%%

for a = 1:length(chans)
    wjn_eeg_vm_plot_tf_stats(D.time,D.frequencies,squeeze(nanmean(tf(:,a,:,:,1:2),5)),[chans{a} '_GO']);
    wjn_eeg_vm_plot_tf_stats(D.time,D.frequencies,squeeze(nanmean(tf(:,a,:,:,1:2),5)),[chans{a} '_MOVE']);
end
%%
tr = [-1 1];
timerange = D.indsample(tr(1)):D.indsample(tr(2));
freqrange = [3:49];
close all
% go_gm = nanmean(tf(:,:,:,:,[1 2]),5);
go_d = tf(:,:,:,:,2)-tf(:,:,:,:,1);
move_d = tf(:,:,:,:,4)-tf(:,:,:,:,3);
stop_d = tf(:,:,:,:,6)-tf(:,:,:,:,5);
% move_gm = nanmean(tf(:,:,:,:,[3 4]),5);

for a = 3%1:length(chans)
    %       timerange = 1:D.nsamples;
    %       freqrange = 1:D.nfrequencies;
    
    ctf = squeeze(go_d(:,a,freqrange,timerange));
    wjn_eeg_vm_plot_tf_diff_stats(D.time(timerange),D.frequencies(freqrange),ctf,[strrep(chans{a},'_',' ') ' go diff']);
    
    ctf = squeeze(move_d(:,a,freqrange,timerange));
    wjn_eeg_vm_plot_tf_diff_stats(D.time(timerange),D.frequencies(freqrange),ctf,[strrep(chans{a},'_',' ') ' move diff']);
    
    %     ctf = squeeze(stop_d(:,a,freqrange,timerange));
    % wjn_eeg_vm_plot_tf_diff_stats(D.time(timerange),D.frequencies(freqrange),ctf,[strrep(chans{a},'_',' ') ' stop diff'])
    
end

%%
foi = 15:25;
mgod=squeeze(nanmean(go_d(:,:,foi,timerange),3));
mmovd=squeeze(nanmean(move_d(:,:,foi,timerange),3));
mstopd=squeeze(nanmean(stop_d(:,:,foi,timerange),3));
cmap = colorlover(19);
%
close all
figure
% subplot(1,2,1)
mypower(D.time(timerange),squeeze(mgod(:,1,:)),cmap(7,:));
hold on
mypower(D.time(timerange),squeeze(mgod(:,2,:)),cmap(9,:));
mypower(D.time(timerange),squeeze(mgod(:,3,:)),cmap(1,:));
mypower(D.time(timerange),squeeze(mgod(:,4,:)),cmap(3,:));
xlim([-1 1]);
ylim([-10 15])
for a = 1:size(mgod,3)
    pl(1,a) = wjn_ppt(squeeze(mgod(:,1,a)),squeeze(mgod(:,3,a)));
    pl(2,a) = wjn_ppt(squeeze(mgod(:,2,a)),squeeze(mgod(:,3,a)));
    pl(3,a) = wjn_ppt(squeeze(mgod(:,4,a)),squeeze(mgod(:,3,a)));
end
mrt = nanmean(nanmean(rt(:,1:2)));
% pt = fdr_bh(pl(1,wjn_sc(D.time(timerange),0):wjn_sc(D.time(timerange),mrt)),.05)

hpl=[];
hpl(1,:) = pl(1,:)<.05;
hpl(2,:) = 2.*(pl(2,:)<.05);
hpl(3,:) = 3.*(pl(3,:)<.05);
imagesc(D.time(timerange),-3:.33:-2,hpl)
plot([mrt mrt],[-3.5 15],'linestyle','--','color',[.5 .5 .5],'linewidth',2)
plot([0 0],[-3.5 15],'linestyle','--','color','k','linewidth',2)
caxis([0 3])
colormap([1 1 1; cmap(7,:); cmap(9,:); cmap(3,:)])
ylim([-3.5 15])
xlim([-1.04 1.05])
figone(5)
xlabel('Time [s]')
ylabel('\Delta Beta 15-25 Hz [%]')
myprint('BETA_GO')
%
close all
figure
% subplot(1,2,1)
% mgod = mmovd;
mypower(D.time(timerange),squeeze(mmovd(:,1,:)),cmap(7,:));
hold on
mypower(D.time(timerange),squeeze(mmovd(:,2,:)),cmap(9,:));
mypower(D.time(timerange),squeeze(mmovd(:,3,:)),cmap(1,:));
mypower(D.time(timerange),squeeze(mmovd(:,4,:)),cmap(3,:));
xlim([-1 1]);
ylim([-10 15])


pl=[];
for a = 1:size(mgod,3)
    pl(1,a) = wjn_ppt(squeeze(mmovd(:,1,a)),squeeze(mmovd(:,3,a)));
    pl(2,a) = wjn_ppt(squeeze(mmovd(:,2,a)),squeeze(mmovd(:,3,a)));
    pl(3,a) = wjn_ppt(squeeze(mmovd(:,4,a)),squeeze(mmovd(:,3,a)));
end



hpl=[];
hpl(1,:) = pl(1,:)<.05;
hpl(2,:) = 2.*(pl(2,:)<.05);
hpl(3,:) = 3.*(pl(3,:)<.05);
imagesc(D.time(timerange),-5:.33:-4,hpl)
plot([-mrt -mrt],[-5.5 15],'linestyle','--','color','k','linewidth',2)
plot([0 0],[-5.5 15],'linestyle','--','color',[.5 .5 .5],'linewidth',2)
caxis([0 3])
colormap([1 1 1; cmap(7,:); cmap(9,:); cmap(3,:)])
ylim([-5.5 15])
xlim([-1.04 1.05])
figone(5)
xlabel('Time [s]')
ylabel('\Delta Beta 15-25 Hz [%]')
myprint('BETA_MOV')


%%
keep n

D=spm_eeg_load(wjn_vm_list(n(1),'fullfile','sscrtf_B'));


cmap = colorlover(19);
close all
r=[];pr=[];
toi = [-1 1];
timerange = D.indsample(toi(1)):D.indsample(toi(2));
t=D.time(timerange);

for a  =1:length(n)
    D=spm_eeg_load(wjn_vm_list(n(a),'fullfile','sscrtf_B'));
    %     D=wjn_tf_sep_common_baseline(D.fullfile,baseline,'go');
    %     D=wjn_tf_smooth(D.fullfile,sk(1),sk(2));
    rt(a,1) = nanmean(D.rt);
    mt(a,1) = nanmean(D.mt);
    merr(a,1) = nanmean(D.merr);
    mavg_v(a,1) = nanmean(D.avg_v);
    mmax_v(a,1) = nanmean(D.max_v);
    i = ci('go',D.conditions);
    x = squeeze(nanmean(D(1:4,15:25,timerange,i),2));
    drange = wjn_sc(t,0):wjn_sc(t,.3);
    beta(a,:) = squeeze(nanmean(nanmean(x(:,drange,:),2),3))';
    xg{a} = x;
    y = D.rt;
    yy{a}=[D.rt D.mt D.merr D.avg_v D.max_v];
    
    for b = 1:4
        r(a,b,:)=corr(squeeze(x(b,:,:))',y,'rows','pairwise','type','spearman');
    end
    
    
    
end
mrt = nanmean(rt);
%
figure
mypower(D.time(timerange),squeeze(r(:,1,:)),cmap(7,:));
hold on
mypower(D.time(timerange),squeeze(r(:,2,:)),cmap(9,:));
mypower(D.time(timerange),squeeze(r(:,3,:)),cmap(1,:));
mypower(D.time(timerange),squeeze(r(:,4,:)),cmap(3,:));
xlim([-1 1])
ylim([-1 1]);
hold on

pl=[];
for a = 1:size(r,3)
    %     pl(1,a) = wjn_ppt(squeeze(r(:,1,a)),squeeze(r(:,3,a)));
    %     pl(2,a) = wjn_ppt(squeeze(r(:,2,a)),squeeze(r(:,3,a)));
    %     pl(3,a) = wjn_ppt(squeeze(r(:,3,a)));
    %     pl(4,a) = wjn_ppt(squeeze(r(:,4,a)),squeeze(r(:,3,a)));
    
    %
    pl(1,a) = wjn_ppt(squeeze(r(:,1,a)));
    pl(2,a) = wjn_ppt(squeeze(r(:,2,a)));
    pl(3,a) = wjn_ppt(squeeze(r(:,3,a)));
    pl(4,a) = wjn_ppt(squeeze(r(:,4,a)));
end

hpl=[];
hpl(1,:) = pl(1,:)<.05;
hpl(2,:) = 2.*(pl(2,:)<.05);
hpl(3,:) = 3.*(pl(3,:)<.05);
hpl(4,:) = 4.*(pl(4,:)<.05);
sigbar(D.time(timerange),pl(3,:)<.05)
imagesc(D.time(timerange),-.1:.025:-.05,hpl)

ylim([-1 1]);
mypower(D.time(timerange),squeeze(r(:,3,:)),cmap(1,:));
plot([0 0],[-5.5 15],'linestyle','--','color','k','linewidth',2)
plot([mrt mrt],[-5.5 15],'linestyle','--','color',[.5 .5 .5],'linewidth',2)
% ylim([-.105 .1])
% ylim([0 .1])
ylim([-.11 .15])
colormap([1 1 1; cmap(7,:); cmap(9,:); cmap(1,:);cmap(3,:)])
xlim([-1.1 1.05])
ylabel('\Rho Beta - RT')
xlabel('Time [s]')
title('GO')
figone(5)
drawnow

D=spm_eeg_load(wjn_vm_list(n(1),'fullfile','sscrtf_B'));
cmap = colorlover(19,1);

r=[];pr=[];
timerange = D.indsample(toi(1)):D.indsample(toi(2));
for a  =1:length(n)
    D=spm_eeg_load(wjn_vm_list(n(a),'fullfile','sscrtf_B'));
    %     D=wjn_tf_sep_common_baseline(D.fullfile,baseline,'go');
    %     D=wjn_tf_smooth(D.fullfile,sk(1),sk(2));
    i = ci('move',D.conditions);
    x = squeeze(nanmean(D(1:4,15:25,timerange,i),2));
    y = D.rt;
    xm{a} = x;
    
    rt(a,1) = nanmean(D.rt);
    for b = 1:4
        r(a,b,:)=corr(squeeze(x(b,:,:))',y,'rows','pairwise');
    end
end
mrt = nanmean(rt);
%
figure
mypower(D.time(timerange),squeeze(r(:,1,:)),cmap(7,:));
hold on
% sigbar(D.time(timerange),pl(3,:)<.05)
mypower(D.time(timerange),squeeze(r(:,2,:)),cmap(9,:));
mypower(D.time(timerange),squeeze(r(:,3,:)),cmap(1,:));
mypower(D.time(timerange),squeeze(r(:,4,:)),cmap(3,:));
xlim([-1 1])
ylim([-1 1]);
hold on
pl=[];
for a = 1:size(r,3)
    %     pl(1,a) = wjn_ppt(squeeze(r(:,1,a)),squeeze(r(:,3,a)));
    %     pl(2,a) = wjn_ppt(squeeze(r(:,2,a)),squeeze(r(:,3,a)));
    %     pl(3,a) = wjn_ppt(squeeze(r(:,3,a)));
    %     pl(4,a) = wjn_ppt(squeeze(r(:,4,a)),squeeze(r(:,3,a)));
    
    
    pl(1,a) = wjn_ppt(squeeze(r(:,1,a)));
    pl(2,a) = wjn_ppt(squeeze(r(:,2,a)));
    pl(3,a) = wjn_ppt(squeeze(r(:,3,a)));
    pl(4,a) = wjn_ppt(squeeze(r(:,4,a)));
end

hpl=[];
hpl(1,:) = pl(1,:)<.05;
hpl(2,:) = 2.*(pl(2,:)<.05);
hpl(3,:) = 3.*(pl(3,:)<.05);
hpl(4,:) = 4.*(pl(4,:)<.05);
sigbar(D.time(timerange),pl(3,:)<.05)

imagesc(D.time(timerange),-.1:.025:-.05,hpl)
mypower(D.time(timerange),squeeze(r(:,3,:)),cmap(1,:));
plot([-mrt -mrt],[-5.5 15],'linestyle','--','color','k','linewidth',2)
plot([0 0],[-5.5 15],'linestyle','--','color',[.5 .5 .5],'linewidth',2)
ylim([-.11 .15])
colormap([1 1 1; cmap(7,:); cmap(9,:); cmap(1,:);cmap(3,:)])
xlim([-1.04 1.05])
ylabel('\Rho Beta - RT')
xlabel('Time [s]')
% title('GO')
figone(5)

xxx = [rt mt merr mavg_v mmax_v];

mdl=fitlm(beta,xxx(:,5));


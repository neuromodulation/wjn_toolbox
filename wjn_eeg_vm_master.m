clear all
close all

root = wjn_vm_list('eegroot');
p = wjn_vm_list;
% p = p([7,8,6:-1:1]);

cd(root);

patlist = wjn_vm_list('list');
n=[patlist{:,1}];

for a =17%19:length(n)
    p = wjn_vm_list(n(a));
    delete(fullfile(root,p.id,'data','*.*'));
    try
        rmdir(fullfile(root,p.id,'data','figures'),'s')
        rmdir(fullfile(root,p.id,'data','source_images'),'s')
        rmdir(fullfile(root,p.id,'data','source_localisation'),'s')
    end
    wjn_eeg_vm_pipeline(p);
end
    

%%
close all
p = wjn_vm_list;
patlist = wjn_vm_list('list');
n=[patlist{:,1}];
% n(end) =[];
[atf,ctf,dtf,t,f,c,rt,mt,mv,me] = wjn_eeg_vm_group_results(p(n),'srmtf_B');
fr = [4 7; 7 13; 13 20; 20 35; 35 45; 55 95];
clear tf

close all
for a = 1:size(atf,2)
    tf(a,1,:,:,:) = atf(:,a,:,:);
    tf(a,2,:,:,:) = ctf(:,a,:,:);
    tf(a,1,:,:,:) = nanmean(tf(a,1:2,:,:,:),2);
    tf(a,2,:,:,:) = dtf(:,a,:,:);
    figure
%     for b  = 1:2
    subplot(6,2,[1:2:11])
    [p,fdr_p,adj_p] = wjn_tf_signrank(squeeze(tf(a,1,:,:,:)));
    wjn_contourf(t,f,nanmean(squeeze(tf(a,1,:,:,:))))
    hold on
    caxis([-25 25])
    xlim([-2.5 2.5])
    title(c{a})
    %   wjn_contourp(t,f,p<=0.05)
    wjn_contourp(t,f,adj_p<=0.05,'r')
    for d = 1:size(fr,1)
        clear pt
    subplot(6,2,d*2)
    dt=squeeze(nanmean(dtf(:,a,fr(d,1):fr(d,2),:),3));
    amtf = squeeze(nanmean(atf(:,a,fr(d,1):fr(d,2),:),3));
    cmtf = squeeze(nanmean(ctf(:,a,fr(d,1):fr(d,2),:),3));
    mypower(t,amtf,'b')
    hold on
    mypower(t,cmtf,'r')
    for b = 1:length(t)
         pt(b) = wjn_ppt(dt(:,b));
         
    end
    sigbar(t,pt<=0.05)
    xlim([-2.5 2.5])
    end
    
%     end
end
% xlim([.25 .75])

%%
% spm12(1)
clear
p = wjn_vm_list;
patlist = wjn_vm_list('list');
n=[patlist{:,1}];
root = wjn_vm_list('eegroot');
cd(root);
% n(end) =[];
for a = 1:length(n)
    froot = wjn_vm_list(n(a),'dataroot');
    
    niis{a} = fullfile(froot,'sextract_13-30Hz_move.nii');
end

wjn_nii_average(niis,'grand_average_move_13-30Hz.nii')

wjn_eeg_spm_one_sample('models_move',niis')

%% create tf var
close all
clear all
baseline = [-2000 -1000];
foi = 13:30;
toi = [0 .25];

% sk = [4 250];

% baseline = [-500 500];
sk = [3 100];
tr = [-1 1];
freqrange = [3:40];

patlist = wjn_vm_list('list');
n = [patlist{:,1}];
root = wjn_vm_list('eegroot');
cd(root)
[~,chans]=wjn_mni_list;
chans = chans(1:4);
D=wjn_sl(wjn_vm_list(n(1),'fullfile','mtf_B'));
for a  =1:length(n)    
    D=wjn_sl(wjn_vm_list(n(a),'fullfile','mtf_B'));
%     D=wjn_tf_baseline(D.fullfile,baseline);
    D=wjn_tf_sep_common_baseline(D.fullfile,baseline,'go');
%     D=wjn_tf_sep_baseline(D.fullfile,baseline,{'mov_aut');
    D=wjn_tf_smooth(D.fullfile,sk(1),sk(2));
    tf(a,:,:,:,:) = D(ci(chans,D.chanlabels),:,:,ci({'go_aut','go_con','move_aut','move_con','stop_aut','stop_con'},D.conditions));
end
timerange = D.indsample(tr(1)):D.indsample(tr(2));

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

mgod=squeeze(nanmean(go_d(:,:,foi,timerange),3));
mmovd=squeeze(nanmean(move_d(:,:,foi,timerange),3));
mstopd=squeeze(nanmean(stop_d(:,:,foi,timerange),3));
cmap = colorlover(19);

figure
subplot(1,2,1)
mypower(D.time(timerange),squeeze(mgod(:,1,:)),cmap(7,:));
hold on
mypower(D.time(timerange),squeeze(mgod(:,2,:)),cmap(9,:));
mypower(D.time(timerange),squeeze(mgod(:,3,:)),cmap(1,:));
mypower(D.time(timerange),squeeze(mgod(:,4,:)),cmap(3,:));
xlim([-1 1]);
ylim([-10 10])
for a = 1:size(mgod,3)
    p(1,a) = wjn_ppt(squeeze(mgod(:,1,a)),squeeze(mgod(:,3,a)));
    p(2,a) = wjn_ppt(squeeze(mgod(:,2,a)),squeeze(mgod(:,3,a)));
    p(3,a) = wjn_ppt(squeeze(mgod(:,4,a)),squeeze(mgod(:,3,a)));
end

imagesc(D.time(timerange),-10:-7,p<.05)
caxis([0 1])
colormap([1 1 1; 0 0 0])
    
subplot(1,2,2)
mypower(D.time(timerange),squeeze(mmovd(:,1,:)),cmap(7,:));
hold on
mypower(D.time(timerange),squeeze(mmovd(:,2,:)),cmap(9,:));
mypower(D.time(timerange),squeeze(mmovd(:,3,:)),cmap(1,:));
mypower(D.time(timerange),squeeze(mmovd(:,4,:)),cmap(3,:));
xlim([-1 1]);
ylim([-10 10])
for a = 1:size(mgod,3)
    p(1,a) = wjn_ppt(squeeze(mmovd(:,1,a)),squeeze(mmovd(:,3,a)));
    p(2,a) = wjn_ppt(squeeze(mmovd(:,2,a)),squeeze(mmovd(:,3,a)));
    p(3,a) = wjn_ppt(squeeze(mmovd(:,4,a)),squeeze(mmovd(:,3,a)));
end

imagesc(D.time(timerange),-10:-7,p<.05)
caxis([0 1])
colormap([1 1 1; 0 0 0])
figone(7,30)

% 
% bgod = squeeze(nanmean(mgod(:,:,wjn_sc(D.time(timerange),toi(1)):wjn_sc(D.time(timerange),toi(2))),3));
% bmovd = squeeze(nanmean(mmovd(:,:,wjn_sc(D.time(timerange),toi(1)):wjn_sc(D.time(timerange),toi(2))),3));
% bstopd = squeeze(nanmean(mstopd(:,:,wjn_sc(D.time(timerange),toi(1)):wjn_sc(D.time(timerange),toi(2))),3));
% 
% subplot(2,2,3)
% mybar(bgod)
% set(gca,'XTickLabel',chans)
% wjn_ppt(bgod(:,2),bgod(:,3))
% 
% subplot(2,3,4)
% mybar(bmovd)
% set(gca,'XTickLabel',chans)
% wjn_ppt(bmovd(:,2),bmovd(:,3))


%%
keep tf chans
D=wjn_sl(wjn_vm_list(2,'fullfile','mtf_B'));
freqrange = [55:95];
timerange = wjn_sc(D.time,-2):wjn_sc(D.time,1);
p = wjn_vm_list;
patlist = wjn_vm_list('list');
n = [patlist{:,1}];
for b = 1:length(n)
    D=wjn_sl(wjn_vm_list(n(b),'fullfile','sscrmtf_B'));
    mrt(b,:) = D.mrt;
    merr(b,:) = D.mmerr;
    mavg_v(b,:) = D.mavg_v;
    mmt(b,:) = D.mmt;
end
t = D.time(timerange);
f = D.frequencies(freqrange);
vars = {'mrt','merr','mavg_v','mmt'};
for a = [1 2 3 4]
    for b = 1:length(vars)

         y = eval(vars{b});
        yy = [y(:,1);y(:,2)];
        my = nanmean(y(:,1:2),2);
        dy = y(:,2)-y(:,1);
        gomtf = squeeze(nanmean(tf(:,a,freqrange,timerange,1:2),5));
        gotf = squeeze(tf(:,a,freqrange,timerange,1));
        gotf(21:40,:,:) = squeeze(tf(:,a,freqrange,timerange,2));
        godtf = squeeze(tf(:,a,freqrange,timerange,2))-squeeze(tf(:,a,freqrange,timerange,1));  

        wjn_eeg_vm_tf_plot_corr(t,f,gotf,yy,['gamma_' chans{a} '_' vars{b} '_go'])
        
        movemtf = squeeze(nanmean(tf(:,a,freqrange,timerange,3:4),5));
        movetf = squeeze(tf(:,a,freqrange,timerange,3));
        movetf(21:40,:,:) = squeeze(tf(:,a,freqrange,timerange,4));
        movedtf = squeeze(tf(:,a,freqrange,timerange,4))-squeeze(tf(:,a,freqrange,timerange,3));
               wjn_eeg_vm_tf_plot_corr(t,f,movetf,yy,['gamma_' chans{a} '_' vars{b} '_move'])
    end
end
%%

keep tf chans
D=wjn_sl(wjn_vm_list(2,'fullfile','mtf_B'));
freqrange = [5:45];
timerange = wjn_sc(D.time,-2):wjn_sc(D.time,1);
p = wjn_vm_list;
patlist = wjn_vm_list('list');
n = [patlist{:,1}];
for b = 1:length(n)
    D=wjn_sl(wjn_vm_list(n(b),'fullfile','sscrmtf_B'));
    mrt(b,:) = D.mrt;
    merr(b,:) = D.mmerr;
    mavg_v(b,:) = D.mavg_v;
    mmt(b,:) = D.mmt;
end
t = D.time(timerange);
f = D.frequencies(freqrange);
vars = {'mrt','merr','mavg_v','mmt'};
for a = [1 2 3 4]
    for b = 1:length(vars)

         y = eval(vars{b});
        yy = [y(:,1);y(:,2)];
        my = nanmean(y(:,1:2),2);
        dy = y(:,2)-y(:,1);
        gomtf = squeeze(nanmean(tf(:,a,freqrange,timerange,1:2),5));
        gotf = squeeze(tf(:,a,freqrange,timerange,1));
        gotf(21:40,:,:) = squeeze(tf(:,a,freqrange,timerange,2));
        godtf = squeeze(tf(:,a,freqrange,timerange,2))-squeeze(tf(:,a,freqrange,timerange,1));  

        wjn_eeg_vm_tf_plot_corr(t,f,gotf,yy,[chans{a} '_' vars{b} '_go'])
        
        movemtf = squeeze(nanmean(tf(:,a,freqrange,timerange,3:4),5));
        movetf = squeeze(tf(:,a,freqrange,timerange,3));
        movetf(21:40,:,:) = squeeze(tf(:,a,freqrange,timerange,4));
        movedtf = squeeze(tf(:,a,freqrange,timerange,4))-squeeze(tf(:,a,freqrange,timerange,3));
               wjn_eeg_vm_tf_plot_corr(t,f,movetf,yy,[chans{a} '_' vars{b} '_move'])
    end
end
%%
mfocus = nanmean(focus(:,1:2),2);
dfocus = focus(:,2)-focus(:,1);
mmcb = nanmean(mcb(:,1:2),2);
dmcb = mcb(:,3);
rmcb = mcb(:,2)./mcb(:,1);
rfocus = focus(:,2)./focus(:,1);
%
x1 = squeeze(mtf(:,:,:,1));
x2 = squeeze(mtf(:,:,:,2));
x = [x1(:,:);x2(:,:)];
y = [focus(:,1);focus(:,2)];



figure
% subplot(1,4,1)
% wjn_corr_plot(rfocus,rmcb)
% title('relation')
subplot(1,2,1)
wjn_corr_plot(dfocus,dmcb)
% title('difference')
cc=colorlover(5);
xlabel('\Delta motor error [a.u.]')
ylabel('\Delta high beta power [%]')
plot(dfocus,dmcb,'Marker','o','MarkerFacecolor',cc(3,:),'MarkerEdgeColor','w','LineStyle','none')
subplot(1,2,2)
wjn_corr_plot(mfocus,mmcb)
xlabel('Averaged motor error [a.u.]')
ylabel('Averaged high beta power [%]')
plot(mfocus,mmcb,'Marker','o','MarkerFacecolor',cc(3,:),'MarkerEdgeColor','w','LineStyle','none')
% myprint('corr_plot')

% subplot(1,4,4)
% wjn_corr_plot([focus(:,1);focus(:,2)],[mcb(:,1);mcb(:,2)])
% title('all')
figone(9,12)
%%
close all
go_gm = nanmean(tf(:,:,:,:,[1 2]),5);
move_gm = nanmean(tf(:,:,:,:,[3 4]),5);

for a = 1:4%length(chans)
    ctf = squeeze(go_gm(:,a,:,:));
wjn_eeg_vm_plot_tf_stats(D.time,D.frequencies,ctf,[strrep(chans{a},'_',' ') ' go'])

    ctf = squeeze(move_gm(:,a,:,:));
wjn_eeg_vm_plot_tf_stats(D.time,D.frequencies,ctf,[strrep(chans{a},'_',' ') ' move'])

end

close all
for a = 1:4%length(chans)
    ctf = squeeze(tf(:,a,:,:,1));
wjn_eeg_vm_plot_tf_stats(D.time,D.frequencies,ctf,[strrep(chans{a},'_',' ') ' aut go'])

    ctf = squeeze(tf(:,a,:,:,2));
wjn_eeg_vm_plot_tf_stats(D.time,D.frequencies,ctf,[strrep(chans{a},'_',' ') ' con go'])

end




%%
close all
clear all
baseline = [-2500 -2000];
sk = [4 250];
patlist = wjn_vm_list('list');
n = [patlist{:,1}];
root = wjn_vm_list('eegroot');
cd(root)
[~,chans]=wjn_mni_list;
chans = {'M1l-SMA','preSMA-SMA','preSMA-M1l'};

chanpairs = {'M1l','SMA';'preSMA','SMA';'preSMA','M1l'};
for a  =1:length(n)    
    D=wjn_sl(wjn_vm_list(n(a),'fullfile','micohB'));
%     nD = clone(D,['abs_' D.fname]);
%     nD(:,:,:,:) = abs(D(:,:,:,:));
%     save(nD);
%     d=abs(D(:,:,:,:));
%      D=wjn_tf_wavelet_coherence(D.fullfile,{'Cz','C3'},1:40,25,0);
    D=wjn_tf_multitaper_coherence(D.fullfile,chanpairs,1:40);

    D=wjn_tf_sep_common_baseline(D.fullfile,baseline,'go');
    D=wjn_tf_smooth(D.fullfile,sk(1),sk(2));
    timerange = wjn_sc(D.time,-3):wjn_sc(D.time,3);
    t=D.time(timerange);
    wpli(a,:,:,:) = nanmean(D(ci('M1l-SMA',D.chanlabels),15:20,timerange,ci({'go_aut','go_con'},D.conditions)),2);
    
    tfwpli(a,:,:,:) = D(ci('M1l-SMA',D.chanlabels),:,timerange,ci({'go_aut','go_con'},D.conditions));
 
end
wjn_eeg_vm_plot_tf_diff_stats(t,D.frequencies,squeeze(tfwpli(:,:,:,2)-tfwpli(:,:,:,1)),'SMA-M1')
%
cc = colorlover(5);
figure
h1=mypower(t,wpli(:,:,1),cc(1,:));
hold on
h2=mypower(t,wpli(:,:,2),cc(3,:));
legend([h1 h2],{'automatic','controlled'})

for a = 1:length(timerange)
    p(a) = wjn_ppt(wpli(:,a,2),wpli(:,a,1));
end
% ylim([-0.1 0.1])
pt = fdr_bh(p);
sigbar(t,p<=0.05)
sigbar(t,p<=pt)
ylabel('Imaginary part of coherence [%]')
xlabel('Time [s]')
sigbar(t,p<=pt)
h1=mypower(t,wpli(:,:,1),cc(1,:));
hold on
h2=mypower(t,wpli(:,:,2),cc(3,:));

figone(7)
xlim([-1 1])
% myprint('icoh_M1l-
%%
close all
% go_gm = nanmean(tf(:,:,:,:,[1 2]),5);
go_d = tf(:,:,:,:,2)-tf(:,:,:,:,1);
move_d = tf(:,:,:,:,4)-tf(:,:,:,:,3);
% move_gm = nanmean(tf(:,:,:,:,[3 4]),5);

for a = 1:length(chans)
    timerange = D.indsample(-1.5):D.indsample(1.5);
    freqrange = [1:40];
    ctf = squeeze(go_d(:,a,freqrange,timerange));
wjn_eeg_vm_plot_tf_diff_stats(D.time(timerange),D.frequencies(freqrange),ctf,[strrep(chans{a},'_',' ') ' go diff'])

    ctf = squeeze(move_d(:,a,:,:));
wjn_eeg_vm_plot_tf_diff_stats(D.time,D.frequencies,ctf,[strrep(chans{a},'_',' ') ' move diff'])

end
%%
close all
go_gm = nanmean(tf(:,:,:,:,[1 2]),5);
move_gm = nanmean(tf(:,:,:,:,[3 4]),5);

for a = 1:length(chans)
    ctf = squeeze(go_gm(:,a,:,:));
wjn_eeg_vm_plot_tf_stats(D.time,D.frequencies,ctf,[strrep(chans{a},'_',' ') ' go'])

    ctf = squeeze(move_gm(:,a,:,:));
wjn_eeg_vm_plot_tf_stats(D.time,D.frequencies,ctf,[strrep(chans{a},'_',' ') ' move'])

end

%% 
spm12(1)
clear
p = wjn_vm_list;
patlist = wjn_vm_list('list');
n=[patlist{:,1}];
root = wjn_vm_list('eegroot');
cd(root);
% n(end) =[];
for a = 1:length(n)
    froot = wjn_vm_list(n(a),'dataroot');
    niis{a} = fullfile(froot,'sextract_13-30Hz_con-aut.nii');
end

wjn_nii_average(niis,'grand_average_con-aut_13-30Hz.nii')

wjn_eeg_spm_one_sample('models_con-aut',niis')
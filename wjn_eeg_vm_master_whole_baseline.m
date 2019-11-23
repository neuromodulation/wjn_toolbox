clear all
close all

root = wjn_vm_list('eegroot');
p = wjn_vm_list;
% p = p([7,8,6:-1:1]);

cd(root);

patlist = wjn_vm_list('list');
n=[patlist{:,1}];
%%
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
    
    niis{a} = fullfile(froot,'sextract_13-30Hz_move.nii');
end

wjn_nii_average(niis,'grand_average_move_13-30Hz.nii')

wjn_eeg_spm_one_sample('models_move',niis')

%% create tf var
close all
clear all
baseline = [-2000 -1000];
sk = [4 250];
patlist = wjn_vm_list('list');
n = [patlist{:,1}];
root = wjn_vm_list('eegroot');
cd(root)
[~,chans]=wjn_mni_list;
chans = chans(1:4);
for a  =1:length(n)    
    D=wjn_sl(wjn_vm_list(n(a),'fullfile','mtf_B'));
    D=wjn_tf_sep_common_baseline(D.fullfile,baseline,'go');
    D=wjn_tf_smooth(D.fullfile,sk(1),sk(2));
    
    tf(a,:,:,:,: ) = D(ci(chans,D.chanlabels),:,:,ci({'go_aut','go_con','move_aut','move_con'},D.conditions));
    
    D=wjn_sl(wjn_vm_list(n(a),'fullfile','mB'));
    D(:,:,:,:) = abs(D(:,:,:,:));
    save(D);
    D=wjn_tf_sep_common_baseline(D.fullfile,baseline,'go');
    D=wjn_tf_smooth(D.fullfile,sk(1),sk(2));
end



%%

close all
% go_gm = nanmean(tf(:,:,:,:,[1 2]),5);
go_d = tf(:,:,:,:,2)-tf(:,:,:,:,1);
move_d = tf(:,:,:,:,4)-tf(:,:,:,:,3);
% move_gm = nanmean(tf(:,:,:,:,[3 4]),5);

for a = 1:length(chans)
    timerange = D.indsample(-1):D.indsample(1);
    freqrange = [5:45];
    ctf = squeeze(go_d(:,a,freqrange,timerange));
% np(a,:,:)=wjn_eeg_vm_plot_tf_diff_stats(D.time(timerange),D.frequencies(freqrange),ctf,[strrep(chans{a},'_',' ') ' go diff']);

    ctf = squeeze(move_d(:,a,freqrange,timerange-round(.5*D.fsample)));
% wjn_eeg_vm_plot_tf_diff_stats(D.time(timerange-round(.5*D.fsample)),D.frequencies(freqrange),ctf,[strrep(chans{a},'_',' ') ' move diff'])

end
%%
keep tf chans
D=wjn_sl(wjn_vm_list(2,'fullfile','mtf_B'));
freqrange = [60:90];
timerange = wjn_sc(D.time,-.5):wjn_sc(D.time,.5);
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
baseline = [-3000 -2000];
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
%     D=wjn_sl(wjn_vm_list(n(a),'fullfile','B'));
%     nD = clone(D,['abs_' D.fname]);
%     nD(:,:,:,:) = abs(D(:,:,:,:));
%     save(nD);
%     d=abs(D(:,:,:,:));
%      D=wjn_tf_wavelet_coherence(D.fullfile,chanpairs,1:99,25,0);
%     D=wjn_tf_multitaper_coherence(D.fullfile,chanpairs,1:40);

    D=wjn_tf_sep_common_baseline(D.fullfile,baseline,'go');
    D=wjn_tf_smooth(D.fullfile,sk(1),sk(2));
    timerange = wjn_sc(D.time,-3):wjn_sc(D.time,3);
    t=D.time(timerange);
    wpli(a,:,:,:) = nanmean(D(ci('preSMA-SMA',D.chanlabels),13:30,timerange,ci({'go_aut','go_con'},D.conditions)),2);
   
%     tfwpli(a,:,:,:) = D(ci('preSMA-M1l',D.chanlabels),:,timerange,ci({'go_aut','go_con'},D.conditions));
 
end
% wjn_eeg_vm_plot_tf_diff_stats(t,D.frequencies,squeeze(tfwpli(:,:,:,2)-tfwpli(:,:,:,1)),'SMA-M1')
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
xlim([-3 3])
myprint('icoh_preSMA-SMA')
%%

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
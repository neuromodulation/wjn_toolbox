clear
filename='reproc_N27HC_BW28092017_rest.eeg';
%% convert analyzer file to SPM format
D=wjn_eeg_convert(filename);
%% convert from SPM to fieldTrip
data = D.ftraw(0);
%% rereference to laplacian
cfg = [];
cfg.method = 'spline';
ndata = ft_scalpcurrentdensity(cfg,data);
%% remove all channels except Cz,Fz,C3,C4
cfg = [];
cfg.channel = {'Cz','Fz','C3','C4','P3','P4'};
nndata= ft_preprocessing(cfg,data);
%% convert from FieldTrip to SPM
nD=spm_eeg_ft2spm(nndata,['lr_' D.fname]);
save(nD);
%% add original tablet channels to SPM structure
nnD = clone(D,['c' nD.fname],[nD.nchannels+2 nD.nsamples 1]);
nnD(1:nD.nchannels,:,1) = nD(:,:,:);
nnD(nD.nchannels+1:nD.nchannels+2,:,:) = D(ci({'X','Y'},D.chanlabels),:,:);
nnD = chanlabels(nnD,':',[nD.chanlabels {'X','Y'}]);
nnD = chantype(nnD,1:nD.nchannels,'EEG');
save(nnD)
D=nnD;
keep D
%% Create epochs from event triggers
D=wjn_eeg_auto_epoch(D.fullfile,[-5 5]);
%% Remove artefactual epochs
filename = 'eclr_spmeeg_reproc_N27HC_BW28092017_vm.mat';
D=wjn_eeg_auto_artefacts(filename);
% D=wjn_eeg_auto_artefacts(D.fullfile);
%% Correct the condition labels
D=wjn_eeg_vm_conditions(D.fullfile);
%% Clean out
D=wjn_eeg_vm_clean_trials(D.fullfile);
%% Extract behavior
D=wjn_eeg_vm_extract_behaviour(D.fullfile);
%% Time Frequency Transform
files = ffind('rraeclr_*.mat');
for ni =15:length(files)
    D=wjn_sl(files{ni});
D=wjn_tf_wavelet(D.fullfile,[1:100],15);
% %% Average across trials
D=wjn_average(D.fullfile,1);
% %% Baseline correction
D=wjn_tf_sep_common_baseline(D.fullfile,[-3000 -1000],{'go_aut','go_con'});
% %% TF smoothing
D=wjn_tf_smooth(D.fullfile,4,250);
end
%% plot TF for all conditions
close all
figure
n=0;
conds = {'go_aut','move_aut','stop_aut','go_con','move_con','stop_con'};
for b =1 :D.nchannels
    for a = 1:D.ntrials     
        n=n+1;
        subplot(D.nchannels,D.ntrials,n)
        wjn_plot_tf(D,b,conds{a})
        caxis([-50 100])
        if a==1
            ylabel(D.chanlabels{b})
        end
        if b==1
            title(strrep(conds{a},'_',' '));
        end
    end
end
figone(20,30)
fname = D.fname;
myprint(['blocks_TF_' fname(1:end-4)])

%% plot TF for b1 conditions
close all
figure
n=0;
conds = {'go_aut_b1','move_aut_b1','stop_aut_b1','go_con_b1','move_con_b1','stop_con_b1'};
for b =1 :D.nchannels
    for a = 1:D.ntrials     
        n=n+1;
        subplot(D.nchannels,D.ntrials,n)
        wjn_plot_tf(D,b,conds{a})
        caxis([-50 100])
        if a==1
            ylabel(D.chanlabels{b})
        end
        if b==1
            title(strrep(conds{a},'_',' '));
        end
    end
end
figone(20,30)
fname = D.fname;
myprint(['block1_TF_' fname(1:end-4)])

%% plot TF for all conditions
close all
figure
n=0;
conds = {'go_aut_b2','move_aut_b2','stop_aut_b2','go_con_b2','move_con_b2','stop_con_b2'};
for b =1 :D.nchannels
    for a = 1:D.ntrials     
        n=n+1;
        subplot(D.nchannels,D.ntrials,n)
        wjn_plot_tf(D,b,conds{a})
        caxis([-50 100])
        if a==1
            ylabel(D.chanlabels{b})
        end
        if b==1
            title(strrep(conds{a},'_',' '));
        end
    end
end
figone(20,30)
fname = D.fname;
myprint(['block2_TF_' fname(1:end-4)])



%% Gruppen Analyse Time Frequency
files = ffind('scrmtf*.mat');
channel = 'C3'; %  'Fz'    'C3'    'Cz'    'C4'    'P3'    'P4'
cond = 'go'; % go move go_aut go_con move_aut move_con

for a = 1:length(files)
    D=wjn_sl(files{a});
    D=wjn_tf_smooth(D.fullfile,6,300);
    tf(a,:,:) = squeeze(nanmean(D(ci(channel,D.chanlabels),:,:,ci(cond,D.conditions)),4));
end
[p,fdr]=wjn_tf_signrank(tf,0.05)
%[p,fdr]=wjn_tf_ppt(tf,0.01)
   
figure
subplot(1,2,1)
wjn_contourf(D.time,D.frequencies,tf)
xlim([-3 3])
title([channel ' - ' strrep(cond,'_',' ')])
caxis([-50 50])
c=colorbar
ylabel(c,'Relative spectral power [%]')
TFaxes
subplot(1,2,2)
wjn_contourf(D.time,D.frequencies,([p<=0.05])+([p<=fdr])) % p wert 0.05
TFaxes
colorbar
xlim([-3 3])
figone(7,20)
myprint(['group_onesample_' channel '_' cond]);
% 
%% Gruppen Analyse Time Frequency zwischen Bedingungen
files = ffind('scrmtf*.mat');
channel = 'Cz';
cond1 = 'go_aut'; % Durch rechnen für go und move + aut und con
cond2 = 'go_con';

for a = 1:length(files)
    D=wjn_sl(files{a});
    D=wjn_tf_smooth(D.fullfile,6,300);
    tf1(a,:,:) = squeeze(nanmean(D(ci(channel,D.chanlabels),:,:,ci(cond1,D.conditions)),4));
    tf2(a,:,:) = squeeze(nanmean(D(ci(channel,D.chanlabels),:,:,ci(cond2,D.conditions)),4));
end
tf = tf2-tf1; %% condition 2 - 1
[p,fdr]=wjn_tf_signrank(tf,0.05);
% [p,fdr]=wjn_tf_ppt(tf,0.05);
   

figure
subplot(1,2,1)
wjn_contourf(D.time,D.frequencies,tf)
xlim([-3 3])
%title([channel ' - ' strrep(cond,'_','')])fdr
title([channel ' - ' 'go con - aut'])
caxis([-15 15])
c=colorbar
ylabel(c,'Relative spectral power [%]')
TFaxes
subplot(1,2,2)
wjn_contourf(D.time,D.frequencies,([p<=0.05])+([p<=fdr]))
TFaxes
colorbar
xlim([-3 3])
figone(7,20)
myprint(['group_difference_' channel '_' cond2 '-' cond1]);


%% NEUE BURST ANALYSE
% filename = 'clr_spmeeg_reproc_N27HC_BW28092017_rest.mat';
% D=wjn_sl(filename);
% D=wjn_tf_wavelet(D.fullfile) % nicht tf_rraeclr sondern tf_clr
% D=wjn_tf_smooth(D.fullfile,4,250);
files = ffind('stf_clr*rest.mat');
for a = 1:length(files)
    D=wjn_sl(files{a});
    wjn_tf_full_bursts(D.fullfile);
end



D=wjn_sl('mtf_*JD*.mat')
D=wjn_tf_baseline(D.fullfile,[-2000 -500]);
D=wjn_tf_smooth(D.fullfile,3,50)

figure
for a = 1:D.nchannels
subplot(1,D.nchannels,a)
    wjn_plot_tf(D,a,2,50)
ylim([1 200])
TFaxes
caxis([-100 500])
xlim([-2.5 2.5])
title(D.chanlabels{a})
end
figone(4,40)
myprint(fullfile('case_example','TF_pb_force'))

%%
load NN_force_signle_stripJD05_R.mat
% load NN_burst_single_strip_JD05_R.mat
D=wjn_sl('tf_dcont*JD*.mat')


figure
plot(D.time,nn.force.YC)

% 
% figure
% wjn_plot_tf(D,'Strip',2,25)
% ylim([1 200])
% xlim([-2.5 2.5])
% caxis([-100 500])
% myprint(fullfile('case_example','TF_ECOG_pb_force'))
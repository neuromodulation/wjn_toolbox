%% find good channels
D=wjn_sl('srmtf*.mat')

figure
for a = 1:18
subplot(1,18,a)
wjn_plot_tf(D,a,'vowel_onset')
ylim([1 200])
TFaxes
caxis([-100 500])
xlim([-2.5 2.5])
title(D.chanlabels{a})
end
figone(4,40)

%%
Dr = wjn_sl('dff*.mat');
% D=wjn_sl('tf_ff*.mat');
D = wjn_tf_wavelet(Dr.fullfile,0:5:400,200);
Dr = wjn_downsample(Dr.fullfile,50);
D.audio_env = Dr(ci('audio_env',Dr.chanlabels),:,1);
D.naudio_env = wjn_zscore(D.audio_env);

D.speak = D.naudio_env>.5;
D.gnaudio_env = D.naudio_env.*D.speak;
D.gnaudio_env = D.gnaudio_env./max(D.gnaudio_env);


i = [464:3000 4108:8562 29360:37559];% 
% i=[];

nspeak = D.speak(i);

inspeak = mythresh(mydiff(nspeak),0.5,50);
dataindex = [];
for a = 1:length(inspeak)
    dataindex = [dataindex i(inspeak(a))-50:i(inspeak(a))+50];
end

i = dataindex;
oX=wjn_nn_feature_table(D,[],[],[],i);
% oX.raw_13_raw = smooth(squeeze(Dr(ci('raw_13',Dr.chanlabels),:,1)),Dr.fsample*.33);
% oX.raw_14_raw = smooth(squeeze(Dr(ci('raw_14',Dr.chanlabels),:,1)),Dr.fsample*.33);
oT=D.speak(i);

X = oX;
T = oT;
tD={[1 5 10]};

[net,Y,L,chans]=wjn_nn_all_channels(X,T,0,repmat({[8 8]},[1 5]),tD);
save speaknet L chans

T = D.naudio_env(i);
% X.netout = Y;
[net,Y,L,chans]=wjn_nn_all_channels(X,T,0,repmat({[8 8]},[1 5]),tD);
save volnet L chans

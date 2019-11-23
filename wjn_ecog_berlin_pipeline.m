function wjn_ecog_berlin_pipeline(filename)
%%
% D=wjn_spikeconvert(filename,[],0,0);
filename = ffind('spm*.mat',0);
D=wjn_downsample(filename,300,150);
D=wjn_linefilter(D.fullfile);
D=wjn_ecog_rereference(D.fullfile);
fsignal =wjn_smoothn(mydiff(squeeze(D(ci('AO1',D.chanlabels),:,1))),100);

%%
clear conditionlabels
estart = mythresh(fsignal.*-1,0.001,1200);
estart(end)  = [];
eback=mythresh(fsignal,0.001,1200);
eback(1) = [];


% e = mythresh(,:,1).*-1,-4.9);
f = find(D(ci('AO2',D.chanlabels),:,1)>-1.5);

e = [estart,eback];
conditionlabels(ismember(estart,f)) = {'start_low_force'};
conditionlabels(~ismember(estart,f)) = {'start_high_force'};
conditionlabels(length(estart)+find(ismember(eback,f))) = {'back_low_force'};
conditionlabels(length(estart)+find(~ismember(eback,f))) = {'back_high_force'};

D=wjn_epoch(D.fullfile,[-6000 7000],conditionlabels,D.time(e)');
% ff=[1 3 7 13 20 35 60 90 120 180 250];
% ff=[2:3:35 43:99 114:15:250];
ff=[1:250];
D=wjn_tf_wavelet(D.fullfile,ff,25);
D=wjn_average(D.fullfile,1);
D=wjn_tf_baseline(D.fullfile);
D=wjn_tf_smooth(D.fullfile,4,250);
%%
D=wjn_sl('mtf_errlfds*.mat');
D=wjn_tf_baseline(D.fullfile,[-2000 0]);
D=wjn_tf_smooth(D.fullfile,8,500);
%

for a =1:D.nchannels
figure
imagesc(D.time,D.frequencies,interp2(squeeze(nanmean(D(a,:,:,[1 2]),4))))
colormap('jet')
axis xy
title(D.chanlabels{a})
caxis([-50 60])
ylim([1 150])
myprint(D.chanlabels{a})
myprint([D.chanlabels{a} '_move'])
end


%%
% 
D=wjn_spikeconvert('407FL66_rest_ON.mat')
D=wjn_downsample(D.fullfile,1000,500);
D=wjn_linefilter(D.fullfile)
D=wjn_ecog_rereference(D.fullfile)
D=wjn_tf_wavelet(D.fullfile,[1:500],25)

pow = squeeze(nanmean(D(:,:,:,1),3));

c=colorlover(5);
c2 = colorlover(6);
cc=[c([1;3;4;5],:);c2];
% cc=colorlover(6);

close all
% for a = 1:6
    figure('color','k','inverthardcopy','off')
    plot(D.frequencies,squeeze(nanmean(D(:,:,:,1),3)),'linewidth',3)
%     set(gca,'color','k','ycolor','w','xcolor','w')
    figone(7)
    legend(D.chanlabels{a},'color','none','textcolor','w')
    ylim([0 3])
%     myprint(['REST_ECOG' num2str(a)])
% end



%%
clear pow
fnames = {'stim_off.mat','stim_2-5_rest.mat','stim_2-5_move.mat'}
for a = 1:length(fnames)
%     load(fnames{a});
%     save(fnames{a},'ECOGL12','ECOGL13','ECOGL14','ECOGL15','ECOGL16')
%     
%     D=wjn_spike_ecog(fnames{a});
%     D=wjn_tf_wavelet(D.fullfile,[1:85],25);
    D=wjn_sl(['tf_*' fnames{a}])
    pow(a,:,:) = wjn_raw_power_normalization(squeeze(nanmean(D(:,:,:,1),3)),D.frequencies,[5 95]);
    
end
cc=colorlover(5);
cc=cc([1 4 5],:);
for a = 1:6
    figure('color','k','inverthardcopy','off')
    plot(D.frequencies,squeeze(pow(1,a,:)),'linewidth',3,'color',cc(1,:))
    hold on
   
    plot(D.frequencies,squeeze(pow(2,a,:)),'linewidth',3,'color',cc(2,:))
    plot(D.frequencies,squeeze(pow(3,a,:)),'linewidth',3,'color',cc(3,:))
    figone(7)
    l=legend('STIM OFF REST','STIM ON REST','STIM ON MOVE')
    set(l,'color','none','Textcolor','w')
    xlabel('Frequency [Hz]')
    ylabel('Relative spectral power [a.u.]')
    title(D.chanlabels{a})
    xlim([5 40])
    ylim([0 2.5])
     set(gca,'color','k','xcolor','w','ycolor','w')
    myprint(['STIM_' D.chanlabels{a}])
end


%%

D=wjn_sl('srm*rrlfd*.mat');

figure('color','k','inverthardcopy','off')
wjn_contourf(D.time,D.frequencies,D([3],:,:,1),250)
caxis([-20 50])
TFaxes
set(gca,'color','k','xcolor','w','ycolor','w')
xlim([-2 6])
ylim([1 130])
c=colorbar
c.Color='w';
figone(7)
c.Label.String ='Relatve spectral power [%]';
myprint('self_paced_ECOG')
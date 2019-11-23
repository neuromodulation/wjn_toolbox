
% D=wjn_spike_ecog('block_rota_on.mat');
% 
% 
% % D=wjn_downsample(D.fullfile,1000);
% 
% D=wjn_remove_channels(D.fullfile,'oECOG')
% 
% 
% D=wjn_tf_wavelet(D.fullfile,[1:300],15);
% D=wjn_tf_smooth(D.fullfile,1,250);

%%
root = 'E:\Dropbox\Motorneuroscience\ecog_berlin\407LF66';
cd(root)
% 
clear
% Dr = wjn_sl('brrdspm*block_rota_on*.mat');
D = wjn_sl('tf_brrdspm*block_rota_on*.mat');
% D.rota = D.AO1;
D.velocity = mydiff(D.AO1);
D.velocity([1:10 end-9:end]) = 0;

D.speed = smooth(abs(D.velocity),D.fsample*2);
D.speed = D.speed./max(D.speed);
plot(D.time,D.speed,D.time,abs(D.velocity));
tD=0:15;
CX=wjn_nn_feature_table(D,'ECOG');
CX.Properties.Description = 'MOVE_BERLIN_CLASSIFICATION';
T=D.speed;
T=T./max(T);
T=T>0.13;
close all
[Cout, CL] = wjn_nn_all_channels(CX,T,0,[8 8 8],tD,{1:2900,2901:D.nsamples,[]});
save classify_allchans CL Cout
T = D.speed;
RX=CX;
RX.Properties.Description = 'MOVE_BERLIN_BRADYKINESIA_REGRESSION';
for a=1:size(Cout,1)
 RX.([Cout.chans{a} '_move']) = CL(a).Y';
end
i = find(T>0.1);
[Rout, RL] = wjn_nn_all_channels(RX(i,:),T(i),0,[8 8 8],tD,{1:1400,1401:length(i),[]});
CX.Properties.Description = 'MOVE_BERLIN_BRADYKINESIA_ICA_REGRESSION';
for a=1:size(Rout,1)
ic = ci([Rout.chans{a} '_'],RX.Properties.VariableNames);
RX.([Rout.chans{a} '_speed']) = cell2mat(seq2con(RL(a).net(con2seq(table2array(RX(:,ic))'))))';
end
tD=0:2:6%:15 
[net,Y,L] = wjn_nn_classifier_2(RX(i,:),T(i),40,40,tD,0,0,1,{[1:1400]+1400,[1401:length(i)]-1400,[]});
save BRADYKINESIA_ICA L RL Rout

nY=RL(2).Y%-min(RL(2).Y);
% nY=nY./max(nY);

rota = wjn_zscore(D.AO1);

for a = 1:length(RL)
    iY(a,:) = RL(a).Y;
end

X=array2table(iY')
[~,~,L]=wjn_nn_classifier_2(X,RL(end).T,0,[12 12 12],[0:2:6],0,0,0,{463:length(i),1:462,[]})

nnY=zeros([1 size(T,1)]);
nnY(:,i) = L.Y';


figure
cc = colorlover(7);
% cc =[0 0 0;cc([1 2 ],:)];
plot(D.time,T.*100,'color','k','linewidth',2)
hold on
% plot(D.time,nnY.*100,'color',cc(1,:),'linewidth',2)
plot(D.time,20+rota*10,'color',[.5 .5 .5])
sigbar(D.time,CL(2).Y>CL(2).thr)
sigbar(D.time(i(1:463)),CL(2).Y(i(1:463))>CL(2).thr,cc(2,:))
plot(D.time,T.*100,'color','k','linewidth',2)
hold on
plot(D.time,nnY.*100,'color',cc(1,:),'linewidth',2)
% mypower(D.time,nnY.*100,cc(1,:),'std')

plot(D.time,20+rota*10,'color',[.5 .5 .5])
figone(4,40)
ylabel('Velocity [%]')
xlabel('Time [s]')
xlim([0 200])
ylim([0 110])
myprint('Velocity prediction')

%%

root = 'E:\Dropbox\Motorneuroscience\ecog_berlin\407LF66';
cd(root)
% 
clear
% Dr = wjn_sl('brrdspm*block_rota_on*.mat');
D = wjn_sl('tf_brrdspm*block_rota_on*.mat');
D=wjn_tf_baseline(D.fullfile,[1000 20000]);
D=wjn_tf_smooth(D.fullfile,2,500);

i = D.indsample(3):D.nsamples;
rota = D.AO1(1,i,1);
rota =rota-min(rota);
rota = rota./max(rota);
D.velocity = mydiff(D.AO1);
D.velocity([1:10 end-9:end]) = 0;
D.speed = smooth(abs(D.velocity(i)),D.fsample*2);
D.speed = D.speed./max(D.speed);
speed = D.speed;
tr = D.time(i); 
beta = squeeze(nanmean(D(7,13:20,i,1),2));
beta = beta/max(beta);
gamma = squeeze(nanmean(D(7,60:90,i,1),2));
gamma = gamma/max(gamma);
betagamma = beta./gamma;
betagamma = betagamma./max(betagamma);

figure
plot(tr,rota,'linewidth',.1,'color','k');
figone(4,40)
myprint('rota')

figure
plot(tr,smooth(speed,3),'color','k','linewidth',2)
figone(4,40)
myprint('rota_speed')

%% 
clear all
cd('E:\Dropbox (Brain Modulation Lab)\Analysis_FieldTrip\analysis')

D=wjn_sl('ssrmtf_peffDBS2015_session3.mat')


tf = squeeze(nanmean(D(7,:,i,1),1));
% tf = wjn_raw_baseline(tf,D.frequencies);
% tf = smooth2a(tf,5,round(.25*D.fsample));
figure
wjn_contourf(tr,D.frequencies,tf);
axis xy
ylim([0 100])
figone(5,40)
caxis([-100 100])
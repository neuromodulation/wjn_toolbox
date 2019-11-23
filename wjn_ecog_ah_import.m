function wjn_ecog_ah_import(filename)

root = fullfile(mdf,'ecog');
cd(root)
load files

id = filename(1:4);

load(fullfile(root,'raw',filename),'signal','CueStimulusTimes','CommandStimulusTimes','LeftResponseTimes','RightResponseTimes','FeedbackStimulusTimes','Force','time1kHz','labels');

str = stringsplit(filename,'_');

if strcmp(str{1}(1:2),'MM')
    Force = Force(:,[2,1]);
end

s4 = ci({'STN4','STN32'},labels);


f=resample(Force,time1kHz,1200);

signal = [signal f(1:size(signal,1),:)];
labels(end+1:end+2)  = {'force_left','force_right'};
if ~isempty(s4);
    D=wjn_import_rawdata(['s_' filename],signal(:,1:end ~= s4)',labels(1:end ~= s4),1200);
else
    D=wjn_import_rawdata(['s_' filename],signal(:,1:end)',labels(1:end),1200);
end
    D=chantype(D,':','LFP');
D=chantype(D,ci('force',D.chanlabels),'Other');


D.trialtimes.LeftResponseTimes = time1kHz(LeftResponseTimes);
D.trialtimes.RightResponseTimes = time1kHz(RightResponseTimes);
D.trialtimes.FeedbackStimulusTimes = FeedbackStimulusTimes;
D.trialtimes.CueStimulusTimes = CueStimulusTimes;
D.trialtimes.CommandStimulusTimes = CommandStimulusTimes;
% D.trialtimes.baseline = baseline;
D.hemisphere = str{2}(1);

if strcmp(str{2}(1),'R')
    con = 'Left';
    ips = 'Right';
    fi = length(labels)-1;
else
    con = 'Right';
    ips = 'Left';
    fi = length(labels);
end

etimes = {'CueStimulusTimes',[con 'ResponseTimes']};


irest = wjn_sc(D.time,CueStimulusTimes);

iirest = [];
for a = 1:length(irest)
    iirest =[iirest irest(a)-D.fsample:irest(a)];
end

D = chantype(D,D.nchannels-1:D.nchannels,'Other');
save(D)

D=wjn_filter(D.fullfile,[58 62],'stop');
% D=wjn_filter(D.fullfile,[118 122],'stop');
% D=wjn_filter(D.fullfile,[178 182],'stop');

Drest = wjn_import_rawdata(['rest_' filename],squeeze(D(1:D.nchannels-2,iirest)),D.chanlabels(D.indchantype('LFP')),D.fsample);



Dmove = wjn_epoch(D.fullfile,[-3 3],'move',D.trialtimes.([con 'ResponseTimes'])','move');
Dmove = wjn_tf_wavelet(Dmove.fullfile,1:100,15);
Dmove = wjn_average(Dmove.fullfile,1);
Dmove = wjn_tf_baseline(Dmove.fullfile);


for a = 1:Dmove.nchannels-2
    figure
    wjn_plot_tf(Dmove,a)
    title(D.chanlabels{a});
    drawnow
    myprint(['../ecog_figures/' id 'TF_move_' Dmove.chanlabels{a}])
end


Dcont = wjn_import_rawdata(['cont_' filename],squeeze(D(:,iirest(1)-D.fsample:wjn_sc(D.time,FeedbackStimulusTimes(end)))),D.chanlabels,D.fsample)


Dcont = chantype(Dcont,Dcont.nchannels-1:Dcont.nchannels,'Other');
save(Dcont)



oD = wjn_spm_copy(Dcont.fullfile,['o' Dcont.fname]);
oD = wjn_downsample(oD.fullfile,450,200);
Dcont = wjn_downsample(Dcont.fullfile,200,95,'d');


oDrest = wjn_spm_copy(Drest.fullfile,['o' Dcont.fname]);
oDrest = wjn_downsample(oDrest.fullfile,450,200);
Drest = wjn_downsample(Drest.fullfile,200,95,'d');

ichans = Dcont.indchantype('LFP');
chans = Dcont.chanlabels(ichans);
[pow,f,rpow]=wjn_raw_fft(squeeze(Dcont(ichans,:,1)),Dcont.fsample);


   stnch = ci('STN',Dcont.chanlabels)
    figure
    plot(f,pow(stnch,:),'LineWidth',2)
    hold on
    xlim([5 35])
 
    for b = 1:length(stnch)
        [peak.STNpeak{b},peak.STNpeakfrequency{b}] = findpeaks(pow(stnch(b),12:35),'MinPeakDistance',5);
        if isempty(peak.STNpeak{b})
            continue
        end
        peak.STNpeakfrequency{b} = peak.STNpeakfrequency{b}+10;
        [m,i]=max(peak.STNpeak{b});
        peak.STNpeaks(b,:) = [m peak.STNpeakfrequency{b}(i)];
        scatter(peak.STNpeakfrequency{b},peak.STNpeak{b})
    end
    
    [peak.sSTNpeakamp,peak.sSTNcontact] = max(peak.STNpeaks(:,1),[],1);
    peak.sSTNpeakfrequency = peak.STNpeaks(peak.sSTNcontact,2);
    scatter(peak.sSTNpeakfrequency,peak.sSTNpeakamp,'rsq','filled')
    peak.sSTN = Dcont.chanlabels(stnch(peak.sSTNcontact));
    figone(7)
    legend(Dcont.chanlabels(stnch))
    xlabel('Frequency [Hz]')
    ylabel('Power [a.u.]')
    myprint(['../ecog_figures/' id '_STN_peaks'])
    
sSTN = peak.sSTN{1};
iSTN = peak.sSTNcontact;
sStrip = channel_finder('Strip',Dcont.chanlabels);
STNch = channel_finder('STN',Dcont.chanlabels);

figure
for a = 1:length(chans)
    subplot(1,length(chans),a)
    if strcmp(chans{a},sSTN)
        col = 'r';
    else
        col = 'k';
    end
    plot(f,pow(a,:),'color',col,'linewidth',3)
    xlim([3 40])
%     ylim([0 1.2])
    xlabel('Frequency [Hz]')
    ylabel('Power [%]')
    title(chans{a})
end
figone(7,50)
%%
myprint(['../ecog_figures/' id '_power_spectra'])


clear gdata
peakrange = [peak.sSTNpeakfrequency-5 peak.sSTNpeakfrequency+5];
% da=wjn_eeg_burst_analysis(Dcont.fullfile,[8 12],[],{sSTN sStrip},[],'brown');
drpk=wjn_eeg_burst_analysis(Drest.fullfile,peakrange,[],[STNch sStrip],[],'brown');
dpk=wjn_eeg_burst_analysis(Dcont.fullfile,peakrange,[],[STNch sStrip],[],'brown');
dhb=wjn_eeg_burst_analysis(Dcont.fullfile,[20 30],[],[STNch sStrip],[],'brown');
dlb=wjn_eeg_burst_analysis(Dcont.fullfile,[10 20],[],[STNch sStrip],[],'brown');
db=wjn_eeg_burst_analysis(Dcont.fullfile,[12 35],[],[STNch sStrip],[],'brown');
dg=wjn_eeg_burst_analysis(Dcont.fullfile,[40 95],[],[STNch sStrip],[],'brown');
dr=wjn_eeg_burst_analysis(Drest.fullfile,[peak.sSTNpeakfrequency-5 peak.sSTNpeakfrequency+5],[],[STNch sStrip],[],'brown');

%
md = dpk.rawamp(iSTN,:)>=median(dpk.rawamp(iSTN ,:));
md=md';
%
itr = 1:Dcont.nsamples/2;
ist = round(((Dcont.nsamples/2)+1)):Dcont.nsamples;
% svm = fitcsvm([da.rawamp(2,itr)',dpk.rawamp(2,itr)',dhb.rawamp(2,itr)'],md(itr)');
% gdata = [squeeze(Dcont(D.indchannel(sStrip),:,1));da.rawamp(2,:);dlb.rawamp(2,:);dhb.rawamp(2,:);dg.rawamp(2,:)]';
gdata = dpk.rawamp(ci('Strip',dpk.channels),:)';
stimon = md;%mydiff(md(:,1))==1;
ilb = dpk.burstduration(iSTN,:,:)>prctile(dpk.bdur{iSTN},75);
isb = dpk.burstduration(iSTN,:,:)>0 & dpk.burstduration(iSTN,:,:)<prctile(dpk.bdur{iSTN},25);
% svml = fitcsvm(gdata(itr,:),ilb(itr));
% g=svml.predict(gdata(itr,:));

ichs = ci([sSTN sStrip],Dcont.chanlabels);


iilb = find(ilb);
iisb = find(isb);

irlb = drpk.burstduration(iSTN,:,:)>prctile(drpk.bdur{iSTN},75);
irsb = drpk.burstduration(iSTN,:,:)>0 & drpk.burstduration(iSTN,:,:)<prctile(drpk.bdur{iSTN},25);

iirlb = find(irlb);
iisb = find(irsb);

timerange = 2;
iti = Dcont.fsample*timerange;

iilb(iilb<iti+1|iilb>length(isb)-iti-1) = [];
iisb(iisb<iti+1|iisb>length(isb)-iti-1) = [];
nb = min([length(iilb) length(iisb)]);

lnd=[];snd=[];lraw=[];sraw=[];
for a= 1:nb
    ict = iilb(a)-iti:iilb(a)+iti;
    lnd(a,:,:) = [dpk.rawamp(iSTN,ict)' gdata(ict,:)];
    lraw(a,:,:) = Dcont(ichs,ict,1);
end

for a= 1:nb
    ict=iisb(a)-iti:iisb(a)+iti;
    snd(a,:,:) =  [dpk.rawamp(iSTN,ict)' gdata(ict,:) ];
    sraw(a,:,:) = Dcont(ichs,ict,1);
end

istrips=ci('Strip',Dmove.chanlabels)
gamma = squeeze(nanmean(Dmove(ci('Strip',Dmove.chanlabels),60:90,:,1),2))
[~,igamma] = max(nanmean(gamma(:,Dmove.indsample(-.25):Dmove.indsample(.25)),2));
gammaStrip = Dmove.chanlabels{istrips(igamma)};
nt = linspace(-timerange,timerange,length(ict));
ipowraw = wjn_sc(nt,-.25):wjn_sc(nt,.25);


chs = [sSTN sStrip];
[~,ibetaStrip] = max(nanmean(nanmean(lnd(:,ipowraw,2:end))+nanmean(snd(:,ipowraw,2:end)),2))
ibetaStrip = ibetaStrip+1;
betaStrip = chs{ibetaStrip}



cc=colorlover(1);


close all
figure
for a = 1:size(snd,3)
    subplot(1,size(snd,3),a)
    sp=mypower(nt,snd(:,:,a),cc(3,:),'sem')
    ylabel('Beta power [a.u.]')
    xlabel('STN burst aligned time [s]')
    hold on
    lp=mypower(nt,lnd(:,:,a),cc(2,:),'sem')
    xlim([-1 1])
    title(chs{a})
    if a==size(snd,3)
%         ylim([3 15])
        legend([sp lp],{'short bursts','long bursts'},'location','NorthEast')
    end
    
    if strcmp(chs{a},gammaStrip)
        legend('gammaStrip')
    elseif strcmp(chs{a},betaStrip)
        legend('betaStrip')
    end
end
figone(7,50)
myprint(['../ecog_figures/' id 'burst aligned power'])



ss = betaStrip;
srawstn = squeeze(sraw(:,1,ipowraw))';
srawstrip = squeeze(sraw(:,ci(ss,chs),ipowraw))';
lrawstn = squeeze(lraw(:,1,ipowraw))';
lrawstrip = squeeze(lraw(:,ci(ss,chs),ipowraw))';

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

mlpow = squeeze(nanmean(lnd(:,ipowraw,:),2));
mspow = squeeze(nanmean(snd(:,ipowraw,:),2));


models.swls=stepwiselm([mlpow(:,2:end);mspow(:,2:end)],[mlpow(:,1);mspow(:,1)])
models.sws=stepwiselm(mspow(:,2:end),mspow(:,1))
models.swl=stepwiselm(mlpow(:,2:end),mlpow(:,1))

models.fulll=fitlm(mlpow(:,2:end),mlpow(:,1))
models.fulls=fitlm(mspow(:,2:end),mspow(:,1))
models.fullls=fitlm([mlpow(:,2:end);mspow(:,2:end)],[mlpow(:,1);mspow(:,1)])
% fitlm([mlpow(:,1);mspow(:,1)],[mlpow(:,2);mspow(:,2)])

ms= table2array(models.fullls.Coefficients(:,{'Estimate','pValue'}))

ms(ms(:,1)<=0,:) = nan;

[~,irStrip]=nanmin(ms(2:end,2));

irStrip = irStrip+1;
regressionStrip = chs{irStrip};



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


[itrl,si]=sort([iisb(1:nb) iilb(1:nb)]);
trl = Dcont.time(itrl);
conditionlabels = [repmat({'short_burst'},[1,nb]) repmat({'long_burst'},[1,nb])];
conditionlabels = conditionlabels(si);
% dD = wjn_downsample(oD.fullfile,450,200);
De=wjn_epoch(oD.fullfile,[-2 2],conditionlabels,trl');

Dtf = wjn_tf_wavelet(De.fullfile,[1:200],15);
Da = wjn_average(Dtf.fullfile,1);
Dr = wjn_tf_baseline(Da.fullfile);

Der = wjn_epoch(oDrest.fullfile,[1:200],15);
Drtf = wjn_tf_wavelet(Der.fullfile,[1:200],15);
Dar = wjn_average(Drtf.fullfile,1);
Drr = wjn_tf_baseline(Dar.fullfile);

close all
for a = 1:Dr.nchannels
    figure
    subplot(1,2,1)
    wjn_plot_tf(Dr,a,'short')
    caxis([-100 200])
    xlim([-1 1])
    ylim([2 40])
    TFaxes
    ylabel(Dr.chanlabels(a))
    title('short bursts')
    subplot(1,2,2)
    wjn_plot_tf(Dr,a,'long')
    xlim([-1 1])
    ylim([2 40])
    caxis([-100 200])
    title('long bursts')
    TFaxes
    figone(7,20)
    myprint(['../ecog_figures/' id '_TF_' Dr.chanlabels{a} ])
%     ylim([2 200])<<r
end
%%

% De=wjn_sl('edo*WO*.mat');

% De = wjn_keep_channels(De.fullfile,{'STN1','Strip3'});
% pacflow=[5:5:40];
% pacfhigh = [40:10:200];
% Dp=wjn_cfc(De.fullfile,[-.25 0.25],pacflow,pacfhigh);
% 
% 
% smspac = squeeze(nanmean(Dp(ci(sSTN,Dp.chanlabels),:,:,ci('short',Dp.conditions)),1));
% smlpac = squeeze(nanmean(Dp(ci(sSTN,Dp.chanlabels),:,:,ci('long',Dp.conditions)),1));
% 
% %
% ich = ci(ss,Dp.chanlabels);
% 
% cmspac = squeeze(nanmean(Dp(ich,:,:,ci('short',Dp.conditions)),1));
% cmlpac = squeeze(nanmean(Dp(ich,:,:,ci('long',Dp.conditions)),1));
% 
% freqrange = [peak.sSTNpeakfrequency-5 peak.sSTNpeakfrequency+5];
% 
% figure
% subplot(2,2,2)
% wjn_contourf(Dp.f1,Dp.f2,smlpac)
% ca = get(gca,'clim')
% xlim(freqrange)
% title('PAC long bursts')
% ylabel('STN Frequency [Hz]')
% xlabel('Frequency [Hz]')
% subplot(2,2,1)
% wjn_contourf(Dp.f1,Dp.f2,smspac)
% caxis([0 .2])
% ylabel('STN Frequency [Hz]')
% xlabel('Frequency [Hz]')
% title('PAC short bursts')
% xlim(freqrange)
% 
% caxis(ca)
% subplot(2,2,4)
% wjn_contourf(Dp.f1,Dp.f2,cmlpac)
% % caxis([0 .4])
% ylabel('Frequency [Hz]')
% xlabel('Frequency [Hz]')
% title('ECOG PAC long bursts')
% xlim(freqrange)
% ca = get(gca,'clim')
% subplot(2,2,3)
% wjn_contourf(Dp.f1,Dp.f2,cmspac)
% caxis(ca)
% ylabel('Frequency [Hz]')
% xlabel('Frequency [Hz]')
% title('ECOG PAC short bursts')
% xlim(freqrange)
% 
% 
% myprint(['../ecog_figures/' id '_ECOG_PAC'])

%%
% figure
% n=0;
% 
% 
% 
% for b = 1:3
% for a = 1:Dp.nchannels
% 
%     n=n+1;
% subplot(3,Dp.nchannels,n)
% imagesc(Dp.f1,Dp.f2,squeeze(Dp(a,:,:,b)))
% axis xy
% xlim([6 35])
% ylim([40 160])
% xlabel('Frequency [Hz]')
% ylabel(Dp.chanlabels{a})
% title(Dp.conditions{b})
% % hold on
% % wjn_contourp(Dp.f1,Dp.f2,squeeze(Dp.p(a,:,:,b))<=.05)
% end
% end
% myprint(['../ecog_figures/' id '_PAC_matrix'])


% pacd = squeeze(nanmean(nanmean(Dp(:,D.indfrequencyfreqrange,:,2),2),3)-nanmean(nanmean(Dp(:,freqrange,:,1),2),3));

%
restfile = Drest.fullfile;
contfile = Dcont.fullfile;
efile = De.fullfile;
pacfile = Dp.fullfile;
movfile = Dmove.fullfile;
tffile = Da.fullfile;
tfrfile = Dar.fullfile;
rtffile = Dr.fullfile


clearvars D* 
clearvars oD*
save(['bdata_' filename]);
% figure
% plot(mydiff(g)+2),hold on,plot(mydiff(ilb(ist)))
% 
%           
% %        cv = crossval(svm);
% %        [~,score] = kfoldPredict(cv);
% %       mean(score<0));
% 
% % g = svmclassify(svm,gdata(ist,:),'showplot','true');
% 
% 
% %%
% figure
% plot(d.t,d.rawamp(1,:)>median(d.rawamp(1,:)));
% % wjn_burst_aligned_bursts(d);
% cfg = [];
% 
% %%
% 
% Force = D(fi,:,1);
% 
% [force,iforce] = findpeaks(Force(:),'MinPeakDistance',500,'MinPeakHeight',50);
% 
% df = mydiff(wjn_quickfilter(Force(:),1200,[0.0001 30]));
% 
% conditionlabels = {};
% for a = 1:length(iforce)
%     [forceyank(a),i]=findpeaks(df(iforce(a)-500:iforce(a)),'npeaks',1,'SortStr','descend');
%     iforceyank(a) = iforce(a)-500+i;
%     conditionlabels = [conditionlabels {'yank','force'}];
% end
% 
% x=[1:length(Force) 1:length(Force)];
% i = sort([x(iforce) x(iforceyank)]);
% 
% 
% trl = D.time(i)';
% D.conditionlabels = conditionlabels;
% D.trl = trl;
% 
% 
% D.force = force;
% D.forceyank = forceyank';
% save(D)
% %%
% 
% D = wjn_epoch(D.fullfile,[-3 3],D.conditionlabels,D.trl);
% 
% 
% 
% [force,iforce]= findpeaks(wjn_smoothn(D(fi,:,1),500),'MinPeakHeight',50,'MinPeakDistance',D.fsample);
% % [forceyank,iforceyank]= findpeaks(mydiff(wjn_smoothn(D(fi,:,1),500)),'MinPeakHeight',0.5,'MinPeakDistance',D.fsample);
% D.trl = D.time(iforce)';
% 
% 
% 
% %
% 
% D=wjn_epoch(D.fullfile,[-1.5 1.5],'lf',D.trl);
% 
% % 
% % figure,
% % plot(D.time,squeeze(D(fi,:,:)))
% % figone(7)
% 
% % d=wjn_eeg_burst_analysis(D.fullfile,[60 200],[-1 0],[],[],[],1)
% 
% 
% 
% figure
% schannels = ci('Strip',D.chanlabels);
% for a = 1:length(schannels)
%         subplot(1,length(schannels),a)
% wjn_plot_tf(D,D.chanlabels{schannels(a)})
% xlim([-1 1])
% end
% figone(7,30)

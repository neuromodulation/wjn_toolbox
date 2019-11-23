function pow_coh = lfp_emg_coherence_all(tfile,lfpchans,emgchans)
S.D=tfile;
S.condition = 'all';
S.channels = [lfpchans; emgchans'];
S.freq = [1 100];
S.freqd = 300;
S.timewin = 3.41;
S.rectify=1;
Cr=spm_eeg_fft(S)
% S.condition = 'R';
% Cr=spm_eeg_fft(S)

%% Find peaks in power spectra


colors=[0.043137254901961,0.207843137254902,0.376470588235294;
        0.384313725490196,0.635294117647059,0.658823529411765;
        0.670588235294118,0.223529411764706,0.117647058823529];
ci = channel_indicator('LFP',Cr.channels);
figure;
peakdefinition = ['(Cr.f(ipks(b)) < 30 && ranksum(rpow(ipks(b)-3:ipks(b)+3),rpow([ipks(b)-6:ipks(b)-4,ipks(b)+4:ipks(b)+7]))<0.05) || (Cr.f(ipks(b)) > 30 && ranksum(rpow(ipks(b)-8:ipks(b)+8),rpow([ipks(b)-16:ipks(b)-9,ipks(b)+9:ipks(b)+16]))<0.05)'];
peakdistance = 16;
for a = 1:length(ci);
    rpow = Cr.logfit(:,ci(a));
    [pks,ipks]=findpeaks(rpow,'minpeakdistance',peakdistance);
    ifpks=[];fpks=[];ppks=[];
    for b = 1:length(ipks);
        if ipks(b) > 8 && ipks(b) < length(Cr.f)-16;
            if eval(peakdefinition)
                [mpks]=max(findpeaks(Cr.rpow(ci(a),ipks(b)-8:ipks(b)+8)));
                impks = find(Cr.rpow(ci(a),:) == mpks);
                ifpks=[ifpks impks];
                ppks=[ppks Cr.rpow(ci(a),impks)];
                fpks = [fpks Cr.f(impks)]; 
            end
        end
    end
    Cr.fpks{a} = fpks;
    Cr.ppks{a} = ppks;
    Cr.ifpks{a} = ifpks;
%     subplot(2,1,1);
figone(7)
    scatter(Cr.f(ifpks),Cr.rpow(ci(a),ifpks),50,'v','filled','MarkerFaceColor','r'),hold on;
    h{a}=plot(Cr.f,Cr.rpow(ci(a),:),'LineWidth',2,'LineSmoothing','on','color',colors(a,:));figtwo(17);xlim([5 95]);
    myfont(gca);xlabel('Frequency [Hz]');ylabel('Relative spectral power [%]');
end

    legend([h{1},h{2},h{3}],[strrep(Cr.channels(ci(1))','_',' '),strrep(Cr.channels(ci(2))','_',' '),strrep(Cr.channels(ci(3))','_',' ')])    
    title(Cr.condition);

COH = Cr;
save(Cr.fname,'COH');

rfpks = Cr.fpks;
rppks = Cr.ppks;
save([Cr.name '_peaks'],'rfpks','rppks');


%% Plot power spectra
% figure;
% subplot(1,2,1);
% figone(7)
% plot(Cr.f,Cr.rpow(match_str(Cr.channels,lfpchans),:),'LineSmoothing','on','LineWidth',2);
% myfont(gca);set(gca,'FontSize',9);title('Rest');xlabel('Frequency [Hz]');ylabel('Relative spectral power [%]');
% l=legend(Cr.channels(match_str(Cr.channels,lfpchans)));set(l,'FontSize',8);
% xlim([3 35]);
% subplot(1,2,2);
% plot(Ct.f,Ct.rpow(match_str(Ct.channels,lfpchans),:),'LineSmoothing','on','LineWidth',2);
% myfont(gca);set(gca,'FontSize',9);title('Tremor');xlabel('Frequency [Hz]');ylabel('Relative spectral power [%]');
% l=legend(Ct.channels(match_str(Ct.channels,lfpchans)));set(l,'FontSize',8);
% xlim([3 35]);
% myprint([Cr.name '_LFP_Power_Spectrum'])
%%
enames = {'EMG','unrectified'};
outnames = {'rEMG','uEMG'};
fnames = {Cr.fname};
for n = 1;
    for a = 1:2;
        S.D=fnames{n};
        S.combinations = {'LFP',enames{a}};
        S.mcombinations = {'VIM',outnames{a}};
        [CC(a,:),sCC(a,:)]=spm_eeg_coh_combinations(S);
        close all;
    end
    if n==1;
        CCr = CC; sCCr=sCC;
    else
        CCt = CC; sCCt = sCC;
    end
end
%%
% figure;
% subplot(2,1,1)
% plot(Cr.f,CCr,'LineSmoothing','on','LineWidth',2);myfont(gca);
% hold on; plot(Cr.f,sCCr,'color',[0.5 0.5 0.5])
% legend('rectified','unrectified');title('Rest');
% xlim([1 40]);xlabel('Frequency [Hz]');ylabel(['Coherence']);
% subplot(2,1,2)
% plot(Ct.f,CCt,'LineSmoothing','on','LineWidth',2);myfont(gca);
% legend('rectified','unrectified');title('Tremor');
% xlim([1 40]);xlabel('Frequency [Hz]');ylabel(['Coherence']);
% figone(7);
% myprint([Cr.name '_LFP_EMG_Coherence']);
%%
% figure;
% plot(Cr.f,CCr(2,:),'LineSmoothing','on','LineWidth',1,'color',[0.5 0.5 0.5]);
% % hold on;
% % plot(Ct.f,CCt(2,:),'LineSmoothing','on','LineWidth',1,'color',[0.2 0.2 0.2]);
% myfont(gca);xlabel('Frequency [Hz]');ylabel('Coherence');
% legend('Rest','Tremor');
% xlim([2 35])
% figone(7);
% myprint('Rest_vs_Tremor_unrectified')
% 
% %%
% figure;
% plot(Cr.f,CCr(1,:),'LineSmoothing','on','LineWidth',1,'color',[0.5 0.5 0.5]);
% hold on;
% plot(Ct.f,CCt(1,:),'LineSmoothing','on','LineWidth',1,'color',[0.2 0.2 0.2]);
% myfont(gca);xlabel('Frequency [Hz]');ylabel('Coherence');
% legend('Rest','Tremor');
% xlim([2 35])
% figone(7);
% myprint('Rest_vs_Tremor_rectified')
% save('Vim_EMG_Coherence');

%% Each channel

for c = 1:length(lfpchans);
    for n = 1;
        for a = 1:2;

            S.D=fnames{n};
            S.combinations = {lfpchans{c},enames{a}};
            S.mcombinations = {lfpchans{c},outnames{a}};
            [CC(a,:),sCC(a,:)]=spm_eeg_coh_combinations(S);
            close all;
           
            if n==1;
                CCr = CC; sCCr=sCC;
            else
                CCt = CC; sCCt = sCC;
            end
           
        end
    end
    
%      figure;
%     plot(Cr.f,CCr(2,:),'LineSmoothing','on','LineWidth',1,'color',[0.5 0.5 0.5]);
% %     hold on;
% %     plot(Ct.f,CCt(2,:),'LineSmoothing','on','LineWidth',1,'color',[0.2 0.2 0.2]);
%     myfont(gca);xlabel('Frequency [Hz]');ylabel('Coherence');
% %     legend('Rest','Tremor');
%     title(strrep(lfpchans{c},'_',' '));
%     xlim([2 35])
%     figone(7);
%     myprint([lfpchans{c} 'Rest_vs_Tremor_unrectified'])

% 
%     figure;
%     plot(Cr.f,CCr(1,:),'LineSmoothing','on','LineWidth',1,'color',[0.5 0.5 0.5]);
% %     hold on;
% %     plot(Ct.f,CCt(1,:),'LineSmoothing','on','LineWidth',1,'color',[0.2 0.2 0.2]);
%     myfont(gca);xlabel('Frequency [Hz]');ylabel('Coherence');
%     legend('Rest','Tremor');title(strrep(lfpchans{c},'_',' '));
%     xlim([2 35])
%     figone(7);
%     myprint([lfpchans{c} 'Rest_vs_Tremor_rectified'])
end
format short

disp('Rest:');
disp(['LFP 01: ' num2str(rfpks{1},2) ' Hz'])
disp(['LFP 01: ' num2str(rppks{1},3) ' %']);
disp(['LFP 12: ' num2str(rfpks{2},2) ' Hz'])
disp(['LFP 12: ' num2str(rppks{2},3) ' %']);
disp(['LFP 23: ' num2str(rfpks{3},2) ' Hz'])
disp(['LFP 23: ' num2str(rppks{3},3) ' %']);

% disp('Tremor:')
% disp(['LFP 01: ' num2str(tfpks{1},2) ' Hz'])
% disp(['LFP 01: ' num2str(tppks{1},3) ' %']);
% disp(['LFP 12: ' num2str(tfpks{2},2) ' Hz'])
% disp(['LFP 12: ' num2str(tppks{2},3) ' %']);
% disp(['LFP 23: ' num2str(tfpks{3},2) ' Hz'])
% disp(['LFP 23: ' num2str(tppks{3},3) ' %']);

%%
enames = {'EMG','unrectified'};
outnames = {'rEMG','uEMG'};
fnames = {Cr.fname};
for n = 1;
    for a = 1:2;
        S.D=fnames{n};
        S.combinations = {'LFP',enames{a}};
        S.mcombinations = {'VIM',outnames{a}};
        [CC(a,:),sCC(a,:)]=spm_eeg_coh_combinations(S);
        close all;
    end
    if n==1;
        CCr = CC; sCCr=sCC;
    else
        CCt = CC; sCCt = sCC;
    end
end

pow_coh.pow = Cr.rpow(channel_indicator('LFP',Cr.channels),:);
pow_coh.mpow = mean(Cr.rpow(channel_indicator('LFP',Cr.channels),:),1);
pow_coh.ucoh = CCr(1,:);
pow_coh.rcoh = CCr(2,:);
pow_coh.sucoh = sCCr(1,:);
pow_coh.srcoh = sCCr(2,:);
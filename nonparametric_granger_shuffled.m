%% non parametric granger 
clear    
root = 'D:\MEG\Dystonia\data\'
    cd(root)
    IDs = {'PLFP04_off','PLFP07_off','PLFP09_off','PLFP10_off','PLFP11_off',...%'PLFP12_off',...
        'PLFP20_off','PLFP22_off','PLFP25_off'};
    lfpchans = {'LFP_L01','LFP_L12','LFP_L23','LFP_R01','LFP_R12','LFP_R23'};
    fr = [4 8; 7 13;13 30;60 90];
    source_name = {'Temporal_Cortex','Cerebellum','Motor_Cortex','Thalamus'};
    side = {'right','left'};
    lfp = {'LFP_R','LFP_L'};
    
for b = 1:length(source_name);
         n=0;
    for a = 1:length(IDs);
   
        for si = 1:length(side);
    %         for l = 1:length(lfpchans);
    %             S.combination{l,1} = source_name{b};
    %             S.combination{l,2} = lfpchans{l};
    %         end
    %         c = load(fullfile(root,IDs{a},'source_extraction',['mCOH_R_off_' source_name{b} '_GPi_LFP_Bred'  IDs{a} '.mat']))
    %         lc = combination_finder('LFP_L',source_name{b},c.mCOH.chancomb);
    %         rc = combination_finder('LFP_R',source_name{b},c.mCOH.chancomb);
    %         [~,il]=max(mean(c.mCOH.coh(lc,sc(c.mCOH.f,fr(b,1)):sc(c.mCOH.f,fr(b,2))),2));
    %         [~,ir]=max(mean(c.mCOH.coh(rc,sc(c.mCOH.f,fr(b,1)):sc(c.mCOH.f,fr(b,2))),2));
    %         cohchans.(source_name{b})(a,:) = channel_finder('LFP',c.mCOH.chancomb([lc(il),rc(ir)],:));



                    id = IDs{a};
                    filename = fullfile(root,'source_extraction','2_98',['source_extraction_' side{si}],['Bred'  IDs{a} '.mat']);
            %         S.freq = [2 98];
            %         chans = [source_name{b} cohchans.(source_name{b})(a,:)];
                     chans = [source_name{b} lfpchans];
        D = spm_eeg_load(filename);

        pair = [channel_finder(source_name{b},D.chanlabels), channel_finder(lfp{si},D.chanlabels)];

        data = D.fttimelock(D.indchannel(pair), ':', ':');
        % rdata = odata(:,1:end);
        % rdata.trial = rdata.trial(:, :, end:-1:1);
        % rdata.trial(:,:,size(rdata,3)+1) = rdata.trial(:, :, 1);
        % data = {odata, rdata};

        % for i = 1:numel(data)

            fstep = 1/(D.nsamples/D.fsample);
            fstep = round(1/fstep)*fstep;

            foi     = fstep:fstep:100;
            fres    = 0*foi+fstep;
            fres(fres>10*fstep) = 0.1*fres(fres>10*fstep);
            fres(fres>50) = 5;

            cfg = [];
            cfg.output ='fourier';
            cfg.channelcmb=pair;

            cfg.keeptrials = 'yes';
            cfg.keeptapers='yes';
            cfg.taper = 'dpss';
            cfg.method          = 'mtmfft';
            cfg.foi     = foi;
            cfg.tapsmofrq = fres;

            inp = ft_freqanalysis(cfg, data);
            %

            cfg1 = [];
            cfg1.channelcmb=coherence_finder(source_name{b},lfp{si},pair);
            cfg1.method  = 'coh';
%             cfg.complex = 'imag';

            coh = ft_connectivityanalysis(cfg1, inp);
            Ntrials = size(data.trial,1);
            shift=[2:Ntrials 1];
        % Compute the shift predictor for coherence
        scoh=coh;
        scoh.cohspctrm=zeros(size(scoh.cohspctrm));

        % cfg = [];
        % cfg.output ='powandcsd';
        % cfg.keeptrials = 'yes';
        % cfg.keeptapers='no';
        % cfg.taper = 'dpss';
        % cfg.method = 'mtmfft';
        % cfg.foilim     = [0 100]; % Frequency range
        % cfg.tapsmofrq = 1;
            for c=1:length(data.label)
                sdata=data;
                sdata.trial(:,c,:)=data.trial(shift,c,:);
                cfg.channelcmb = {data.label{c}, 'all'};
                sinp = ft_freqanalysis(cfg, sdata);
                sscoh = ft_connectivityanalysis(cfg1, sinp);
                for in=1:size(sscoh.labelcmb, 1)
                    ind=[intersect(strmatch(sscoh.labelcmb(in,1),scoh.labelcmb(:,1),'exact'), ...
                        strmatch(sscoh.labelcmb(in,2),scoh.labelcmb(:,2),'exact'))...
                        intersect(strmatch(sscoh.labelcmb(in,1),scoh.labelcmb(:,2),'exact'), ...
                        strmatch(sscoh.labelcmb(in,2),scoh.labelcmb(:,1),'exact'))];
                    scoh.cohspctrm(ind, :)=sscoh.cohspctrm(in, :);
                end
            end
            %
            cfg1.method = 'granger';
            stat{1} = ft_connectivityanalysis(cfg1, inp);
            stat{2} = ft_connectivityanalysis(cfg1, sinp);
 
coh  ={coh,scoh};
n=n+1;
is2l = combination_finder(source_name{b},'LFP',stat{1}.labelcmb)
il2s = combination_finder('LFP',source_name{b},stat{1}.labelcmb)
x.([source_name{b}]).coh(:,:,n) = squeeze(coh{1}.cohspctrm);
x.([source_name{b}]).scoh(:,:,n) = squeeze(coh{2}.cohspctrm);
x.([source_name{b}]).lfp2source(:,:,n) = squeeze(stat{1}.grangerspctrm(il2s,:));
x.([source_name{b}]).slfp2source(:,:,n) = squeeze(stat{2}.grangerspctrm(il2s,:));
x.([source_name{b}]).source2lfp(:,:,n) = squeeze(stat{1}.grangerspctrm(is2l,:));
x.([source_name{b}]).ssource2lfp(:,:,n) = squeeze(stat{2}.grangerspctrm(is2l,:));
% 
% figure;
% subplot(3, 1, 1)
% n = n+1;
% plot(coh{1}.freq, squeeze(coh{1}.cohspctrm(1, 2, :)));
% hold on
% plot(coh{2}.freq, squeeze(coh{2}.cohspctrm(1, 2, :)), 'r');
% title(strrep([IDs{a} ' ' source_name{b} ' - GPi'],'_',' '))
% subplot(3, 1, 2)
% plot(stat{1}.freq, stat{1}.grangerspctrm(2, :));
% hold on
% plot(stat{2}.freq, stat{2}.grangerspctrm(2, :), 'r');
% 
% subplot(3, 1, 3)
% plot(stat{1}.freq, stat{1}.grangerspctrm(3, :));
% hold on
% plot(stat{2}.freq, stat{2}.grangerspctrm(3, :), 'r');

        end
        end
end
f = stat{1}.freq;
save x x f
    %% directionality stats and mean
    root = 'D:\MEG\Dystonia\data\'
    cd(root)
    load x x f
%     colors = {'b','c','r','y'};
c = colorlover(5);
c = c([5 1 4 3],:);
    source_name = {'Temporal_Cortex','Cerebellum','Motor_Cortex','Thalamus'};
    frange = [4 8;7 13;13 30;60 90];
for a = 1:length(source_name);

cmcoh = squeeze(mean(mean(x.(source_name{a}).coh,3),1));
cmscoh = squeeze(mean(mean(x.(source_name{a}).scoh,3),1));
cms2l = squeeze(mean(mean(x.(source_name{a}).source2lfp,3),1));
cmss2l = squeeze(mean(mean(x.(source_name{a}).ssource2lfp,3),1));
cml2s = squeeze(mean(mean(x.(source_name{a}).lfp2source,3),1));
cmsl2s = squeeze(mean(mean(x.(source_name{a}).slfp2source,3),1));

[~,pcvss2l] = ttest(mean(cms2l(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1),mean(cml2s(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1),0.05)
% [~,pcml2s] = ttest(mean(cml2s(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1),mean(cmsl2s(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1),0.05,'right')


[~,pcms2l] = ttest(mean(cms2l(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1),mean(cmss2l(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1),0.05,'right')
[~,pcml2s] = ttest(mean(cml2s(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1),mean(cmsl2s(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1),0.05,'right')


figure;
subplot(3,1,1)
plot(f,cmcoh);hold on;
plot(f,cmscoh,'color','r','LineStyle','--');
title(['Direct comparison P = ' num2str(pcvss2l)]);
ylim([0 0.2])
subplot(3,1,2);
plot(f,cms2l);hold on;
plot(f,cmss2l,'color','r','LineStyle','--');
ylim([0 0.015])
legend([source_name{a} ' -> GPi']);
title(['P = '  num2str(pcms2l)])
subplot(3,1,3)
plot(f,cml2s);hold on;
plot(f,cmsl2s,'color','r','LineStyle','--');
ylim([0 0.015])
legend(['GPi -> ' source_name{a}])
title(['P = '  num2str(pcml2s)])
myprint(['NP_directionality_' source_name{a}]);

mcms2l = mean(mean(cms2l(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1));
mcml2s=mean(mean(cml2s(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1));
scml2s = sem(mean(cml2s(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1));
scms2l = sem(mean(cms2l(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1));

mcmss2l = mean(mean(cmss2l(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1));
mcmsl2s=mean(mean(cmsl2s(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1));
scmsl2s = sem(mean(cmsl2s(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1));
scmss2l = sem(mean(cmss2l(:,sc(f,frange(a,1)):sc(f,frange(a,2))),1));

figure;
b1 = bar([1,2,3,4],[mcms2l,nan,mcml2s,nan]);hold on;
b2 = bar([1,2,3,4],[nan,mcmss2l,nan,mcmsl2s]);
eb1 = errorbar([1,2,3,4],[mcms2l,mcmss2l,mcml2s,mcmsl2s],[0 0 0 0],[scms2l,scmss2l,scml2s,scmsl2s],'LineStyle','none');
set(eb1,'color','k');
set(b1,'EdgeColor','k','FaceColor',c(a,:))
set(b2,'EdgeColor','k','FaceColor',c(a,:))
ch=get(b2,'child');
ylim([0 max([mcms2l,nan,mcml2s,nan])*2.1])
% ylim([0 0.01])
set(ch,'FaceA',0.2);

xlim([0 5]);set(gca,'XTick',[1.5 3.5],'XTickLabel',{[strrep(source_name{a},'_',' ') ' leading'],'GPi leading'});
figone(5);myfont(gca);
set(gca,'FontSize',8)

myprint(['NP_bar_directionality_' source_name{a} '_no_legend'],'-opengl')
% legend('original','shuffled')
% myprint(['NP_bar_directionality_' source_name{a} '_legend'],'-opengl');
end


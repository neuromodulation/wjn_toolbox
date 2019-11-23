function wjn_ecog_ah_pb_predict_tremor(filename)
close all
pool = gcp;
Dtf = wjn_sl(filename);


chancombs = {Dtf.chanlabels{Dtf.sECOG},Dtf.chanlabels{Dtf.sSTN},'Strip','STN'};
combnames = {'sECOG','sSTN','ECOG','STN'};
tremor = [];
it = Dtf.timeind.baseline;
t=Dtf.time(it);
[pow1,f]=cwt(wjn_quickfilter(Dtf.force(1,it),Dtf.fsample,[Dtf.ftremor-2 Dtf.ftremor+2]),Dtf.fsample,'TimeBandWidth',120);
[pow2,f]=cwt(wjn_quickfilter(Dtf.force(2,it),Dtf.fsample,[Dtf.ftremor-2 Dtf.ftremor+2]),Dtf.fsample,'TimeBandWidth',120);
i = [wjn_sc(f,Dtf.ftremor+2):wjn_sc(f,Dtf.ftremor-2)];
ii = wjn_sc(f(i),Dtf.ftremor);

Dtf.pow_tremor = [nanmean(abs(pow1),2)';nanmean(abs(pow2),2)'];
Dtf.freq_tremor = f;
Dtf.mpow_tremor = nanmean(Dtf.pow_tremor(:,i),2);


figure
plot(Dtf.freq_tremor,Dtf.pow_tremor)

tremor = [];
tremor(1,:) = smooth(nanmean(abs(pow1(i,:))),.5*Dtf.fsample);
tremor(1,:) = wjn_zscore(tremor(1,:));
tremor(1,tremor(1,:)>3)=0;
% tremor(1,:) = tremor(1,:)./max(abs(tremor(1,:)));
tremor(2,:) = smooth(nanmean(abs(pow2(i,:))),.5*Dtf.fsample);
tremor(2,tremor(2,:)>(nanmean(tremor(2,:))+2*nanstd(tremor(2,:))))=0;
tremor(2,:) = wjn_zscore(tremor(2,:));
% tremor(2,:) = tremor(2,:)./max(abs(tremor(2,:)));

[t1,it1]=sort(tremor(1,:));
[t1,it2]=sort(tremor(2,:));
it1 = it1(end:-1:1);
it2 = it2(end:-1:1);
Dtf.tremor = zeros(size(Dtf.force));

Dtf.tremor(:,it) = tremor;
save(Dtf);

figure
subplot(2,1,1)
imagesc(t,1:length(f),abs(pow1(:,it1)));
axis xy
set(gca,'YTick',i(ii),'YTickLabel',[num2str(f(i(ii)),2) ' Hz'],'YTickLabelRotation',45)
hold on
plot(t,tremor(1,it1)+i(ii)-4,'color','w')
ylim([i(ii)-20 i(ii)+20])
subplot(2,1,2)
imagesc(t,1:length(f),abs(pow2(:,it2)));
axis xy
set(gca,'YTick',i(ii),'YTickLabel',[num2str(f(i(ii)),2) ' Hz'],'YTickLabelRotation',45)
hold on
plot(t,tremor(2,it2)+i(ii)-4,'color','w')
ylim([i(ii)-20 i(ii)+20])
figone(7)
myprint(fullfile('tremor_prediction',[Dtf.id '_' Dtf.hemisphere '_tremor']),1)


for a = 1:length(combnames)
      tbl = wjn_nn_feature_table(Dtf,chancombs{a});
      i = find(nansum(Dtf.tremor));
      Dtf.timeind.tremor = i;
      if size(tbl,2) > 6
          ica = 10;
      else
          ica = 0;
      end
        [Dtf.nn.tremor.(combnames{a}).netC,Dtf.nn.tremor.(combnames{a}).YC,Dtf.nn.tremor.(combnames{a}).LC]=wjn_nn_timedelay(tbl(i,:),Dtf.tremor(Dtf.ficon,i),pool,10);
        save(Dtf);
        myprint(fullfile('predict_tremor',[Dtf.id '_' Dtf.hemisphere '_TREMOR_C_regression_' combnames{a}]),1)

        [Dtf.nn.force.(combnames{a}).netFI,Dtf.nn.move.(combnames{a}).FYI,Dtf.nn.move.(combnames{a}).LFI]=wjn_nn_timedelay(tbl(i,:),Dtf.tremor(Dtf.fiips,i),pool,10);
        save(Dtf);
        myprint(fullfile('predict_tremor',[Dtf.id '_' Dtf.hemisphere '_TREMOR_I_regression_' combnames{a}]),1)
end
%%


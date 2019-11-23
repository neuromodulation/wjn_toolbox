function wjn_ecog_pitt_predict_bursts(filename)
close all
pool = parpool;
Dtf = wjn_sl('tf_dcont*.mat')
% keep Dtf pool

% gpu = gpuDevice(1);
%%
chancombs = {Dtf.chanlabels{Dtf.sECOG},'Strip','STN',Dtf.chanlabels{Dtf.sSTN},{'STN','Strip'}};
combnames = {'sECOG','ECOG','STN','sSTN','STN-ECOG'};
for a = 1:length(combnames)
    close all
   tbl = wjn_nn_feature_table(Dtf,chancombs{a});
    [Dtf.nn.move.(combnames{a}).netMC,Dtf.nn.move.(combnames{a}).YC,Dtf.nn.move.(combnames{a}).thrC,Dtf.nn.move.(combnames{a}).LMC]=wjn_nn_classifier(tbl,Dtf.move_con,pool);
    Dtf.nn.move.(combnames{a}).MC = Dtf.nn.move.(combnames{a}).YC>=Dtf.nn.move.(combnames{a}).thrC;
    save(Dtf);
    myprint(['MOVE_C_class_' combnames{a} '_' Dtf.id '_' Dtf.hemisphere],1)

    [Dtf.nn.move.(combnames{a}).netMI,Dtf.nn.move.(combnames{a}).YI,Dtf.nn.move.(combnames{a}).thrI,Dtf.nn.move.(combnames{a}).LMI]=wjn_nn_classifier(tbl,Dtf.move_ips,pool);
    Dtf.nn.move.(combnames{a}).MI = Dtf.nn.move.YI>=Dtf.nn.move.(combnames{a}).thrI;
    save(Dtf);
    myprint(['MOVE_I_class_' combnames{a} '_' Dtf.id '_' Dtf.hemisphere],1)

    if a<=2
        t=Dtf.bursts.full.btime(Dtf.sSTN,:)>=nanmedian(Dtf.bursts.full.bdur{Dtf.sSTN});
        [Dtf.nn.bursts.netML,Dtf.nn.bursts.YL,Dtf.nn.bursts.thrL,Dtf.nn.bursts.LML]=wjn_nn_classifier(tbl,t,pool);
        Dtf.nn.bursts.ML = Dtf.nn.bursts.YL>=Dtf.nn.bursts.thrL;
        save(Dtf);
        myprint(['BURST_LONG_BROAD_class_' combnames{a} '_' Dtf.id '_' Dtf.hemisphere],1)
        
        t=Dtf.bursts.full.btime(Dtf.sSTN,:)<nanmedian(Dtf.bursts.full.bdur{Dtf.sSTN});
        [Dtf.nn.bursts.netMS,Dtf.nn.bursts.YS,Dtf.nn.bursts.thrS,Dtf.nn.bursts.LMS]=wjn_nn_classifier(tbl,t,pool);
        Dtf.nn.bursts.MS = Dtf.nn.bursts.YS>=Dtf.nn.bursts.thrS;
        save(Dtf);
        myprint(['BURST_SHORT_BROAD_class_' combnames{a} '_' Dtf.id '_' Dtf.hemisphere],1)
        
        t=Dtf.bursts.full.pktime(Dtf.sSTN,:)>=nanmedian(Dtf.bursts.full.pkdur{Dtf.sSTN});
        [Dtf.nn.bursts.netpkML,Dtf.nn.bursts.pkYL,Dtf.nn.bursts.pkthrL,Dtf.nn.bursts.pkLML]=wjn_nn_classifier(tbl,t,pool);
        Dtf.nn.bursts.pkML = Dtf.nn.bursts.pkYL>=Dtf.nn.bursts.pkthrL;
        save(Dtf);
        myprint(['BURST_LONG_PEAK_class_' combnames{a} '_' Dtf.id '_' Dtf.hemisphere],1)
        
        t=Dtf.bursts.full.pktime(Dtf.sSTN,:)<nanmedian(Dtf.bursts.full.pkdur{Dtf.sSTN});
        [Dtf.nn.bursts.netpkMS,Dtf.nn.bursts.pkYS,Dtf.nn.bursts.pkthrS,Dtf.nn.bursts.pkLMS]=wjn_nn_classifier(tbl,t,pool);
        Dtf.nn.bursts.pkMS = Dtf.nn.bursts.pkYS>=Dtf.nn.bursts.pkthrS;
        save(Dtf);
        myprint(['BURST_SHORT_PEAK_class_' combnames{a} '_' Dtf.id '_' Dtf.hemisphere],1)
        
    end
end

for a = [2 5]
      tbl = wjn_nn_feature_table(Dtf,chancombs{a});
              [Dtf.nn.move.(combnames{a}).netFC,Dtf.nn.move.(combnames{a}).FYC,Dtf.nn.move.(combnames{a}).LFC]=wjn_nn_timedelay(tbl,Dtf.force(Dtf.ficon,:),pool);
        save(Dtf);
        myprint(['FORCE_C_regression_' combnames{a} '_' Dtf.id '_' Dtf.hemisphere],1)

        [Dtf.nn.move.(combnames{a}).netFI,Dtf.nn.move.(combnames{a}).FYI,Dtf.nn.move.(combnames{a}).LFI]=wjn_nn_timedelay(tbl,Dtf.force(Dtf.fiips,:),pool);
        save(Dtf);
        myprint(['FORCE_I_regression_' combnames{a} '_' Dtf.id '_' Dtf.hemisphere],1)
end
%%


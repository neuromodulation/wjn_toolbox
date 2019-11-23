function wjn_ecog_pitt_predict_bursts(filename)
%%
close all
pool = gcp;
Dtf = wjn_sl(filename);
% keep Dtf pool

% gpu = gpuDevice(1);
%%
chancombs = {Dtf.chanlabels{Dtf.sECOG},'Strip'};
combnames = {'sECOG','ECOG'};
timeranges = {'baseline','move_both','full'};
for a = 1:length(combnames)
    for b = 1:length(timeranges)
        tbl = wjn_nn_feature_table(Dtf,chancombs{a});
        i = find(Dtf.timeind.(timeranges{b}));
        tbl = tbl(i,:);
        t=Dtf.bursts.(timeranges{b}).btime(Dtf.sSTN,:)>=nanmedian(Dtf.bursts.(timeranges{b}).bdur{Dtf.sSTN});
        [Dtf.nn.bursts.(timeranges{b}).netML,Dtf.nn.bursts.(timeranges{b}).YL,Dtf.nn.bursts.(timeranges{b}).thrL,Dtf.nn.bursts.(timeranges{b}).LML]=wjn_nn_classifier(tbl,t,pool);
        Dtf.nn.bursts.(timeranges{b}).ML = Dtf.nn.bursts.(timeranges{b}).YL>=Dtf.nn.bursts.(timeranges{b}).thrL;
        save(Dtf);
        myprint(fullfile('predict_bursts',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BURST_LONG_BROAD_class_'  ]),1)
        
        t=Dtf.bursts.(timeranges{b}).btime(Dtf.sSTN,:);
        t(t==0)=nan;
        t=t<nanmedian(Dtf.bursts.(timeranges{b}).bdur{Dtf.sSTN});
        [Dtf.nn.bursts.(timeranges{b}).netMS,Dtf.nn.bursts.(timeranges{b}).YS,Dtf.nn.bursts.(timeranges{b}).thrS,Dtf.nn.bursts.(timeranges{b}).LMS]=wjn_nn_classifier(tbl,t,pool);
        Dtf.nn.bursts.(timeranges{b}).MS = Dtf.nn.bursts.(timeranges{b}).YS>=Dtf.nn.bursts.(timeranges{b}).thrS;
        save(Dtf);
        myprint(fullfile('predict_bursts',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BURST_SHORT_BROAD_class']),1)
        
        t=Dtf.bursts.(timeranges{b}).pktime(Dtf.sSTN,:)>=nanmedian(Dtf.bursts.(timeranges{b}).pkdur{Dtf.sSTN});
        [Dtf.nn.bursts.(timeranges{b}).netpkML,Dtf.nn.bursts.(timeranges{b}).pkYL,Dtf.nn.bursts.(timeranges{b}).pkthrL,Dtf.nn.bursts.(timeranges{b}).pkLML]=wjn_nn_classifier(tbl,t,pool);
        Dtf.nn.bursts.(timeranges{b}).pkML = Dtf.nn.bursts.(timeranges{b}).pkYL>=Dtf.nn.bursts.(timeranges{b}).pkthrL;
        save(Dtf);
        myprint(fullfile('predict_bursts',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BURST_LONG_PEAK_class']),1)
        
        t=Dtf.bursts.(timeranges{b}).pktime(Dtf.sSTN,:);
        t(t==0) = nan;
        t=t<nanmedian(Dtf.bursts.(timeranges{b}).pkdur{Dtf.sSTN});
        [Dtf.nn.bursts.(timeranges{b}).netpkMS,Dtf.nn.bursts.(timeranges{b}).pkYS,Dtf.nn.bursts.(timeranges{b}).pkthrS,Dtf.nn.bursts.(timeranges{b}).pkLMS]=wjn_nn_classifier(tbl,t,pool);
        Dtf.nn.bursts.(timeranges{b}).pkMS = Dtf.nn.bursts.(timeranges{b}).pkYS>=Dtf.nn.bursts.(timeranges{b}).pkthrS;
        save(Dtf);
        myprint(fullfile('predict_bursts',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BURST_SHORT_PEAK_class']),1)
        
    end
end



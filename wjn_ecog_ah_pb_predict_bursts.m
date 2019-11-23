function wjn_ecog_ah_pb_predict_bursts(filename)
%%
close all
pool = gcp;
Dtf = wjn_sl(filename);
% keep Dtf pool

% pool = gpuDevice(1);
%%
if isfield(Dtf,'nn')
    Dtf =rmfield(Dtf,'nn');
end

chancombs =Dtf.chanlabels(Dtf.istrip);
combnames = chancombs;
timeranges = {'baseline','move_both','full'};
for a = 1:length(combnames)
    for b = 1:length(timeranges)
        tbl = wjn_nn_feature_table(Dtf,chancombs{a});
        if size(tbl,2) >10
            ica =10;
        else
            ica =0;
        end
        i = find(Dtf.timeind.(timeranges{b}));
        tbl = tbl(i,:);
%         t=Dtf.bursts.(timeranges{b}).btime(Dtf.sSTN,:)>=nanmedian(Dtf.bursts.(timeranges{b}).bdur{Dtf.sSTN});
%         [nn.bursts.(timeranges{b}).netML,nn.bursts.(timeranges{b}).YL,nn.bursts.(timeranges{b}).thrL,nn.bursts.(timeranges{b}).LML]=wjn_nn_classifier(tbl,t,pool,ica);
%         nn.bursts.(timeranges{b}).ML = nn.bursts.(timeranges{b}).YL>=nn.bursts.(timeranges{b}).thrL;
% %         save(Dtf);
%         if strcmp(combnames{a},Dtf.chanlabels{Dtf.sECOG}) || a == length(combnames)
%         myprint(fullfile('predict_bursts',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BURST_LONG_BROAD_class_'  ]),1)
%         end
%         
%         t=Dtf.bursts.(timeranges{b}).btime(Dtf.sSTN,:);
%         t(t==0)=nan;
%         t=t<nanmedian(Dtf.bursts.(timeranges{b}).bdur{Dtf.sSTN});
%         [nn.bursts.(timeranges{b}).netMS,nn.bursts.(timeranges{b}).YS,nn.bursts.(timeranges{b}).thrS,nn.bursts.(timeranges{b}).LMS]=wjn_nn_classifier(tbl,t,pool,ica);
%         nn.bursts.(timeranges{b}).MS = nn.bursts.(timeranges{b}).YS>=nn.bursts.(timeranges{b}).thrS;
% %         save(Dtf);
%         
%         if strcmp(combnames{a},Dtf.chanlabels{Dtf.sECOG}) || a == length(combnames)
%         myprint(fullfile('predict_bursts',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BURST_SHORT_BROAD_class']),1)
%         end
%         
        t=Dtf.bursts.(timeranges{b}).pktime(Dtf.sSTN,:)>=nanmedian(Dtf.bursts.(timeranges{b}).pkdur{Dtf.sSTN});
        [nn.bursts.(timeranges{b}).netpkML,nn.bursts.(timeranges{b}).pkYL,nn.bursts.(timeranges{b}).pkLML]=wjn_nn_classifier(tbl,t,ica);
        
        myprint(fullfile('predict_bursts',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BURST_LONG_PEAK_class']),1)

        
        t=Dtf.bursts.(timeranges{b}).pktime(Dtf.sSTN,:);
        t(t==0) = nan;
        t=t<nanmedian(Dtf.bursts.(timeranges{b}).pkdur{Dtf.sSTN});
        [nn.bursts.(timeranges{b}).netpkMS,nn.bursts.(timeranges{b}).pkYS,nn.bursts.(timeranges{b}).pkLMS]=wjn_nn_classifier(tbl,t,ica);
 %         save(Dtf);
        
      
        myprint(fullfile('predict_bursts',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BURST_SHORT_PEAK_class']),1)
   
        
        close all
    end

end
    disp('Dont cancel, now saving')
save(['NN_burst_single_strip_' Dtf.id '_' Dtf.hemisphere],'nn')
    disp('safe to cancel')
    disp('safe to cancel')
pause(5)

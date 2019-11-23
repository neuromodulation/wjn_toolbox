function wjn_ecog_ah_pb_predict_movement(filename)
%%
close all
pool = gcp;
Dtf = wjn_sl(filename);

% chancombs = {Dtf.chanlabels{Dtf.sECOG} Dtf.chanlabels{Dtf.sSTN} 'STN' 'Strip' {'STN','Strip'}};
% combnames = {'sECOG','ECOG','sSTN','STN'};
chancombs =Dtf.chanlabels(Dtf.istrip);
combnames = chancombs;
timeranges = {'full'};
for a = 1:length(combnames)
    for b = 1:length(timeranges)
        tbl = wjn_nn_feature_table(Dtf,chancombs{a});
        
        if size(tbl,2) >10
            ica =10;
        else
            ica =0;
        end

%         t=Dtf.timeind.move_both;
%         [Dtf.nn.move.netB,Dtf.nn.move.YB,Dtf.nn.move.LMB]=wjn_nn_classifier(tbl,t,ica);
%     
%         myprint(fullfile('predict_movement',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BOTH_MOVE_class_'  ]),1)

        
        t=Dtf.timeind.move_con;
        [nn.move.netC,nn.move.YC,nn.move.LMC]=wjn_nn_classifier(tbl,t,ica);
      
        myprint(fullfile('predict_movement',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_CON_MOVE_class_'  ]),1)
     
     
        t=Dtf.timeind.move_ips;
        [nn.move.netI,nn.move.YI,nn.move.LMI]=wjn_nn_classifier(tbl,t,ica);
       
        myprint(fullfile('predict_movement',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_IPS_MOVE_class_'  ]),1)
     
    
    end
    
end

disp('Dont cancel, now saving')
%     save(Dtf)
save(['NN_move_single_strip_' Dtf.id '_' Dtf.hemisphere],'nn')
    disp('safe to cancel')

pause(5)

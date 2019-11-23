function wjn_ecog_ah_pb_predict_force(filename)
%%
close all
pool = gcp;
Dtf = wjn_sl(filename);
% 
% chancombs = {{Dtf.chanlabels{Dtf.sECOG} Dtf.chanlabels{Dtf.sSTN}}, 'STN' 'Strip'  Dtf.chanlabels{Dtf.sECOG} Dtf.chanlabels{Dtf.sSTN} {'STN','Strip'}};
% combnames = {'sSTN-sECOG','STN','Strip','sECOG','sSTN','sSTN-sECOG'};
chancombs =Dtf.chanlabels(Dtf.istrip);
combnames = chancombs;
timeranges = {'full'};
con_side ={'R','L'};
ips_side ={'L','R'};
for a = 1:length(combnames)
    for b = 1:length(timeranges)
        tbl = wjn_nn_feature_table(Dtf,chancombs{a});
        
        if size(tbl,2) >12
            ica =10;
            H={[size(tbl,2) size(tbl,2)],[size(tbl,2),size(tbl,2),size(tbl,2)]},
            tD={[0:20:200]}
        else
            ica =0;
            H={2.*[size(tbl,2) size(tbl,2)],2.*[size(tbl,2),size(tbl,2),size(tbl,2)]},
            tD={[0:20:200]}
        end
        
        t = Dtf.nforce(ci(Dtf.con(1),con_side),:);
        t =t-min(t);
        %

%         t=Dtf.timeind.force_both;
%         [nn.force.netB,nn.force.YB,nn.force.LMB]=wjn_nn_classifier(tbl,t,ica);
%     
%         myprint(fullfile('predict_force',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_BOTH_force_class_'  ]),1)

        
%         t=Dtf.timeind.force_con;
        [nn.force.netC,nn.force.YC,nn.force.LMC]=wjn_nn_classifier(tbl,t,ica,H,tD,.0);
      
        myprint(fullfile('predict_force',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_CON_force_R_'  ]),1)
     
     
             t = Dtf.nforce(ci(Dtf.con(1),ips_side),:);
             t=t-min(t);
        [nn.force.netI,nn.force.YI,nn.force.LMI]=wjn_nn_classifier(tbl,t,ica, H, tD,.0);
       
        myprint(fullfile('predict_force',[Dtf.id '_' Dtf.hemisphere '_' combnames{a} '_' timeranges{b} '_IPS_force_R_'  ]),1)
     
    
    end
    
end

disp('Dont cancel, now saving')
    save(['NN_force_signle_strip' Dtf.id '_' Dtf.hemisphere],'nn')
    disp('safe to cancel')
    disp('safe to cancel')

pause(5)
close all

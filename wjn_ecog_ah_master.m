addpath('/home/julian/Dropbox (Brain Modulation Lab)/wjn_toolbox/');

spm12
clear all
clearvars
clc

root = '/home/julian/Dropbox (Brain Modulation Lab)/ecog/';
cd(root)

% files = ffind(fullfile(root,'preproc','s_*.mat'));
%
cd(fullfile(root,'preproc'))
%%
files = ffind('tf_*.mat');
% 


for a =1:length(files)
   Dtf=wjn_ecog_ah_pb_burst_preprocessing(files{a},3,0);
   close all
end

% %wjn_ecog_ah_pb_tremor_assessment;
% copyfile('tf*.*','../backup/','f')
%%
close all
clear all


files = ffind('tf_*.mat');

for a = [1 3:13]%8:length(files)
    wjn_ecog_ah_pb_predict_force(files{a})
end
%%
close all 
clear all
% cd(fullfile(root,'preproc'))
files = ffind('tf_*.mat');

for a = 2%1:length(files)
    wjn_ecog_ah_pb_predict_bursts(files{a})
end

close all
clear all

%
files = ffind('tf_*.mat');

for a = [2]%8:length(files)
    wjn_ecog_ah_pb_predict_movement(files{a})
end


% predict movement across patients

clear all
close all
files =ffind('tf_*.mat');
franges ={'theta','alpha','lowbeta','highbeta','lowgamma','highgamma'};
neven =0;
nodd =0;
for a =1:length(files)
%     try
    Dtf =wjn_sl(files{a});

    ctbl =wjn_nn_feature_table(Dtf,Dtf.chanlabels{Dtf.sECOG});
    ctbl.Properties.VariableNames =franges;
    ct =Dtf.timeind.move_con;
  
    
%     if ~neven && iseven(a)
    if a ==1
        tbl =ctbl;
          t=Dtf.timeind.move_con;
          neven =neven+1;
%     elseif neven && iseven(a)
    elseif a<10
        tbl=[tbl;ctbl];
        t =[t Dtf.timeind.move_con];
        neven =neven+1;
%     elseif ~nodd && ~iseven(a)
    elseif a==10
          ttbl =ctbl;
          tt=Dtf.timeind.move_con;
          nodd =nodd+1;
%     elseif nodd && ~iseven(a)
    elseif a>10
        ttbl=[ttbl;ctbl];
        tt =[tt Dtf.timeind.move_con];
            nodd =nodd+1;
    end
end


    
pool =gcp;

close all
% keep tbl pool t
[net,~,nn] = wjn_nn_classifier(tbl,t,0,{[80 80 80 80 80]},{[0:40:400]},.01);

Y2=net(con2seq(table2array(ttbl)'));

save move_net nt nn
% val_acc = confusion(Y2,con2seq(tt(401:end)));

% predict force across patients
clear all
close all
files =ffind('tf_*.mat');
franges ={'theta','alpha','lowbeta','highbeta','lowgamma','highgamma'};
neven =0;
nodd =0;
side ={'R','L'};
for a =1:length(files)
%     try
    Dtf =wjn_sl(files{a});

    ctbl =wjn_nn_feature_table(Dtf,Dtf.chanlabels{Dtf.sECOG});
    ctbl.Properties.VariableNames =franges;
           ct=Dtf.force(ci(Dtf.con(1),side),:);  
%     if ~neven && iseven(a)
    if a ==1
        tbl =ctbl;
        t = ct;
          neven =neven+1;
%     elseif neven && iseven(a)
    elseif a<10
        tbl=[tbl;ctbl];
        t =[t ct];
        neven =neven+1;
%     elseif ~nodd && ~iseven(a)
    elseif a==10
          ttbl =ctbl;
          tt=ct;
          nodd =nodd+1;
%     elseif nodd && ~iseven(a)
    elseif a>10
        ttbl=[ttbl;ctbl];
        tt =[tt ct];
            nodd =nodd+1;
    end
end


    
pool =gcp;

close all
% keep tbl pool t

[net,~,nn] = wjn_nn_classifier(tbl,t,0,{[80 80 80 80 80]},{[0:40:400]},.025);

Y2=net(con2seq(table2array(ttbl)'));

save force_net net 
%%
clear all
close all
% cd H:\

files = ffind('tf_dcont*.mat');
pkfreq = [8:35];
for n = 1:length(files)
    clear bursts
%     D=wjn_ecog_ah_pb_import_clinical_data(files{a});
    Dtf=wjn_sl(files{n});
    timeranges = fieldnames(Dtf.timeind);
for a = 1:Dtf.nchannels
    for b = 1:length(timeranges)
        bursts.(timeranges{b}).bdata(a,:) = smooth(squeeze(nanmean(Dtf(a,pkfreq,find(Dtf.timeind.(timeranges{b})),1),2)),.2*Dtf.fsample);
        bursts.(timeranges{b}).bthresh(a) = prctile(bursts.(timeranges{b}).bdata(a,:),75);
        [bursts.(timeranges{b}).bdur{a},bursts.(timeranges{b}).bamp{a},...
        bursts.(timeranges{b}).nb(a),bursts.(timeranges{b}).btime(a,:),bursts.(timeranges{b}).bpeak{a},...
        bursts.(timeranges{b}).bibi(a),bursts.(timeranges{b}).bregularity(a),...
        bursts.(timeranges{b}).basym(a)]=wjn_burst_duration(bursts.(timeranges{b}).bdata(a,:),bursts.(timeranges{b}).bthresh(a),Dtf.fsample,100,'brown');
        bursts.(timeranges{b}).mbdur(a) = nanmean(bursts.(timeranges{b}).bdur{a});
        bursts.(timeranges{b}).mbamp(a) = nanmean(bursts.(timeranges{b}).bamp{a});
        bursts.(timeranges{b}).hbdur(a,:) = hist(bursts.(timeranges{b}).bdur{a},100:100:1000);
        bursts.(timeranges{b}).hbtimes =100:100:1000;
       bursts.(timeranges{b}).phbdur(a,:) = bursts.(timeranges{b}).hbdur(a,:)./nansum(bursts.(timeranges{b}).hbdur(a,:)).*100;
       
        
             bursts.(timeranges{b}).pkdata(a,:) = smooth(squeeze(nanmean(Dtf(a,Dtf.fpkSTN,find(Dtf.timeind.(timeranges{b})),1),2)),.2*Dtf.fsample);
        bursts.(timeranges{b}).pkthresh(a) = prctile(bursts.(timeranges{b}).pkdata(a,:),75);
        [bursts.(timeranges{b}).pkdur{a},bursts.(timeranges{b}).pkamp{a},...
        bursts.(timeranges{b}).npk(a),bursts.(timeranges{b}).pktime(a,:),bursts.(timeranges{b}).pkpeak{a},...
        bursts.(timeranges{b}).pkibi(a),bursts.(timeranges{b}).pkregularity(a),...
        bursts.(timeranges{b}).pkasym(a)]=wjn_burst_duration(bursts.(timeranges{b}).pkdata(a,:),bursts.(timeranges{b}).pkthresh(a),Dtf.fsample,100,'brown');
        bursts.(timeranges{b}).mpkdur(a) = nanmean(bursts.(timeranges{b}).pkdur{a});
        bursts.(timeranges{b}).mpkamp(a) = nanmean(bursts.(timeranges{b}).pkamp{a});
        bursts.(timeranges{b}).hpkdur(a,:) = hist(bursts.(timeranges{b}).pkdur{a},100:100:1000);
        bursts.(timeranges{b}).hpktimes =100:100:1000;
       bursts.(timeranges{b}).phpkdur(a,:) = bursts.(timeranges{b}).hpkdur(a,:)./nansum(bursts.(timeranges{b}).hpkdur(a,:)).*100;
       
        
       
        bursts.(timeranges{b}).gdata(a,:) = smooth(squeeze(nanmean(Dtf(a,45:185,find(Dtf.timeind.(timeranges{b})),1),2)),.06*Dtf.fsample);
        bursts.(timeranges{b}).gthresh(a) = prctile(bursts.(timeranges{b}).gdata(a,:),75);
        [bursts.(timeranges{b}).gdur{a},bursts.(timeranges{b}).gamp{a},bursts.(timeranges{b}).ng(a),bursts.(timeranges{b}).gtime(a,:),bursts.(timeranges{b}).gpeak{a},bursts.(timeranges{b}).gibi(a),bursts.(timeranges{b}).gregularity(a),bursts.(timeranges{b}).gasym(a)]=wjn_burst_duration(bursts.(timeranges{b}).gdata(a,:),bursts.(timeranges{b}).gthresh(a),Dtf.fsample,33,'brown');
        bursts.(timeranges{b}).mgdur(a) = nanmean(bursts.(timeranges{b}).gdur{a});
        bursts.(timeranges{b}).mgamp(a) = nanmean(bursts.(timeranges{b}).gamp{a}); 
         bursts.(timeranges{b}).hgdur(a,:) = hist(bursts.(timeranges{b}).gdur{a},50:50:500);  
        bursts.(timeranges{b}).hgtimes =50:50:500;
        bursts.(timeranges{b}).phgdur(a,:) = bursts.(timeranges{b}).hgdur(a,:)./nansum(bursts.(timeranges{b}).hgdur(a,:)).*100;       
    end
end
D=Dtf;
clear Dtf
    updrs{n} = D.updrs;
    hemiupdrs(n,1) = D.updrs.hemiupdrs;
    hemiupdrs_nt(n,1) = D.updrs.hemiupdrs_nt;
    hemiupdrs_nt_ue(n,1) = D.updrs.hemiupdrs_ue_nt;
    nbursts{n} = bursts;
    
    sstn_rest_power(n,:) = D.spow_rest(D.sSTN,:);
    sstn_move_power(n,:) = D.spow_move(D.sSTN,:);
    sstn_pow_dmr(n,:) = D.pow_dmr(D.sSTN,:);
    
    stn_rest_power(n,:) = nanmean(D.spow_rest(D.istn,:));
    stn_move_power(n,:) = nanmean(D.spow_move(D.istn,:));
    stn_pow_dmr(n,:) = nanmean(D.pow_dmr(D.istn,:));
        
    secog_rest_power(n,:) = D.spow_rest(D.sECOG,:);
    secog_move_power(n,:) = D.spow_move(D.sECOG,:);
    secog_pow_dmr(n,:) = D.pow_dmr(D.sECOG,:);
    
    ecog_rest_power(n,:) = nanmean(D.spow_rest(D.istrip,:));
    ecog_move_power(n,:) = nanmean(D.spow_move(D.istrip,:));
    ecog_pow_dmr(n,:) = nanmean(D.pow_dmr(D.istrip,:));
    
    stnpk(n,1) = D.fpkSTN;
    stnmpk(n,1) = D.mpkSTN;
    channels{n} = D.chanlabels;
    fpkSTN(n,1) = D.fpkSTN;

    fpkECOG(n,1) = D.fbECOG;
    mpkECOG(n,1) = D.spow_rest(D.sECOG,D.fbECOG);
    sSTN(n,1) = D.sSTN;
    sECOG(n,1) = D.sECOG;
    spow_rest{n} = D.spow_rest;
    spow_move{n} = D.spow_move;
    pow_rest{n} = D.pow_rest;  
end
f = D.frequencies;
clear D
save burst_analysis -V7.3
%%
bursts = nbursts;
% clear
% load burst_analysis
clear ephbdur
% fpkSTN(13) = 14;
% fpkSTN(5) = 10;
for a = 1:length(updrs)
    rstn_rest_power(a,:) = pow_rest{a}(sSTN(a),:);
    rstnbeta(a,1) = nanmean(rstn_rest_power(a,12:20),2);
    rperipeakSTN(a,1) = nanmean(rstn_rest_power(a,fpkSTN(a)-2:fpkSTN+2),2);
    rpeakSTN(a,1) = rstn_rest_power(a,fpkSTN(a));
%     figure
%     plot(f,sstn_rest_power(a,:))
%     hold on
%     scatter(f(fpkSTN(a)),sstn_rest_power(a,fpkSTN(a)))
%     title(a)
%     peakSTN(a,1) = sstn_rest_power(a,fpkSTN(a));
    sstnbeta(a,1) = nanmean(sstn_move_power(a,8:35),2);
    secogbeta(a,1)= nanmean(secog_move_power(a,8:35),2);
    peakSTN(a,1) = nanmean(sstn_rest_power(a,fpkSTN(a)),2);
    peripeaksECOG(a,1) = nanmean(secog_rest_power(a,fpkECOG(a)-2:fpkECOG(a)+2),2);
    updrs_off(a,1) = updrs{a}.off_total;
    bbamp(a,1) = bursts{a}.baseline.bamp(sSTN(a));
    bbdur(a,1) = bursts{a}.baseline.mbdur(sSTN(a));
    ephbdur(a,:) = bursts{a}.no_move.hgdur(sSTN(a),:);
    mbdur(a,1) = nanmean(bursts{a}.no_move.mgdur(sSTN(a)));
    mbamp(a,1) = nanmean(bursts{a}.no_move.mgamp(sSTN(a)));
    mbn(a,1) = bursts{a}.no_move.ng(sSTN(a));
end
% i=wjn_corr_optimizer(sstnbeta,hemiupdrs);
nhemiupdrs=hemiupdrs;
% nhemiupdrs(5)=nan;

wjn_pc([sstnbeta secogbeta sstnbeta./secogbeta mbn mbamp mbdur ephbdur],nhemiupdrs)
%%
figure
wjn_corr_plot(peripeaksSTN,hemiupdrs')

figure
wjn_corr_plot(peripeaksSTN,nhemiupdrs)


[rho,prho,r,p]=wjn_pc(ecog_rest_power,hemiupdrs');
cc=colorlover(5);

figure
% mypower(f,sstn_move_power,cc(1,:));
% hold on
plot(f,rho,'linewidth',2,'color',[.5 .5 .5]);
hold on
sigbar(f,prho<0.05)
plot(f,r,'linewidth',2,'color',[.5 .5 .5]);
hold on
sigbar(f,p<0.05)

%%
% 
% 
% %% correct pacflow pacfhigh peakrange betaStrip RegressionStrip cmlpac cmspac
% clear all
% clearvars
% clc
% 
% % root = fullfile(mdf,'ecog');
% % cd(root)
% % load files
% 
% bfiles = ffind('bdata_*.mat');
% for a = 1:length(bfiles)
%     wjn_ecog_ah_correct_bdata(bfiles{a})
% end
% 
% 
% %%
% clear
% bfiles = ffind('bdata_*.mat');
% for a = 1:length(bfiles)
%     wjn_ecog_ah_connectivity(bfiles{a})
% end
% 
% % copyfile bdata_JD* ..
% 
% 
% %%
% 
% clear
% files = ffind('bdata*.mat')
% 
% for a = 1:length(files)
%     load(files{a},'rtffile','wplifile','icohfile','sSTN','ss')
%     Dtf = wjn_sl(rtffile);
%     ftf = Dtf.fname;
%     Dtf = wjn_tf_baseline(ftf(2:end),[-500 -0]);
%     Dicoh = wjn_sl(icohfile);
%     ficoh = Dicoh.fname;
%     Dicoh = wjn_tf_baseline(ficoh(2:end),[-500 0]);
%     fn = Dicoh.fname;
%     Dcoh = wjn_tf_baseline(['m' fn(4:end)],[-500 0]);
%     Dwpli = wjn_sl(['mwpli' fn(7:end)]);
%     istn = ci(sSTN,Dtf.chanlabels);
%     iss = ci(ss,Dtf.chanlabels);
%     il = ci('long',Dtf.conditions);
%     is = ci('short',Dtf.conditions);
%     ti = wjn_sc(Dtf.time,-1):wjn_sc(Dtf.time,1);
%     icoh = ci([sSTN '-' ss],Dicoh.chanlabels);
%     mtf(a,:,:,:,:) = squeeze(Dtf([istn iss],:,ti,[is il]));
%     micoh(a,:,:,:,:) = squeeze(Dcoh(icoh,:,ti,[is il]));
%     mwpli(a,:,:,:,:) = squeeze(Dwpli(icoh,:,ti,[is il]));
% end
% 
% t = Dtf.time(ti)
% f = Dtf.frequencies
% 
% 
% figure
% subplot(2,4,1)
% wjn_contourf(t,Dtf.frequencies,nanmean(mtf(:,1,:,:,1)))  
% caxis([-50 100])
% subplot(2,4,2)
% wjn_contourf(t,Dtf.frequencies,nanmean(mtf(:,2,:,:,1)))    
% caxis([-50 100])
% subplot(2,4,5)
% wjn_contourf(t,Dtf.frequencies,nanmean(mtf(:,1,:,:,2)))  
% caxis([-50 100])
% subplot(2,4,6)
% wjn_contourf(t,Dtf.frequencies,nanmean(mtf(:,2,:,:,2)))    
% caxis([-50 100])
% subplot(2,4,3)
% wjn_contourf(t,Dtf.frequencies,nanmean(micoh(:,:,:,1)))  
% caxis([-50 100])
% subplot(2,4,7)
% wjn_contourf(t,Dtf.frequencies,nanmean(micoh(:,:,:,2)))  
% caxis([-50 100])
% subplot(2,4,4)
% wjn_contourf(t,Dtf.frequencies,nanmean(mwpli(:,:,:,1)))  
% caxis([0 .5])
% subplot(2,4,8)
% wjn_contourf(t,Dtf.frequencies,nanmean(mwpli(:,:,:,2)))  
% caxis([0 .5])
% 
% %%
% clear
% bfiles = ffind('bdata_*.mat');
% for a = 1:length(bfiles)
%     load(bfiles{a},'dpk','sSTN','regressionStrip')
%     istn = ci(sSTN,dpk.channels)
%     icog = ci(regressionStrip,dpk.channels)
% %     icog = randi(5,1)+3;
% %     [stndurhist(a,:),x] = hist(dpk.bdur{istn},[200:50:500]);
% %     [icogdurhist(a,:),x] = hist(dpk.bdur{icog},[200:50:500]);
%     stn25 = prctile(dpk.bdur{istn},25);
%     stn75 = prctile(dpk.bdur{istn},75);
%     ecog25 = prctile(dpk.bdur{icog},25);
%     ecog75 = prctile(dpk.bdur{icog},75);
%     rstn(a) = stn75/stn25;
%     recog(a) = ecog75/ecog25;
% %     rl(a) = stndurhist(a,1)./stndurhist(a,end);
% end
% figure
% [r,p]=wjn_corr_plot(rstn',recog');
% 
% %%
% clear
% load bdata_RT03_LT.mat dpk sSTN ss dlb
% istn = ci(sSTN,dpk.channels);
% icog = ci(ss,dpk.channels);
% ti = wjn_sc(dpk.t,2);
% 
% ii = istn;
% ib = dpk.btime{ii};
% bd = dpk.bamp{ii};
% ni = find(ib>ti & ib<length(dpk.t)-ti)
% cpow =[]
% for a = 1:length(ib(ni))
%     ramp=dpk.rawamp(icog,ib(ni(a))-ti:ib(ni(a))+ti);
%     ramp = (ramp-nanmean(ramp))./std(ramp);
%     cpow(a,:) = ramp; 
%     ramp=dpk.rawamp(istn,ib(ni(a))-ti:ib(ni(a))+ti);
%     ramp = (ramp-nanmean(ramp))./std(ramp);
%     spow(a,:) = ramp; 
%     
% end
% 
% [~,i]=sort(bd(ni));
% % i=1:length(ni);
% 
% % i=ni;
% dur = bd(ni(i));
% tw = linspace(-2,2,length(ramp));
% 
% figure
% subplot(1,2,2)
% imagesc(tw,dur,cpow(i,:))
% axis xy
% subplot(1,2,1)
% imagesc(tw,dur,spow(i,:))
% axis xy
% figone(30,5)
% 
% figure
% plot(nanmean(cpow(i,wjn_sc(tw,-.1):wjn_sc(tw,.1)),2))
% wjn_pc(nanmean(cpow(i,wjn_sc(tw,-.25):wjn_sc(tw,.25)),2))
% %%
% clear
% files = ffind('bdata*.mat')
% pacflow=[5:3:40];
% pacfhigh = [40:5:200];
% fbeta = wjn_sc(pacflow,12):wjn_sc(pacflow,35);
% fgamma = wjn_sc(pacfhigh,60):wjn_sc(pacfhigh,200);
% for a = 1:length(files)
%     load(files{a},'cmlpac','cmspac','peak','lcoh','scoh','lepow','sepow','sspow','lspow','f','rtfile')
%     pr = [peak.sSTNpeakfrequency-5 peak.sSTNpeakfrequency+5];
%     lpac(a,:,:) = cmlpac;
%     spac(a,:,:) = cmspac;
%     dpac(a,:,:) = cmlpac-cmspac;
%     mlpac(a) = nanmean(nanmean(lpac(a,fgamma,fbeta)));
%     mspac(a) = nanmean(nanmean(spac(a,fgamma,fbeta)));
%     mdpac(a) = nanmean(nanmean(dpac(a,fgamma,fbeta)));
%     mdpac(a) = nanmean(nanmean(dpac(a,fgamma,wjn_sc(pacflow,pr(1)):wjn_sc(pacflow,pr(2))),2));
%     mlcoh(a,:) = lcoh;
%     mscoh(a,:) = scoh;
%     mlepow(a,:) = lepow./sum(lepow([5:55 65:95]))*100;
%     msepow(a,:) = sepow./sum(lepow([5:55 65:95]))*100;
%     mlspow(a,:) = lspow./sum(lspow([5:55 65:95]))*100;
%     msspow(a,:) = sspow./sum(lspow([5:55 65:95]))*100;
%     mdcoh(a,:) = lcoh-scoh;
%     mmdcoh(a)= nanmean(mdcoh(a,pr+1));
% end
% 
% cc=colorlover(1);
% figure
% subplot(1,3,3)
% hs=mypower(f,mscoh',cc(3,:))
% xlabel('Frequency [Hz]')
% ylabel('Coherence')
% hold on
% hl=mypower(f,mlcoh',cc(2,:))
% legend([hs hl],{'short','long'})
% xlim([4 45])
% subplot(1,3,2)
% mypower(f,msepow',cc(3,:))
% hold on
% xlabel('Frequency [Hz]')
% ylabel('Power [%]')
% mypower(f,mlepow',cc(2,:))
% xlim([4 45])
% subplot(1,3,1)
% mypower(f,msspow',cc(3,:))
% xlabel('Frequency [Hz]')
% ylabel('Power [%]')
% hold on
% mypower(f,mlspow',cc(2,:))
% xlim([4 45])
% figone(7,30)
% %
% figure
% subplot(1,3,2)
% wjn_contourf(pacflow,pacfhigh,squeeze(nanmean(lpac)));
% PACaxes
% % ca=get(gca,'clim')
% caxis([0.14 0.18])
% subplot(1,3,1)
% wjn_contourf(pacflow,pacfhigh,squeeze(nanmean(spac)))
% % caxis(ca);
% xlim([12 35])
% caxis([0.14 0.18])
% PACaxes
% subplot(1,3,3)
% wjn_contourf(pacflow,pacfhigh,squeeze(nanmean(dpac)))
% PACaxes
% axis xy
% xlim([12 35])
% figure
% mybar([mspac' mlpac'])
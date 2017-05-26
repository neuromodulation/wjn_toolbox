%%
files = ffind('mPDC*.mat');

%%
% remove tu sup and tics
files(7:8) = [];

%%
clear gc cg scg sgc

for a = 1:length(files);
    load(files{a},'mPDC');
    cg(a,:) = mPDC.CMPf_GPi.mpdc;
    scg(a,:) = mPDC.CMPf_GPi.mse;
    
    gc(a,:) = mPDC.GPi_CMPf.mpdc;
    sgc(a,:) = mPDC.GPi_CMPf.mse;
 

end

%%
f = mPDC.f;
mgc = mean(gc,1);
msgc = mean(sgc,1);
mcg = mean(cg,1);
mscg = mean(scg,1);

%%
figure;
myline(f,mgc);
myfont(gca);
hold on;
myline(f,mcg,'color',[0.5 0.5 0.5]);
l=legend('GPi to CMPf','CMPf to GPi');
set(l,'EdgeColor','w')
xlabel('Frequency [Hz]');
ylabel('Partial directed coherence');
xlim([2 40]);
ylim([0 0.2])
%%
p = pairPermTest(5000,gc,cg);

plot(p)

%% tu files 

clear
tufiles = ffind('*tu*.mat');

%% rest
load(tufiles{1});
cg = mPDC.CMPf_GPi.pdc;
scg = mPDC.CMPf_GPi.se;
gc = mPDC.GPi_CMPf.pdc;
sgc = mPDC.GPi_CMPf.se;
mcg = mPDC.CMPf_GPi.mpdc;
mgc = mPDC.GPi_CMPf.mpdc;
smcg = mPDC.CMPf_GPi.mse;
smgc = mPDC.GPi_CMPf.mse;

f = mPDC.f;
%
figure;
%%
% subplot(1,3,1);
% myline(f,mgc);
% myfont(gca);
% set(gca,'FontSize',16,'FontAngle','italic');
% hold on;
% myline(f,mcg,'color',[0.5 0.5 0.5]);
% l=legend('GPi to CMPf','CMPf to GPi');
% set(l,'EdgeColor','w')
% ylabel('PDC');
% xlim([2 40]);
% ylim([0 0.2])
% title('rest')
% hold off;
%% Tics 
load(tufiles{3});
cg = mPDC.CMPf_GPi.pdc;
scg = mPDC.CMPf_GPi.se;
gc = mPDC.GPi_CMPf.pdc;
sgc = mPDC.GPi_CMPf.se;
mcg = mPDC.CMPf_GPi.mpdc;
mgc = mPDC.GPi_CMPf.mpdc;
smcg = mPDC.CMPf_GPi.mse;
smgc = mPDC.GPi_CMPf.mse;

subplot(1,2,1);
myline(f,mgc);
myfont(gca);
set(gca,'FontSize',16,'FontAngle','italic');
hold on;
myline(f,mcg,'color',[0.5 0.5 0.5]);
l=legend('GPi to CMPf','CMPf to GPi');
set(l,'EdgeColor','w')
ylabel('PDC');
xlim([2 40]);
ylim([0 0.2])
title('tics')
hold off;
%% suppression
load(tufiles{2});
cg = mPDC.CMPf_GPi.pdc;
scg = mPDC.CMPf_GPi.se;
gc = mPDC.GPi_CMPf.pdc;
sgc = mPDC.GPi_CMPf.se;
mcg = mPDC.CMPf_GPi.mpdc;
mgc = mPDC.GPi_CMPf.mpdc;
smcg = mPDC.CMPf_GPi.mse;
smgc = mPDC.GPi_CMPf.mse;

subplot(1,2,2);
myline(f,mgc);
myfont(gca);
set(gca,'FontSize',16,'FontAngle','italic');
hold on;
myline(f,mcg,'color',[0.5 0.5 0.5]);
l=legend('GPi to CMPf','CMPf to GPi');
set(l,'EdgeColor','w')
ylabel('PDC');
xlim([2 40]);
ylim([0 0.2])
title('tic suppression')


xlabel('Frequency [Hz]');
hold off;

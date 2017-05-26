root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results
cc = colorlover(1);
cc = cc([5,3,1],:);

%% legend
figure
bar(rand(10,1),'facecolor',cc(1,:));
hold on
bar(rand(10,1),'facecolor',cc(2,:));
bar(rand(10,1),'facecolor',cc(3,:));
ylim([0 10])
xlim([0 10])
legend({'                 ','                ','               '},'fontsize',12)
figone(7)
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
myprint(fullfile(root,'final_figures','bw_legend'))
%% reaction times

% reaction time
close all
figure

% rta = [nanmean(res.PD.ngrt(:,1:30,1),2) nanmean(res.PD.ngrt(:,1:30,2),2) nanmean(res.healthy.ngrt(:,1:30,1),2)];
% rtc = [nanmean(res.PD.nrrt(:,1:30,1),2) nanmean(res.PD.nrrt(:,1:30,2),2) nanmean(res.healthy.nrrt(:,1:30,1),2)];
% rtd = rtc-rta;



rta = [res.PD.rt(:,1,1) res.PD.rt(:,1,2) res.healthy.rt(:,1,1)];
rtc = [res.PD.rt(:,2,1) res.PD.rt(:,2,2) res.healthy.rt(:,2,1)];
rtd = [res.PD.drt(:,1,1) res.PD.drt(:,1,2) res.healthy.drt(:,1)];

mybar(rtd,cc,[1 2 3],.8,'c')

xlim([-.5 9.5])

ylim([450 1000])

[b,e]=mybar([rta rtc rtd],cc,[1:3 5:7 9:11],.8,'none')
sigbracket('**',[1 3],820) % 0.003
sigbracket('**',[2 3],720) % 0.009
sigbracket('*',[5 7],1020) % 0.045
sigbracket('**',[5 6],920) % 0.001
sigbracket('**',[9 10],300) % 0.006
sigbracket('*',[10 11],400) % 0.02
ylim([0 1150])
xlim([-.5 12.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])

% tifprint(fullfile(root,'final_figures','f_rt'))
myprint(fullfile(root,'final_figures','f_rt'))

close all
figure
rtab2 = [res.PD.rt(:,3,1) res.PD.rt(:,3,2) res.healthy.rt(:,3,1)];
rtcb2 = [res.PD.rt(:,4,1) res.PD.rt(:,4,2) res.healthy.rt(:,4,1)];
rtdb2 = [res.PD.drt(:,2,1) res.PD.drt(:,2,2) res.healthy.drt(:,2)];
[b,e]=mybar([rtab2 rtcb2 rtdb2],cc,[1:3 5:7 9:11],.8,'none')
sigbracket('*',[1 2],820) % 0.029
sigbracket('***',[5 6],920) % 0.0001
% sigbracket('**',[5 6],920) % 0.001
% sigbracket('**',[9 10],300) % 0.006
% sigbracket('*',[10 11],400) % 0.02
ylim([0 1150])
xlim([-.5 12.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','f_rt_b2'))
myprint(fullfile(root,'final_figures','f_rt_b2'))


%% movement velocity
close all
figure
va = [res.PD.v(:,1,1) res.PD.v(:,1,2) res.healthy.v(:,1,1)];
vc = [res.PD.v(:,2,1) res.PD.v(:,2,2) res.healthy.v(:,2,1)];
vd = [res.PD.dv(:,1,1) res.PD.dv(:,1,2) res.healthy.dv(:,1)];


[b,e]=mybar([va vc vd],cc,[1:3 5:7 9:11],.8,'-');
sigbracket('***',[1 3],.5) % 0
sigbracket('***',[1 2],.42) % 0
sigbracket('**',[5 7],.5) % 0.003
sigbracket('***',[5 6],.42) % 0
sigbracket('**',[9 10],-.1) % 0
sigbracket('*',[10 11],-.1) % 0.009
ylim([-.2 .6])
xlim([-0.5 12.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','f_v'))
myprint(fullfile(root,'final_figures','f_v'))

close all
figure
vab2 = [res.PD.v(:,3,1) res.PD.v(:,3,2) res.healthy.v(:,3,1)];
vcb2 = [res.PD.v(:,4,1) res.PD.v(:,4,2) res.healthy.v(:,4,1)];
vdb2 = [res.PD.dv(:,2,1) res.PD.dv(:,2,2) res.healthy.dv(:,2)];
[b,e]=mybar([vab2 vcb2 vdb2],cc,[1:3 5:7 9:11],.8,'none');
sigbracket('***',[1 3],.5) % 0
sigbracket('***',[1 2],.42) % 0
sigbracket('***',[5 7],.54) % 0.0001
sigbracket('***',[5 6],.46) % 0
ylim([-.2 .6])
xlim([-0.5 12.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','f_v_b2'))
myprint(fullfile(root,'final_figures','f_v_b2'))
%% movement time
close all
figure
mva = [res.PD.mv(:,1,1) res.PD.mv(:,1,2) res.healthy.mv(:,1,1)];
mvc = [res.PD.mv(:,2,1) res.PD.mv(:,2,2) res.healthy.mv(:,2,1)];
mvd = [res.PD.dmv(:,1,1) res.PD.dmv(:,1,2) res.healthy.dmv(:,1)];

mybar(mvd,cc,[1 2 3],.8,'none')

[b,e]=mybar([mva mvc mvd],cc,[1:3 5:7 9:11],.8,'none');
sigbracket('***',[1 3],2200) % 0
sigbracket('***',[1 2],1900) % 0
sigbracket('*',[2 3],1600) % 0.024
sigbracket('***',[5 7],3000) % 0
sigbracket('***',[5 6],2700) % 0
sigbracket('**',[9 10],1300) % 0.006
sigbracket('**',[9 11],1550) % 0.02
ylim([-150 3300])
xlim([-0.5 12.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','f_mv'))
myprint(fullfile(root,'final_figures','f_mv'))

close all
figure
mvab2 = [res.PD.mv(:,3,1) res.PD.mv(:,3,2) res.healthy.mv(:,3,1)];
mvcb2 = [res.PD.mv(:,4,1) res.PD.mv(:,4,2) res.healthy.mv(:,4,1)];
mvdb2 = [res.PD.dmv(:,2,1) res.PD.dmv(:,2,2) res.healthy.dmv(:,2)];
[b,e]=mybar([mvab2 mvcb2 mvdb2],cc,[1:3 5:7 9:11],.8,'none');
sigbracket('***',[1 3],2400) % 0
sigbracket('***',[1 2],2100) % 0
sigbracket('**',[2 3],1600) % 0.0018
sigbracket('***',[5 7],3000) % 0
sigbracket('***',[5 6],2700) % 0
sigbracket('**',[9 10],1300) % 0.006
sigbracket('**',[9 11],1550) % 0.027
ylim([-150 3300])
xlim([-0.5 12.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','f_mv_b2'))
myprint(fullfile(root,'final_figures','f_mv_b2'))
%% vector error
close all
figure

ea = [res.PD.MERR(:,1,1) res.PD.MERR(:,1,2) res.healthy.MERR(:,1,1)];
ec = [res.PD.MERR(:,2,1) res.PD.MERR(:,2,2) res.healthy.MERR(:,2,1)];
ed = [res.PD.dMERR(:,1,1) res.PD.dMERR(:,1,2) res.healthy.dMERR(:,1)];
[b,e]=mybar([ea ec ed],cc,[1:3 5:7 9:11],.8,'none');
sigbracket('***',[1 2],25) % 0
sigbracket('*',[2 3],28) % 0.013
sigbracket('***',[5 6],30) % 0
sigbracket('***',[6 7],33) % 0.013
sigbracket('*',[9 11],16) % 0.02
sigbracket('*',[10 11],18.5) % 0.03
ylim([0 38])
xlim([-0.5 12.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','f_err'))
myprint(fullfile(root,'final_figures','f_err'))

close all
figure

eab2 = [res.PD.MERR(:,3,1) res.PD.MERR(:,3,2) res.healthy.MERR(:,3,1)];
ecb2 = [res.PD.MERR(:,4,1) res.PD.MERR(:,4,2) res.healthy.MERR(:,4,1)];
edb2 = [res.PD.dMERR(:,2,1) res.PD.dMERR(:,2,2) res.healthy.dMERR(:,2)];
[b,e]=mybar([eab2 ecb2 edb2],cc,[1:3 5:7 9:11],.8,'none');
sigbracket('***',[1 2],27) % 0
sigbracket('**',[2 3],30) % 0.0088
sigbracket('**',[5 6],32) % 0.0022
sigbracket('***',[6 7],35) % 0.0162
% sigbracket('*',[9 11],16) % 0.02
% sigbracket('*',[10 11],18.5) % 0.03
ylim([0 38])
xlim([-0.5 12.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','f_err_b2'))
myprint(fullfile(root,'final_figures','f_err_b2'))

%% fiber tracking correlation
root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results
c=colorlover(1);
close all
x=res.PD.prt(res.PD.images);
x=res.PD.drt(res.PD.images,1,2);
y=res.PD.sm;
[r,p]=wjn_permcorr(x,y,'pearson')
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(3,:),'MarkerEdgecolor',c(5,:),'LineWidth',.5)
hold on
[xl,yl]=mycorrline(x,y,-85,185);
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','sm'))
% 
% rho = 0.5351
% p = 0.009
% r = 0.5813
% p = 0.0044
%% fiber tracking correlation left
root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results
c=colorlover(5);
close all
x=res.PD.prt(res.PD.images);
y=res.PD.lsm;
[r,p]=wjn_permcorr(x,y,'pearson')
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(4,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
[xl,yl]=mycorrline(x,y,-85,185);
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
% tifprint(fullfile(root,'final_figures','lsm'))
% 
% r = 0.5474
% p = 0.0048

%% fiber tracking correlation right
root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results
c=colorlover(5);
close all
x=res.PD.prt(res.PD.images);
y=res.PD.rsm;
[r,p]=wjn_permcorr(x,y,'pearson')
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(4,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
[xl,yl]=mycorrline(x,y,-85,185);
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
% tifprint(fullfile(root,'final_figures','rsm'))
% 
% rho = 0.3947
% p = 0.0466
%
% r = 0.3697
% p = 0.0576
%% fiber tracking spatial correlation R profile

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results
c=colorlover(5);
close all
x=res.PD.prt(res.PD.images);
y=res.PD.ris;
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(4,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
[xl,yl]=mycorrline(x,y,-85,185);
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','ris'))
% 
% rho = 0.5608
% p = 0.009
%
% r = 0.5337
% p = 0.0078
%% spatial correlation with stronges prt effect patient 12

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results
c=colorlover(5);
close all
x=res.PD.prt(res.PD.images);
y=res.PD.rim;
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(4,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
[xl,yl]=mycorrline(x,y,-85,185);
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','rim'))
% 
% rho = 0.3379
% p = 0.07
%
% r = 0.4520
% p = 0.025


%% prt updrs correlation

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
close all
x=res.PD.pupdrs;
y=res.PD.prt;
[rho,prho,r,p]=wjn_pc(x,y);
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(4,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','pupdrsprt'))
% 
r = 0.19;
p = 0.22;

%% pv updrs correlation

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
close all
x=res.PD.pupdrs;
y=wjn_pct_change(nanmean(res.PD.v(:,1:4,1),2),nanmean(res.PD.v(:,1:4,2),2));
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(4,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','pupdrspv'))
% 
%rho = -0.4582;
%p = 0.019;

%r=-0.4293
%p=.025

%% pmv updrs correlation

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
close all
x=res.PD.pupdrs;
y=wjn_pct_change(nanmean(res.PD.mv(:,1:2,1),2),nanmean(res.PD.mv(:,1:2,2),2));
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(4,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','pupdrspmv'))
% % 
% rho = 0.5087;
% prho = 0.01;
% r = 0.4141;
% p = 0.0330


%% updrs off pv correlation

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
close all
% x=res.PD.pupdrs;
x=res.PD.updrs_off;
y=wjn_pct_change(nanmean(res.PD.v(:,2,1),2),nanmean(res.PD.v(:,1,1),2));
% y=wjn_pct_change(nanmean(res.PD.pt(:,1:2,1),2),nanmean(res.PD.pt(:,1:2,2),2));
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(4,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','pupdrspv'))
% % 
% rho = 0.4396;
% prho = 0.0220;
% r = 0.3651;
% p = 0.0396

%% learning PD off green

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
x = [1:30]';
y=squeeze(nanmean(res.PD.ngpt(:,1:30,1)))';
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(1,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','PD_off_ngpt'))

% rho = -0.0874
% prho = 0.3170
%
% r = -0.1055
% p = 0.2848
%% learning PD on green

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
x = [1:30]';
y=squeeze(nanmean(res.PD.ngpt(:,1:30,2)))';
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(3,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','PD_on_ngpt'))
% 
% rho = -0.8265
% prho < 0.0001
% 
% r = -0.8597
% p < 0.0001


%% learning PD off red

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
x = [1:30]';
y=squeeze(nanmean(res.PD.nrpt(:,1:30,1)))';
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(1,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','PD_off_nrpt'))

% rho = -0.2013
% prho = 0.1322
%
% r = -0.1808
% p = 0.1600
%% learning PD on red

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
x = [1:30]';
y=squeeze(nanmean(res.PD.nrpt(:,1:30,2)))';
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(3,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','PD_on_nrpt'))
% 
% rho = -0.5996
% prho < 0.0001
% 
% r = -0.6227
% p < 0.0001

%% learning healthy green

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
x = [1:30]';
y=squeeze(nanmean(res.healthy.ngpt(:,1:30,1)))';
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(5,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
yl=get(gca,'ylim');
set(gca,'YTick',800:100:1500)
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','HC_ngpt'))

% rho = -0.9132
% prho < 0.00001
%
% r = -0.8727
% p < 0.00001
%% learning healthy red

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
x = [1:30]';
y=squeeze(nanmean(res.healthy.nrpt(:,1:30,1)))';
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(5,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
yl=get(gca,'ylim');
set(gca,'YTick',1400:50:2000)
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','HC_nrpt'))
% 
% rho = -0.8265
% prho < 0.0001
% 
% r = -0.8597
% p < 0.0001
%% learning bar plot

% reaction time
cc=colorlover(5);
cc=cc([1,3,5],:);
close all
figure
la = [res.PD.rgpt(:,1) res.PD.rgpt(:,2) res.healthy.rgpt(:,1)];
lc = [res.PD.rrpt(:,1) res.PD.rrpt(:,2) res.healthy.rrpt(:,1)];
ld = [res.PD.drpt(:,1) res.PD.drpt(:,2) res.healthy.drpt(:,1)];
[b,e]=mybar([la lc ld],cc,[1:3 5:7 9:11],.9,'none')
sigbracket('*',[1 2],0.13) % 0.0254
sigbracket('***',[1 3],0.20) % 0.0000
sigbracket('*',[2 3],-0.48) % 0.0314
sigbracket('*',[5 6],0.27) % 0.0258
sigbracket('***',[5 7],0.34) % 0.0000
sigbracket('**',[6 7],-0.42) % 0.0074
sigbracket('*',[5 6],0.27) % 0.0258
sigbracket('***',[5 7],0.34) % 0.0000
sigbracket('**',[6 7],-0.42) % 0.0074

ylim([-.6 .45])
xlim([-.5 12.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','rpt_learning'))

%% motor learning off 
x=[1:60]';
% [offgrho,gprho,offgr,gp]=wjn_pc(squeeze(res.PD.ngpt(:,:,1))',x);
% [offrrho,rprho,offrr,rp]=wjn_pc(squeeze(res.PD.nrpt(:,:,1))',x);
% [ongrho,gprho,ongr,gp]=wjn_pc(squeeze(res.PD.ngpt(:,:,2))',x);
% [onrho,rprho,onrr,rp]=wjn_pc(squeeze(res.PD.nrpt(:,:,2))',x);
% [hcgrho,gprho,hcgr,gp]=wjn_pc(squeeze(res.healthy.ngpt)',x);
% [hcrrho,rprho,hcrr,rp]=wjn_pc(squeeze(res.healthy.nrpt)',x);

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results
c=colorlover(5);
close all
x=res.PD.updrs_off;

% x=[res.PD.sm(1:10,1);nan;res.PD.sm(11:19,1)];
% y=wjn_pct_change(res.PD.rgpt(:,1),res.PD.rgpt(:,2));

y=nanmean([res.PD.rrpt(:,1) res.PD.rgpt(:,1)],2);
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(1,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
ylim([-0.5 0.7])
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','off_rgrtpt'))
% 
% rho = 0.4727;
% p = 0.0178;
%
% r = 0.4642
% p = 0.0170
%% green learning on

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
close all
x=res.PD.updrs_on;
y=nanmean([res.PD.rrpt(:,2) res.PD.rgpt(:,2)],2);
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x,y,'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(3,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifprint(fullfile(root,'final_figures','on_rgrtpt'))
% 
% rho = 0.5198;
% prho = 0.0007;
%
% r = 0.38;
% p = 0.043;

%% all green learning

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results res
c=colorlover(5);
close all
x=[res.PD.updrs_on;res.PD.updrs_off]
y=[res.PD.rgpt(:,2); res.PD.rgpt(:,1)];
[rho,prho,r,p]=wjn_pc(x,y)
figure
plot(x(1:20),y(1:20),'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(3,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
hold on
plot(x(21:40),y(21:40),'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(1,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
plot(x(21:40),y(21:40),'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(1,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)
plot(x(1:20),y(1:20),'LineStyle','none','Marker','o','MarkerSize',7,'MarkerFaceColor',c(3,:),'MarkerEdgecolor',c(2,:),'LineWidth',.5)

xl=get(gca,'xlim');
[xl,yl]=mycorrline(x,y,xl(1),xl(2));
ylim([-1 1])
plot(xl,yl,'LineWidth',2,'color',[.5 .5 .5])
figone(7);
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
tifrint(fullfile(root,'final_figures','all_rgrtpt'))

% rho = 0.4241
% prho = 0.0014
% r = 0.4511
% p = 0.0012


%% reaction times percentage approach

% reaction time
cc = colorlover(5);
cc = cc([1 3 1 3 1 3 1 3 1 3],:)
close all
figure
rta = [res.PD.phrt(:,1,1) res.PD.phrt(:,1,2)];
rtc = [res.PD.phrt(:,2,1) res.PD.phrt(:,2,2)];
rtd = [res.PD.phdrt(:,1,1) res.PD.phdrt(:,1,2)];
[b,e]=mybar([rta rtc rtd],cc,[1:2 4:5 7:8],.9,'none')
% sigbracket('**',[1 3],820) % 0.003
sigbracket('**',[4 5],32) % 0.009
sigbracket('**',[7 8],32) % 0.045
% sigbracket('**',[5 6],920) % 0.001
% sigbracket('**',[9 10],300) % 0.006
% sigbracket('*',[10 11],400) % 0.02
ylim([-70 70])
xlim([-.5 9.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','phrt'))
myprint(fullfile(root,'final_figures','phrt'))
%%
close all
figure
rtab2 = [res.PD.phrt(:,3,1) res.PD.phrt(:,3,2)];
rtcb2 = [res.PD.phrt(:,4,1) res.PD.phrt(:,4,2)];
rtdb2 = [res.PD.phdrt(:,2,1) res.PD.phdrt(:,2,2)];
[b,e]=mybar([rtab2 rtcb2 rtdb2],cc,[1:2 4:5 7:8],.9,'none')
sigbracket('*',[1 2],820) % 0.029
sigbracket('***',[5 6],920) % 0.0001
% sigbracket('**',[5 6],920) % 0.001
% sigbracket('**',[9 10],300) % 0.006
% sigbracket('*',[10 11],400) % 0.02
ylim([-100 100])
xlim([-.5 9.5])
set(gcf,'Position',[8.9694   11.3506    6.0060    5.5298])
set(gca,'XTickLabel',[]);set(gca,'color','w');set(gca,'box','off','XTick',[])
tifprint(fullfile(root,'final_figures','phrt_b2'))
myprint(fullfile(root,'final_figures','phrt_b2'))


%% export all bars

close all
[infoname,infopath] = uigetfile({'*.mat','results from paradigm'});
cd(infopath)
load(fullfile(infopath,infoname));
type={'habit','odd'};
%% Modified Thompson Tau Test
[irt]=sort(find_outliers_Thompson([BLOCK1habit(:,1);BLOCK1odd(:,1);BLOCK2habit(:,1);...
    BLOCK2odd(:,1);BLOCK3habit(:,1);BLOCK3odd(:,1)],0.01,'median',1));hold on
figone(7,12),ylabel('Reaction Time [s]')
lim=get(gca,'ylim');xlim([0 180])
plot([30 30],lim,'color','k','LineStyle','--')
plot([60 60],lim,'color','k','LineStyle','--')
plot([90 90],lim,'color','k','LineStyle','--')
plot([120 120],lim,'color','k','LineStyle','--')
plot([150 150],lim,'color','k','LineStyle','--')

myprint('irt')

[imt]=sort(find_outliers_Thompson([BLOCK1habit(:,3);BLOCK1odd(:,3);BLOCK2habit(:,3);...
    BLOCK2odd(:,3);BLOCK3habit(:,3);BLOCK3odd(:,3)],0.01,'median',1));hold on;
figone(7,12),ylabel('Movement Time [s]')
lim=get(gca,'ylim');xlim([0 180])
plot([30 30],lim,'color','k','LineStyle','--')
plot([60 60],lim,'color','k','LineStyle','--')
plot([90 90],lim,'color','k','LineStyle','--')
plot([120 120],lim,'color','k','LineStyle','--')
plot([150 150],lim,'color','k','LineStyle','--')
myprint('imt')

irt1h=irt(irt<=30);
irt1o=irt(irt>30 & irt <=60)-30;
irt2h=irt(irt>60 & irt <=90)-60;
irt2o=irt(irt>90 & irt <=120)-90;
irt3h=irt(irt>120 & irt <=150)-120;
irt3o=irt(irt>150)-150;

imt1h=imt(imt<=30);
imt1o=imt(imt>30 & imt <=60)-30;
imt2h=imt(imt>60 & imt <=90)-60;
imt2o=imt(imt>90 & imt <=120)-90;
imt3h=imt(imt>120 & imt <=150)-120;
imt3o=imt(imt>150)-150;
%%
nBLOCK1habit = BLOCK1habit;
nBLOCK1habit(irt1h,1)=nan;
nBLOCK2habit = BLOCK2habit;
nBLOCK2habit(irt2h,1)=nan;
nBLOCK3habit = BLOCK3habit;
nBLOCK3habit(irt3h,1)=nan;

nBLOCK1odd = BLOCK1odd;
nBLOCK1odd(irt1o,1)=nan;
nBLOCK2odd = BLOCK2odd;
nBLOCK2odd(irt2o,1)=nan;
nBLOCK3odd = BLOCK3odd;
nBLOCK3odd(irt3o,1)=nan;


nBLOCK1habit(imt1h,3)=nan;
nBLOCK2habit(imt2h,3)=nan;
nBLOCK3habit(imt3h,3)=nan;

nBLOCK1odd(imt1o,3)=nan;
nBLOCK2odd(imt2o,3)=nan;
nBLOCK3odd(imt3o,3)=nan;

rmb1a=nanmean(nBLOCK1habit,1)
rsb1a=sem(nBLOCK1habit,1)
rmb2a=nanmean(nBLOCK2habit,1)
rsb2a=sem(nBLOCK2habit,1)
rmb3a=nanmean(nBLOCK3habit,1)
rsb3a=sem(nBLOCK3habit,1)

rmb1c=nanmean(nBLOCK1odd,1)
rsb1c=sem(nBLOCK1odd,1)
rmb2c=nanmean(nBLOCK2odd,1)
rsb2c=sem(nBLOCK2odd,1)
rmb3c=nanmean(nBLOCK3odd,1)
rsb3c=sem(nBLOCK3odd,1)

mb1a=nanmean(BLOCK1habit,1)
sb1a=sem(BLOCK1habit,1)
mb2a=nanmean(BLOCK2habit,1)
sb2a=sem(BLOCK2habit,1)
mb3a=nanmean(BLOCK3habit,1)
sb3a=sem(BLOCK3habit,1)

mb1c=nanmean(BLOCK1odd,1)
sb1c=sem(BLOCK1odd,1)
mb2c=nanmean(BLOCK2odd,1)
sb2c=sem(BLOCK2odd,1)
mb3c=nanmean(BLOCK3odd,1)
sb3c=sem(BLOCK3odd,1)

xlstext = {'Block 1 auto','Block 1 controlled','Block 2 auto','Block 2 controlled','Block 3 auto','Block 3 controlled'};
xlsname = [name '_outliers_removed.xls']
xlswrite(xlsname,cellstr(name),1,'A1')
xlswrite(xlsname,cellstr(cond),1,'B1')
xlswrite(xlsname,{'Reaction Time';'Performance Time';'Movement Time'},1,'A3')
xlswrite(xlsname,xlstext,1,'B2')
xlswrite(xlsname,[rmb1a',rmb1c',rmb2a',rmb2c',rmb3a',rmb3c'],1,'B3')
def = {'Block 1','automatic','','Block 1','controlled','','Block 2','automatic','','Block 2','controlled','','Block 3','automatic','','Block 3','controlled','',};
trinity={'Reaction Time','Performance Time','Movement Time'};
xlswrite(xlsname,def,2,'A1')
xlswrite(xlsname,[trinity,trinity,trinity,trinity,trinity,trinity],2,'A2')
xlswrite(xlsname,[nBLOCK1habit,nBLOCK1odd,nBLOCK2habit,nBLOCK2odd,nBLOCK3habit,nBLOCK3odd],2,'A3')


xlstext = {'Block 1 auto','Block 1 controlled','Block 2 auto','Block 2 controlled','Block 3 auto','Block 3 controlled'};
xlsname = [name 'outliers_in.xls']
xlswrite(xlsname,cellstr(name),1,'A1')
xlswrite(xlsname,cellstr(cond),1,'B1')
xlswrite(xlsname,{'Reaction Time';'Performance Time';'Movement Time'},1,'A3')
xlswrite(xlsname,xlstext,1,'B2')
xlswrite(xlsname,[mb1a',mb1c',mb2a',mb2c',mb3a',mb3c'],1,'B3')
def = {'Block 1','automatic','','Block 1','controlled','','Block 2','automatic','','Block 2','controlled','','Block 3','automatic','','Block 3','controlled','',};
trinity={'Reaction Time','Performance Time','Movement Time'};
xlswrite(xlsname,def,2,'A1')
xlswrite(xlsname,[trinity,trinity,trinity,trinity,trinity,trinity],2,'A2')
xlswrite(xlsname,[BLOCK1habit,BLOCK1odd,BLOCK2habit,BLOCK2odd,BLOCK3habit,BLOCK3odd],2,'A3')

clear
disp('FERTIG')

clear
root = 'E:\Dropbox\Motorneuroscience\visuomotor_tracking_ANA\MatLab Export';
cd(root)
load final_results
RT_PDoff = squeeze(results.PD.rt(:,1:4,1));
RT_PDon = squeeze(results.PD.rt(:,1:4,2));
RT_HC = squeeze(results.healthy.rt(:,1:4,1));


mRT_PD = nanmean([RT_PDoff,RT_PDon],2);
mRT_PDoff = nanmean([RT_PDoff],2);
mRT_PDon = nanmean([RT_PDon],2);
mRT_HC = nanmean([RT_HC],2);



RT_aut_b1 = nanmean([RT_PDoff(:,1),RT_PDon(:,1),RT_HC(:,1)],2);
RT_con_b1 = nanmean([RT_PDoff(:,2),RT_PDon(:,2),RT_HC(:,2)],2);
RT_aut_b2 = nanmean([RT_PDoff(:,3),RT_PDon(:,3),RT_HC(:,3)],2);
RT_con_b2 = nanmean([RT_PDoff(:,4),RT_PDon(:,4),RT_HC(:,4)],2);

RT_aut = nanmean([RT_aut_b1,RT_aut_b2],2);
RT_con = nanmean([RT_con_b1,RT_con_b2],2);

RT_b1 = nanmean([RT_aut_b1,RT_con_b1],2);
RT_b2 = nanmean([RT_aut_b2,RT_con_b2],2);

% xlswrite('Reaktionszeiten_Ana',RT_PDoff,'PDoff','B2');
% xlswrite('Reaktionszeiten_Ana',RT_PDon,'PDon','B2');
% xlswrite('Reaktionszeiten_Ana',RT_HC,'HC','B2');
%% Vergleiche Gruppen und Bedingungen getrennt

wjn_pt_report(RT_con_b1-RT_aut_b1,RT_con_b2-RT_aut_b2,1,10000)
set(gca,'XTickLabel',{'RT con-aut b1','RT con-aut b2'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_con-aut_b1-RT_con-aut_b2')

wjn_pt_report(RT_b1,RT_b2,1,10000)
set(gca,'XTickLabel',{'RT b1','RT b2'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_b1-RT_b2')

wjn_pt_report(RT_aut,RT_con,1,10000)
set(gca,'XTickLabel',{'RT aut','RT con'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_aut-RT_con')

wjn_pt_report(mRT_PD,mRT_HC,0,10000)
set(gca,'XTickLabel',{'RT PD','RT HC'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PD-RT_HC')

wjn_pt_report(mRT_PDoff,mRT_PDon,1,10000)
set(gca,'XTickLabel',{'RT PDoff','RT PDon'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDoff-RT_PDon')

wjn_pt_report(mRT_PDoff,mRT_HC,1,10000)
set(gca,'XTickLabel',{'RT PDoff','RT HC'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDoff-RT_HC')

wjn_pt_report(mRT_PDon,mRT_HC,1,10000)
set(gca,'XTickLabel',{'RT PDon','RT HC'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDon-RT_HC')

wjn_pt_report(mRT_PDon,mRT_HC,1,10000)
set(gca,'XTickLabel',{'RT PDon','RT HC'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDon-RT_HC')


%% Vergleiche Bedingungen innerhalb der Gruppen
wjn_pt_report(RT_PDon(:,1),RT_PDon(:,2),1,10000)
set(gca,'XTickLabel',{'RT PDon aut b1','RT PDon con b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDon_aut_b1-RT_PDon_con_b1')

wjn_pt_report(RT_PDoff(:,1),RT_PDoff(:,2),1,10000)
set(gca,'XTickLabel',{'RT PDoff aut b1','RT PDoff con b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDoff_aut_b1-RT_PDoff_con_b1')

wjn_pt_report(RT_HC(:,1),RT_HC(:,2),1,10000)
set(gca,'XTickLabel',{'RT HC aut b1','RT HC con b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_HC_aut_b1-RT_HC_con_b1')

%% Vergleiche Block 1 aut zwischen den Gruppen
wjn_pt_report(RT_PDoff(:,1),RT_PDon(:,1),1,10000)
set(gca,'XTickLabel',{'RT PDoff aut b1','RT PDon aut b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDoff_aut_b1-RT_PDon_aut_b1')

wjn_pt_report(RT_PDoff(:,1),RT_HC(:,1),0,10000)
set(gca,'XTickLabel',{'RT PDoff aut b1','RT HC aut b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDoff_aut_b1-RT_HC_aut_b1')

wjn_pt_report(RT_PDon(:,1),RT_HC(:,1),0,10000)
set(gca,'XTickLabel',{'RT PDon aut b1','RT HC aut b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDon_aut_b1-RT_HC_aut_b1')

%% Vergleiche Block 1 con zwischen den Gruppen
wjn_pt_report(RT_PDoff(:,2),RT_PDon(:,2),1,10000)
set(gca,'XTickLabel',{'RT PDoff con b1','RT PDon con b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDoff_con_b1-RT_PDon_con_b1')

wjn_pt_report(RT_PDoff(:,2),RT_HC(:,2),0,10000)
set(gca,'XTickLabel',{'RT PDoff con b1','RT HC con b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDoff_con_b1-RT_HC_con_b1')

wjn_pt_report(RT_PDon(:,2),RT_HC(:,2),0,10000)
set(gca,'XTickLabel',{'RT PDon con b1','RT HC con b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDon_con_b1-RT_HC_con_b1')

%% Vergleiche Block 1 con zwischen den Gruppen
wjn_pt_report(RT_PDoff(:,2)-RT_PDoff(:,1),RT_PDon(:,2)-RT_PDon(:,1),1,10000)
set(gca,'XTickLabel',{'RT PDoff con-aut b1','RT PDon con-aut b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDoff_con-aut_b1-RT_PDon_con_b1')

wjn_pt_report(RT_PDoff(:,2)-RT_PDoff(:,1),RT_HC(:,2)-RT_HC(:,1),1,10000)
set(gca,'XTickLabel',{'RT PDoff con-aut b1','RT HC con-aut b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDoff_con-aut_b1-RT_HC_con-aut_b1')

wjn_pt_report(RT_PDon(:,2)-RT_PDon(:,1),RT_HC(:,2)-RT_HC(:,1),1,10000)
set(gca,'XTickLabel',{'RT PDon con-aut b1','RT HC con-aut b1'})
ylabel('Reaction Time [ms]')
figone(10,13)
myprint('abbildungen_ana/RT_PDon_con-aut_b1-RT_HC_con_b1')
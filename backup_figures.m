[mf,df,sys] = getsystem;

figfolder = [mf 'all_figures'];

backupfolder = ['E:\figures\' date];
mkdir(backupfolder)
copyfile(figfolder,backupfolder)
copyfile([mf 'figures.*'],backupfolder)
delete(fullfile(figfolder,'*.*'));delete(fullfile(figfolder,'png','*.*'))

disp('Figures backed up...')
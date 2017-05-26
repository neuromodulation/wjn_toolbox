function matfolder(folder,filename)
root = cd;
mf = getsystem;
% load([mf 'scripts.mat'])
% s = size(scripts,1);
% scripts{s+1,1} = s+1;
% scripts{s+1,2} = cd;
% scripts{s+1,3} = filename;
% timestamp = datestr(now);
% scripts{s+1,4} = timestamp;
% save([mf 'scripts.mat'], 'scripts');

% xlswrite(fullfile(mf,'scripts.xls'),{'No','Path','Script','Date'},1,'A1')
% xlswrite(fullfile(mf,'scripts.xls'),scripts,1,'A2')
new_folder = fullfile(mf,'projects',folder);
save fff folder root new_folder

mkdir(new_folder)
myedit(fullfile(new_folder,filename))
function matedit(filename)


load(fullfile(getsystem,'scripts.mat'))
s = size(scripts,1);
scripts{s+1,1} = s+1;
scripts{s+1,2} = cd;
scripts{s+1,3} = filename;
timestamp = datestr(now);
scripts{s+1,4} = timestamp;
save(fullfile(getsystem,'scripts.mat'),'scripts')

% xlswrite(fullfile(getsystem,'scripts.xls'),{'No','Path','Script','Date'},1,'A1')
% xlswrite(fullfile(getsystem,'scripts.xls'),scripts,1,'A2')

edit(fullfile(getsystem,filename))
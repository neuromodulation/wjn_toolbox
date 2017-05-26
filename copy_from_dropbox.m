function [outfold,infold] = copy_from_dropbox


[mf,dbf,cfdsys] = getsystem;
timestamp = datestr(now);
mtdfiles = ffind('mtd*.mat');

if isempty(mtdfiles)
    outfold = cd;
    infold =[];
    [x,y,z]=fileparts(cd);
    sys = 'unknown';
else
    load(mtdfiles{end})
    [x,y,z]=fileparts(infold)
end

[~,folder] = fileparts(outfold)
outfold = fullfile(dbf,folder);
cd(fullfile(dbf,folder));

if ~exist(infold,'dir')
    altdir = uigetdir
    altdir = [altdir '\' y];
    mkdir(altdir)
    save(fullfile(dbf,'DBM',['cfd_' y '_' date]),'cfdsys','sys','infold','outfold','timestamp','altdir')
    cd(altdir)
    save(['cfd_' y '_' date],'cfdsys','sys','infold','outfold','timestamp','altdir')
    copyfile(outfold,altdir,'f')
else
    
    save(fullfile(dbf,'DBM',['cfd_' y '_' date]),'cfdsys','sys','infold','outfold','timestamp')
    cd(infold)
    save(['cfd_' y '_' date],'cfdsys','sys','infold','outfold','timestamp')
    copyfile(outfold,infold,'f')
end
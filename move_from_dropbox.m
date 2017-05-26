function [outfold,infold] = move_from_dropbox
[mf,dbf,mfdsys] = getsystem;
timestamp = datestr(now);
mtdfiles = ffind('mtd*.mat');

if isempty(mtdfiles)
    outfold = cd;
    infold =[];
    [x,y,z]=fileparts(cd);
else
    load(mtdfiles{end})
    [x,y,z]=fileparts(infold)
end


cd(outfold)

if ~exist(infold,'dir')
    altdir = uigetdir
    movefile(outfold,altdir,'f')
    save(fullfile(dbf,'DBM',['mfd_' y '_' date]),'mfdsys','sys','infold','outfold','timestamp','altdir')
    cd(altdir)
    save(['mfd_' y '_' date],'mfdsys','sys','infold','outfold','timestamp','altdir')
else
    movefile(outfold,infold,'f')
    save(fullfile(dbf,'DBM',['mfd_' y '_' date]),'mfdsys','sys','infold','outfold','timestamp')
    cd(infold)
    save(['mfd_' y '_' date],'mfdsys','sys','infold','outfold','timestamp')
end
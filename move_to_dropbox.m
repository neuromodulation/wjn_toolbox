function [outfold,infold] = move_to_dropbox
[mf,dbf,sys] = getsystem;
timestamp = datestr(now);
[x,y,z]=fileparts(cd)
infold = cd;
outfold = fullfile(dbf,y);
mkdir(outfold)
copyfile(cd,outfold)
save(['mtd_' y '_' date],'sys','infold','outfold','timestamp')
cd(outfold)
save(['mtd_' y '_' date],'sys','infold','outfold','timestamp')
save(fullfile(dbf,'DBM',['mtd_' y '_' date]),'sys','infold','outfold','timestamp')
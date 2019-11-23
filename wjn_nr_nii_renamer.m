function wjn_nr_nii_renamer(filename)

[folder,fname]=fileparts(filename);
str = stringsplit(fname,'_');
subf = fullfile(cd,'nii_output',str{1},str{2});

if ~exist(subf,'dir')
    mkdir(subf)
end

if strcmp(str{1},'DBS')
    outname=fullfile(subf,[strrep(str{3},'-','_') '.nii']);
else
    outname=fullfile(subf,[str{3} '.nii']);
end
    nc=0;
while exist(outname,'file')
   nc = nc+1;
    outname = fullfile(subf,[str{3} '_' num2str(nc) '.nii']);
end

movefile(filename,outname)

warning([filename ' renamed to ' outname])

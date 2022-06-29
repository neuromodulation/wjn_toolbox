function [files,folders] = wjn_subdir(string)

files = subdir(string);



for a =1 :length(files)
    nfiles{a,1} = files(a).name;
    folders{a,1} = files(a).folder;
    [fdir,fname,ext]=fileparts(files(a).name);
%     fnames{a,1} = [fname ext]; 
end

if ~isempty(files)
    files = nfiles;
else
    files=[];
    folders=[];
end
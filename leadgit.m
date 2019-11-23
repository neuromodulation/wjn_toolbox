function leadgit(w)
if ~exist('w','var')
    w = 0;
end

try
    spm('AsciiWelcome');
catch
    spm12
end

close all
d=mdf(2);

try
   rmpath(genpath(fullfile(getsystem,'lead')))
end
addpath(genpath(fullfile('E:\','leaddbs')))

if w
    lead dbs
end



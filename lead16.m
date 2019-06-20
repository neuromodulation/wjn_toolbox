function lead16(w)
if ~exist('w','var')
    w = 0;
end

% try
%     spm('AsciiWelcome');
% catch
%     spm12
% end

close all
d=mdf(2);

if exist('E:\GitHub\leaddbs','dir')
    addpath(genpath('E:\GitHub\leaddbs'))
else
    addpath(genpath(fullfile(getsystem,'leaddbs')))
end

if w
    lead dbs
end
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
addpath(genpath(fullfile(getsystem,'leaddbs')))

if w
    lead dbs
end
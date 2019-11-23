function spm_meg

P = stringsplit(path,';')';
P = P(ci({'\spm','fieldtrip'},P));

for a=1:length(P)
    rmpath(P{a})
end

if ~exist('w','var')
    w = 0;
end

addpath(fullfile(getsystem,'spm_meg'))
spm eeg
pause(1)
close all
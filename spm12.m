function spm12(w)

P = stringsplit(path,';')';
P = P(ci('\spm',P))

for a=1:length(P)
    rmpath(P{a})
end

if ~exist('w','var')
    w = 0;
end

[~,d]=mdf;

[~,~,~,~,spmf] = getsystem;
addpath(spmf)
% addpath(fullfile(d,'spm12','toolbox','MEEGtools'))
if w
    spm('fmri','defaults')
else
        spm('AsciiWelcome');
            addpath(fullfile(spm('Dir'),'external','fieldtrip'));
%             ft16
            addpath(...
            fullfile(spm('Dir'),'external','bemcp'),...
            fullfile(spm('Dir'),'external','ctf'),...
            fullfile(spm('Dir'),'external','eeprobe'),...
            fullfile(spm('Dir'),'external','mne'),...
            fullfile(spm('Dir'),'external','yokogawa_meg_reader'),...
            fullfile(spm('Dir'),'toolbox', 'dcm_meeg'),...
            fullfile(spm('Dir'),'toolbox', 'spectral'),...
            fullfile(spm('Dir'),'toolbox', 'Neural_Models'),...
            fullfile(spm('Dir'),'toolbox', 'MEEGtools'));
        ft_defaults;
end

% pause(1)
% close all
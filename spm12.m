function spm12(w)

if ~exist('w','var')
    w = 0;
end

[~,d]=mdf;
% addpath(fullfile(d,'Shared\spm12'))

% addpath(fullfile(getsystem,'spm_additions'))
addpath(fullfile(getsystem,'meg_toolbox'))

addpath(fullfile(d,'Shared\Code'))

% addpath(fullfile(getsystem,'SPM12'))
% d='E:\Dropbox\'
[~,~,~,~,spmf] = getsystem;
addpath(spmf)
% addpath(fullfile(d,'spm12','toolbox','MEEGtools'))
if w
    spm('eeg','defaults')
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
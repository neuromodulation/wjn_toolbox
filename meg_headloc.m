function meg_headloc(file,condition)

D = spm_eeg_load(file);


S=[];
S.D = fullfile(D.path,D.fname);
S.outfile = fullfile(D.path,['h' D.fname]);
D=spm_eeg_copy(S);

% D = badtrials(D, ':', 0);

% save(D);

S = [];
S.D = D;
S.save = 1;
S.rejectbetween = 1;
S.threshold = 0.01;
S.rejectwithin = 1;
S.trialthresh = 0.01;
S.correctsens = 1;
S.toplot = 1;
S.losttrack = 'reject';
S.trialind = D.indtrial(condition)';
D = spm_eeg_megheadloc(S);
save(D);
%%
% S=[];
% S.D = fullfile(D.path,'hcmTB.mat');
% S.outfile = fullfile(root,'RO','sensor_level','headloc','hcmTB.mat');
% D=spm_eeg_copy(S);
% S.outfile = fullfile(root,'RC1','sensor_level','headloc','hTB.mat');
% D=spm_eeg_copy(S);
% S.outfile = fullfile(root,'RC2','sensor_level','headloc','hTB.mat');
% D=spm_eeg_copy(S);
function [PAC,sig,f1,f2] = wjn_pac(S)
% S.D = epoched file;
% S.fphase = frequency;
% S.fpower = frequency;
% S.save = 1 (default);
if ischar(S)
    S.D = S;
end

if ~isfield(S,'save')
    S.save = 1;
end

if ~isfield(S,'fphase')
    S.fphase = [4 12];
end

if ~isfield(S,'fpower');
    S.fpower = [13 98];
end

if ~isfield(S,'timewin')
    S.timewin = [-Inf Inf];
end

if ~isfield(S,'condition')
    S.condition = {};
end

D=spm_eeg_load(S.D);

clear matlabbatch

[root,fname,~]=fileparts(D.fullfile);
matlabbatch{1}.spm.meeg.tf.tf.D = {D.fullfile};
matlabbatch{1}.spm.meeg.tf.tf.channels{1}.all = 'all';
matlabbatch{1}.spm.meeg.tf.tf.frequencies = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98];
matlabbatch{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
matlabbatch{1}.spm.meeg.tf.tf.method.mtmfft.taper = 'sine';
matlabbatch{1}.spm.meeg.tf.tf.method.mtmfft.freqres = 1;
matlabbatch{1}.spm.meeg.tf.tf.phase = 1;
matlabbatch{1}.spm.meeg.tf.tf.prefix = 'tpa';
spm_jobman('run',matlabbatch);
clear matlabbatch

for a =1:length(D.chanlabels);
    matlabbatch{1}.spm.meeg.tf.cfc.D(1) = cfg_dep('Time-frequency analysis: M/EEG time-frequency power dataset', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dtfname'));
    matlabbatch{1}.spm.meeg.tf.cfc.channels{1}.chan = 'test';
    matlabbatch{1}.spm.meeg.tf.cfc.conditions = {};
    matlabbatch{1}.spm.meeg.tf.cfc.freqwin = [40 98];
    matlabbatch{1}.spm.meeg.tf.cfc.window = 1000;
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{1}.tfpower.Dtf(1) = cfg_dep('Time-frequency analysis: M/EEG time-frequency power dataset', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dtfname'));
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{1}.tfpower.channels{1}.chan = 'test';
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{1}.tfpower.timewin = [-Inf Inf];
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{1}.tfpower.freqwin = [4 40];
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{1}.tfpower.average = 1;
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{1}.tfpower.standardize = 0;
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{1}.tfpower.regname = 'TFpower';
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{2}.tfphase.Dtf(1) = cfg_dep('Time-frequency analysis: M/EEG time-frequency phase dataset', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dtphname'));
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{2}.tfphase.channels{1}.chan = 'test';
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{2}.tfphase.timewin = [-Inf Inf];
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{2}.tfphase.freqwin = [4 40];
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{2}.tfphase.average = 1;
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{2}.tfphase.standardize = 0;
    matlabbatch{1}.spm.meeg.tf.cfc.regressors{2}.tfphase.regname = 'TFphase';
    matlabbatch{1}.spm.meeg.tf.cfc.confounds = {};
    matlabbatch{1}.spm.meeg.tf.cfc.prefix = [D.chanlabels{a} '_' ];
    spm_jobman('run',matlabbatch);
        sig_image{a} = fullfile(root,[D.chanlabels{b} '_cfc_tf_' fname],'sig_pac_reg1.nii');
        pac_image{a} = fullfile(root,[D.chanlabels{b} '_cfc_tf_' fname],'r_pac_reg1.nii');
        PAC(b,:,:) = spm_read_vols(spm_vol(pac_image{b}));
        sig(b,:,:)=spm_read_vols(spm_vol(sig_image{b}));
        close all
end


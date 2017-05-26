function D=wjn_tf_wavelet(filename,f,nfsample)
if ~exist('f','var')
    f=1:100;
end

D=spm_eeg_load(filename);
if ~exist('nfsample','var')
    subsample = 1;
else
    subsample = round(D.fsample/nfsample);
end
% spm eeg
matlabbatch = [];
matlabbatch{1}.spm.meeg.tf.tf.D = {filename};
matlabbatch{1}.spm.meeg.tf.tf.channels{1}.type = 'EEG';
matlabbatch{1}.spm.meeg.tf.tf.channels{2}.type = 'LFP';
matlabbatch{1}.spm.meeg.tf.tf.frequencies = f;
matlabbatch{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
matlabbatch{1}.spm.meeg.tf.tf.method.morlet.ncycles = 7;
matlabbatch{1}.spm.meeg.tf.tf.method.morlet.timeres = 0;
matlabbatch{1}.spm.meeg.tf.tf.method.morlet.subsample = subsample;
matlabbatch{1}.spm.meeg.tf.tf.phase = 0;
matlabbatch{1}.spm.meeg.tf.tf.prefix = '';
spm_jobman('run',matlabbatch)
[dir,fname,~]=fileparts(filename);
D=spm_eeg_load(fullfile(dir,['tf_' fname '.mat']));

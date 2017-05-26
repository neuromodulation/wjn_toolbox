function D=wjn_tf_hilbert(filename,f,subsample)
if ~exist('f','var')
    f=1:100;
end

if ~exist('subsample','var')
    subsample = 1;
end
% spm eeg
matlabbatch = [];
matlabbatch{1}.spm.meeg.tf.tf.D = {filename};
matlabbatch{1}.spm.meeg.tf.tf.channels{1}.type = 'EEG';
matlabbatch{1}.spm.meeg.tf.tf.channels{2}.type = 'LFP';
matlabbatch{1}.spm.meeg.tf.tf.frequencies = f;
matlabbatch{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
matlabbatch{1}.spm.meeg.tf.tf.method.hilbert.freqres = 0.5;
matlabbatch{1}.spm.meeg.tf.tf.method.hilbert.filter.type = 'but';
matlabbatch{1}.spm.meeg.tf.tf.method.hilbert.filter.dir = 'twopass';
matlabbatch{1}.spm.meeg.tf.tf.method.hilbert.filter.order = 3;
matlabbatch{1}.spm.meeg.tf.tf.method.hilbert.polyorder = 1;
matlabbatch{1}.spm.meeg.tf.tf.method.hilbert.subsample = 1;
matlabbatch{1}.spm.meeg.tf.tf.phase = 0;
matlabbatch{1}.spm.meeg.tf.tf.prefix = '';
spm_jobman('run',matlabbatch)
[dir,fname,~]=fileparts(filename);
D=spm_eeg_load(fullfile(dir,['tf_' fname '.mat']));

function D=wjn_tf_multitaper(filename,f)
% D=wjn_tf_multitaper(filename,f)

if ~exist('f','var')
    f=1:100;
end
matlabbatch = [];
matlabbatch{1}.spm.meeg.tf.tf.D = {filename};
matlabbatch{1}.spm.meeg.tf.tf.channels{1}.type = 'EEG';
matlabbatch{1}.spm.meeg.tf.tf.channels{2}.type = 'LFP';
matlabbatch{1}.spm.meeg.tf.tf.frequencies = f;
matlabbatch{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
matlabbatch{1}.spm.meeg.tf.tf.method.mtmspec.timeres = 600;
matlabbatch{1}.spm.meeg.tf.tf.method.mtmspec.timestep = 100;
matlabbatch{1}.spm.meeg.tf.tf.method.mtmspec.bandwidth = 3;
matlabbatch{1}.spm.meeg.tf.tf.phase = 0;
matlabbatch{1}.spm.meeg.tf.tf.prefix = '';
spm_jobman('run',matlabbatch)
[dir,fname,~]=fileparts(filename);
D=spm_eeg_load(fullfile(dir,['tf_' fname '.mat']));
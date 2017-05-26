function D=wjn_tf_baseline(filename,timewindow)

clear matlabbatch
matlabbatch{1}.spm.meeg.tf.rescale.D = {filename};

if ~exist('timewindow','var')
    matlabbatch{1}.spm.meeg.tf.rescale.method.Rel.baseline.timewin = [-Inf Inf];
else
    matlabbatch{1}.spm.meeg.tf.rescale.method.Rel.baseline.timewin = timewindow;
end

matlabbatch{1}.spm.meeg.tf.rescale.method.Rel.baseline.Db = [];
matlabbatch{1}.spm.meeg.tf.rescale.prefix = 'r';
spm_jobman('run',matlabbatch)
[dir,fname]=fileparts(filename);
D=spm_eeg_load(fullfile(dir,['r' fname]));
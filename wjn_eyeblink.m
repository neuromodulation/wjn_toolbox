function D=wjn_eyeblink(filename,channel)

matlabbatch{1}.spm.meeg.preproc.artefact.D = {filename};
matlabbatch{1}.spm.meeg.preproc.artefact.mode = 'mark';
matlabbatch{1}.spm.meeg.preproc.artefact.badchanthresh = 0.2;
matlabbatch{1}.spm.meeg.preproc.artefact.append = true;
matlabbatch{1}.spm.meeg.preproc.artefact.methods.channels{1}.chan = channel;
matlabbatch{1}.spm.meeg.preproc.artefact.methods.fun.eyeblink.threshold = 4;
matlabbatch{1}.spm.meeg.preproc.artefact.methods.fun.eyeblink.excwin = 250;
matlabbatch{1}.spm.meeg.preproc.artefact.prefix = 'a';
spm_jobman('run',matlabbatch);

[dir,fn]=fileparts(filename);
D=spm_eeg_load(['a' fn]);
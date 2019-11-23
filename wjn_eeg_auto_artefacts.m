function D=wjn_eeg_auto_artefacts(filename)

D=wjn_sl(filename);
matlabbatch{1}.spm.meeg.preproc.artefact.D = {D.fullfile};
matlabbatch{1}.spm.meeg.preproc.artefact.mode = 'reject';
matlabbatch{1}.spm.meeg.preproc.artefact.badchanthresh = 0.2;
matlabbatch{1}.spm.meeg.preproc.artefact.append = true;
matlabbatch{1}.spm.meeg.preproc.artefact.methods(1).channels{1}.type = 'EEG';
matlabbatch{1}.spm.meeg.preproc.artefact.methods(1).fun.flat.threshold = 0;
matlabbatch{1}.spm.meeg.preproc.artefact.methods(1).fun.flat.seqlength = 4;
matlabbatch{1}.spm.meeg.preproc.artefact.methods(2).channels{1}.type = 'EEG';
matlabbatch{1}.spm.meeg.preproc.artefact.methods(2).fun.peak2peak.threshold = 100;
matlabbatch{1}.spm.meeg.preproc.artefact.methods(3).channels{1}.type = 'EEG';
matlabbatch{1}.spm.meeg.preproc.artefact.methods(3).fun.threshchan.threshold = 100;
matlabbatch{1}.spm.meeg.preproc.artefact.methods(3).fun.threshchan.excwin = 500;
matlabbatch{1}.spm.meeg.preproc.artefact.prefix = 'a';
spm_jobman('run',matlabbatch)
D=wjn_sl(fullfile(D.path,['a' D.fname]));
Dr=wjn_remove_bad_trials(D.fullfile);D.delete();
D=wjn_remove_bad_channels(Dr.fullfile);Dr.delete();
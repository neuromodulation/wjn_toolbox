function D= wjn_eeg_autoreject_trials(filename)
D=spm_eeg_load(filename);
D=wjn_spm_copy(D.fullfile,fullfile(D.path,['ar' D.fname]));
fdir = D.path;
fname = D.fname;
for a=1:length(D.autoreject.thresholds)
    matlabbatch=[];
    matlabbatch{1}.spm.meeg.preproc.artefact.D = {D.fullfile};
    matlabbatch{1}.spm.meeg.preproc.artefact.mode = 'reject';
    matlabbatch{1}.spm.meeg.preproc.artefact.badchanthresh = 0.2;
    matlabbatch{1}.spm.meeg.preproc.artefact.append = true;
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(1).channels{1}.chan = strrep(D.autoreject.channels(a,:),' ','');
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(1).fun.threshchan.threshold = D.autoreject.thresholds(a)*2;
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(1).fun.threshchan.excwin = 1000;
    matlabbatch{1}.spm.meeg.preproc.artefact.prefix = 'a';
    spm_jobman('run',matlabbatch)
    D=spm_eeg_load(fullfile(fdir,['a' fname]));
    D=D.move(fullfile(fdir,fname));
end

D=spm_eeg_load(D.fullfile);
D=wjn_remove_bad_trials(D.fullfile);
D=wjn_remove_bad_channels(D.fullfile);
   

 
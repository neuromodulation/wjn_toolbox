function wjn_nii_merge(files,fname)

matlabbatch{1}.spm.util.cat.vols = files;
matlabbatch{1}.spm.util.cat.name = fname;
matlabbatch{1}.spm.util.cat.dtype = 4;
spm_jobman('run',matlabbatch)
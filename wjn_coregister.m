function nii=wjn_coregister(reference,source,adds)

if ~exist('adds','var') || isempty(adds)
adds = {};
end
matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {reference};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {source};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = adds;
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 2;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
spm_jobman('run',matlabbatch)

[dir,fname,ext]=fileparts(source);
nii=ea_load_nii(fullfile(dir,['r' fname ext]));
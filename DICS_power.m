%-----------------------------------------------------------------------
% Job saved on 29-May-2015 13:07:18 by cfg_util (rev $Rev: 5797 $)
% spm SPM - SPM12b (beta)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.tools.beamforming.data.dir = {'D:\MEG\plfp1_spm_out\DYST05'};
matlabbatch{1}.spm.tools.beamforming.data.D = {'D:\MEG\plfp1_spm_out\DYST05\SPMrest\tsssDYST05_on.mat'};
matlabbatch{1}.spm.tools.beamforming.data.val = 1;
matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'sensors';
matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{2}.spm.tools.beamforming.sources.reduce_rank = [2 3];
matlabbatch{2}.spm.tools.beamforming.sources.keep3d = 1;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.resolution = 5;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.space = 'MNI template';
matlabbatch{2}.spm.tools.beamforming.sources.visualise = 1;
matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{3}.spm.tools.beamforming.features.whatconditions.all = 1;
matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];
matlabbatch{3}.spm.tools.beamforming.features.modality = {'MEG'};
matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.foi = [13 30];
matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.taper = 'dpss';
matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.keepreal = 0;
matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.hanning = 1;
matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 0.01;
matlabbatch{3}.spm.tools.beamforming.features.bootstrap = false;
matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.dics.fixedori = 'yes';
matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.power = 1;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.all = 1;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.sametrials = false;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.woi = [-Inf Inf];
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.foi = [13 30];
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'singleimage';
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.scale = 'yes';
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'separate';
matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
spm_jobman('run',matlabbatch)
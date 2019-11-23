%-----------------------------------------------------------------------
% Job saved on 11-Apr-2013 23:29:20 by cfg_util (rev $Rev: 4972 $)
% spm SPM - SPM12b (beta)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
cd('C:\megdata\TB\RO\source_coherence\');
copyfile C:\megdata\TB\RO\sensor_level\native\rROcmTB.* native\
copyfile C:\megdata\TB\RO\sensor_level\headloc\rROhcmTB.* headloc\

files = {{'C:\megdata\TB\RO\source_coherence\native\rROcmTB.mat'},{'C:\megdata\TB\RO\source_coherence\headloc\rROhcmTB.mat'}};
refchans = {'LFP_R01','LFP_R12','LFP_R23'};
dirs = {'R01','R12','R23'};
style = {'native','headloc'};
fw = [5 20;7 13;15 25; 55 75; 80 95; 55 95];


for f = 1:2;
    for a=1:numel(refchans);
        for b = 1:length(fw);
            cd(style{f});
            dirname = [dirs{a} '_' num2str(fw(b,1)) '_' num2str(fw(b,2))];
            mkdir(dirname);
            
            matlabbatch{1}.spm.tools.beamforming.data.dir = {['C:\megdata\TB\RO\source_coherence\'  style{f} '\' dirname '\']};
            matlabbatch{1}.spm.tools.beamforming.data.D = files{f};
            matlabbatch{1}.spm.tools.beamforming.data.val = 1;
            matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'sensors';
            matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
            matlabbatch{1}.spm.tools.beamforming.data.overwrite = 0;
            matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.resolution = 10;
            matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.space = 'MNI template';
            matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{3}.spm.tools.beamforming.features.whatconditions.all = 1;
            matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];
            matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.foi = fw(b,:);
            matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.taper = 'dpss';
            matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.keepreal = 0;
            matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.hanning = 1;
            matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 0.01;
            matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{4}.spm.tools.beamforming.inverse.plugin.dics.fixedori = 'yes';
            matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.name = 'LFP_R01';
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.shuffle = 0;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.all = 1;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.woi = [-Inf Inf];
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.foi = fw(b,:);
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'singleimage';
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.scale = 'no';
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
            matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'separate';
            matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
            spm_jobman('run',matlabbatch);
            cd('C:\megdata\TB\RO\source_coherence\');
        end
    end
end
 
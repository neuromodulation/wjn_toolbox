function D = wjn_eeg_source_extraction(filename,mni,names,radius)


if ~exist('mni','var')
    [mni,names]=wjn_mni_list;
end

D=wjn_sl(filename);

if ischar(names)
    names = {names};
end

if ~exist('radius','var')
    radius = 15;
end

[fdir,fname,ext]=fileparts(filename);

matlabbatch{1}.spm.tools.beamforming.data.dir = {fdir};
matlabbatch{1}.spm.tools.beamforming.data.D = {fullfile(fdir,[fname ext])};
matlabbatch{1}.spm.tools.beamforming.data.val = 1;
matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'inv';
matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{2}.spm.tools.beamforming.sources.reduce_rank = [2 3];
matlabbatch{2}.spm.tools.beamforming.sources.keep3d = 1;
for a = 1:length(names)
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.vois{a}.voidef.label = names{a};
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.vois{a}.voidef.pos = mni(a,:);
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.vois{a}.voidef.ori = [0 0 0];
end
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.radius = radius;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.resolution = 5;
matlabbatch{2}.spm.tools.beamforming.sources.visualise = 1;
matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{3}.spm.tools.beamforming.features.whatconditions.all = 1;
matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];
matlabbatch{3}.spm.tools.beamforming.features.modality = {'MEG'};
matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
matlabbatch{3}.spm.tools.beamforming.features.plugin.contcov = struct([]);
matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 5;
matlabbatch{3}.spm.tools.beamforming.features.bootstrap = 'yes';
matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.orient = true;
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.keeplf = false;
matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{5}.spm.tools.beamforming.output.plugin.montage.method = 'max';
matlabbatch{5}.spm.tools.beamforming.output.plugin.montage.vois = {};
matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.mode = 'write';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.modality = 'MEG';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.none = 0;
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.prefix = 'B';

spm_jobman('run',matlabbatch)
D=spm_eeg_load(fullfile(fdir,['B' fname ext]));
D.sources.mni = mni;
D.sources.names = names;
save(D)
pause(1) 
delete(fullfile(fdir,'BF.mat'));
function D=wjn_eeg_lcmv_mesh_extraction(filename,downsample_mesh,addchannels)

if ~exist('downsample_mesh','var')
    downsample_mesh = 10;
end


D=wjn_sl(filename);
fdir = D.path;
fname = D.fname;

matlabbatch=[];
matlabbatch{1}.spm.tools.beamforming.data.dir = {fdir};
matlabbatch{1}.spm.tools.beamforming.data.D = {D.fullfile};
matlabbatch{1}.spm.tools.beamforming.data.val = 1;
matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'inv';
matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{2}.spm.tools.beamforming.sources.reduce_rank = [2 3];
matlabbatch{2}.spm.tools.beamforming.sources.keep3d = 1;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.orient = 'downsampled';
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.fdownsample = downsample_mesh;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.symmetric = 'no';
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.flip = false;
matlabbatch{2}.spm.tools.beamforming.sources.visualise = 0;
matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{3}.spm.tools.beamforming.features.whatconditions.all = 1;
matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];
matlabbatch{3}.spm.tools.beamforming.features.modality = {'EEG'};
matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
matlabbatch{3}.spm.tools.beamforming.features.plugin.contcov = struct([]);
matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 5;
matlabbatch{3}.spm.tools.beamforming.features.bootstrap = true;
matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.orient = true;
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.keeplf = false;
matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{5}.spm.tools.beamforming.output.plugin.montage.method = 'keep';
matlabbatch{5}.spm.tools.beamforming.output.plugin.montage.vois = cell(1, 0);
matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.mode = 'onlinecopy';
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.modality = 'EEG';

if exist('addchannels','var')
    if ischar(addchannels)
        addchannels={addchannels};
    end
    for a = 1:length(addchannels)
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{a}.chan = addchannels{a};
    end
else
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.none = 0;
end
matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.prefix = 'M';
spm_jobman('run',matlabbatch)
D=wjn_sl(fullfile(fdir,['M' fname]));
bf = load(fullfile(fdir,'BF.mat'));
D.sources.mesh.vertices = bf.sources.mesh.canonical.vert;
D.sources.mesh.faces = bf.sources.mesh.canonical.face;
D.sources.mni = D.sources.mesh.vertices;
D.sources.montage = D.montage('getmontage');
save(D)
% keyboard

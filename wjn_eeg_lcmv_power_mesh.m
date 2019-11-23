function D=wjn_eeg_lcmv_power_mesh(filename,freqrange,timerange,conds,outname,inflation_factor)
cdir=cd;
D=spm_eeg_load(filename);

if ~exist('inflation_factor','var') ||isempty(inflation_factor)
    inflation_factor = 1;
end

if ~exist('timerange','var') || isempty(timerange)
    timerange = [-Inf Inf];
end

if ~exist('conds','var') || isempty(conds)
    conds = D.conditions;
elseif ischar(conds)
    conds={conds};
end

fdir = [D.path filesep outname '_lcmv_' num2str(freqrange(1)) '-' num2str(freqrange(2)) 'Hz_' num2str(timerange(1)) '-' num2str(timerange(2)) 'ms'];

mkdir(fdir)
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
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.fdownsample = inflation_factor;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.symmetric = 'no';
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.flip = false;
matlabbatch{2}.spm.tools.beamforming.sources.visualise = 0;
matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{3}.spm.tools.beamforming.features.whatconditions.condlabel = conds;
matlabbatch{3}.spm.tools.beamforming.features.woi = timerange;
matlabbatch{3}.spm.tools.beamforming.features.modality = {'EEG'};
matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
matlabbatch{3}.spm.tools.beamforming.features.plugin.contcov = struct([]);
matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 5;
matlabbatch{3}.spm.tools.beamforming.features.bootstrap = true;
matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.orient = true;
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.keeplf = false;
matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.whatconditions.condlabel = conds;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.sametrials = true;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.woi = timerange;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.foi = freqrange;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.logpower = true;    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.result = 'bycondition';
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.modality = 'EEG';
matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{6}.spm.tools.beamforming.write.plugin.gifti.normalise = 'all';
matlabbatch{6}.spm.tools.beamforming.write.plugin.gifti.space = 'mni';
matlabbatch{6}.spm.tools.beamforming.write.plugin.gifti.visualise = 0;
spm_jobman('run',matlabbatch)
% keyboard

bf=load(fullfile(fdir,'BF.mat'));
D.lcmv.(outname)=[];
D.lcmv.(outname).coords = bf.sources.pos;
D.lcmv.(outname).mesh = bf.sources.mesh.canonical;

for a =1:length(conds)
    D.lcmv.(outname).pow(:,a) = [bf.output.image(a).val];
    D.lcmv.(outname).conds{a} = conds{a};
figure
wjn_plot_surface(D.lcmv.(outname).mesh,D.lcmv.(outname).pow(:,a));

myprint(fullfile(fdir,[conds{a} '_mesh']))
end

    

save(D)

delete BF.mat
cd(cdir)
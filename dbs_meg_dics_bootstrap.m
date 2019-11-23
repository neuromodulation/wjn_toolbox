function dbs_meg_dics_bootstrap(initials, drug, band, prefix)

druglbl = {'off', 'on'};
niter = 0;

try
    [files, seq, root, details] = dbs_subjects(initials, drug);
catch
    return;
end

if nargin<4
    prefix = '';
end

try
    D = spm_eeg_load(fullfile(root, 'SPMrest', [prefix initials '_' druglbl{drug+1} '.mat']));
catch
    D = dbs_meg_rest_prepare_spm12(initials, drug);
end

cd(fullfile(root, 'SPMrest'));

res = mkdir('BF');

banddir = sprintf('band_%d_%dHz', band);
res = mkdir(banddir);

cd(banddir);

[files,dirs] = spm_select('ExtFPListRec','.', 'full.*');
if size(files, 1) && (size(files, 1) == 2*size(dirs, 1))
    return;
end

dbatch{1}.spm.tools.beamforming.data.dir = {fullfile(root, 'SPMrest', 'BF')};
dbatch{1}.spm.tools.beamforming.data.D = {fullfile(D)};
dbatch{1}.spm.tools.beamforming.data.val = 1;
dbatch{1}.spm.tools.beamforming.data.gradsource = 'inv';
dbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
dbatch{1}.spm.tools.beamforming.data.overwrite = 1;
dbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
dbatch{2}.spm.tools.beamforming.sources.reduce_rank = [2 3];
dbatch{2}.spm.tools.beamforming.sources.plugin.grid.resolution = 10;
dbatch{2}.spm.tools.beamforming.sources.plugin.grid.space = 'MNI template';

spm_jobman('run', dbatch);

fbatch{1}.spm.tools.beamforming.features.BF = {fullfile(root, 'SPMrest', 'BF', 'BF.mat')};
fbatch{1}.spm.tools.beamforming.features.whatconditions.all = 1;
fbatch{1}.spm.tools.beamforming.features.woi = [-Inf Inf];
if details.oxford
    fbatch{1}.spm.tools.beamforming.features.modality = {'MEGPLANAR'};
else
    fbatch{1}.spm.tools.beamforming.features.modality = {'MEG'};
end

fbatch{1}.spm.tools.beamforming.features.fuse = 'no';
fbatch{1}.spm.tools.beamforming.features.plugin.csd.foi = band;
fbatch{1}.spm.tools.beamforming.features.plugin.csd.taper = 'dpss';
fbatch{1}.spm.tools.beamforming.features.plugin.csd.keepreal = 0;
fbatch{1}.spm.tools.beamforming.features.plugin.csd.hanning = 0;
if details.oxford
    fbatch{1}.spm.tools.beamforming.features.regularisation.mantrunc.pcadim = 80;
else
    fbatch{1}.spm.tools.beamforming.features.regularisation.manual.lambda = 0.01;
end
fbatch{1}.spm.tools.beamforming.features.bootstrap = false;
fbatch{2}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
fbatch{2}.spm.tools.beamforming.inverse.plugin.dics.fixedori  = 'yes';

%%
obatch{1}.spm.tools.beamforming.output.BF = {fullfile(root, 'SPMrest', 'BF', 'BF.mat')};
obatch{1}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.all = 1;
obatch{1}.spm.tools.beamforming.output.plugin.image_dics.sametrials = true;
obatch{1}.spm.tools.beamforming.output.plugin.image_dics.woi = [-Inf Inf];
obatch{1}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
obatch{1}.spm.tools.beamforming.output.plugin.image_dics.foi = band;
obatch{1}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
obatch{1}.spm.tools.beamforming.output.plugin.image_dics.result = 'singleimage';
obatch{1}.spm.tools.beamforming.output.plugin.image_dics.scale = 'no';
if details.oxford
    obatch{1}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEGPLANAR';
else
    obatch{1}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
end
obatch{2}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
obatch{2}.spm.tools.beamforming.write.plugin.nifti.normalise = 'separate';
obatch{2}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
obatch{3}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('Write: Output files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
obatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.patrep.pattern = '.*';
obatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.unique = false;
obatch{4}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
obatch{4}.spm.tools.beamforming.write.plugin.nifti.normalise = 'separate';
obatch{4}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
%%

obatch{1}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.shuffle = 0;
for i = 0:niter        
    for c = 1:numel(details.chan)
        if i==0
            res = mkdir(fullfile(root, 'SPMrest', banddir), details.chan{c});
            fbatch{1}.spm.tools.beamforming.features.bootstrap = false;
            spm_jobman('run', fbatch);            
        elseif i==1
            fbatch{1}.spm.tools.beamforming.features.bootstrap = true;
            spm_jobman('run', fbatch);        
        end
        obatch{1}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.name = details.chan{c};
        obatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.moveto = {fullfile(root, 'SPMrest', banddir, details.chan{c})};
        
        if i==0
            obatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.patrep.repl = 'full_orig';
        else
            obatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.patrep.repl = ['bootstrap_orig' num2str(i)];
        end
        spm_jobman('run', obatch);
    end
end

obatch{1}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.shuffle = 1;
for i = 0:niter
    for c = 1:numel(details.chan)
        if i==0
            fbatch{1}.spm.tools.beamforming.features.bootstrap = false;
            spm_jobman('run', fbatch);
        elseif i==1
            fbatch{1}.spm.tools.beamforming.features.bootstrap = true;
            spm_jobman('run', fbatch);
        end
        obatch{1}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.name = details.chan{c};
        obatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.moveto = {fullfile(root, 'SPMrest', banddir, details.chan{c})};
        
        if i==0
            obatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.patrep.repl = 'full_shuffled';
        else
            obatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.patrep.repl = ['bootstrap_shuffled' num2str(i)];
        end
        spm_jobman('run', obatch);
    end
end
%%
if niter == 0
    return
end
%%
sbatch{1}.spm.spatial.smooth.fwhm = [16 16 16];
sbatch{1}.spm.spatial.smooth.dtype = 0;
sbatch{1}.spm.spatial.smooth.im = 1;
sbatch{1}.spm.spatial.smooth.prefix = 's';
sbatch{2}.spm.spatial.smooth.fwhm = [16 16 16];
sbatch{2}.spm.spatial.smooth.dtype = 0;
sbatch{2}.spm.spatial.smooth.im = 1;
sbatch{2}.spm.spatial.smooth.prefix = 's';
sbatch{3}.spm.stats.factorial_design.des.t2.scans1(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
sbatch{3}.spm.stats.factorial_design.des.t2.scans2(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
sbatch{3}.spm.stats.factorial_design.des.t2.dept = 0;
sbatch{3}.spm.stats.factorial_design.des.t2.variance = 1;
sbatch{3}.spm.stats.factorial_design.des.t2.gmsca = 0;
sbatch{3}.spm.stats.factorial_design.des.t2.ancova = 0;
sbatch{3}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
sbatch{3}.spm.stats.factorial_design.masking.tm.tm_none = 1;
sbatch{3}.spm.stats.factorial_design.masking.im = 1;
sbatch{3}.spm.stats.factorial_design.masking.em = {fullfile(spm('dir'), 'EEGtemplates', 'iskull.nii')};
sbatch{3}.spm.stats.factorial_design.globalc.g_omit = 1;
sbatch{3}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
sbatch{3}.spm.stats.factorial_design.globalm.glonorm = 1;
sbatch{4}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
sbatch{4}.spm.stats.fmri_est.write_residuals = 0;
sbatch{4}.spm.stats.fmri_est.method.Classical = 1;
sbatch{5}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
sbatch{5}.spm.stats.con.consess{1}.tcon.name = 't';
sbatch{5}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
sbatch{5}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
sbatch{5}.spm.stats.con.delete = 1;
sbatch{6}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
sbatch{6}.spm.stats.results.conspec.titlestr = '';
sbatch{6}.spm.stats.results.conspec.contrasts = 1;
sbatch{6}.spm.stats.results.conspec.threshdesc = 'FWE';
sbatch{6}.spm.stats.results.conspec.thresh = 0.01;
sbatch{6}.spm.stats.results.conspec.extent = 0;
sbatch{6}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
sbatch{6}.spm.stats.results.units = 1;
sbatch{6}.spm.stats.results.print = false;
sbatch{6}.spm.stats.results.write.tspm.basename = 'result';
%%
for c = 1:numel(details.chan)
    statdir = fullfile(root, 'SPMrest', banddir, details.chan{c});
    try
        delete(fullfile(statdir, 'SPM.mat'));
    end
    sbatch{3}.spm.stats.factorial_design.dir = {statdir};
    for i = 1:niter
        sbatch{1}.spm.spatial.smooth.data{i, 1} = fullfile(statdir, ['bootstrap_orig' num2str(i) '.nii,1']);
        sbatch{2}.spm.spatial.smooth.data{i, 1} = fullfile(statdir, ['bootstrap_shuffled' num2str(i) '.nii,1']);
    end
    spm_jobman('run', sbatch);   
end
%%
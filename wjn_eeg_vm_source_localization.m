function D=wjn_eeg_vm_source_localization(filename)
D=spm_eeg_load(filename);


freqbands = D.pow.freqranges;
timeranges = [-3000 -2000;-1000 0;0 1000;1000 2000;-3000 -2500;-500 0;0 500;1000 1500];

% D=rmfield(D,'bf_images');
% for a = 1:size(timeranges,1)
%     for b = 1:size(freqbands,1)
matlabbatch=[];
matlabbatch{1}.spm.tools.beamforming.data.dir = {D.path};
matlabbatch{1}.spm.tools.beamforming.data.D = {D.fullfile};
matlabbatch{1}.spm.tools.beamforming.data.val = 1;
matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'inv';
matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{2}.spm.tools.beamforming.sources.reduce_rank = [2 3];
matlabbatch{2}.spm.tools.beamforming.sources.keep3d = 1;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.orient = 'downsampled';
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.fdownsample = 10;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.symmetric = 'no';
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.flip = false;
matlabbatch{2}.spm.tools.beamforming.sources.visualise = 0;
matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{3}.spm.tools.beamforming.features.whatconditions.all = 1;
matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];%timeranges(a,:);
matlabbatch{3}.spm.tools.beamforming.features.modality = {'EEG'};
matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
%         matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.foi = freqbands(b,:);
%         matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.taper = 'hanning';
matlabbatch{3}.spm.tools.beamforming.features.plugin.contcov = struct([]);
matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 5;
% matlabbatch{3}.spm.tools.beamforming.features.regularisation.minkatrunc.reduce = 1;
matlabbatch{3}.spm.tools.beamforming.features.bootstrap = true;
matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.orient = true;
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.keeplf = false;
%         matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.whatconditions.all=1;
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.sametrials = true;
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.woi = timeranges(a,:);
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.foi = freqbands(b,:);
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.logpower = true;
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.result = 'singleimage';
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
%         matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.modality = 'EEG';

spm_jobman('run',matlabbatch)
for a = 1:size(timeranges,1)
    for b = 1:size(freqbands,1)
        for c=1:2
            matlabbatch=[];
            matlabbatch{1}.spm.tools.beamforming.output.BF={fullfile(D.path,'BF.mat')};
            if c==1
                matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.whatconditions.all=1;
                matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.result = 'singleimage';
                ic=1;
            else
                matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.whatconditions.condlabel = {'move_aut','move_con'};
                matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.result = 'bycondition';
                ic=2:3;
            end
            
            matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.sametrials = true;
            matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.woi = timeranges(a,:);
            matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.foi = freqbands(b,:);
            matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
            matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.logpower = true;
            matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
            matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
            matlabbatch{1}.spm.tools.beamforming.output.plugin.image_power.modality = 'EEG';
            spm_jobman('run',matlabbatch)
            bf=load(fullfile(D.path,'BF.mat'));
            D.bf_images.batch{b,a} = matlabbatch;
            D.bf_images.mesh.faces=bf.sources.mesh.canonical.face;
            D.bf_images.mesh.vertices=bf.sources.mesh.canonical.vert;
            D.bf_images.matrix{b,a}={b a};
            for d =1:length(ic)
                D.bf_images.pow(:,ic(d),b,a)= bf.output.image(d).val';
                D.bf_images.npow(:,ic(d),b,a)= bf.output.image(d).val'./nanmean(bf.output.image(d).val,2);
                D.bf_images.zpow(:,ic(d),b,a)=wjn_zscore(bf.output.image(d).val');
                D.bf_images.spow(:,ic(d),b,a)=  spm_mesh_smooth(D.bf_images.mesh,bf.output.image(d).val',5);
                D.bf_images.snpow(:,ic(d),b,a)= D.bf_images.spow(:,(ic(d)),b,a)./squeeze(nanmean(nanmean(D.bf_images.spow(:,(ic(d)),b,a),1),2));
            end
        end
    end
end
D.bf_images.freqbands=freqbands;
D.bf_images.timeranges=timeranges;
D.bf_images.imesh=spm_mesh_inflate(D.bf_images.mesh);
D.bf_images.coords=bf.sources.pos;
save(D)
% delete(fullfile(D.path,'BF.mat'));
close all
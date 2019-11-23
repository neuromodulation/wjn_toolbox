function wjn_meg_source_power(filename,freqranges,timeranges,conds,outname,type)

if ~exist('type','var')
    type = 'lcmv';
end

[fdir,fname,ext] = fileparts(filename);


D=wjn_sl(filename)
if ~exist('conds','var') || (exist('conds','var') && isempty(conds))
    conds = D.condlist;
else
    conds = channel_finder(conds,D.condlist);
end

% keyboard

for a = 1:size(timeranges,1)
    for b = 1:size(freqranges,1)
        timerange = timeranges(a,:);
        freqrange = freqranges(b,:);
        if sum(abs(timerange))<50
            timerange = timerange.*1000;
            warning('changed timerange from second to millisecond scale:')
            disp(timerange)
        end

        matlabbatch{1}.spm.tools.beamforming.data.dir = {fdir};
        matlabbatch{1}.spm.tools.beamforming.data.D = {filename};
        matlabbatch{1}.spm.tools.beamforming.data.val = 1;
        matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'inv';
        matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
        matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
        matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
        matlabbatch{2}.spm.tools.beamforming.sources.reduce_rank = [2 3];
        matlabbatch{2}.spm.tools.beamforming.sources.keep3d = 1;
        matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.resolution = 5;
        matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.space = 'MNI template';
        matlabbatch{2}.spm.tools.beamforming.sources.visualise = 0;

        if strcmp(type,'lcmv')
            outtype = 'uv_pow';
            matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{3}.spm.tools.beamforming.features.whatconditions.condlabel = conds;
            matlabbatch{3}.spm.tools.beamforming.features.woi = timerange;
            matlabbatch{3}.spm.tools.beamforming.features.modality = {'MEG'};
            matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
            matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.foi = freqrange;
            matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.taper = 'hanning';
            matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 5;
            matlabbatch{3}.spm.tools.beamforming.features.bootstrap = false;
            matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.orient = true;
            matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.keeplf = false;
            matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.whatconditions.condlabel = conds;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.sametrials = false;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.woi = timerange;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.foi = freqrange;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.logpower = false;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.result = 'bycondition';
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.modality = 'MEG';
            matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'all';
            matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
            matlabbatch{7}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.whatconditions.condlabel = conds;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.sametrials = false;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.woi = timerange;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.foi = freqrange;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.logpower = false;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.result = 'singleimage';
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_power.modality = 'MEG';
            matlabbatch{8}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{8}.spm.tools.beamforming.write.plugin.nifti.normalise = 'all';
            matlabbatch{8}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
        elseif strcmp(type,'dics') 
            outtype = 'dics_pow';
            matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{3}.spm.tools.beamforming.features.whatconditions.condlabel = conds;
            matlabbatch{3}.spm.tools.beamforming.features.woi = timerange;
            matlabbatch{3}.spm.tools.beamforming.features.modality = {'MEG'};
            matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
            matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.foi = freqrange;
            matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.taper = 'hanning';
            matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 5;
            matlabbatch{3}.spm.tools.beamforming.features.bootstrap = false;
            matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{4}.spm.tools.beamforming.inverse.plugin.dics.fixedori = 'yes';
            matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.power = 1;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.powmethod = 'lambda1';
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.condlabel = conds;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.sametrials = false;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.woi = timerange;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.logpower = false;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.foi = freqrange;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'bycondition';
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.scale = 1;
            matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
            matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'all';
            matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
            matlabbatch{7}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.reference.power = 1;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.powmethod = 'lambda1';
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.condlabel = conds;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.sametrials = false;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.woi = timerange;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.logpower = false;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.foi = freqrange;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.result = 'singleimage';
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.scale = 1;
            matlabbatch{7}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
            matlabbatch{8}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
            matlabbatch{8}.spm.tools.beamforming.write.plugin.nifti.normalise = 'all';
            matlabbatch{8}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
        end


        spm_jobman('run',matlabbatch)

        oname = D.fname;
        sname = strsplit(oname,'spmeeg');
        if ~exist('outname','var') || (exist('outname','var') && isempty(outname))
            fname = [ 'f_' num2str(freqrange(1)) '-' num2str(freqrange(2)) '_t_' num2str(timerange(1)) '-' num2str(timerange(2)) '_' type '_'];
        else
            fname = ['f_' num2str(freqrange(1)) '-' num2str(freqrange(2)) '_t_' num2str(timerange(1)) '-' num2str(timerange(2)) '_' outname '_' type '_'];
        end

        for c = 1:length(conds)
            ofile = [outtype '_cond_' conds{c} '_' oname(1:end-4) '.nii'];
            sfile = wjn_nii_smooth(ofile,[12 12 12]);
            movefile(sfile,[conds{c} '_' fname sname{end}(1:end-4) '.nii'],'f');
            delete(ofile);
        end
        ofile = [outtype '_' oname(1:end-4) '.nii'];
        sfile = wjn_nii_smooth(ofile,[12 12 12]);
        movefile(sfile,['mean_' fname sname{end}(1:end-4) '.nii'],'f')
        pause(1)
        delete(ofile)
        delete BF.mat
        clear matlabbatch
    end
end

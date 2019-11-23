function imagefiles = source_coherence(folder,file,refchans,freqranges,condition,nshuffle,normalisation)
% 
root = cd;
% source_coherence(folder,file,refchans,freqranges,condition,nshuffle)
D=spm_eeg_load(file);
if ~iscell(refchans);
    refchans = cellstr(refchans);
end
if ~exist('normalisation','var')
    normalisation = 1;
end

if ~exist(folder,'dir')
    mkdir(folder);
end

[mf,dbf,sys]=getsystem;
imagefiles = {};
[ff,fname,ext]=fileparts(file);
fw = freqranges;
for a=1:numel(refchans);
    for b = 1:size(fw,1);
%         pause(1)
        cd(folder);
        dirname = [refchans{a} '_' num2str(fw(b,1)) '_' num2str(fw(b,2))];
%         pause(1)
        if ~exist(dirname,'dir')
        mkdir(dirname);
        end
%         pause(1)
        matlabbatch{1}.spm.tools.beamforming.data.dir = {[cd '\' dirname]};
        matlabbatch{1}.spm.tools.beamforming.data.D = {fullfile(D.path,D.fname)};
        matlabbatch{1}.spm.tools.beamforming.data.val = 1;
        matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'sensors';
        matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
        matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
        matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
        matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.resolution = 10;
        matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.space = 'MNI template';
        matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
        matlabbatch{3}.spm.tools.beamforming.features.whatconditions.condlabel = {condition};
        matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];
        matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.foi = fw(b,:);
        matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.taper = 'dpss';
        matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.keepreal = 0;
        matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.hanning = 1;
        matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 0.01;
        matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
        matlabbatch{4}.spm.tools.beamforming.inverse.plugin.dics.fixedori = 'yes';
     for shuffle = 0:nshuffle;
            if shuffle
                Q = fullfile(folder,dirname,['m_' condition '_dics_refcoh_shuffled_' fname '_' num2str(shuffle) '.nii']);
                if ~exist(fullfile(folder,dirname,['sm_' condition '_dics_refcoh_shuffled_' fname '_' num2str(shuffle) '.nii']),'file')
                matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.name = refchans{a};
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.shuffle = 1;
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.condlabel = {condition};
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.woi = [-Inf Inf];
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.foi = fw(b,:);
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
             
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'singleimage';

                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.scale = 'no';
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
                matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
                if normalisation
                    matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'separate';
                else
                    matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'no';
                end
                matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
                tic
                spm_jobman('run',matlabbatch);
                toc
                
                %% rename shuffled file
                movefile(fullfile(folder,dirname,['dics_refcoh_shuffled_' fname '.nii']),fullfile(folder,dirname,[condition '_dics_refcoh_shuffled_' fname '_' num2str(shuffle) '.nii']))
                disp(['dics_refcoh_shuffled_' fname '.nii'])
                %% mask Source coherence from EEG Template
                Vi = {fullfile(folder,dirname,[condition '_dics_refcoh_shuffled_' fname '_' num2str(shuffle) '.nii']);...
                    fullfile(spm('dir'),'EEGtemplates','iskull.nii')};
                Vo = fullfile(folder,dirname,['m_' condition '_dics_refcoh_shuffled_' fname '_' num2str(shuffle) '.nii']);
                fcalc = 'i1.*(i2>1)';
                spm_imcalc(Vi,Vo,fcalc)
                end
                %% smooth
                P = fullfile(folder,dirname,['m_' condition '_dics_refcoh_shuffled_' fname '_' num2str(shuffle) '.nii']);
                Q = fullfile(folder,dirname,['sm_' condition '_dics_refcoh_shuffled_' fname '_' num2str(shuffle) '.nii']);
                spm_smooth(P,Q,[16 16 16]);
                disp(['sm_' condition '_dics_refcoh_shuffled_' fname '_' num2str(shuffle) '.nii'])
                sfname{shuffle} = Q;
            else
                Q = fullfile(folder,dirname,['m_' condition '_dics_refcoh_' fname '.nii']);
                if ~exist(fullfile(folder,dirname,['sm_' condition '_dics_refcoh_' fname '.nii']),'file')
                matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.name = refchans{a};
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.shuffle = 0;
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.condlabel = {condition};
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.woi = [-Inf Inf];
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.foi = fw(b,:);
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'singleimage';
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.scale = 'no';
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
                matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
                if normalisation
                    matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'separate';
                else
                    matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'no';
                end
                matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
                tic
                spm_jobman('run',matlabbatch);
                toc
               %% mask Source coherence from EEG Template
                 Vi =[];Vo=[];
                 oname = fullfile(folder,dirname,['dics_refcoh_' fname '.nii']);
                 disp(['dics_refcoh_' fname '.nii'])
                 nname = fullfile(folder,dirname,[condition '_dics_refcoh_' fname '.nii']);
                 movefile(oname,nname)
                Vi = {nname;...
                    fullfile(spm('dir'),'EEGtemplates','iskull.nii')};
                Vo = fullfile(folder,dirname,['m_' condition '_dics_refcoh_' fname '.nii']);
                f = 'i1.*(i2>1)';
                spm_imcalc(Vi,Vo,f)
              
                end
                %% Smooth
                P = fullfile(folder,dirname,['m_' condition '_dics_refcoh_' fname '.nii']);
                Q = fullfile(folder,dirname,['sm_' condition '_dics_refcoh_' fname '.nii']);
                spm_smooth(P,Q,[16 16 16]);
                
                ofname = Q;
                disp(['sm_' condition '_dics_refcoh_' fname '.nii'])
            end
        end
        clear matlabbatch
        
        %% stats
        if nshuffle(1)>= 5 
        clear matlabbatch
            delete(fullfile(folder,dirname,'SPM.mat'))
            mf = getsystem;
            load(fullfile(mf,'meg_toolbox', 'cohimage_ttest_job.mat'));
             spm_jobman('initcfg')
            matlabbatch{1}.spm.stats.factorial_design.dir{1} = [folder '\' dirname];

            matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = {ofname};
         
            matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = sfname';
            matlabbatch{1}.spm.stats.factorial_design.masking.em = {fullfile(spm('dir'),'EEGtemplates','iskull.nii')};
            spm_jobman('serial', matlabbatch);
           
            clear matlabbatch
           get_results(fullfile(folder,dirname,'SPM.mat'),fname,0.01,'FWE',100);
           get_results(fullfile(folder,dirname,'SPM.mat'),fname,0.01,'FWE',0);
           get_results(fullfile(folder,dirname,'SPM.mat'),fname,0.05,'FWE',100);
           [dpeaks,table] = get_results(fullfile(folder,dirname,'SPM.mat'),fname,0.05,'FWE',0);
           save(['table_' condition '_' fname '.mat'],'table','dpeaks') 

        end
       
            imagefiles = [imagefiles ofname sfname];
      end
end
pause(1)
cd(root);
% imagefiles = [ofname sfname]
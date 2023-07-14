addpath C:\code\wjn_toolbox
addpath C:\code\spm12
spm('defaults','eeg')
clear all, close all, clc


meg_path = cd;
meg_file=  'ber009_StimOFF_rest_run-01.con';
mri_file = 'raw_anat_t1.nii';
mrk_file = 'ber009_StimOFF_rest_run-01.mrk'; % one file per recording
sfp_file = 'ber009_trr295_corr2.sfp'; % one file per patient
mri_nas_lpa_rpa = [0.0 63.9 -10.2; -79.9 -25.3 -10.2; 80.0 -32.4 -8.0];
D=wjn_meg_import_ricoh_zebris(meg_file,mrk_file,sfp_file,mri_file,mri_nas_lpa_rpa);

%% Check signals, remove bad segments, mark bad channels and apply TSSS

% Run this to check for artifacts - CLOSE WITH 'Q' TO SEE THE TIMES
% cfg = [];cfg.resamplefs=256; data = ft_resampledata(cfg,D.ftraw(D.indchantype('MEG')))
% cfg = []; cfg.viewmode = 'vertical';cfg.blocksize = 30; cfg.ylim=[-2500 2500];cfg = ft_databrowser(cfg, data);
% disp(D.time(round(cfg.artfctdef.visual.artifact.*D.fsample/256)))

bad_segments = [  32.4700   34.6033
    51.8067   55.9967
    108.1333  137.5300
    167.1333  172.1267
    216.4900  226.4267
    312.9600  326.1800];
D=wjn_remove_bad_time_segments(D.fullfile,bad_segments);

% Use SPM viewer to identify bad channels and write them down below: spm_eeg_review(D)

bad_channels = {'AG028','AG075','AG088','AG094'};
D = badchannels(D,D.indchannel(bad_channels),1);
save(D)

% Run TSSS
% S = [];S.D = D;S.magscale   = 100;
% S.tsss       = 1;S.t_window   = 5;S.xspace     = 0;
% D = tsss_spm_enm(S);D = badchannels(D, D.indchantype('MEGANY'), 0);save(D);

%% Filter and downsample the clean data

D=wjn_filter(D.fullfile,1,'high'); Df=D;
D=wjn_filter(D.fullfile,48,'low'); Df.delete();Df=D;
D=wjn_filter(D.fullfile,[45 55],'stop'); Df.delete();Df=D;
D=wjn_filter(D.fullfile,[95 105],'stop'); Df.delete();Df=D;
D=wjn_filter(D.fullfile,[145 155],'stop'); Df.delete();Df=D;
D=wjn_filter(D.fullfile,[125 135],'stop'); Df.delete();Df=D;
S.D=D.fullfile; S.fsample_new = 300; D=spm_eeg_downsample(S);

%% Run Source extraction and wavelet analysis
label = {'RightMotorCortex', 'LeftMotorCortex', 'SMA', 'preSMA', 'RightCerebellum', 'LeftCerebellum'};
mni =[ 37 -25   64; -37  -25   62; -2  -10   59 ; 2   30  48 ;  26.5  -62  -39 ; -26.5  -62  -39];

if exist('BF.mat','file'); delete('BF.mat'); end

Ds=wjn_meg_source_extraction(D.fullfile,mni,label);
Dtf = wjn_tf_wavelet(Ds.fullfile,1:100,50);

figure
plot(Dtf.frequencies,squeeze(nanmean(Dtf(:,:,:,1),3)),'linewidth',1)
legend(Dtf.chanlabels); title(strrep(Dtf.fname,'_',''))
figone(7); xlabel('Frequency [Hz]'); ylabel('Power spectral density')

%% Run Source imaging
freqbands =[3 7;3 12;8 12;13 20;20 35;13 35];
freqs = {'theta','lowfreq','alpha','lowbeta','highbeta','beta'};

D=wjn_epoch(D.fullfile,1000/300,'rest');

for a=1:size(freqbands,1)
    if exist('BF.mat','file')
        delete('BF.mat')
    end
    matlabbatch=[];
    matlabbatch{1}.spm.tools.beamforming.data.dir = {cd};
    matlabbatch{1}.spm.tools.beamforming.data.D = {D.fullfile};
    matlabbatch{1}.spm.tools.beamforming.data.val = 1;
    matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'inv';
    matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
    matlabbatch{1}.spm.tools.beamforming.data.overwrite = 0;
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
    matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.foi = freqbands(a,:);
    matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.taper = 'dpss';
    matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.keepreal = 0;
    matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.hanning = 1;
    matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 5;
    matlabbatch{3}.spm.tools.beamforming.features.bootstrap = false;
    matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.orient = true;
    matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.keeplf = false;
    matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.power = 1;
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.powmethod = 'lambda1';
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.all = 1;
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.sametrials = false;
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.woi = [-Inf Inf];
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.logpower = false;
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.foi =  freqbands(a,:);
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'singleimage';
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.scale = 'yes';
    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
    matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'no';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
    spm_jobman('run',matlabbatch)
    fname = D.fname;
    movefile(['dics_pow_' fname(1:end-4) '.nii' ],['dics_' freqs{a} '_' fname(1:end-4) '.nii' ])

end
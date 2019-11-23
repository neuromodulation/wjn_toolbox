function dbs_meg_task_source(initials, drug, task, prefix)

druglbl = {'off', 'on'};

try
    [files, seq, root, details] = dbs_subjects(initials, drug);
catch
    return;
end

if nargin<5
    prefix = '';
end

files = spm_select('FPList','.', ['^' prefix initials '_' druglbl{drug+1} '_' task '.*.mat']);

try
    cd(fullfile(root, 'SPMtask'));
    files = spm_select('FPList','.', ['^' prefix initials '_' druglbl{drug+1} '_' task '.*.mat']);
    files(1, :);
catch
    D = dbs_meg_extraction_prepare_spm12(initials, drug, task);
    cd(fullfile(root, 'SPMtask'));
    files = spm_select('FPList','.', ['^' prefix initials '_' druglbl{drug+1} '_' task '.*.mat']);
end

res = mkdir('BF');

%%
for f = 1:size(files, 1)
    clear matlabbatch
    
    D = spm_eeg_load(deblank(files(f, :)));
    
    matlabbatch{1}.spm.tools.beamforming.data.dir = {fullfile(D.path, 'BF')};
    matlabbatch{1}.spm.tools.beamforming.data.D = {fullfile(D)};
    
    matlabbatch{1}.spm.tools.beamforming.data.val = 1;
    matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'inv';
    matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
    matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
    matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{2}.spm.tools.beamforming.sources.reduce_rank = [2 3];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(1).label = 'preSMA';
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(1).pos = [2 30 48];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(1).ori = [0 0 0];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(2).label = 'leftIFG';
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(2).pos = [-42 26 14];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(2).ori = [0 0 0];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(3).label = 'rightIFG';
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(3).pos = [42 26 14];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(3).ori = [0 0 0];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(4).label = 'SMA';
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(4).pos = [-2 -10 59];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(4).ori = [0 0 0];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(5).label = 'leftM1';
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(5).pos = [-37 -25 62];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(5).ori = [0 0 0];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(6).label = 'rightM1';
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(6).pos = [37 -25 62];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(6).ori = [0 0 0];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.radius = 15;
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.resolution = 5;
    matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{3}.spm.tools.beamforming.features.whatconditions.all = 1;
    matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];
    matlabbatch{3}.spm.tools.beamforming.features.modality = {'MEG'};
    matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
    matlabbatch{3}.spm.tools.beamforming.features.plugin.contcov = struct([]);
    matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 0.01;
    matlabbatch{3}.spm.tools.beamforming.features.bootstrap = false;
    matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.keeplf = true;
    matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.orient = true;
    matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{5}.spm.tools.beamforming.output.plugin.sourcedata_robust.method = 'max';
    matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.mode = 'write';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.modality = 'MEG';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{1}.type = 'LFP';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{2}.type = 'EMG';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{3}.type = 'EOG';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{4}.chan = 'event';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.prefix = 'B';
    matlabbatch{7}.spm.meeg.preproc.artefact.D(1) = cfg_dep('Write: Output files', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{7}.spm.meeg.preproc.artefact.mode = 'mark';
    matlabbatch{7}.spm.meeg.preproc.artefact.badchanthresh = 1;
    matlabbatch{7}.spm.meeg.preproc.artefact.append = false;
    matlabbatch{7}.spm.meeg.preproc.artefact.methods(1).channels{1}.type = 'LFP';
    matlabbatch{7}.spm.meeg.preproc.artefact.methods(1).fun.zscore.threshold = 5;
    matlabbatch{7}.spm.meeg.preproc.artefact.methods(1).fun.zscore.excwin = 500;
    matlabbatch{7}.spm.meeg.preproc.artefact.prefix = 'a';
    
    spm_jobman('run', matlabbatch);
    
    Ds = spm_eeg_load(fullfile(D.path, 'BF', ['aB' D.fname]));
    %%
    clear matlabbatch;
    
    matlabbatch{1}.spm.meeg.preproc.artefact.D = {fullfile(Ds)};
    matlabbatch{1}.spm.meeg.preproc.artefact.mode = 'mark';
    matlabbatch{1}.spm.meeg.preproc.artefact.badchanthresh = 1;
    matlabbatch{1}.spm.meeg.preproc.artefact.append = false;
    matlabbatch{1}.spm.meeg.preproc.artefact.methods.channels{1}.type = 'LFP';
    matlabbatch{1}.spm.meeg.preproc.artefact.methods.fun.zscorediff.threshold = 10;
    matlabbatch{1}.spm.meeg.preproc.artefact.methods.fun.zscorediff.excwin = 500;
    matlabbatch{1}.spm.meeg.preproc.artefact.prefix = 'a';
    matlabbatch{2}.spm.meeg.preproc.filter.D(1) = cfg_dep('Artefact detection: Artefact-detected Datafile', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
    matlabbatch{2}.spm.meeg.preproc.filter.type = 'butterworth';
    matlabbatch{2}.spm.meeg.preproc.filter.band = 'stop';
    matlabbatch{2}.spm.meeg.preproc.filter.freq = [48 52];
    matlabbatch{2}.spm.meeg.preproc.filter.dir = 'twopass';
    matlabbatch{2}.spm.meeg.preproc.filter.order = 5;
    matlabbatch{2}.spm.meeg.preproc.filter.prefix = 'f';
    matlabbatch{3}.spm.meeg.preproc.filter.D(1) = cfg_dep('Filter: Filtered Datafile', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
    matlabbatch{3}.spm.meeg.preproc.filter.type = 'butterworth';
    matlabbatch{3}.spm.meeg.preproc.filter.band = 'stop';
    matlabbatch{3}.spm.meeg.preproc.filter.freq = [98 102];
    matlabbatch{3}.spm.meeg.preproc.filter.dir = 'twopass';
    matlabbatch{3}.spm.meeg.preproc.filter.order = 5;
    matlabbatch{3}.spm.meeg.preproc.filter.prefix = 'f';
    matlabbatch{4}.spm.meeg.preproc.filter.D(1) = cfg_dep('Filter: Filtered Datafile', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
    matlabbatch{4}.spm.meeg.preproc.filter.type = 'butterworth';
    matlabbatch{4}.spm.meeg.preproc.filter.band = 'stop';
    matlabbatch{4}.spm.meeg.preproc.filter.freq = [148 152];
    matlabbatch{4}.spm.meeg.preproc.filter.dir = 'twopass';
    matlabbatch{4}.spm.meeg.preproc.filter.order = 5;
    matlabbatch{4}.spm.meeg.preproc.filter.prefix = 'f';
    matlabbatch{5}.spm.meeg.preproc.filter.D(1) = cfg_dep('Filter: Filtered Datafile', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
    matlabbatch{5}.spm.meeg.preproc.filter.type = 'butterworth';
    matlabbatch{5}.spm.meeg.preproc.filter.band = 'stop';
    matlabbatch{5}.spm.meeg.preproc.filter.freq = [198 202];
    matlabbatch{5}.spm.meeg.preproc.filter.dir = 'twopass';
    matlabbatch{5}.spm.meeg.preproc.filter.order = 5;
    matlabbatch{5}.spm.meeg.preproc.filter.prefix = 'f';
    matlabbatch{6}.spm.meeg.tf.tf.D(1) = cfg_dep('Filter: Filtered Datafile', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
    matlabbatch{6}.spm.meeg.tf.tf.channels{1}.type = 'LFP';
    matlabbatch{6}.spm.meeg.tf.tf.channels{2}.chan = 'event';
    matlabbatch{6}.spm.meeg.tf.tf.frequencies = [2.5 5 7.5 10 12.5 15 17.5 20 22.5 25 27.5 30 32.5 35 37.5 40 42.5 45 47.5 50 52.5 55 57.5 60 62.5 65 67.5 70 72.5 75 77.5 80 82.5 85 87.5 90 92.5 95 97.5 100];
    matlabbatch{6}.spm.meeg.tf.tf.timewin = [-Inf Inf];
    matlabbatch{6}.spm.meeg.tf.tf.method.mtmconvol.taper = 'dpss';
    matlabbatch{6}.spm.meeg.tf.tf.method.mtmconvol.timeres = 400;
    matlabbatch{6}.spm.meeg.tf.tf.method.mtmconvol.timestep = 50;
    matlabbatch{6}.spm.meeg.tf.tf.method.mtmconvol.freqres = [2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.75 3 3.25 3.5 3.75 4 4.25 4.5 4.75 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5];
    matlabbatch{6}.spm.meeg.tf.tf.phase = 0;
    matlabbatch{6}.spm.meeg.tf.tf.prefix = '';
    matlabbatch{7}.spm.meeg.tf.rescale.D(1) = cfg_dep('Time-frequency analysis: M/EEG time-frequency power dataset', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dtfname'));
    matlabbatch{7}.spm.meeg.tf.rescale.method.Log = 1;
    matlabbatch{7}.spm.meeg.tf.rescale.prefix = 'r';
    matlabbatch{8}.spm.meeg.preproc.filter.D(1) = cfg_dep('Time-frequency rescale: Rescaled TF Datafile', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
    matlabbatch{8}.spm.meeg.preproc.filter.type = 'butterworth';
    matlabbatch{8}.spm.meeg.preproc.filter.band = 'high';
    matlabbatch{8}.spm.meeg.preproc.filter.freq = 0.5;
    matlabbatch{8}.spm.meeg.preproc.filter.dir = 'twopass';
    matlabbatch{8}.spm.meeg.preproc.filter.order = 5;
    matlabbatch{8}.spm.meeg.preproc.filter.prefix = 'f';
    
    spm_jobman('run', matlabbatch);                
    
    Dtf = spm_eeg_load(fullfile(D.path, 'BF', ['frtf_ffffaaB' D.fname]));
    
    clear matlabbatch;
    
    matlabbatch{1}.spm.meeg.preproc.epoch.D = {fullfile(Dtf)};   
    matlabbatch{1}.spm.meeg.preproc.epoch.bc = 0;
    matlabbatch{1}.spm.meeg.preproc.epoch.eventpadding = 0;
    matlabbatch{1}.spm.meeg.preproc.epoch.prefix = 'e';  
    
    switch task
        case 'SM'
            dop = {'OFF', 'ON'};
            
            P={};
            P.subject  = initials;
            P.dopastat = drug+1;
            P.dopamine = dop{P.dopastat};
            P.files    = files;
            P.epochout = 1;%make trl file
            P.pre = 500;
            P.post = 1500;
            S = [];
            S.dataset=fullfile(Dtf);
            S.f=f;%session/file number
            
            experiment = 4;
            [onsets, names, durations, pmod, eventdesign, epoch] = cont_trialfun_PDpresma_4spm_berlin(S, experiment, P);
            
            
            %%
            trl = cat(1, epoch(:).trl);
            conditionlabels = cat(1, epoch(:).labels);
            
            save(['trl' num2str(f) '.mat'], 'trl', 'conditionlabels');
            
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.trlfile = {fullfile(Dtf.path, ['trl' num2str(f) '.mat'])};
        case 'STOP'
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.timewin = [-2000 2000];
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).conditionlabel = 'R';
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).eventtype = 'EEG159';
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).eventvalue = 10;
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(1).trlshift = 0;
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).conditionlabel = 'L';
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).eventtype = 'EEG160';
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).eventvalue = 10;
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.define.trialdef(2).trlshift = 0;
    end
    
    spm_jobman('run', matlabbatch);
end
%%
clear matlabbatch
matlabbatch{1}.spm.meeg.preproc.merge.D = cellstr(spm_select('FPList','.', ['^efr.*' prefix initials '_' druglbl{drug+1} '_' task '.*.mat']));
matlabbatch{1}.spm.meeg.preproc.merge.recode.file = '.*';
matlabbatch{1}.spm.meeg.preproc.merge.recode.labelorg = '.*';
matlabbatch{1}.spm.meeg.preproc.merge.recode.labelnew = '#labelorg#';
matlabbatch{1}.spm.meeg.preproc.merge.prefix = 'c';
matlabbatch{2}.spm.meeg.averaging.average.D(1) = cfg_dep('Merging: Merged Datafile', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.ks = 5;
matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.bycondition = false;
matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.savew = false;
matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.removebad = true;
matlabbatch{2}.spm.meeg.averaging.average.plv = false;
matlabbatch{2}.spm.meeg.averaging.average.prefix = 'm';

spm_jobman('run', matlabbatch);

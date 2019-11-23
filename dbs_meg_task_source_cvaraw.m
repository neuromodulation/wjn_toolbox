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


keep = 0;
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
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(7).label = 'leftTP';
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(7).pos = [-38 -32 12];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(7).ori = [0 0 0];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(8).label = 'rightTP';
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(8).pos = [38 -32 12];
    matlabbatch{2}.spm.tools.beamforming.sources.plugin.voi.voidef(8).ori = [0 0 0];    
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
    matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.orient = false;
    matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{5}.spm.tools.beamforming.output.plugin.sourcedata_robust.method = 'keep';
    matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.mode = 'write';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.modality = 'MEG';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{1}.type = 'LFP';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{2}.type = 'EMG';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{3}.type = 'EOG';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.addchannels.channels{4}.chan = 'event';
    matlabbatch{6}.spm.tools.beamforming.write.plugin.spmeeg.prefix = 'B';
    
    spm_jobman('run', matlabbatch);
    
    Ds = spm_eeg_load(fullfile(D.path, 'BF', ['B' D.fname]));
    %%
    
    S = [];
    S.D = Ds;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [48 52];
    S.dir = 'twopass';
    S.order = 5;
    S.prefix = 'f';
    Ds = spm_eeg_filter(S);
    
    
    S = [];
    S.D = Ds;
    S.prefix = 'R';
    S.channels = {
        'regexp_^STN'
        'regexp_^EMG'
        'regexp_EOG'
        'event'
        }';
    S.method = 'cva';
    S.settings.chanset(1).cvachan.channels{1}.regexp = '^preSMA';
    S.settings.chanset(1).refchan.channels{1}.regexp = '^STN';
    S.settings.chanset(1).ncomp = 1;
    S.settings.chanset(1).outlabel = 'preSMA';
    S.settings.chanset(1).foi = [2 90];
    S.settings.chanset(1).tshiftwin = [-60 60];
    S.settings.chanset(1).tshiftres = 20;
    S.settings.chanset(2).cvachan.channels{1}.regexp = '^leftIFG';
    S.settings.chanset(2).refchan.channels{1}.regexp = '^STN';
    S.settings.chanset(2).ncomp = 1;
    S.settings.chanset(2).outlabel = 'leftIFG';
    S.settings.chanset(2).foi = [2 90];
    S.settings.chanset(2).tshiftwin = [-60 60];
    S.settings.chanset(2).tshiftres = 20;
    S.settings.chanset(3).cvachan.channels{1}.regexp = '^rightIFG';
    S.settings.chanset(3).refchan.channels{1}.regexp = '^STN';
    S.settings.chanset(3).ncomp = 1;
    S.settings.chanset(3).outlabel = 'rightIFG';
    S.settings.chanset(3).foi = [2 90];
    S.settings.chanset(3).tshiftwin = [-60 60];
    S.settings.chanset(3).tshiftres = 20;
    S.settings.chanset(4).cvachan.channels{1}.regexp = '^SMA';
    S.settings.chanset(4).refchan.channels{1}.regexp = '^STN';
    S.settings.chanset(4).ncomp = 1;
    S.settings.chanset(4).outlabel = 'SMA';
    S.settings.chanset(4).foi = [2 90];
    S.settings.chanset(4).tshiftwin = [-60 60];
    S.settings.chanset(4).tshiftres = 20;
    S.settings.chanset(5).cvachan.channels{1}.regexp = '^leftM1';
    S.settings.chanset(5).refchan.channels{1}.regexp = '^STN';
    S.settings.chanset(5).ncomp = 1;
    S.settings.chanset(5).outlabel = 'leftM1';
    S.settings.chanset(5).foi = [2 90];
    S.settings.chanset(5).tshiftwin = [-60 60];
    S.settings.chanset(5).tshiftres = 20;
    S.settings.chanset(6).cvachan.channels{1}.regexp = '^rightM1';
    S.settings.chanset(6).refchan.channels{1}.regexp = '^STN';
    S.settings.chanset(6).ncomp = 1;
    S.settings.chanset(6).outlabel = 'rightM1';
    S.settings.chanset(6).foi = [2 90];
    S.settings.chanset(6).tshiftwin = [-60 60];
    S.settings.chanset(6).tshiftres = 20;
    S.keepothers = false;
    S.conditions.all = 1;
    S.timewin = [-Inf Inf];
    Ds = spm_eeg_reduce(S);
            
    if ~keep, delete(S.D); end;
    
    S = [];   
    S.prefix = 'R';
    S.channels = {
        'preSMA'
        'leftIFG'
        'rightIFG'
        'SMA'   
        'leftM1'
        'rightM1'
        'leftTP'
        'rightTP'
        'regexp_^EMG'
        'regexp_EOG'
        'event'
        }';
    S.method = 'cva';
    k = 1;
    Lind = Ds.selectchannels('regexp_^STN_L');
    if length(Lind)>1
        S.settings.chanset(k).cvachan.channels{1}.regexp = '^STN_L';
        S.settings.chanset(k).refchan.channels{1}.chan = 'preSMA';
        S.settings.chanset(k).refchan.channels{2}.chan = 'leftIFG';
        S.settings.chanset(k).refchan.channels{3}.chan = 'rightIFG';        
        S.settings.chanset(k).refchan.channels{4}.chan = 'SMA';
        S.settings.chanset(k).refchan.channels{5}.chan = 'leftM1';
        S.settings.chanset(k).refchan.channels{6}.chan = 'rightM1';
        S.settings.chanset(k).refchan.channels{7}.chan = 'leftTP';
        S.settings.chanset(k).refchan.channels{8}.chan = 'rightTP';
        S.settings.chanset(k).ncomp = 1;
        S.settings.chanset(k).outlabel = 'STN_L';
        S.settings.chanset(k).foi = [2 90];
        S.settings.chanset(k).tshiftwin = [-60 60];
        S.settings.chanset(k).tshiftres = 20;
        k = k+1;
    elseif length(Lind)==1
        Ds = chanlabels(Ds, Lind, 'STN_L');
        save(Ds);
    end
        
    Rind = Ds.selectchannels('regexp_^STN_R');
    if length(Rind)>1
        S.settings.chanset(k).cvachan.channels{1}.regexp = '^STN_R';
        S.settings.chanset(k).refchan.channels{1}.chan = 'preSMA';
        S.settings.chanset(k).refchan.channels{2}.chan = 'leftIFG';
        S.settings.chanset(k).refchan.channels{3}.chan = 'rightIFG';
        S.settings.chanset(k).refchan.channels{4}.chan = 'SMA';
        S.settings.chanset(k).refchan.channels{5}.chan = 'leftM1';
        S.settings.chanset(k).refchan.channels{6}.chan = 'rightM1';
        S.settings.chanset(k).refchan.channels{7}.chan = 'leftTP';
        S.settings.chanset(k).refchan.channels{8}.chan = 'rightTP';
        S.settings.chanset(k).ncomp = 1;
        S.settings.chanset(k).outlabel = 'STN_R';
        S.settings.chanset(k).foi = [2 90];
        S.settings.chanset(k).tshiftwin = [-60 60];
        S.settings.chanset(k).tshiftres = 20;
    elseif length(Rind)==1
        Ds = chanlabels(Ds, Rind, 'STN_R');
        save(Ds);
    end    
    S.keepothers = false;
    S.conditions.all = 1;
    S.timewin = [-Inf Inf];
    
    if isfield(S.settings, 'chanset')
        S.D = Ds;
        Ds = spm_eeg_reduce(S);
    else
        Ds = copy(Ds, spm_file(fullfile(Ds), 'prefix', 'R'));
    end
    
    if ~keep, delete(S.D); end;
    
    S = [];
    S.D = Ds;
    S.mode = 'mark';
    S.badchanthresh = 1;
    S.methods(1).channels = {'LFP'};
    S.methods(1).fun = 'zscorediff';
    S.methods(1).settings.threshold = 10;
    S.methods(1).settings.excwin = 500;
    S.methods(2).channels = {'LFP'};
    S.methods(2).fun = 'zscore';
    S.methods(2).settings.threshold = 5;
    S.methods(2).settings.excwin = 500;
    S.append = true;
    S.prefix = 'a';
    Ds = spm_eeg_artefact(S);
    
    if ~keep, delete(S.D); end;
    
    S = [];
    S.D = Ds;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [98 102];
    S.dir = 'twopass';
    S.order = 5;
    S.prefix = 'f';
    Ds = spm_eeg_filter(S);
    
    if ~keep, delete(S.D); end;
    
    S = [];
    S.D = Ds;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [148 152];
    S.dir = 'twopass';
    S.order = 5;
    S.prefix = 'f';
    Ds = spm_eeg_filter(S);
    
    if ~keep, delete(S.D); end;
    
    S = [];
    S.D = Ds;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [198 202];
    S.dir = 'twopass';
    S.order = 5;
    S.prefix = 'f';
    Ds = spm_eeg_filter(S);
    
    if ~keep, delete(S.D); end;
    
    S = [];
    S.D = Ds;
    S.channels = {
        'LFP'
        'event'
        }';
    S.frequencies = [2.5:2.5:100];
    S.timewin = [-Inf Inf];
    S.phase = 0;
    S.method = 'mtmconvol';
    S.settings.taper = 'dpss';
    S.settings.timeres = 400;
    S.settings.timestep = 50;
    S.settings.freqres = [2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.5 2.75 3 3.25 3.5 3.75 4 4.25 4.5 4.75 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5];
    S.prefix = '';
    Ds = spm_eeg_tf(S);
    
    
    S = [];
    S.D = Ds;
    S.method = 'Log';
    S.prefix = 'r';
    Ds = spm_eeg_tf_rescale(S);
    
    
    S = [];
    S.D = Ds;
    S.type = 'butterworth';
    S.band = 'high';
    S.freq = 0.5;
    S.dir = 'twopass';
    S.order = 5;
    S.prefix = 'f';
    Ds = spm_eeg_filter(S);
    
%%
    clear matlabbatch;
    
    matlabbatch{1}.spm.meeg.preproc.epoch.D = {fullfile(Ds)};
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
            S.dataset=fullfile(Ds);
            S.f=f;%session/file number
            
            experiment = 4;
            [onsets, names, durations, pmod, eventdesign, epoch] = cont_trialfun_PDpresma_4spm_berlin(S, experiment, P);
            
            
            
            trl = cat(1, epoch(:).trl);
            conditionlabels = cat(1, epoch(:).labels);
            
            save(['trl' num2str(f) '.mat'], 'trl', 'conditionlabels');
            
            matlabbatch{1}.spm.meeg.preproc.epoch.trialchoice.trlfile = {fullfile(Ds.path, ['trl' num2str(f) '.mat'])};
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

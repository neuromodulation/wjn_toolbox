function dbs_meg_spm_rest_cohimages12(initials, drug, prefix)

druglbl = {'off', 'on'};

try
    [files, seq, root, details] = dbs_subjects(initials, drug);
catch
    return;
end

if nargin<3
    prefix = '';
end

try
    D = spm_eeg_load(fullfile(root, 'SPMrest', [prefix initials '_' druglbl{drug+1} '.mat']));
catch
    D = dbs_meg_rest_prepare_spm12(initials, drug);
end

%D = dbs_meg_rest_prepare_spm12(initials, drug);

cd(fullfile(root, 'SPMrest'));

res = mkdir([prefix 'COH']);

cohroot = fullfile(root, 'SPMrest', [prefix 'COH']);

rand('twister',sum(100*clock));

chan = details.chan;

D = chantype(D, D.indchannel(chan), 'LFP');save(D);
%%
ranges = {[5 45], [55 600]};
rangeres = [2.5, 10];
rangelabels = {'low', 'high'};
%%
data = D.fttimelock(D.indchantype({'MEGGRAD', 'MEGMAG', 'LFP'}, 'GOOD'), ':', D.indtrial(D.condlist, 'GOOD'));

matlabbatch = {};
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Original>Shuffled';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 1;
matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.results.conspec.titlestr = 'Significant coherence';
matlabbatch{4}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{4}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{4}.spm.stats.results.conspec.thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec.extent = 100;
matlabbatch{4}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
matlabbatch{4}.spm.stats.results.units = 3;
matlabbatch{4}.spm.stats.results.print = false;
matlabbatch{4}.spm.stats.results.write.none = 1;



for r = 1:numel(chan)
    refchan = chan{r};

    res = mkdir(cohroot, refchan);

    for f = 1:numel(ranges)

        res = mkdir(fullfile(cohroot, refchan), rangelabels{f});

        
        timelock = data;


        for shuffle = 0:10 % Number of shufflings

            if shuffle
                refind = strmatch(refchan, timelock.label, 'exact');
                timelock.trial(:, refind, :) = ...
                    timelock.trial(randperm(size(timelock.trial, 1)), refind, :);
            end

            cfg = [];
            cfg.output ='powandcsd';
            
            if strncmp(initials, 'OX', 2)
                cfg.channelcmb={refchan, 'MEG*'};
            else
                cfg.channelcmb={refchan, 'MEG'};
            end
            
            cfg.keeptrials = 'no';
            cfg.keeptapers='no';
            cfg.taper = 'dpss';
            cfg.method          = 'mtmfft';
            cfg.foilim     = ranges{f};
            cfg.tapsmofrq = rangeres(f);

            inp = ft_freqanalysis(cfg, timelock);

            cfg = [];
            cfg.method  = 'coh';
            
            coh = ft_connectivityanalysis(cfg, inp);

            dummy=[];
            dummy.label   = coh.labelcmb(:, 2);
            dummy.trial   = {100*coh.cohspctrm};
            dummy.time    = {coh.freq./1000};
            dummy.fsample = 1000./mean(diff(coh.freq));

            cD = spm_eeg_ft2spm(dummy, fullfile(D.path, 'dummy.mat'));

            cD = sensors(cD, 'MEG', D.sensors('MEG'));
            
            cD = chantype(cD, ':', 'MEG');
            
            cD = units(cD, ':', 'fT');

            S = [];
            S.task = 'project3D';
            S.modality = 'MEG';
            S.updatehistory = 0;
            S.D = cD;

            cD = spm_eeg_prep(S);

            cD = type(cD, 'evoked');

            cD.save;

            S    = [];
            S.D  = cD;
            S.mode = 'scalp x time';
            
            spm_eeg_convert2images(S);

            if ~shuffle
                ofname = fullfile(cohroot, refchan, rangelabels{f}, 'original.nii');
                v = spm_vol(fullfile(cD.path, 'dummy', 'condition_Undefined.nii'));
                Y = ~isnan(spm_read_vols(v));
                
                v.fname = fullfile(cohroot, refchan, rangelabels{f}, 'cmask.nii');
                
                spm_write_vol(v, Y);              
            else
                ofname = fullfile(cohroot, refchan, rangelabels{f}, ['shuffled' num2str(shuffle) '.nii']);
            end

            spm_smooth(fullfile(cD.path, 'dummy', 'condition_Undefined.nii'),...
                ofname, [10 10 rangeres(f)]); % Smoothing paraneters

            rmdir(fullfile(D.path, 'dummy'), 's');
            delete(fullfile(D.path, 'dummy.mat'));
            delete(fullfile(D.path, 'dummy.dat'));

            matlabbatch{1}.spm.stats.factorial_design.dir{1} = fileparts(ofname);

            switch shuffle
                case 0
                    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = {ofname};
                case 1
                    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = {ofname};
                otherwise
                    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2{shuffle, 1} = ofname;
            end
        end
        matlabbatch{1}.spm.stats.factorial_design.masking.em{1} =  fullfile(cohroot, refchan, rangelabels{f}, 'cmask.nii');
        
        delete(fullfile(cohroot, refchan, rangelabels{f}, 'SPM.mat'));
        
        spm_jobman('run', matlabbatch);

        xSPM = evalin('base', 'xSPM');
        
        stat = zeros(xSPM.DIM');
        stat(sub2ind(xSPM.DIM', xSPM.XYZ(1,:)', xSPM.XYZ(2,:)', xSPM.XYZ(3,:)')) = xSPM.Z;
        stat = squeeze(stat);

        L = bwlabeln(stat);
        
        V = spm_vol(fullfile(cohroot, refchan, rangelabels{f}, 'spmT_0001.nii'));

        V.fname = fullfile(cohroot, refchan, rangelabels{f}, 'sigmask.nii');
        
        spm_write_vol(V, L);
        
        sigranges = [];
        for c = 1:max(L(:))
            cclust = squeeze(any(any(L==c)));
            sigranges = [sigranges; min(coh.freq(cclust)) max(coh.freq(cclust))];
        end

        save(fullfile(cohroot, refchan, rangelabels{f}, 'sigranges.mat'), 'sigranges');
    end
end

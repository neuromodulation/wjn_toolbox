% spm eeg
addpath C:\matlab\SPM12
dbsroot = 'C:\megdata\TB\';
% spm('eeg','defaults')

cd native\
%%
D = spm_eeg_load('cmTB.mat');

S=[];
S.D = D.fname;
S.outfile = ['RO' D.fname];
D=spm_eeg_copy(S);
D=badtrials(D,D.indtrial('RC'),1);
save(D);
S=[];
S.D = D.fname;
D=spm_eeg_remove_bad_trials(S);
save(D);
%%
rand('twister',sum(100*clock));

stnchans = {
    'LFP_R01';
    'LFP_R12';
    'LFP_R23';
% 'STN_R13'
% 'STN_L13'
    %      'HEOG'
    %      'VEOG'
    };

%%
ranges = {[5 45], [55 95]};
rangeres = [2.5, 7.5];
rangelabels = {'low', 'high'};
%%

res = mkdir(D.path, 'cohimages');

ind = D.pickconditions(D.condlist);
data = D.ftraw(0);
data.trial = data.trial(ind);
data.time =  data.time(ind);

magind = strmatch('MEGMAG', D.chantype);
if ~isempty(magind)
    for i = 1:numel(data.trial)
        data.trial{i}(magind, :) = [];
    end
    data.label(magind) = [];
end

for r = 1:numel(stnchans)
    refchan = stnchans{r};

    res = mkdir(fullfile(D.path, 'cohimages'), refchan);

    for f = 1:numel(ranges)

        res = mkdir(fullfile(D.path, 'cohimages', refchan), rangelabels{f});
        load(fullfile(dbsroot, 'cohimage_ttest_job.mat'));

        cfg = [];
        cfg.keeptrials = 'yes';
        timelock = ft_timelockanalysis(cfg, data);


        for shuffle = 0:10 % Number of shufflings

            if shuffle
                refind = strmatch(refchan, timelock.label, 'exact');
                timelock.trial(:, refind, :) = ...
                    timelock.trial(randperm(size(timelock.trial, 1)), refind, :);
            end

            cfg = [];
            cfg.output ='powandcsd';
            cfg.channelcmb={refchan, 'MEG'};
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
            dummy.trial   = {coh.cohspctrm};
            dummy.time    = {coh.freq./1000};
            dummy.fsample = 1000./mean(diff(coh.freq));

            cD = spm_eeg_ft2spm(dummy, fullfile(D.path, 'dummy.mat'));

            cD = sensors(cD, 'MEG', D.sensors('MEG'));
            
            cD = chantype(cD, [], 'MEG');
            
            cD = units(cD, [], 'fT');

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
            S.n  = 64;
            S.mode = 'scalp x time';
            S.interpolate_bad = 1;
            spm_eeg_convert2images(S);

            if ~shuffle
                ofname = fullfile(D.path, 'cohimages', refchan, rangelabels{f}, 'original.nii');
                spm_imcalc(fullfile(cD.path, 'dummy', 'Condition_Undefined.nii'),...
                    fullfile(D.path, 'cohimages', refchan, rangelabels{f}, 'cmask.nii'), '~isnan(i1)');
            else
                ofname = fullfile(D.path, 'cohimages', refchan, rangelabels{f}, ['shuffled' num2str(shuffle) '.nii']);
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
        matlabbatch{1}.spm.stats.factorial_design.masking.em{1} =  fullfile(D.path, 'cohimages', refchan, rangelabels{f}, 'cmask.nii');
        spm_jobman('serial', matlabbatch);

        stat = zeros(xSPM.DIM');
        stat(sub2ind(xSPM.DIM', xSPM.XYZ(1,:)', xSPM.XYZ(2,:)', xSPM.XYZ(3,:)')) = xSPM.Z;
        stat = squeeze(stat);

        L = bwlabeln(stat);
        
        V = spm_vol(fullfile(D.path, 'cohimages', refchan, rangelabels{f}, 'spmT_0001.img'));

        V.fname = fullfile(D.path, 'cohimages', refchan, rangelabels{f}, 'sigmask.nii');
        
        spm_write_vol(V, L);
        
        sigranges = [];
        for c = 1:max(L(:))
            cclust = squeeze(any(any(L==c)));
            sigranges = [sigranges; min(coh.freq(cclust)) max(coh.freq(cclust))];
        end

        save(fullfile(D.path, 'cohimages', refchan, rangelabels{f}, 'sigranges.mat'), 'sigranges');
    end
end

function sensor_level(folder,file,condition,lfpchans)
% function sensor_level(file,condition,lfpchans,headloc)
% headloc 1 or 0

% spm eeg
% addpath C:\matlab\SPM12
% dbsroot = 'C:\megdata\TB\';
spm('eeg','defaults');
%close all;
   global xSPM
% cd native\
%%
cd(folder);
D = spm_eeg_load(file);
% 
% S=[];
% S.D = D.fname;
% S.outfile = [condition D.fname];
% D=spm_eeg_copy(S);
% D=badtrials(D,1:D.ntrials,1);
% D=badtrials(D,D.indtrial(condition),0);
% save(D);
% S=[];
% S.D = D.fname;
% D=spm_eeg_remove_bad_trials(S);
% save(D);


%%
rand('twister',sum(100*clock));

% lfpchans= {
%     'LFP_R01';
%     'LFP_R12';
%     'LFP_R23';
% % 'STN_R13'
% % 'STN_L13'
%     %      'HEOG'
%     %      'VEOG'
%     };

%%
ranges = {[5 45], [55 95]};
rangeres = [2.5, 7.5];
rangelabels = {'low', 'high'};
%%

res = mkdir(folder, 'cohimages');
[junk,fname]=fileparts(file);

ind = D.indtrial(condition);
if strcmp(condition,'all');
    ind = 1:D.ntrials;
end
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

for r = 1:numel(lfpchans)
    refchan = lfpchans{r};

    res = mkdir(fullfile(folder, 'cohimages'), refchan);

    for f = 1:numel(ranges)
    
        res = mkdir(fullfile(folder, 'cohimages', refchan), rangelabels{f});
        load(fullfile('E:\Dropbox\matlab\meg_toolbox', 'cohimage_ttest_job.mat'));

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
            
            save(fullfile(folder,['cohfile_' refchan '_' rangelabels{f}]),'coh');
            
            dummy=[];
            dummy.label   = coh.labelcmb(:, 2);
            dummy.trial   = {coh.cohspctrm};
            dummy.time    = {coh.freq./1000};
            dummy.fsample = 1000./mean(diff(coh.freq));

            cD = spm_eeg_ft2spm(dummy, fullfile(folder, 'dummy.mat'));

            cD = sensors(cD, 'MEG', D.sensors('MEG'));
            
            cD = chantype(cD, '(:)', 'MEG');
            
            cD = units(cD, '(:)', 'fT');

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
                ofname = fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'original.nii');
                spm_imcalc(fullfile(folder, 'dummy', 'Condition_Undefined.nii'),...
                    fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'cmask.nii'), '~isnan(i1)');
            else
                ofname = fullfile(folder, 'cohimages', refchan, rangelabels{f}, ['shuffled' num2str(shuffle) '.nii']);
            end

            spm_smooth(fullfile(folder, 'dummy', 'condition_Undefined.nii'),...
                ofname, [10 10 rangeres(f)]); % Smoothing paraneters
            pause(5)
        
            
%             rmdir(fullfile(folder, 'dummy'), 's');
            delete(fullfile(folder,'dummy','*.*'))
            delete(fullfile(folder, 'dummy.mat'));
            delete(fullfile(folder, 'dummy.dat'));

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
        matlabbatch{1}.spm.stats.factorial_design.masking.em{1} =  fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'cmask.nii');
        if exist(fullfile(fileparts(ofname),'SPM.mat'),'file')
        delete(fullfile(fileparts(ofname),'SPM.mat'))
        end
        spm_jobman('serial', matlabbatch);
     
        stat = zeros(xSPM.DIM');
        stat(sub2ind(xSPM.DIM', xSPM.XYZ(1,:)', xSPM.XYZ(2,:)', xSPM.XYZ(3,:)')) = xSPM.Z;
        stat = squeeze(stat);

        L = bwlabeln(stat);
        
        V = spm_vol(fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'spmT_0001.nii'));

        V.fname = fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'sigmask.nii');
        
        spm_write_vol(V, L);
        
        sigranges = [];
        for c = 1:max(L(:))
            cclust = squeeze(any(any(L==c)));
            sigranges = [sigranges; min(coh.freq(cclust)) max(coh.freq(cclust))];
        end
            
        
        freqs = coh.freq;
         
        if f == 1;
       
        FWE01k100 = get_results_freqs(freqs,fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'SPM.mat'),fname,0.01,'FWE',100);
        pause(1)
        print(fullfile(folder,[refchan '_' rangelabels{f} '_FWE01k100.png']),'-dpng') 
        FWE01k0 = get_results_freqs(freqs,fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'SPM.mat'),fname,0.01,'FWE',0);
        pause(1)
        print(fullfile(folder,[refchan '_' rangelabels{f} '_FWE01k0.png']),'-dpng') 
        FWE05k100 = get_results_freqs(freqs,fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'SPM.mat'),fname,0.05,'FWE',100);
        pause(1)
        print(fullfile(folder,[refchan '_' rangelabels{f} '_FWE05k100.png']),'-dpng') 
        FWE05k0 = get_results_freqs(freqs,fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'SPM.mat'),fname,0.05,'FWE',0);
        pause(1)
        print(fullfile(folder,[refchan '_' rangelabels{f} '_FWE05k0.png']),'-dpng') 
        
        elseif f ==2;
        hFWE01k100 = get_results_freqs(freqs,fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'SPM.mat'),fname,0.01,'FWE',100);
        pause(1)
        print(fullfile(folder,[refchan '_' rangelabels{f} '_FWE01k100.png']),'-dpng') 
        hFWE01k0 = get_results_freqs(freqs,fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'SPM.mat'),fname,0.01,'FWE',0);
        pause(1)
        print(fullfile(folder,[refchan '_' rangelabels{f} '_FWE01k0.png']),'-dpng') 
        hFWE05k100 = get_results_freqs(freqs,fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'SPM.mat'),fname,0.05,'FWE',100);
        pause(1)
        print(fullfile(folder,[refchan '_' rangelabels{f} '_FWE05k100.png']),'-dpng') 
        hFWE05k0 = get_results_freqs(freqs,fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'SPM.mat'),fname,0.05,'FWE',0);
        pause(1)
        print(fullfile(folder,[refchan '_' rangelabels{f} '_FWE05k0.png']),'-dpng') 
        
        end
        save(fullfile(folder, 'cohimages', refchan, rangelabels{f}, 'sigranges.mat'),'sigranges','FWE01k100','FWE01k0','FWE05k100','FWE05k0');
 

    end
    
end

% save([fname '_sigrange.mat'],'sigrange');

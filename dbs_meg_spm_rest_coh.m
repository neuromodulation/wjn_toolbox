function dbs_meg_spm_rest_coh(initials, drug, prefix)

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

cd(fullfile(root, 'SPMrest'));

res = mkdir([prefix 'COH']);

cohroot = fullfile(root, 'SPMrest', [prefix 'COH']);


chan = details.chan;

%%
data = D.fttimelock(D.indchantype({'MEG', 'MEGPLANAR', 'LFP'}, 'GOOD'), ':', D.indtrial(D.condlist, 'GOOD'));


for r = 1:numel(chan)
    refchan = chan{r};
    
    res = mkdir(cohroot, refchan);
    
    cd(fullfile(cohroot, refchan));
    
    foi     = 2.5:2.5:600;
    fres    = 0*foi+2.5;
    fres(fres>25) = 0.1*fres(fres>25);
    fres(fres>50) = 5;
    
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
    cfg.foi     = foi;
    cfg.tapsmofrq = fres;
    
    inp = ft_freqanalysis(cfg, data);
    
    cfg = [];
    cfg.method  = 'coh';
    
    coh = ft_connectivityanalysis(cfg, inp);
    
    dummy=[];
    dummy.label   = coh.labelcmb(:, 2);
    dummy.trial   = {coh.cohspctrm};
    dummy.time    = {coh.freq./1000};
    dummy.fsample = 1000./mean(diff(coh.freq));
    
    cD = spm_eeg_ft2spm(dummy,  spm_file(D.fullfile, 'path', pwd,  'prefix', ['COH_' refchan '_']));
    
    cD = sensors(cD, 'MEG', D.sensors('MEG'));
    
    cD = chantype(cD, ':', D.chantype(D.indchannel(cD.chanlabels)));
    
    cD = units(cD, ':', 'fT');
    
    S = [];
    S.task = 'project3D';
    S.modality = 'MEG';
    S.updatehistory = 0;
    S.D = cD;
    
    cD = spm_eeg_prep(S);
    
    cD = type(cD, 'evoked');
    
    cD.save;
end
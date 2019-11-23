function wjn_eeg_vm_burst_pipeline(pp)


for pi = 1:length(pp)
    if iscell(pp)
        p = pp{pi};
    else
        p = pp;
    end
    
    wjn_vm_list('eegroot')
    keep p pi pp

    root = fullfile(mdf,'vm_eeg\',p.id,'raw');
    if ~exist(root,'dir')
        mkdir(root)
    end
    cd(root)
    
    taskfile = [p.task_eeg(1:end-4)];
    restfile = [p.rest_eeg(1:end-4)];
    
    D=spm_eeg_convert('N24HC_FS21092017_rest.eeg');
    D=wjn_common_average(D.fullfile,D.chanlabels(D.indchantype('EEG')),'FCz');
    D=wjn_filter(D.fullfile,[3 47]);
    D=wjn_downsample(D.fullfile,256);
    D=wjn_mne_autoreject(D.fullfile);

   
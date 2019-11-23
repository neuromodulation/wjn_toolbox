
root = 'E:\Dropbox\Motorneuroscience\vm_meg\STN-MEG01DB01-1-11-07-2017';
cd(root)

filename = 'plfp46.0200.con';
locaname = 'plfp46.before2-coregis.txt';

    keep filename root a locaname
    baseline = [-2500 -1500];
    rest_epoch = 1025/256;
    task_epoch = [-5 5];

 
    D=wjn_meg_import_ptb_con(filename,locaname);
    D=wjn_meg_vm_create_events(D.fullfile);
    D=wjn_epoch(D.fullfile,task_epoch,D.conditionlabels,D.trl,'e');
    D=wjn_meg_auto_artefacts(D.fullfile);
    D=wjn_eeg_vm_clean_trials(D.fullfile);
    D=wjn_eeg_vm_extract_behaviour(D.fullfile);
    tname = D.fullfile;
    D=wjn_meg_source_extraction(D.fullfile);
    source_task = D.fname;
    iD = wjn_induced(D.fullfile)
    % D=wjn_sl(source_task);
    D=wjn_tf_wavelet(D.fullfile,1:100,25);
    D=wjn_average(D.fullfile,1);
    Dd=wjn_tf_sep_baseline(D,baseline,'go');
    
    iD=wjn_tf_wavelet(iD.fullfile,1:100,25);
    iD=wjn_average(iD.fullfile,1);
    iDd=wjn_tf_sep_baseline(iD,baseline,'go');
    
    
    Dd=wjn_tf_sep_common_baseline(D.fullfile,baseline,'go');
    [Dticoh,Dtwpli]=wjn_tf_wavelet_coherence(source_task,wjn_eeg_vm_connectivity_combinations,1:100,25,1);
    Dcd=wjn_tf_sep_baseline(Dticoh.fullfile,baseline,'go');

    %% Time Frequency RT and V single trial correlations
    else
        source_task = ffind('Brbr*.mat',0)
    end
    D=wjn_sl(['tf_' source_task]);
    D=wjn_tf_corr(D.fullfile,'rt',D.rt,'move','spearman');
    wjn_plot_tf_correlations(D.fullfile)
    pause(10)
    close all
    D=wjn_sl(['icoh' source_task]);
    D=wjn_tf_corr(D.fullfile,'rt',D.rt,'move','spearman');
    wjn_plot_tf_correlations(D.fullfile)
    pause(10)
    close all
    D=wjn_sl(['tf_' source_task]);
    D=wjn_tf_corr(D.fullfile,'v',D.max_v,'move','spearman');
    wjn_plot_tf_correlations(D.fullfile)
    pause(10)
    close all
    D=wjn_sl(['icoh' source_task]);
    D=wjn_tf_corr(D.fullfile,'v',D.max_v,'move','spearman');
    wjn_plot_tf_correlations(D.fullfile)
    pause(10)
    close all
    D=wjn_sl(['tf_' source_task]);
    D=wjn_tf_corr(D.fullfile,'merr',D.merr,'move','spearman');
    wjn_plot_tf_correlations(D.fullfile)
    pause(10)
    close all
    D=wjn_sl(['icoh' source_task]);
    D=wjn_tf_corr(D.fullfile,'merr',D.merr,'move','spearman');
    wjn_plot_tf_correlations(D.fullfile)
    pause(10)
    close all
    %% Run Source localisation with baseline correction for theta,alpha,low beta, beta, high beta and gamma ranges
    wjn_meg_vm_source_localisation(tname,baseline)

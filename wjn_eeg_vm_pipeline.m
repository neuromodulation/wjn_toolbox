function wjn_eeg_vm_pipeline(pp)


for pi = 1:length(pp)
    if iscell(pp)
        p = pp{pi};
    else
        p = pp;
    end
    
    wjn_vm_list('eegroot')
    keep p pi pp

    root = fullfile(mdf,'vm_eeg\',p.id,'data');
    if ~exist(root,'dir')
        mkdir(root)
    end
    cd(root)

    taskfile = p.task_eeg;
    restfile = p.rest_eeg;
    %% settings:
    baseline = [-3500 -2500];
    rest_epoch = 1025/600;
    task_epoch = [-5 5];
    %% Conversion and preprocessing
    
    Dr=wjn_eeg_conv_preproc(fullfile(p.root,p.id,'BA_exported',restfile),rest_epoch);
    Dt=wjn_eeg_conv_preproc(fullfile(p.root,p.id,'BA_exported',taskfile),task_epoch);
    Dt=wjn_eeg_vm_conditions(Dt.fullfile);
    Dt=wjn_eeg_vm_clean_trials(Dt.fullfile);
    Dt=wjn_eeg_vm_extract_behaviour(Dt.fullfile);
    tname = Dt.fname;
    rname = Dr.fname;
    %% source extraction rest
    Dr=wjn_eeg_source_extraction(Dr.fullfile);
%     if strcmp(p.hand,'left')
%         ml = D.indchannel('M1l');
%         il = D.indchannel('IFGl');
%         mr = D.indchannel('M1r');
%         ir = D.indchannel('IFGr');
%         D=chanlabels(D,[ml mr il ir],{'M1r','M1l','IFGr','IFGl'});
%     end
    source_rest = Dr.fname;
    Dr=wjn_tf_wavelet(Dr.fullfile,1:100,25);
    Dr=wjn_average(Dr.fullfile,0);
    
    %% source extraction task
    Dt=wjn_eeg_source_extraction(Dt.fullfile);
    
    source_task = Dt.fname;
    Dt=wjn_tf_wavelet(Dt.fullfile,1:100,25);
    Dt=wjn_average(Dt.fullfile,1);
    Dd=wjn_tf_sep_baseline(Dt,baseline,'go');
    wjn_eeg_vm_compare_tf(Dt.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dt.fullfile);
    pause(10)
    close all
    Dd=wjn_tf_sep_baseline(Dt,baseline,'go');
    wjn_eeg_vm_compare_tf(Dd.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dd.fullfile);
    pause(10)
    close all
    Dd=wjn_tf_sep_common_baseline(Dt.fullfile,baseline,'go');
    wjn_eeg_vm_compare_tf(Dd.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dd.fullfile);
    pause(10)
    close all
    %% baseline correction based on resting data
    Ds=wjn_tf_baseline_sep_dataset(Dt.fullfile,Dr.fullfile);
    wjn_eeg_vm_compare_tf(Ds.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Ds.fullfile);
    pause(10)
    close all
    %% Connectivity analysis rest
    [Dricoh,Drwpli]=wjn_tf_wavelet_coherence(source_rest,wjn_eeg_vm_connectivity_combinations,1:100,25,1);
    %% Connectivity analysis task
    [Dticoh,Dtwpli]=wjn_tf_wavelet_coherence(source_task,wjn_eeg_vm_connectivity_combinations,1:100,25,1);
    Dcd=wjn_tf_sep_baseline(Dticoh.fullfile,baseline,'go');
    wjn_eeg_vm_compare_tf(Dcd.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dcd.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_tf(Dtwpli.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dtwpli.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_tf(Dticoh.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dticoh.fullfile);
    pause(10)
    close all

    Dcd=wjn_tf_sep_common_baseline(Dticoh.fullfile,baseline,'go');
    wjn_eeg_vm_compare_tf(Dcd.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dcd.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_tf(Dtwpli.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dtwpli.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_tf(Dticoh.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dticoh.fullfile);
    pause(10)
    close all
    %% baseline correction based on resting data
    Dcs=wjn_tf_baseline_sep_dataset(Dticoh.fullfile,Dricoh.fullfile);
    wjn_eeg_vm_compare_tf(Dcs.fullfile);
    pause(10)
    close all
    wjn_eeg_vm_compare_frequency_ranges(Dcs.fullfile);
    pause(10)
    close all
    %% sensor level rest
    Dre = wjn_sl(rname);
    Dre=wjn_tf_wavelet(Dre.fullfile,1:100,25,wjn_eeg_central_channels64);
    Dre=wjn_average(Dre.fullfile,0);
    %% sensor level task
    Dte = wjn_sl(tname);
    Dte = wjn_tf_wavelet(Dte.fullfile,1:100,25,wjn_eeg_central_channels64);
    Dte = wjn_average(Dte.fullfile,1);
    wjn_eeg_vm_plot_tf_sensor(Dte.fullfile)
    Dsd=wjn_tf_sep_baseline(Dte,baseline,'go');
    wjn_eeg_vm_plot_tf_sensor(Dsd.fullfile)
    pause(10)
    close all
    %% sensor level baseline based on resting data
    Dss=wjn_tf_baseline_sep_dataset(Dte.fullfile,Dre.fullfile);
    wjn_eeg_vm_plot_tf_sensor(Dss.fullfile)
    pause(10)
    close all
    %% Time Frequency RT and V single trial correlations
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
    wjn_eeg_vm_source_localisation(tname,baseline)
    %% clean the folder
    mkdir('figures')
    movefile('*.png','figures','f')
    movefile('*.pdf','figures','f')


end

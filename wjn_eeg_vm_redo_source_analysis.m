function wjn_eeg_vm_redo_source_analysis
clear
root = wjn_vm_list('eegroot');
cd(root);
   baseline = [-3000 -2000];
list = wjn_vm_list('list');
for a = 1:20%:size(list,1)
%     D=wjn_sl(wjn_vm_list(list{a,1},'fullfile','srmtf_B'));
     D=wjn_sl(wjn_vm_list(list{a,1},'fullfile'));
    [mni,names]=wjn_eeg_vm_mni_grid;
    D=wjn_eeg_source_extraction(D.fullfile,mni,names,15);
    D=wjn_tf_wavelet(D.fullfile,1:45,25);
    D=wjn_average(D.fullfile,1);
    D=wjn_tf_sep_baseline(D,baseline,'go');
    D=wjn_tf_smooth(D.fullfile,4,250);
%     pause(1)
    v = squeeze(nanmean(nanmean(D(:,13:30,D.indsample(-1):D.indsample(.5),D.indtrial('go_con')),2),3))-squeeze(nanmean(nanmean(D(:,13:30,D.indsample(-1):D.indsample(0.5),D.indtrial('go_aut')),2),3));
    wjn_eeg_source_extracted_image('extract_13-30Hz_con-aut.nii',D.sources.mni,v);
%     pause(1)
    v = squeeze(nanmean(nanmean(nanmean(D(:,13:30,D.indsample(0):D.indsample(2),ci('move',D.conditions)),2),3),4));
    wjn_eeg_source_extracted_image('extract_13-30Hz_move.nii',D.sources.mni,v);
end
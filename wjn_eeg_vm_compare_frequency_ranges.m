function wjn_eeg_vm_compare_frequency_ranges(filename)

D=spm_eeg_load(filename);
freqranges = [2 7;7 13;13 20;20 35;13 35;40 80];
timeranges = [-3.5 3;-2 1.5;-1 1; -1 1;-1 1; -.5 .5];
cc=colorlover(1);
cc= cc([2;5;2;5;2;5],:);
fname = D.fname;
for a = 1:size(freqranges,1);
    wjn_plot_tf_freq_averages(D.fullfile,freqranges(a,:),'move',[],timeranges(a,:),[],cc);
    myprint(['average_' num2str(freqranges(a,1)) '-' num2str(freqranges(a,2)) '_Hz_' fname(1:end-4)])
end
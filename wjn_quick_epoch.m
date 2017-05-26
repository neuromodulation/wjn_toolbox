function D=wjn_quick_epoch(filename)

D=spm_eeg_load(filename);
S=[];
S.D = filename; 
S.trialength = 1024;
D=spm_eeg_epochs(S);
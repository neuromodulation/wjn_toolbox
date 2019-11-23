function D=wjn_transplant_bad_events(Dnew,Dold)

D=spm_eeg_load(Dnew);
Dold=spm_eeg_load(Dold);
D=badtrials(D,find(Dold.badtrials),1);
save(D);
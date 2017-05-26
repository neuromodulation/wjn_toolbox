function D = wjn_eeg_convert(filename)

S.dataset = filename;
S.saveorigheader = 1;
D=spm_eeg_convert(S);

i = ci('EMG',D.chanlabels);
D=chantype(D,i,'EMG');
save(D);

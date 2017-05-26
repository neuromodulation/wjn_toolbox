function D=wjn_meg_read_ptb_data(confile,fiducialfile)

S.dataset = confile;
D=spm_eeg_convert(S);

D=chantype(D,D.indchantype('EEG'),'Other');
D = fiducials(D,ft_read_headshape(fiducialfile));
save(D)
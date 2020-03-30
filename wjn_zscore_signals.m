function D=wjn_zscore_signals(filename)

D=spm_eeg_load(filename);
D=D.copy(fullfile(D.path,['z' D.fname]));

for a =1:D.nchannels
    good = find(D(a,:)~=0);
    D(a,:)=wjn_zscore(D(a,:));
end
save(D)
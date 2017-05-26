function nD=wjn_induced(filename)
%% input = epoched file

D=spm_eeg_load(filename);

nD=clone(D,['i' D.fname]);

for a = 1:D.nchannels;
    for b = 1:D.ntrials;
        nD(a,:,b) = D(a,:,b)-squeeze(mean(D(a,:,ci(D.conditions{b},D.conditions)),3));
    end
end
save(nD)


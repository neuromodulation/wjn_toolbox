function D = wjn_fix_chantype(filename)

D=spm_eeg_load(filename);
ch = D.nchannels;
for a = 1:ch
    if sum(strncmpi(D.chanlabels{a},{'ECOG','STN','LFP','GPi','VIM','CMPf','rLFP'},3))  
        D=chantype(D,a,'LFP');
    elseif sum(strncmpi(D.chanlabels{a},{'EMG','FDI','SCM'},3))
        D=chantype(D,a,'EMG');
    elseif sum(strncmpi(D.chanlabels{a},{'EEG','Cz','C3','C4','Pz'},3)) || sum(strncmpi(D.chanlabels{a},{'EEG','Cz','C3','C4'},2)) 
        D=chantype(D,a,'EEG');
    end
end
save(D);

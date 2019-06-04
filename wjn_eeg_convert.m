function D = wjn_eeg_convert(filename)

S.dataset = filename;
S.saveorigheader = 1;
D=spm_eeg_convert(S);

save(D);

downsample = 0;
if downsample
    D=wjn_downsample(D.fullfile,downsample);
end
ch = numel(D.chanlabels);

for a = 1:ch
    if sum(strncmpi(D.chanlabels{a},{'STN','LFP','GPi','VIM','CMPf','rLFP','rSTN','ECOG'},3))  
        D=chantype(D,a,'LFP');
    elseif sum(strncmpi(D.chanlabels{a},{'EMG','FDI','SCM'},3))
        D=chantype(D,a,'EMG');
    elseif sum(strncmpi(D.chanlabels{a},{'EEG','Cz','C3','C4','Pz'},3)) || sum(strncmpi(D.chanlabels{a},{'EEG','Cz','C3','C4'},2)) 
        D=chantype(D,a,'EEG');
    end
end

save(D)

% D=wjn_downsample(D.fullfile,300,150,'d');
% D=wjn_linefilter(D.fullfile)

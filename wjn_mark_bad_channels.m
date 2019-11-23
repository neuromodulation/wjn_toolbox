function D = wjn_mark_bad_channels(filename,channel)

D=spm_eeg_load(filename);

if ischar(channel) || iscell(channel)
    i = ci(channel,D.chanlabels);
else 
    i = channel;
end

D=badchannels(D,i,1);
save(D);
D=wjn_remove_bad_channels(D.fullfile);
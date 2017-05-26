function Dn = wjn_remove_channels(filename,channels)

D=spm_eeg_load(filename);

if ischar(channels)
    channels = {channels};
end

bc = D.badchannels;

if iscell(channels)
    D=badchannels(D,ci(channels,D.chanlabels),1);
else
    D=badchannels(D,channels,1);
end
save(D);

Dn=wjn_remove_bad_channels(D.fullfile);
D=badchannels(D,':',0);
D=badchannels(D,bc,1);
save(D);
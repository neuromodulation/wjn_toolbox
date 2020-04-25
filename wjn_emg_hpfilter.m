function D=wjn_emg_hpfilter(filename,hpfreq,chans)

D=spm_eeg_load(filename);

if ~exist('hpfreq','var')
    hpfreq=10;
end

if ~exist('chans','var')
    i = unique([D.indchantype('EMG') ci('EMG',D.chanlabels)]);
elseif ischar(chans) || iscell(chans)
    i = ci(chans,D.chanlabels);
else
    i=chans;
end
    
D(i,:,:) = ft_preproc_highpassfilter(D(i,:,:),D.fsample,hpfreq);
save(D)
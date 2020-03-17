function D=wjn_invert_signals(filename)

D=spm_eeg_load(filename);

i = unique([ci({'EEG','LFP'},D.chantype) ci({'EEG','LFP'},D.chanlabels)]);
 for b = 1:length(i)
     signal = ft_preproc_bandpassfilter(D(i(b),:),D.fsample,[3 35]);
    if nanmedian(signal(find(abs(signal)>prctile(abs(signal),95)))) > 0
        D(b,:)=-D(b,:);
    end
end
         
save(D);

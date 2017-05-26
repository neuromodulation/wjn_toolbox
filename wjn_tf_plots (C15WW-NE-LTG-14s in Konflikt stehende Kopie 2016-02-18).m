function wjn_tf_plots(filename)


D=spm_eeg_load(filename);

for a = 1:D.nchannels;
    figure
    for b = 1:D.ntrials;
        subplot(ceil(sqrt(D.ntrials)),ceil(sqrt(D.ntrials)),b)
        imagesc(D.time,D.frequencies,squeeze(D(a,:,:,b)))
        axis xy
        title([D.chanlabels{a} ' - ' D.conditions{b}])
        colorbar
    end
end

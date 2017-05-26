function [data,channels]=wjn_tf_mean(filename,timerange,freqrange)
% [data,channels]=wjn_tf_mean(filename,timerange,freqrange)

D=spm_eeg_load(filename);
ti = [sc(D.time,timerange(1)):sc(D.time,timerange(2))];
fi = [sc(D.frequencies,freqrange(1)):sc(D.frequencies,freqrange(2))];

for a = 1:D.nchannels
    data(a,:) = mean(mean(D(a,ti,fi,:),2),3);
end

channels = D.chanlabels;

D.tfmean.(['TF' num2str(freqrange(1)) '_' num2str(freqrange(2))]) = data;

save(D)

figure
bar(data)
set(gca,'XTickLabel',D.chanlabels)
legend(D.conditions)
figone(8,10+D.nchannels)
title(['T: ' num2str(timerange(1)) '-' num2str(timerange(2)) ' s F: ' num2str(freqrange(1)) '-' num2str(freqrange(2)) ' Hz'])

function [m,w,p]=wjn_spw_peaks(filename,filtfreq)

if ~exist('filtfreq','var')
    filtfreq=[3 45];
end

D=spm_eeg_load(filename);
chs = unique([ci({'EEG','LFP'},D.chantype) ci({'EEG','LFP'},D.chanlabels)]);
peaks = nan(size(D.time));
widths = nan(size(D.time));
for a=1:length(chs)
    data = D(chs(a),:);
    data(data==0)=nan;
    good = ~isnan(data);
    fdata=data;
    fdata(good) = zscore(ft_preproc_bandpassfilter(data(good),D.fsample,filtfreq));
    [mp,ip,wp,pp]=findpeaks(fdata,'MinpeakProminence',1);
    [mn,in,wn,pn]=findpeaks(-fdata,'MinpeakProminence',1);
    m=[mp mn];
    i= [ip in];
    w = [wp wn];
    p = [pp pn];
    peaks(a,1:length(p))=sort(p,'descend');
    widths(a,1:length(p))=sort(w,'descend');
end
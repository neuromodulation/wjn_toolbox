function [D,alltimes,allconds]=wjn_spw(filename,prominence)
if ~exist('prominence','var')
    prominence = 1.5;
end

D=spm_eeg_load(filename);
spw=[];


chs = unique([ci({'EEG','LFP'},D.chantype) ci({'EEG','LFP'},D.chanlabels)]);
alltimes=[];
allconds=[];
for a = 1:length(chs)
    data = -zscore(D(chs(a),:));
    [i,w,p,m,d]=wjn_raw_spw(ft_preproc_bandpassfilter(data,D.fsample,[3 45]),prominence);
    spw(a).index=i';
    spw(a).time = D.time(i)';
    spw(a).prominence = p';
    spw(a).maximum = m';
    spw(a).width = w';
    spw(a).interval = d;
    spw(a).cond = repmat({['SPW_n' D.chanlabels{chs(a)}]},size(i));
    alltimes=[alltimes;D.time(i)'];
    allconds = [allconds,spw(a).cond];
end

D.nspw = spw;

for a = 1:length(chs)
     data = zscore(D(chs(a),:));
    [i,w,p,m,d]=wjn_raw_spw(ft_preproc_lowpassfilter(data,D.fsample,45),prominence);
     spw(a).index=i';
    spw(a).time = D.time(i)';
    spw(a).prominence = p';
    spw(a).maximum = m';
    spw(a).width = w';
    spw(a).interval = d;
    spw(a).cond = repmat({['SPW_p' D.chanlabels{chs(a)}]},size(i));
    alltimes=[alltimes;D.time(i)'];
    allconds = [allconds,spw(a).cond];
end

D.pspw = spw;
save(D)
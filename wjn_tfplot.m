function h=wjn_tfplot(D,ch,c)
if ~exist('ch','var') || isempty(ch)
    ch = 1:D.nchannels;
end

if ~exist('c','var') || isempty(c)
    c = 1:D.ntrials;
end

figure,
h=imagesc(D.time,D.frequencies,squeeze(nanmean(nanmean(D(ch,:,:,c),1),4)));
axis xy
TFaxes
figone(7);
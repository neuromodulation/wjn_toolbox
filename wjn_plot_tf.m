function h=wjn_plot_tf(D,ch,c,int)
% function h=wjn_plot_tf(D,ch,c,int)
if ~exist('ch','var') || isempty(ch)
    ch = 1:D.nchannels;
elseif ischar(ch) || iscell(ch)
    ch = ci(ch,D.chanlabels);
end

if ~exist('c','var') || isempty(c)
    c = 1:D.ntrials;
elseif ischar(c) || iscell(c)
    c = ci(c,D.conditions);
end

if ~exist('int','var')
    int = 1;
end
if ~int
    h=imagesc(D.time,D.frequencies,squeeze(nanmean(nanmean(D(ch,:,:,c),1),4)));
else
    try
        h=imagesc(D.time,D.frequencies,interp2(interp2(squeeze(nanmean(nanmean(D(ch,:,:,c),1),4)))));
    catch
        h=imagesc(D.time,D.frequencies,interp2(squeeze(nanmean(nanmean(D(ch,:,:,c),1),4))));
    end
end
axis xy
TFaxes
figone(7);
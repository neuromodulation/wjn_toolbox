function [h,ttf,t,f]=wjn_plot_tf(D,ch,c,lg,nc)
% function h=wjn_plot_tf(D,ch,c)
% keyboard

if ~exist('lg','var')
    lg = 0;
end



if ~exist('ch','var') || isempty(ch) || strcmp(ch,'all')
    ch = 1:D.nchannels;
elseif ischar(ch) || iscell(ch)
    ch = ci(ch,D.chanlabels,2);
end

if ~exist('c','var') || isempty(c)
    if ~isempty(D.frequencies)
        c = 1:D.ntrials;
    else
        c = 1:length(D.condlist);
    end
elseif ischar(c) || iscell(c)
    if ~isempty(D.frequencies)
        c = ci(c,D.conditions,2);
    else
        c=ci(c,D.condlist,2);
    end
end

if isempty(D.frequencies) 
%     keyboard
    fft = wjn_ft_wavelet(D.ftraw(0),25,ch,c);
    t = fft{1}.time;
    f = fft{1}.freq;
    for a = 1:length(fft)
        d(:,:,:,a) = fft{a}.powspctrm;
        for b = 1:size(d,1)
            d(b,:,:,a) = wjn_raw_baseline(d(b,:,:,a),f);
        end
    end
    c=1:a;
    ch = 1:b;
else
    d=D(:,:,:,:);
    t = D.time;
    f = D.frequencies;
end


if ~exist('int','var')
    int = 1;
end

hi = D.history;
fn= D.fname;    

tf=squeeze(nanmean(nanmean(d(ch,:,:,c),1),4));
% tf(tf(:)>(nanmean(nanmean(tf))+3*nanstd(nanstd(tf))))=nan;

if strcmp(fn(1:3),'mtf') || (exist('lg','var') && lg)
    ttf = log(tf);
else
    ttf = tf;
end

if exist('nc','var')
h=wjn_contourf(t,f,ttf,nc);
else
h=imagesc(t,f,ttf);
axis xy
end
TFaxes
figone(7);
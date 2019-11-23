function d = wjn_freq_average(D,freq,ch)

if ~exist('z','var')
    z = 0;
end

if ~exist('ch','var') || isempty(ch)
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


for a =1:length(ch)
    for b = 1:length(c)
        d(a,:,b) = nanmean(D(ch(a),D.indfrequency(freq(1)):D.indfrequency(freq(2)),:,c(b)),2);
        if z
            d(a,:,b)=wjn_zscore(d(a,:,b));
        end
    end
end


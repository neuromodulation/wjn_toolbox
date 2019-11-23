function wjn_plot_D(D,ch,c,z)


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

if exist('z','var') && z
    for a =1:length(ch)
        for b = 1:length(c)
            D(ch(a),:,c(b))=wjn_zscore(D(ch(a),:,c(b)));
        end
    end
end
    

figure
plot(D.time,squeeze(D(ch,:,c)))
xlabel('Time [s]')
ylabel('Amplitude [uV]')
legend(D.chanlabels(ch),'Location','NorthEastOutside')
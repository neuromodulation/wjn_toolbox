function wjn_plot_tf_freq_averages(filename,freqrange,conds,chans,xlimits,ylimits,cc)

D=wjn_sl(filename);
if ~exist('cc','var')
    cc=colorlover(6);
end

foi = D.indfrequency(freqrange(1)):D.indfrequency(freqrange(2));

if exist('chans','var') && ~isempty(chans)
    chi=ci(chans,D.chanlabels);
else
    chi = 1:D.nchannels;
end

if exist('conds','var')
    coi = ci(conds,D.condlist,2);
else
    coi = 1:D.ntrials;
end
    
figure
for a = 1:length(chi);
    subplot(2,round(length(chi)/2),a)
    for b = 1:length(coi);
        p(b)=plot(D.time,squeeze(nanmean(D(chi(a),foi,:,coi(b)),2))','linewidth',1,'color',cc(b,:));
        hold on
    end
    if a==1
        legend(p,D.conditions(coi),'location','southwest');
    end
        title(D.chanlabels{chi(a)})
        if exist('xlimits','var')
            xlim(xlimits)
        else
            xlim([D.time(1)+.25 D.time(end)-.25])
        end
        if exist('ylimits','var') && ~isempty(ylimits)
            ylim(ylimits)
        end
        xlabel('Time [s]')
        ylabel(['\mu ' num2str(freqrange(1)) ' - ' num2str(freqrange(2)) 'Hz %'])
end
    
    figone(20,30)
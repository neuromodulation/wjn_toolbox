function p=wjn_plot_raw_signals(time,data,chanlabels)

if size(data,1) > 400 && size(data,1) > size(data,2)
    data = data';
end
if size(time)==  [1,1]
    time = linspace(0,length(data)/time,length(data));
end

if ~exist('chanlabels','var')
    for a = 1:size(data,1)
        chanlabels{a} = ['chan' num2str(a)];
    end
end

for a = 1:size(data,1)
    p(a)=plot(time,wjn_zscore(data(a,:))./10+a);
    hold on
end
set(gca,'YTick',[1:size(data,1)],'YTickLabel',strrep(chanlabels,'_',' '),'YTickLabelRotation',45);
xlim([time(1) time(end)]);
ylim([0 length(chanlabels)+1]);
xlabel('Time [s]')
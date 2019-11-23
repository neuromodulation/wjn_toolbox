function wjn_plot_tf_correlations(filename)

D=wjn_sl(filename)
for a = 1:D.nchannels
    figure
    subplot(1,2,1)
    wjn_contourf(D.time,D.frequencies,D(a,:,:,1));
    TFaxes
    title(D.chanlabels{a})
%     caxis([-.5 .5])
    subplot(1,2,2)
    wjn_contourf(D.time,D.frequencies,D(a,:,:,2)<=.05);
    
    TFaxes
    figone(7,14)
end
    
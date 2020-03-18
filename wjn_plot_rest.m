function wjn_plot_rest(filename)

load(filename)

for a=1:length(COH.channels)
figure
plot(COH.f,COH.rpow(a,:),'linewidth',2)
xlabel('Frequency [Hz]')
ylabel('Relative power spectral density [%]')
xlim([3 45]);
legend(COH.channels(a))
figone(7)
end


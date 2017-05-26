
[fi,dir]=uigetfile('*.mat','Choose spm_eeg_fft file','Multiselect','on')

for a = 1:length(fi)
x=load(fullfile(dir,fi{a}))
D=x.COH;
[~,ic] = lfpfinder2(D.channels,1);
if isempty(ic)
ic = listdlg('ListString',D.channels,'PromptString','Choose channels:','ListSize',[250 300]);
end
f=D.f;
figure
plot(f,D.rpow(ic,:),'LineWidth',1)
xlim([4 40])
figone(7)
xlabel('Frequency [Hz]')
ylabel('Relative spectral power [%]')
legend(D.channels{ic})
title(D.name)
myprint(fullfile(dir,['LFP_Power_spectra_' D.name]))
end
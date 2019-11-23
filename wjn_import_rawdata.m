function D=wjn_import_rawdata(filename,idata,chanlabels,fs)

data.trial{1} = double(idata);
data.time{1} = linspace(0,length(idata)/fs,length(idata));
data.label = chanlabels;
data.fsample = fs;
% keyboard
D=spm_eeg_ft2spm(data,filename);
D=chantype(D,':','Other');

ilfp = ci({'LFP','STN','GPi','VIM','ecog'},chanlabels);
iemg = ci({'EMG'},chanlabels);
ieeg = ci({'EEG','Cz','C3','C4'},chanlabels);

D=chantype(D,ieeg,'EEG');
D=chantype(D,iemg,'EMG');
D=chantype(D,ilfp,'LFP');
save(D)
check(D)
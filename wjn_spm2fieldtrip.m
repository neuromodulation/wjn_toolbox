function data = wjn_raw_spm2fieldtrip(filename)

D = spm_eeg_load(filename);
data = D.ftraw;
data.hdr = D.fsample;
data.hdr.nChans = D.nchannels;
data.hdr.nTrials = D.ntrials;
data.hdr.label = D.chanlabels;
data.hdr.chantype = strrep(D.chantype,'LFP','SEEG');
data.hdr.chanunit = D.units;

%   hdr.Fs                  sampling frequency
%   hdr.nChans              number of channels
%   hdr.nSamples            number of samples per trial
%   hdr.nSamplesPre         number of pre-trigger samples in each trial
%   hdr.nTrials             number of trials
%   hdr.label               Nx1 cell-array with the label of each channel
%   hdr.chantype            Nx1 cell-array with the channel type, see FT_CHANTYPE
%   hdr.chanunit            Nx1 cell-array with the physical units, see FT_CHANUNIT
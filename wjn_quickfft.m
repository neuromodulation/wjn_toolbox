function coh =wjn_quickfft(filename,input)

D=spm_eeg_load(filename);

S.D = D.fullfile;
S.condition = D.condlist;
S.channels = D.chanlabels(~D.badchannels);
S.freq = [1 100];
S.freqd = D.fsample;
S.timewin = D.fsample/1000;
S.normfreq = [5 95];
S.rectify = 0;
S.dir = 0;
S.phaamp = 0;
if exist('input','var')
    if ischar(input)
        input = {input};
    end
    for a = 1:length(input);
        eval(input{a});
    end
    
end
coh=spm_eeg_fft_dir3(S)

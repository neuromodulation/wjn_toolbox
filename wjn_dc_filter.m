function D = wjn_dc_filter(filename)

%
%   S.band    - filterband [low|high|bandpass|stop]
%   S.freq    - cutoff frequency(-ies) [Hz]
%
%  Optional fields:
%   S.type    - filter type [default: 'butterworth']
%                 'butterworth': Butterworth IIR filter
%                 'fir':         FIR filter (using MATLAB fir1 function)
%   S.order   - filter order [default: 5 for Butterworth]
S.D = filename;
S.freq = [48 54];
S.band = 'stop';
D=spm_eeg_filter(S);
S.D = D.fullfile;
S.freq = [98 102];
S.band = 'stop';
D=spm_eeg_filter(S);
function  D = wjn_filter(filename,freq,band,prefix)

if ~exist('prefix','var')
    prefix = 'f';
end

D=spm_eeg_load(filename);
if numel(freq)==1
    if ~exist('band','var')
        band = 'high';
    end
    S=[];
    S.D = D.fullfile;
    S.band = band;
    S.freq = freq;
    S.prefix = prefix;
    D=spm_eeg_filter(S);

elseif numel(freq)==2
    if ~exist('band','var')
        band = 'bandpass';
    end
    S=[];
    S.D = D.fullfile;
    S.band = band;
    S.freq = freq;
    S.prefix = prefix;
    D=spm_eeg_filter(S);
end
    
function  D = wjn_filter(filename,freq,band,channels,prefix)
%% D= wjn_filter('spmeeg_test.mat',[13 35],'bandpass','LFP_STN_R12')

if ~exist('prefix','var')
    prefix = 'f';
end

D=spm_eeg_load(filename);

if exist('channels','var') 
    if isnumeric(channels)
        ic = channels;
    elseif ischar(channels) || iscell(channels)
        ic = ci(channels,D.chanlabels);
    end
        
    original_chantype = D.chantype;
    D = chantype(D,':','Other');
    D= chantype(D,ic,'EEG');
    save(D);
    oD=D;
end

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
if exist('oD','var')
    oD=chantype(oD,':',original_chantype)
    save(oD)
end
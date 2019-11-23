function cT = wjn_chantype(input)


if ~iscell(input)
    D=input;
    input = D.chanlabels;
end

cT = repmat({'Other'},size(input));
cT(ci({'LFP','STN','GPi','VIM'},input))={'LFP'};
cT(ci({'EMG','SCM'},input))={'EMG'};
cT(ci({'EEG','C3','C4','Cz','Fz'},input))={'EEG'};

if exist('D','var')
    D=chantype(D,':',cT);
    save(D)
    cT = D;
end

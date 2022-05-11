function cT = wjn_chantype(input,convention)


if ~iscell(input) && ~ischar(input)
    D=input;
    input = D.chanlabels;
elseif ischar(input)
    input = {input};    
end

if ~exist('convention','var')
    convention = 'spm';
end

switch convention
    case 'spm'

    cT = repmat({'Other'},size(input));
    cT(ci({'LFP','STN','GPi','VIM','ECOG'},input))={'LFP'};
    cT(ci({'EMG','SCM','BIP'},input))={'EMG'};
    cT(ci({'EEG','C3','C4','Cz','Fz'},input))={'EEG'};

    if exist('D','var')
        D=chantype(D,':',cT);
        save(D)
        cT = D;
    end
    
    
case 'fieldtrip'

    cT = repmat({'unknown'},size(input));
    cT(ci({'LFP','STN','GPi','VIM','SEEG'},input))={'SEEG'};
    cT(ci({'ECOG'},input))={'ECOG'};
    cT(ci({'EMG','SCM','BIP'},input))={'EMG'};
    cT(ci({'EEG','C3','C4','Cz','Fz'},input))={'EEG'};

end
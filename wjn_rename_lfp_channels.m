function D=wjn_rename_lfp_channels(filename,oldstring,newstring)

try
    D=spm_eeg_load(filename);
    chans = D.chanlabels;
    ichans = ci(oldstring,chans);

for a = 1:length(chans)
    if ismember(a,ichans)
    
     nchan =[newstring chans{a}(~ismember(chans{1},oldstring))];
    
        D=chanlabels(D,ichans(a),nchan);
    end
end

save(D);


catch
d = load(filename);

chans = fieldnames(d);
ichans = ci(oldstring,chans);



for a = 1:length(chans)
    if ismember(a,ichans)
    
     nchan =[newstring chans{a}(~ismember(chans{1},oldstring))];
    
        n.(nchan) = d.(chans{ichans(a)});
    else
        n.(chans{a}) = d.(chans{a});
    end
end

% keep n
save(filename,'-struct','n')
D=d;
end
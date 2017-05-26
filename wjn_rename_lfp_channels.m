function wjn_rename_lfp_channels(filename,oldstring,newstring)

d = load(filename);

chans = fieldnames(d);
ichans = ci(oldstring,chans);



for a = 1:length(chans);
    if ismember(a,ichans)
    
     nchan =[newstring chans{a}(~ismember(chans{1},oldstring))];
    
        n.(nchan) = d.(chans{ichans(a)});
    else
        n.(chans{a}) = d.(chans{a});
    end
end

% keep n
save(filename,'-struct','n')
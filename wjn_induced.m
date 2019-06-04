function nD=wjn_induced(filename)
%% input = epoched file

D=spm_eeg_load(filename);

nD=clone(D,['i' D.fname]);



conds = D.condlist;

for a = 1:length(conds)
    i=ci(conds{a},D.conditions);
    nD(:,:,i) = bsxfun(@minus,squeeze(D(:,:,i)),nanmean(D(:,:,i),3));  
end

save(nD)




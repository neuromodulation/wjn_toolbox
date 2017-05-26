function nD=wjn_remove_bad_trials(filename)

D=spm_eeg_load(filename);

goodtrials = 1:D.ntrials;
goodtrials(D.badtrials)=[];
ngoodtrials = numel(goodtrials);
ndim = size(D);
ndim(end) = ngoodtrials;
nD=clone(D,['r' D.fname],ndim);
nD=conditions(nD,1:ngoodtrials,D.conditions(goodtrials));
nD = trialonset(nD,1:ngoodtrials,D.trialonset(goodtrials));
if numel(ndim)==3
    nD(:,:,:) = D(:,:,goodtrials);
elseif numel(ndim)==4
    nD(:,:,:,:) = D(:,:,:,goodtrials);
end
save(nD);




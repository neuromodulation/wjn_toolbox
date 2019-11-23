function D=wjn_tf_sep_common_baseline(filename,baseline,cond)

D=spm_eeg_load(filename);

if sum(abs(baseline))>100
    baseline = baseline./1000;
end


mb = nanmean(nanmean(D(:,:,D.indsample(baseline(1)):D.indsample(baseline(2)),ci(cond,D.conditions)),3),4);


for a = 1:D.ntrials
    
    for b = 1:D.nchannels
        rtf(b,:,:,a) = bsxfun(@rdivide,...
        bsxfun(@minus,...
        squeeze(D(b,:,:,a)),...
        squeeze(mb(b,:)')),...
        squeeze(mb(b,:)')).*100;
   
    end

end

nD = clone(D,['scr' D.fname]);

nD(:,:,:,:) = rtf;
nD.info.baseline = baseline;   
save(nD)
D=nD;


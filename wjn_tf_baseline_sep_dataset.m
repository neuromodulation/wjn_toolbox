function D=wjn_tf_baseline_sep_dataset(taskfile,restfile)

D=spm_eeg_load(taskfile);
Dr=spm_eeg_load(restfile);

mb = squeeze(nanmean(Dr(:,:,:,1),3));

if size(mb,1)~=D.nchannels
    error('rest file must have same channels')
end
% keyboard
for a = 1:D.ntrials
   
    for b = 1:D.nchannels
        
        rtf(b,:,:,a) = bsxfun(@rdivide,...
        bsxfun(@minus,...
        squeeze(D(b,:,:,a))./sum(squeeze(D(b,:,:,a))),...
        squeeze(mb(b,:)')./sum(squeeze(mb(b,:)))),...
        squeeze(mb(b,:)')./sum(squeeze(mb(b,:)))).*100;
    end
end

nD = clone(D,['sdr' D.fname]);
nD = conditions(nD,':',D.conditions);

nD(:,:,:,:) = rtf;
save(nD)
D=nD;
function D=wjn_eeg_normalize_source_montage(filename)

D=wjn_sl(filename);
D=wjn_spm_copy(D.fullfile,fullfile(D.path,['n' D.fname]));
D(:,:,:,:)=100.*(D(:,:,:,:)./squeeze(nanmean(nanmean(nanmean(nanmean(D(:,:,:,:)))))));
save(D)


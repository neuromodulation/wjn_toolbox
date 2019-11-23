function wjn_nii_flip_lr(old_name,flipped_name)

if ~exist('flipped_name','var')
    [fdir,fname,ext]=fileparts(old_name);
    flipped_name = fullfile(fdir,['f' fname ext]);
end

spm_imcalc({old_name},flipped_name,'flipud(i1)')
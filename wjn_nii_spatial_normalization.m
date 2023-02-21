function nii = wjn_nii_spatial_normalization(nii)

if ischar(nii) || iscell(nii)
    nii = ea_load_nii(nii);
end

nii = ea_load_nii(nii);
nii.fname = ['normalized_' nii.fname];
nii.img(:)=nii.img(:)./nanmean(nii.img(:));
ea_write_nii(nii)
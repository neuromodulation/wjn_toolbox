function nii = wjn_crop_nii(nii)

[lf,lt]=leadf;
addpath(genpath(lf));

ea_crop_nii(nii);
nii=wjn_read_nii(nii);
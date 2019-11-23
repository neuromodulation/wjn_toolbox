function wjn_nii_remove_nan(filename)

nii = wjn_read_nii(filename);
nii.fname = ['z_' nii.fname];
nii.img(isnan(nii.img))=0;
ea_write_nii(nii)
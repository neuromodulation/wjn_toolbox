function wjn_nii_normalize(filename)

nii=wjn_read_nii(filename);


nii.img(:) = 100.*(nii.img(:)./nanmax(nii.img(:)));
nii.fname = ['P_' nii.fname];
ea_write_nii(nii);
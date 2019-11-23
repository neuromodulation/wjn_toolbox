function nii = wjn_nii_correct_datatype(filename)
% keyboard
nii = load_nii(filename);
nii.hdr.dime.datatype = 4;
nii.hdr.hist.qform_code=1;
nii.hdr.hist.sform_code=0;
save_nii(nii,filename);

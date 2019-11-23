function outname=wjn_nii_diff(i1,i2,outname)

spm_imcalc({i1,i2},outname,'i1-i2')



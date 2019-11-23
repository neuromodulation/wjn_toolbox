function wjn_nr_auto_segment
root = 'E:\Dropbox (Personal)\Neuroradiology\segmentations';
cd(root)
nii=wjn_dcm2nii;
cd(root)
wjn_nr_cat_segmentation(nii,0);
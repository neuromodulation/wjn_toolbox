clear all
cd('E:\Dropbox (Personal)\Neuroradiology\CSF\N2')

imagefiles={'INV1.nii','INV2.nii','UNI.nii'};
segmentationfiles ={'c1INV1.nii','c2INV1.nii','c3INV1.nii','c4INV1.nii','c5INV1.nii'};

segnet = wjn_nr_cnn_segment_train(imagefiles,segmentationfiles);

cd('E:\Dropbox (Personal)\Neuroradiology\CSF\N3')
tic
wjn_nr_cnn_segment(imagefiles,segnet);
toc


% segnet = wjn_nr_cnn_segment_train(imagefiles,segmentationfiles,segnet);

%%

wjn_nr_cat_segmentation('UNI.nii')
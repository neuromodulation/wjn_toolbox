function nii=wjn_read_nii(fname)
nii=spm_vol(fname);
img=spm_read_vols(nii);
nii=nii(1); % only keep the header of the first vol for multi-vol image
nii.img=img; % set image data
transform = nii(1).mat;
vox = [1,1,1;
       1,1,1;
       1,1,1;
       2,1,1;
       1,2,1;
       1,1,2];
mm = [vox, ones(size(vox,1),1)] * transform';
mm(:,4) = [];
vsize = diag(pdist2(mm(1:3,:),mm(4:6,:)))';
nii.voxsize=vsize;% set voxsize


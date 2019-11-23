function wjn_ecog_create_beta_rois(mni,beta,r)
   
for a = 1:size(mni,1)
    nii=wjn_spherical_roi('temp.nii',mni(a,:),r);
    nii=ea_load_nii(nii)
    img(a,:) = nii.img(:).*beta(a);
end

mimg = nanmean(img(:,:),1);
mimg(isnan(mimg))=0;

nii.img(:) = mimg(:);
nii.fname = 'beta.nii';
ea_write_nii(nii)
delete('temp.nii')
% wjn_heatmap('beta_hm.nii',mni,beta)
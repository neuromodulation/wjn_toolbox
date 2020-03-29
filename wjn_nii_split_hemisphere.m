function [rh,lh] = wjn_nii_split_hemisphere(nii,crop)
%% [rh,lh] = wjn_nii_split_hemisphere(nii)
try
    nii = wjn_read_nii(nii);
catch
end

if ~exist('crop','var')
    crop=0;
end

for a = 1:nii.dim(1)
    c(a,:) = nii.mat*[a 1 1 1]';
end


il = find(c(:,1)<0);

ir = find(c(:,1)>0);

lh = nii;
rh = nii;

lh.img(ir,:,:) = nan;
rh.img(il,:,:) = nan;

[fdir,fname,ext]=fileparts(nii.fname);

lh.fname = fullfile(fdir,['lh_' fname ext]);
rh.fname = fullfile(fdir,['rh_' fname ext]);

ea_write_nii(rh)
ea_write_nii(lh)
if crop
    ea_crop_nii(lh.fname)
    ea_crop_nii(rh.fname)
end
lh = wjn_read_nii(lh.fname);
rh = wjn_read_nii(rh.fname);

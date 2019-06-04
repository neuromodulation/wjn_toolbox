function [label,code,dist]=wjn_get_mni_anatomy(coord)

areas=importdata(fullfile(getsystem,'imaging','labeling','Automated Anatomical Labeling 2 (Tzourio-Mazoyer 2002).txt'));

t1=spm_vol_nifti(fullfile(getsystem,'imaging','labeling','Automated Anatomical Labeling 2 (Tzourio-Mazoyer 2002).nii'));

[d,xyz]=spm_read_vols(t1);
nxyz  = xyz;
nxyz=xyz(:,d(:)>0);
[dist,a] = min(pdist2(nxyz',coord));
[~,a]=min(pdist2(xyz',nxyz(:,a)'));



% a = find(find(xyz(1,:) == coord(1)) & xyz(2,:) == coord(2) & xyz(3,:) == coord(3));
code = d(ind2sub(t1.dim,a));

label = areas{code};

            
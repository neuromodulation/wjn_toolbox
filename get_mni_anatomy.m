function [label,code,id,CB]=get_mni_anatomy(coord)

load(fullfile(getsystem,'meg_toolbox\ROI_MNI_V4_List.mat'))
t1=spm_vol_nifti(fullfile(getsystem,'meg_toolbox\ROI_MNI_V4.nii'));

[d,xyz]=spm_read_vols(t1);




a = find(xyz(1,:) == coord(1) & xyz(2,:) == coord(2) & xyz(3,:) == coord(3));
id = d(ind2sub(t1.dim,a));
label = [];code =[]; CB = [];
for i = 1:length(ROI)
    if ROI(i).ID == id
        label = ROI(i).Nom_L;
        code = ROI(i).Nom_C;
        CB = ROI(i).CB;
    end
end

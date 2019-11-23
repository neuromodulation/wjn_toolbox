

nii = ea_load_nii(wjn_t1_template);
vox_mm=[122 313 247 1; 116 292 255 1; 110 274 260 1; 109 253 266 1; 105 233 270 1; 104 211 217 1];

mni_mm = nii.mat*vox_mm';

mni_mm = mni_mm(1:3,:)';

m1 = wjn_mni_list;
m1=m1(2,:);

dx=mni_mm(:,1)-m1(:,1);
dy=mni_mm(:,2)-m1(:,2);
dz=mni_mm(:,3)-m1(:,3);
d= wjn_distance(mni_mm,m1);


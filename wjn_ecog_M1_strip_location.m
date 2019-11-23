function mni = wjn_ecog_M1_strip_location

m1=wjn_mni_list;
m1=m1(1,:);

mni(1,:) = [m1(1) m1(2)+30 m1(3)];
mni(2,:) = [m1(1) m1(2)+20 m1(3)];
mni(3,:) = [m1(1) m1(2)+10 m1(3)];
mni(4,:) = m1;
mni(5,:) = [m1(1) m1(2)-10 m1(3)];
mni(6,:) = [m1(1) m1(2)-20 m1(3)];

for a = 2:size(mni,1)
    fnames{a} = wjn_spherical_roi(['temp' num2str(a) '.nii'],mni(a,:),4);
  
end
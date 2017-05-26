function w = wjn_nii_cluster_weight(filename)

V = spm_vol(filename);
dat = spm_read_vols(V);
[l2, num] = spm_bwlabel(double(dat>0),26);
if ~num, warning('No clusters found.'); 
    w = 0;
else

%-Extent threshold, and sort clusters according to their extent
[n, ni] = sort(histc(l2(:),1:num), 1, 'descend');

w = sum(dat(l2==ni(1)));
end
function wjn_nii_cluster_threshold(nii,thresh,clustersize)

[fdir,fname]=fileparts(nii);
o.mask = 1;
% o.dtype = 16;

if isnumeric(thresh)
    thresh = ['>' num2str(thresh)];
end
spm_imcalc(nii,'temp.nii',['i1' thresh],o);

ROI  = 'temp.nii';  % input image (binary, ie a mask)
k    = clustersize;          % minimal cluster size
ROIf = 'temp.nii'; % output image (filtered on cluster size)

%-Connected Component labelling
V = spm_vol(ROI);
dat = spm_read_vols(V);
[l2, num] = spm_bwlabel(double(dat>0),26);
if ~num, warning('No clusters found.'); end


%-Extent threshold, and sort clusters according to their extent
[n, ni] = sort(histc(l2(:),0:num), 1, 'descend');

l  = zeros(size(l2));
n  = n(2:end); ni = ni(2:end)-1;
disp(n)
ni = ni(n>=k); n  = n(n>=k);
for i=1:length(n), l(l2==ni(i)) = i; end
clear l2 ni
fprintf('Selected %d clusters (out of %d) in image.\n',length(n),num);

%-Write new image
V.fname = ROIf;
spm_write_vol(V,l~=0); % save as binary image. Remove '~=0' so as to
                     % have cluster labels as their size. 
                       % or use (l~=0).*dat if input image was not binary
      
spm_imcalc({nii,'temp.nii'},fullfile(fdir,['c' fname '.nii']),'i1.*i2',o)

function [r,p]=wjn_nii_corr_loom(files,temp,v)

n = numel(files);

t = wjn_read_nii(temp);
t.img(t.img(:)==0)=nan;

i=[1:n];
r=[]
for a = 1:n
    nii=wjn_read_nii(files{a});
    nii.img(nii.img(:)==0)=nan;
    r(a,1) = corr(t.img(:),nii.img(:),'rows','pairwise','type','spearman');
end

wjn_corr_plot(r,v)
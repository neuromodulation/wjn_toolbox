function p=wjn_rs_corr(outname,images,v)

for a=1:length(images)
    nii = wjn_read_nii(images{a});
    d(a,:)=nii.img(:);
end



[r,p]=corr(d,v,'type','spearman');

nii.img(:)=r(:);
nii.fname = ['r_' outname];
ea_write_nii(nii)
nr(:) = r;
nr(p>0.05)=0;
nii.img(:)=nr(:);
nii.fname = ['p_' outname];
ea_write_nii(nii);
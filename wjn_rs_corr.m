function p=wjn_rs_corr(outname,images,v,spear)

try
for a=1:length(images)
    nii = wjn_read_nii(images{a});
    d(a,:)=nii.img(:);
end
catch
    d = images.data';
    nii = images.nii;
end

% keyboard
[r,p]=corr(d,v,'type','pearson');

mii = wjn_read_nii(fullfile(leadp,'greymatter_mask2mm.nii'));
bii = wjn_read_nii(fullfile(leadp,'fBrainMask_05_91x109x91.nii'));

nii.img(:)=r(:).*bii.img(:);
nii.fname = ['R_' outname];
ea_write_nii(nii)
nr(:) = r;
nr(p>0.05)=0;
nii.img(:)=nr(:);
nii.fname = ['pR_' outname];
ea_write_nii(nii);

nii.img(:)=r(:).*mii.img(:);
nii.fname = ['mR_' outname];
ea_write_nii(nii)
nr(:) = r(:).*mii.img(:);
nr(p>0.05)=0;
nii.img(:)=nr(:);
nii.fname = ['mpR_' outname];
ea_write_nii(nii);


if exist('spear','var') && spear
[r,p]=corr(d,v,'type','spearman');

nii.img(:)=r(:);
nii.fname = ['RHO_' outname];
ea_write_nii(nii)
nr(:) = r;
nr(p>0.05)=0;
nii.img(:)=nr(:);
nii.fname = ['pRHO_' outname];
ea_write_nii(nii);
nii.img(:)=r(:).*mii.img(:);
nii.fname = ['mRHO_' outname];
ea_write_nii(nii)
nr(:) = r(:).*mii.img(:);
nr(p>0.05)=0;
nii.img(:)=nr(:);
nii.fname = ['mpRHO_' outname];
ea_write_nii(nii);
end

nii.img(:)=nanmean(d);
nii.fname = ['mdata_' outname];
ea_write_nii(nii)

function wjn_plot_isosurface(nsurf,nblob)

if ~exist('nblob','var')
    nblob = nsurf;
end


spm_imcalc({nsurf,nblob},'temp.nii','(i1>0.001).*i2')

nii=wjn_read_nii('temp.nii')

mi = [1 1 1 1]*nii.mat';
ma = [nii.dim 1]*nii.mat';

xi=1:nii.dim(1);
yi=1:nii.dim(2);
zi=1:nii.dim(3);
n=0;
for a =1:nii.dim(1);
    for b = 1:nii.dim(2);
        for c = 1:nii.dim(3);
            n=n+1;
            mni(a,:)

isosurface(xi,yi,zi,
function h=wjn_plot_axial_nii(Z,filename)

if ischar(filename) || iscell(filename)
    nii=ea_load_nii(filename);
else
    nii=filename;
end
allcoords= [wjn_cor2mni([1 1 1],nii.mat);wjn_cor2mni(nii.dim,nii.mat)];

coord = wjn_mni2cor([0 0 Z],nii.mat);

x = linspace(allcoords(1,1),allcoords(2,1),nii.dim(1));
y = linspace(allcoords(1,2),allcoords(2,2),nii.dim(2));

h=imagesc(x,y,interp2(interp2(flipud(nii.img(:,:,coord(3))'))));
axis equal
box off
axis off


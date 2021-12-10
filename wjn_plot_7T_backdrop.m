function wjn_plot_7T_backdrop(Z,filename)

if ~exist('filename','var')
    filename = 'E:\OneDrive - Charité - Universitätsmedizin Berlin\Dokumente\Data\_non_Datasets\Templates\MNI_ICBM_2009b_NLIN_ASYM\backdrops\7T_100um_Edlow_2019.mat';
    nii = load(filename);
elseif ischar(filename) || iscell(filename)
    nii=load(filename);
else
    nii=filename;
end

coord = wjn_mni2cor([0 0 Z],nii.mat);

imagesc(flipud(nii.img(:,:,coord(3))'))
colormap('gray')
axis equal
box off
axis off
figone(40,40)

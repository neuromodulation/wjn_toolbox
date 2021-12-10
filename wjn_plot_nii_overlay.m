function [axb,axo,hb,ho]=wjn_plot_nii_overlay(back,overlay,Z)

if ischar(back)
    try 
        bd=ea_load_nii(back);
    catch
        bd=load(back);
    end
elseif isempty(back)
    filename = 'E:\OneDrive - Charité - Universitätsmedizin Berlin\Dokumente\Data\_non_Datasets\Templates\MNI_ICBM_2009b_NLIN_ASYM\backdrops\7T_100um_Edlow_2019.mat';
    bd = load(filename);
else
   bd=back;
end

if ischar(overlay)
    try 
        le=ea_load_nii(overlay);
    catch
        le=load(overlay);
    end
else
    le=overlay;
end

nii=bd;
allcoords= [wjn_cor2mni([1 1 1],nii.mat);wjn_cor2mni(nii.dim,nii.mat)];
coord = wjn_mni2cor([0 0 Z],nii.mat);
x = linspace(allcoords(1,1),allcoords(2,1),nii.dim(1));
y = linspace(allcoords(1,2),allcoords(2,2),nii.dim(2));
axb = axes;
hb=imagesc(axb,x,y,flipud(nii.img(:,:,coord(3))'));
colormap(axb,'gray')
% caxis([0 40])
axis equal
box off
axis off
hold on

axo = axes;

nii=le;
allcoords= [wjn_cor2mni([1 1 1],nii.mat);wjn_cor2mni(nii.dim,nii.mat)];
coord = wjn_mni2cor([0 0 Z],nii.mat);
x = linspace(allcoords(1,1),allcoords(2,1),nii.dim(1));
y = linspace(allcoords(1,2),allcoords(2,2),nii.dim(2));
ho=imagesc(axo,x,y,interp2(interp2(flipud(nii.img(:,:,coord(3))'))));
% try
% set(ho,'AlphaDataMapping','scaled','AlphaData',log(ho.CData))
% catch
    set(ho,'AlphaDataMapping','scaled','AlphaData',ho.CData)
% end
% caxis([0 7000000])
colormap(axo,'turbo')
axis equal
box off
axis off
hold off    


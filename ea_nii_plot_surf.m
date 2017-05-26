function ea_nii_plot_surf(gii,nii, mindistance)
% Plot a colored surface base on NIfTI file (heatmap, activition map...)
% The color is coded by the intensity in NIfTI file
% 'spm_surf' is used to construct the surface
% MATLAB GIfTI toobox is used for rendering

if nargin < 2
    mindistance = 0.5;
end
try
    surf = gifti(gii);
catch
    vol = spm_vol(gii);
    img = spm_read_vols(vol);
    output = spm_surf(gii, 2,0.5);
    surffile = output.surffile{1};
    surf = gifti(surffile);
end
vol = spm_vol(nii);
img = spm_read_vols(vol);
ind = find(img);
[Xvox, Yvox, Zvox] = ind2sub(size(img), ind);
vox = [Xvox, Yvox, Zvox];
mm = single(ea_vox2mm(vox, vol.mat));

v.cdata = zeros(size(surf.vertices,1),1);
for i=1:size(surf.vertices,1)
    dist = pdist2(mm, surf.vertices(i,:));
    nearest = find(dist==min(dist),1);
    if min(dist)<=mindistance   
        v.cdata(i) = img(vox(nearest,1),vox(nearest,2),vox(nearest,3));
    else
        v.cdata(i) = nan;
    end
end
% v.cdata = smooth(v.cdata,20);
v.cdata(v.cdata ==0) = nan;
ncdata = round(v.cdata./max(v.cdata).*64);

[r,g,b] = ind2rgb(ncdata,jet);
cdata=[r g b];

% cdata(isnan(v.cdata),1)=.5;
% cdata(isnan(v.cdata),2)=.5;
% cdata(isnan(v.cdata),3)=.5;

figure; plot(surf,v);
figure;
patch('faces',surf.faces,'vertices',surf.vertices,'FaceVertexCData',cdata,'facecolor','interp','edgecolor','none','FaceAlpha',.5)
set(gca,'visible','off')
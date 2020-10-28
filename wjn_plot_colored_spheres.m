function [s, v, ov]=wjn_plot_colored_spheres(mni,v,r, cmap)

if ~exist('v','var') || isempty(v)
    v = ones(size(mni,1),1);
end

ov = v;
if ~exist('r','var')
    r=1;
end



[x,y,z]=sphere(250);

if ~exist('cmap','var')
    cmap = colormap;
end

if exist('v','var') && length(v)==size(mni,1)
    if any(v<0)
        v = round(v./nanmax(abs(v)).*size(cmap,1)/2+size(cmap,1)/2);
    else
        v=round(v./nanmax(v).*size(cmap,1));
    end
    v(v<1)=1;
    %cmap(end,:)=[.5 .5 .5];
    %v(isnan(v))=size(cmap,1);
elseif exist('v','var')
    cmap=repmat(v,size(mni,1),1);
    v=1:size(cmap,1);
else
    cmap=[1 0 0];
    v =ones(size(mni,1));
end


for a = 1:size(mni,1)
    s(a)=surf(r.*x+mni(a,1),r.*y+mni(a,2),r.*z+mni(a,3),'FaceColor',cmap(v(a),:),'EdgeColor','none');
    hold on
end
axis equal
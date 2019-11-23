function s=wjn_plot_colored_spheres(mni,v,r)

if ~exist('r','var')
    r=1;
end

[x,y,z]=sphere;

cmap = colormap;

if exist('v','var') && length(v)==size(mni,1)
    v=round(v./nanmax(v).*size(cmap,1));
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
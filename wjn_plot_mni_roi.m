function ax = wjn_plot_mni_roi(mni,radius,color,alpha)

[x,y,z] = sphere(30);

if ~exist('radius','var')
    radius = .5;
end

if ~exist('color','var')
    color = [.5 .5 .5];
end

if ~exist('alpha','var')
    alpha = .5;
end

for a = 1:size(mni,1)
    ax(a)=surf(mni(a,1)+(x.*2*radius),mni(a,2)+y.*2.*radius,mni(a,3)+z.*2.*radius);
    set(ax(a),'LineStyle','none','facecolor',color,'facealpha',alpha)
    hold on
end

axis equal

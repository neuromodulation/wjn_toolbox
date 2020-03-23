function [b]=sigbar(x,y,color,alpha,lim)
if ~exist('color','var')
    color = [0.8 0.8 0.8];
end
if ~exist('alpha','var')
    alpha = 0.8
end


if ~exist('lim','var')
    lim = get(gca,'ylim');
    y = y*lim(2);
    y(y==0) = lim(1);
end

if ~exist('y','var') || isempty(y)
    y = ones(size(x)).*lim(2);
end

b = bar(x,y,'barwidth',1,'FaceColor',color,'BaseValue',lim(1));
set(b,'FaceAlpha',alpha)
set(b,'EdgeColor','none');

%keyboard
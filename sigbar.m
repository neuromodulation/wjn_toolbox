function [b]=sigbar(x,y,color)
if ~exist('color','var')
    color = [0.8 0.8 0.8]
end
lim = get(gca,'ylim');
y = y*lim(2);
y(y==0) = lim(1);
b = bar(x,y,'barwidth',1,'FaceColor',color,'BaseValue',lim(1));
ch = get(b,'child');
set(ch,'facea',.5)
set(b,'EdgeColor','none');


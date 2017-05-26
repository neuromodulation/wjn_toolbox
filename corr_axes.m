function corr_axes

x=get(gca,'Position');
s = get(gcf,'Position');
set(gcf,'Position',[s(1)+.05 s(2)+.05 s(3)+0.2 s(4)+0.2])
set(gca,'Position',[x(1)+.05 x(2)+.05 x(3)-0.1 x(4)-0.1])
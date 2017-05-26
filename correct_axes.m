function correct_axes(ax)

scale = 0.5;
pos = get(ax, 'Position');
pos(2) = pos(2)+scale*pos(4);
pos(4) = (1-scale)*pos(4);
set(ax, 'Position', pos)
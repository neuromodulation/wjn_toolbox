function resize_figure

fpos=get(gcf,'Position')

axs = findall(gcf,'type','axes');

for a = 1:length(axs)
    get(axs(a),'OuterPosition')
    set(axs(a),'OuterPosition'
    apos(a,:) = get(axs(a),'Position')
end
function wjn_plot_fibers(fc,c)

if ischar(fc)
    fname = fc;
    clear fc
    load(fname)   
        if ~exist('fc','var')
            for a = 1:length(ids)
                fc{a} = fibers(fibers(a,4)==ids(a));
            end
        end
end

for a = 1:length(fc)
    h=plot3(fc{a}(:,1),fc{a}(:,2),fc{a}(:,3));
    hold on
    if exist('c','var')
        set(h,'color',c);
    end
end

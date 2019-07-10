function h=wjn_plot_fibers(fc,c)

if ~exist('c','var')
    c=colorlover(19);
end

if ischar(fc)
    fname = fc;
    clear fc
    load(fname)   
        if ~exist('fc','var')
            for a = 1:length(ids)
                fc{a} = fibers(fibers(:,4)==ids(a),:);
            end
        end
elseif ~iscell(fc)
    fibers = fc;
    i = unique(fibers(:,4));
    fc={};
    for a =1:length(i)
        fc{a} = fibers(fibers(:,4)==i(a),:);
    end
end

if size(c,1)>1
    nx=linspace(1,size(c,1),length(fc));
    c = [interp1(1:size(c,1),c(:,1),nx'),interp1(1:size(c,1),c(:,2),nx'),interp1(1:size(c,1),c(:,3),nx')];
elseif size(c,1)==1
    c = repmat(c,[length(fc),1]);  
end


for a = 1:length(fc)
    h(a)=plot3(fc{a}(:,1),fc{a}(:,2),fc{a}(:,3),'linewidth',.05);
    hold on
    if exist('c','var')
        set(h(a),'color',c(a,:));
        h(a).Color(4)=.2;

        
    end
end

axis equal 
axis off
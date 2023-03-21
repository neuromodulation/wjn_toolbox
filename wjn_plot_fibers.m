function h=wjn_plot_fibers(fc,c,dec,m)

if ~exist('c','var')
    c=colorlover(19);
end

if ~exist('m','var') || ~m
    m = 1;
elseif m
    m = -1;

end

if ~exist('dec') || isempty(dec) || ~dec
    dec = 1;
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

fc = fc(1:dec:end);

if size(c,1)>1
    nx=linspace(1,size(c,1),length(fc));
    c = [interp1(1:size(c,1),c(:,1),nx'),interp1(1:size(c,1),c(:,2),nx'),interp1(1:size(c,1),c(:,3),nx')];
elseif size(c,1)==1
    c = repmat(c,[length(fc),1]);  
end

colormap('viridis');
for a = 1:length(fc)
%     h(a)=plot3(m.*fc{a}(:,1),fc{a}(:,2),fc{a}(:,3),'linewidth',.2);
[x,y,z]=tubeplot([m.*fc{a}(:,1),fc{a}(:,2),fc{a}(:,3)]',0.15,30);
h(a) = surf(x,y,z,'edgecolor','none','FaceAlpha',0.5);

% h=streamline(fc,fc);

%  h(a)=streamtube(m.*fc{a}(:,1),fc{a}(:,2),fc{a}(:,3));
%     drawnow
%     camorbit(-1,0)
    hold on
%     if exist('c','var')
%         set(h(a),'EdgeColor','none','FaceColor',c(a,:));
%         h(a).Color(4)=.2;
        
        
%     end
end
% keyboard
% alpha 0.1
axis equal 
axis off
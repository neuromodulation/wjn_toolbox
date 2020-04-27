function wjn_boxplot(y,cmap,x,bwidth,str)

if ~exist('cmap','var') || isempty(cmap)
    try
        cmap = [colorlover(5,0); colorlover(6,0)];
        cmap = cmap([1 3 6 5 4 2 7 8 9 10],:);
        cmap = repmat(cmap,[20,1]);
    catch
        cmap = [1 0 0;0 1 0;0 0 1];
    end
else
    for a = 1:10
        cmap = [cmap;cmap];
    end
end
if ~exist('bwidth','var') || isempty(bwidth)
    bwidth=1;
end
if ~exist('x','var') || isempty(x)
    x=1:size(y,2);
end
if ~exist('ec','var') || isempty(ec)
    ec = 'k';
    bc = ec;
elseif strcmp(ec,'none')
    bc = 'k';
end

oc = ec;
% figure

l = size(y,2);
% if ~exist('x','var') || isempty(x)
% x = 1:l;
% end
    b=boxplot(y,x,'Whisker',1,'width',bwidth,'boxstyle','filled','color','k','medianstyle','line','positions',x);
       hold on
for a=1:l
%     if strcmp(oc,'c')
%         ec = cmap(a,:);
%     end
%     ny = nan(1,l);
%     if iscell(y)
%         ny(1,a) = nanmean(y{:,a},1);
%         my(a)= nanmean(y{:,a},1);
%         sy(1,a) = sem(y{:,a});
% 
%     else
%         ny(1,a) = nanmean(y(:,a),1);
%         my(1,a) = nanmean(y(:,a),1);
%         sy(1,a) = sem(y(:,a));
%     end
%     keyboard
%        b(a) = bar(x,ny,'FaceColor',cmap(a,:),'barwidth',bwidth,'Edgecolor',ec);
% keyboard
   set(b(2,a),'color',cmap(a,:),'linewidth',bwidth*10);
   set(b(3,a),'XData',[x(a)-.2*bwidth,x(a)+.2*bwidth]);
   scatter(ones(size(y,1),1).*a,y(:,a),'k.');
   if exist('str','var')
       for c=1:size(y,1)
           text(a,y(c,a),['.    ' wjn_strrep( str{c})],'FontSize',5)
       end
   end

%    set(b(3,a),'width',1)
%     b(a) = bar(x,ny,'FaceColor',cmap(a,:),'barwidth',bwidth);
    hold on
end

% keyboard


% boxplot(y,x,'symbol','k','width',.2,'boxstyle','filled','color',[.8 .8 .8],'medianstyle','line')
set(gca,'XTickLabelRotation',45)
function [b,e] = mybar(y,cmap,x,bwidth,ec,id)

if ~exist('id','var')
    id = 0;
end

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

if ~exist('ec','var') || isempty(ec)
    ec = 'k';
    bc = ec;
elseif strcmp(ec,'none')
    bc = 'k';
end

oc = ec;
% figure

l = size(y,2);
if ~exist('x','var') || isempty(x)
x = 1:l;
end
for a=1:l
    if strcmp(oc,'c')
        ec = cmap(a,:);
    end
    ny = nan(1,l);
    if iscell(y)
        ny(1,a) = nanmean(y{:,a},1);
        my(a)= nanmean(y{:,a},1);
        sy(1,a) = sem(y{:,a});

    else
        ny(1,a) = nanmean(y(:,a),1);
        my(1,a) = nanmean(y(:,a),1);
        sy(1,a) = sem(y(:,a));
    end
%     keyboard
       b(a) = bar(x,ny,'FaceColor',cmap(a,:),'barwidth',bwidth,'Edgecolor',ec);
%     b(a) = bar(x,ny,'FaceColor',cmap(a,:),'barwidth',bwidth);
    hold on
end
% keyboard
for a = 1:length(my)
    if strcmp(oc,'c')
        bc = cmap(a,:);
    end
    if my(a)<0
        e=errorbar(x(a),my(a),sy(a),zeros(size(sy(a))),'LineStyle','none','color',bc,'Marker','none','Capsize',0);
    elseif my(a)>0
        e=errorbar(x(a),my(a),zeros(size(sy(a))),sy(a),'LineStyle','none','color',bc,'Marker','none','Capsize',0);
%     else
%         e=errorbar(x,my,sy,'LineStyle','none','color','k');
    end
       hold on
 hold on
end
% keyboard
if id
    for a = 1:length(x)
        for b = 1:size(y,1)
            text(x(a)-(.5*bwidth),y(b,a),'-','HorizontalAlignment','center')
        end
%         plot(x(a)-.55*bwidth,y(:,a),'Marker','<','MarkerFaceColor','k','MarkerEdgeColor','none','LineStyle','none','MarkerSize',1.5)
    end
end
xlim([0 x(a)+1])
figone(5)
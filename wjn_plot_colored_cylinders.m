function [h,v,ov]=wjn_plot_colored_cylinders(mni,v,r,cmap,height)

if ~exist('height','var')
    height = 4;
end

if ~exist('v','var') || isempty(v)
    v = ones(size(mni,1),1);
end

ov = v;
if ~exist('r','var')
    r=1;
end


if ~exist('cmap','var')
    cmap = colormap;
end

if exist('v','var') && length(v)==size(mni,1)
    if any(v<0)
        v = round(v./nanmax(abs(v)).*size(cmap,1)/2+size(cmap,1)/2);
    else
        v=round(v./nanmax(v).*size(cmap,1));
    end
    v(v<1)=1;
    %cmap(end,:)=[.5 .5 .5];
    %v(isnan(v))=size(cmap,1);
elseif exist('v','var')
    cmap=repmat(v,size(mni,1),1);
    v=1:size(cmap,1);
else
    cmap=[1 0 0];
    v =ones(size(mni,1));
end



% Loop through each cylinder
for i = 1:size(mni,1)
%     L = [mni(i,:)-((height/2).*(mni(i,:)./pdist2(mni(i,:),[0 -70 17])));mni(i,:)+((height/2).*(mni(i,:)./pdist2(mni(i,:),)))];
%    keyboard
    T= [0 -35 17];
    X = mni(i,:);
   Pmatrix = [round(linspace(T(1),X(1),100));
           round(linspace(T(2),X(2),100));
           round(linspace(T(3),X(3),100))]';
       ic=wjn_sc(pdist2(X,Pmatrix),1);
    [X,Y,Z] = cylinder2P(r,50,mni(i,:),Pmatrix(ic,:));
    h(i,1) = surf(X,Y,Z,'facecolor','none','LineStyle','-','EdgeColor','none');
    h(i,2) = fill3(X(1,:),Y(1,:),Z(1,:),cmap(v(i),:),'EdgeColor','none');
% %     h(i,3) = fill3(X(2,:),Y(2,:),Z(2,:),cmap(v(i),:),'EdgeColor',cmap(v(i),:));
    hold on
end


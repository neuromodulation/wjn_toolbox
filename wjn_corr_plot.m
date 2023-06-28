function [rho,prho,r,p,s,pl]=wjn_corr_plot(d1,d2,c,perm)

if ~exist('perm','var')
    perm=0;
end

if ~exist('d2','var')
    d2=d1;
    d1 = [1:size(d1,1)]';
end

dx = d1;
nr = size(dx,2);

for nx = 1:nr
    d1 = dx(:,nx);
    if nr>1
        subplot(1,nr,nx)
    end
i = [find(isnan(d1));find(isnan(d2))];
if ~isempty(i)
    d1(i) = [];
    d2(i) = [];
end
  
% keyboard
if ~exist('type','var')
    type = 'spearman';
end

if ~exist('c','var') || isempty(c)
    c = [.2 .2 .2];
end
if perm

[rho,prho,r,p]=wjn_pc(d1,d2);

else
    [rho,prho]=corr(d1,d2,'rows','pairwise','type','spearman');
    
    [r,p]=corr(d1,d2,'rows','pairwise','type','pearson');
end

if (~lillietest(d1) && ~lillietest(d2)) || (~kstest(d1) && ~kstest(d2))
    dist = 'normal distribution';
else
    dist = 'distribution not normal';
end

% s=scatter(d1,d2,40,'Marker','o','MarkerFaceColor',c,'MarkerEdgeColor','none');
hold on
[x,y]=mycorrline(d1,d2,min(d1)-1*abs(min(d1)),max(d1)+1*abs(max(d1)));
pl=plot(x,y,'LineWidth',3,'color',[.6 .6 .6]);
s=scatter(d1,d2,350,'Marker','.','MarkerFaceColor',c,'MarkerEdgeColor',c);
try
xlim([min(d1)-.15*abs(min(d1)) max(d1)+.15*max(d1)])
end
try
ylim([min(d2)-.15*abs(min(d2)) max(d2)+.15*max(d2)])
end
legend(pl,sprintf([' \\rho = ' num2str(rho,3) ' P = ' num2str(prho,3) ' \n R = ' num2str(r,3) ' P = ' num2str(p,3) ' \n ' dist]),'location','southoutside');
end
set(gca,'box','on')
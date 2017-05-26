function [r,p,s]=wjn_corr_plot(d1,d2,c,type)

if ~exist('d2','var')
    d2=d1;
    d1 = [1:size(d1,1)]';
end

i = [find(isnan(d1)) find(isnan(d2))];
if ~isempty(i)
    d1(i) = [];
    d2(i) = [];
end
    
if ~exist('type','var')
    type = 'spearman';
end

if ~exist('c','var')
    c = [.5 .5 .5];
end
for a = 1:15
[rho,prho(a),r,p(a)]=wjn_pc(d1,d2);
end
p = min(p);
prho = min(prho);
if (~lillietest(d1) && ~lillietest(d2)) || (~kstest(d1) && ~kstest(d2))
    dist = 'normal';
else
    dist = 'not normal';
end

s=scatter(d1,d2,'Marker','o','MarkerFaceColor',c,'MarkerEdgeColor','w');
hold on
[x,y]=mycorrline(d1,d2,min(d1)+.05*abs(min(d1)),max(d1)-.05*abs(max(d1)));
pl=plot(x,y,'LineWidth',2,'color',[.6 .6 .6]);
xlim([min(d1)-.15*abs(min(d1)) max(d1)+.15*max(d1)])
ylim([min(d2)-.15*abs(min(d2)) max(d2)+.15*max(d2)])
legend(pl,sprintf([' \\rho = ' num2str(rho,3) ' P = ' num2str(prho,3) ' \n R = ' num2str(r,3) ' P = ' num2str(p,3) ' \n ' dist]),'location','southoutside');

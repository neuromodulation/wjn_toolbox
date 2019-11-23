function [r,p,cb,cp]=wjn_lm_plot(d1,d2,c)

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
  
if ~exist('c','var')
    c = [.2 .2 .2];
end


    mdl=fitlm(d1,d2);
r = mdl.Rsquared.Ordinary;
p = mdl.coefTest;
cb = mdl.Coefficients.Estimate(2);
cp=mdl.Coefficients.pValue(2);
d1 = mdl.predict;

if (~lillietest(d1) && ~lillietest(d2)) || (~kstest(d1) && ~kstest(d2))
    dist = 'normal distribution';
else
    dist = 'distribution not normal';
end

s=scatter(d1,d2,40,'Marker','o','MarkerFaceColor',c,'MarkerEdgeColor','w');
hold on
[x,y]=mycorrline(d1,d2,min(d1)-1*abs(min(d1)),max(d1)+1*abs(max(d1)));
pl=plot(x,y,'LineWidth',3,'color',[.6 .6 .6]);
s=scatter(d1,d2,40,'Marker','o','MarkerFaceColor',c,'MarkerEdgeColor',c);
try
xlim([min(d1)-.15*abs(min(d1)) max(d1)+.15*max(d1)])
end
try
ylim([min(d2)-.15*abs(min(d2)) max(d2)+.15*max(d2)])
end
l=legend(pl,sprintf(['R² = ' num2str(r,2) ' P = ' num2str(p,2) ' \n B = ' num2str(cb,2) ' P = ' num2str(cp,2) ' \n ' dist]),'location','southoutside');
end
set(gca,'box','on')
l.Box = 'off';
% keyboard
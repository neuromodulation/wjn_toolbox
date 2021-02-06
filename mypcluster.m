function [p,i]=mypcluster(P,pthresh,showplot)
% [p,i]=mypcluster(P,pthresh)
% P = vector of P-values
% pthresh = threshold (default p<=0.05)


P = 1-P;

if ~exist('pthresh','var') || isempty(pthresh);
    pthresh = .05;
end

im = [];tm = [];rn = [];
[om,on] = bwlabeln(P>=1-pthresh);
for a = 1:on;
    im{a} = find(om==a);
    tm(a) = sum(P(im{a}));
end

[pmin,imin]=max(abs(tm));
i= im{imin};


for b = 1:10000;
    r = P(randperm(length(P)));
    
im = [];tm = [];
[om,on] = bwlabeln(r>=1-pthresh);
for a = 1:on;
    im{a} = find(om==a);
    tm(a) = sum(P(im{a}));
end

    rn(b) = max(tm);
end
    
sr = sort(rn);
p = 1-sc(sr,pmin)/10000;




if exist('showplot','var') && showplot
    figure
    subplot(6,1,1:4)
    plot(sr(end:-1:1),'color','k','linewidth',2);
    set(gca,'XTick',[1000:1000:10000],'XTickLabel',[0.1:.1:1])
    hold on
    
    xlabel('P-Value')
    scatter(10000-sc(sr,pmin),pmin,'ro','filled')
    title(['P = ' num2str(p)])
    subplot(6,1,6)
    y=zeros(size(P));
    y(i) = 1;
    sigbar(1:length(P),y)
    figone(7)
    set(gca,'YTick',[])
    text(i(1),.5,num2str(i(1)),'fontsize',6,'HorizontalAlignment','right');
    text(i(end),.5,num2str(i(end)),'fontsize',6)
end
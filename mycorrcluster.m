function [p,i]=mycorrcluster(R,n,tail,tt,showplot)
% [p,i]=mycorrcluster(R,n) 
% R = vector of R values
% n = number of observations for each R value
% tail = [1 = both,2=right,3=left]; default = 1;
% t = T-threshold ; default = 1.96 / 1.64
% showplot (default = 0);

thresh = [1.96 1.64 1.64];
tfunc = {'abs(t)>=','t>=','-t>='};
rfunc = {'abs(r)>=','r>=','-r>='};

if ~exist('tail','var')
    tail = 1;
end

if ~exist('tt','var') || isempty(tt)
    tt = thresh(tail);
end

for a = 1:length(R);
    rho = R(a);
    t(a) = rho.*sqrt((n-2)./(1-rho.^2)); 
end


eval(['[om,on] = bwlabeln(' tfunc{tail} num2str(tt) ');']);

for a = 1:on;
    im{a} = find(om==a);
    tm(a) = sum(t(im{a}));
end

[tmax,imax]=max(abs(tm));
i= im{imax};


for b = 1:10000;
    r = t(randperm(length(t)));
    
    eval(['[om,on] = bwlabeln(' rfunc{tail} num2str(tt) ');']);
    for a = 1:on;
        im{a} = find(om==a);
        tm(a) = sum(t(im{a}));
    end

    rn(b) = max(tm);
end
    
sr = sort(rn);
p = sc(sr,tmax)/100-100;


if exist('showplot','var') && showplot
    figure
    plot(sr(end:-1:1),'color','k','linewidth',2);
    set(gca,'XTick',[1000:1000:10000],'XTickLabel',[0.1:.1:1])
    hold on
    figone(7)
    xlabel('P-Value')
    scatter(10000-sc(sr(end:-1:1)+1,tmax),tmax,'ro','filled')
    title(['P = ' num2str(p)])
end

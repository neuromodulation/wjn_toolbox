function brueckeplot(x,data)

% x should be a vector of size 1*npoints defining the axis (e.g. frequencies)
% data can be a vector or matrix of size nsamples*npoints where npoints of
% y must be equal to npoints of x
% median and standard deviation will be calculated across nsamples


mdata=median(data,1); %calculate median
upstd=mdata+std(data); %calculate upper std
lowstd=mdata-std(data); %calculate lower std
y=[lowstd;upstd-lowstd]'; %calculate a 2 row matrix for the area plot
stdplot=area(x,y); %plot the area
set(stdplot(1),'FaceColor','none')
set(stdplot(2),'FaceColor',[0 0.3 0.6])% set the first area plot to invisible
set(stdplot(1),'LineStyle','none')
set(stdplot(2),'LineStyle','--','LineWidth',0.5) % delete lines from area plots
stdplotc=get(stdplot(2),'children'); % make children
set(stdplotc,'FaceAlpha',0.5); % set Face Alpha to make the area transparent
hold on;
plot(x,mdata,'Color','k','LineWidth',1.5,'LineSmoothing','on'); % plot the median


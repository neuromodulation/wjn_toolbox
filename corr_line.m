function h=corr_line(x,y)

 fit=polyfit(x,y,1);hold on;
 xaxis = linspace(min(x),max(x),numel(x));
        rl = polyval(fit,xaxis);
        h=plot(xaxis,rl,'color',[0.8 0.8 0.8],'LineWidth',2);
        
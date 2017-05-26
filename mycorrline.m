function [x,y] = mycorrline(x,y,xmin,xmax)
% [x,y] = mycorrline(x,y,xmin,xmax)

 fit=polyfit(x,y,1);
    x = linspace(xmin,xmax,50);
    y = polyval(fit,x);
function h = wjn_plot(x,y)

if ~exist('y','var')
    h=plot(squeeze(x));
else
    h=plot(squeeze(x),squeeze(y));
end
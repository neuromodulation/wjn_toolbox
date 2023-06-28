function wjn_contourp(t,f,p,c)

if ~exist('c','var')
    c = 'k';
end
squeeze(p);
contour(t,f,p,1,'color',c,'linewidth',.5,'linestyle','--')
function [o] = close_peaks(coord,pvals,distance)
%function [o] = close_peaks(coords,pval,distance)
% Script to find peaks in mni space with a smaller distance in mm
% the output is the coordinate table for all peaks with the redundant
% coordinates removed according to significance

if isempty(pvals)
    o=[]
    warning('No significant p-values found')
    return
 
end

for a = 1:length(pvals)
    if iscell(coord)
        coords(:,a) = coord{a};
    else
        coords(:,a) = coord(:,a);
    end
    if iscell(pvals)
        pval(a) = pvals{a};
    else
        pval(a) = pvals(a);
    end
end
coords(:,pval>0.05) = [];pval(pval>0.05) =[];
c = nan(size(coords,2),size(coords,2));
for a= 1:size(coords,2)
    for b = 1:size(coords,2)
        if ~isequal(a,b)
            c(a,b) = sqrt((coords(1,a)-coords(1,b))^2 ...
                + (coords(2,a)-coords(2,b))^2 ...
                + (coords(3,a)-coords(3,b))^2)           
        elseif isequal(a,b) 
            c(a,b) = nan;
        end
    end
end
n=0;
[x,y] = find(c<distance);
if ~isempty(x);
for a = 1:2:length(x);
    n=n+1;
    if pval(x(a)) < pval(y(a))
        nc(:,n) = coords(:,x(a))
        i(n) = x(a);
        r(n) = y(a);
    elseif pval(x(a)) > pval(y(a))
        nc(:,n) = coords(:,y(a))
        i(n) = y(a);
        r(n) = x(a);
    end
end
o = coords;
o(:,r) = [];
else
    o = coords;
end
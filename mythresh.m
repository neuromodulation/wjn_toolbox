function x = mythresh(data,threshold,interval)
%function x = mythresh(data,threshold);
% find threshold crossings
x=find(data(1:end-1) < threshold & data(2:end) > threshold);

if exist('interval','var')
    di=mydiff(x,1);
    x(find(di<interval)) =[];
end

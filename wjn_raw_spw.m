function [i,w,p,m,d]=wjn_raw_spw(data,distance,prominence)

if ~exist('prominence','var')
    prominence = 0;
end

if ~exist('distance','var')
    distance = 0;
end



[m,i,w,p]=findpeaks(data,'MinPeakprominence',prominence,'MinPeakDistance',distance);
d=nanmean([mydiff(i(1:end-1)) mydiff(i(2:end))],2);
d=fillmissing([nan;d],'next');


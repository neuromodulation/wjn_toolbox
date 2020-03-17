function [i,w,p,m,d]=wjn_raw_spw(data,prominence)

if ~exist('prominence','var')
    prominence = 1.5;
end


[m,i,w,p]=findpeaks(data,'MinPeakProminence',prominence);
d=nanmean([mydiff(i(1:end-1)) mydiff(i(2:end))],2);
d=fillmissing([nan;d],'next');


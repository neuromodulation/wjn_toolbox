function [i,s,p,w,m,d]=wjn_raw_spw(data,fsample)


[m,i,w,p]=findpeaks(data,'MinPeakDistance',fsample*0.012);
d=nanmean([mydiff(i(1:end-1)) mydiff(i(2:end))],2);
d=fillmissing([nan;d],'next');

ns = round(fsample*.005);

for a =1:length(i)
    if i(a) < ns+1 || i(a) > length(data)-ns
        s(a)=nan;
    else
        s(a) = data(i(a))-mean([data(i(a)-ns) data(i(a)-ns)]);
    end
end


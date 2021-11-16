function [i,s,m,w,p]=wjn_spw_raw(data,fsample,pct)

ish = round(0.005*fsample);
[m,i,w,p]=findpeaks(data);
s = ((m-data(i-ish))+(m-data(i+ish)))./2;
if exist('pct','var')
    ix = s>prctile(s,pct);
    i = i(ix);
    s = s(ix);
    m = m(ix);
    w = w(ix);
    p = p(ix);
end


    
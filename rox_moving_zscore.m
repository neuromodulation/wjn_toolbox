function z=rox_moving_zscore(d,nsamples)

if size(d,2)<size(d,1)
    d=d';
end

movm=movmean(d,[nsamples 0]);
mstd=movstd(d,[nsamples 0]);

z=(d-movm)./mstd;


% 
% for i=ls+1:l
%  n=n+1;
%  zz=wjn_zscore(nd(i-ls:i));
%  z(n) = zz(ls+1);
% end

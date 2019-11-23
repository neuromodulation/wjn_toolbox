function z=wjn_moving_zscore(d,nsamples)

if size(d,2)<size(d,1)
    d=d';
end

sub = nan(1,ceil(nsamples/2));
nd = [sub d sub];
ls = length(sub);
l = length(nd);

n=0;
for i=ls+1:l-ls
n=n+1;
 zz=wjn_zscore(nd(i-ls:i+ls));
 z(n) = zz(ls+1);
end

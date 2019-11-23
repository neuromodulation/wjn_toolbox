function z=rox_moving_mean(d,nsamples)

if size(d,2)<size(d,1)
    d=d';
end

sub = nan(1,ceil(nsamples));
nd = [sub d];
ls = length(sub);
l = length(nd);

n=0;

for i=ls+1:l
 n=n+1;
 m=nanmean(nd(i-ls:i));
 zz=(nd(i-ls:i)-m)./m;
 z(n) = zz(ls+1);
end

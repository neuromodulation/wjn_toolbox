function z=rox_moving_ranknorm(d,nsamples)

if size(d,2)<size(d,1)
    d=d';
end

sub = nan(1,ceil(nsamples));
nd = [sub d];
ls = length(sub);
l = length(nd);

n=0;

for i=ls+1:l-ls
 n=n+1;
 zz=mainvarsetnorm(nd(i-ls:i),nd(i:i+ls));
 z(n) = zz(ls+1);
end

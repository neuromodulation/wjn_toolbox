function xp=wjn_prctile(x,p)

q = quantile(x,100);
xp = q(p);
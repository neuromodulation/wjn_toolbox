function p=wjn_paired_permutation(d1,d2)
% p=wjn_paired_permutation(d1,d2)
% randomly permutes the group of pairs 

if ~exist('d2','var')
    d = d1;
else
    d = d1-d2;
end
n=size(d,1);
ni = 10000;
for a=1:ni
    r = ones(n,1)-(randi([0 1],[n,1]).*2);
    d(:,a+1) = d(:,1).*r;
end
md = nanmean(d);
p = min([1-find(sort(md,'ascend')==md(1))/ni,1-find(sort(md,'descend')==md(1))/ni]);


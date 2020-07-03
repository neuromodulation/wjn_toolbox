function p=wjn_ppt(d1,d2,ni)
% p=wjn_paired_permutation(d1,d2)
% randomly permutes the group of pairs 

if ~exist('d2','var') || isempty(d2)
    d = d1;
else
    d = d1-d2;
end

if isempty(find(d))
    warning('d1 = d2 OR d = 0')
    p = nan;
end


n=size(d,1);
if ~exist('ni','var')
    
    ni = 10000;
    
end

if factorial(length(d))<ni
        ni=factorial(length(d));
    warning(['Limited to ' num2str(ni) ' possible permutations'])
end

for a=1:ni
    r = ones(n,1)-(randi([0 1],[n,1]).*2);
    d(:,a+1) = d(:,1).*r;
end
% keyboard
md = nanmean(d);

[ud,id] = unique(md);
md = md(sort(id));
% plot(md)


if nanmean(d(:,1))<=nanmean(md)
    p =find(sort(md,'ascend')==nanmean(d(:,1)))/length(md);
else
    p=find(sort(md,'descend')==nanmean(d(:,1)))/length(md);
end

p=2*p;
if isempty(p)
    p = nan;
end
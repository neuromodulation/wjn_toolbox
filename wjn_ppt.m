function p=wjn_ppt(d1,d2,ni)
% p=wjn_paired_permutation(d1,d2)
% randomly permutes the group of pairs 

if ~exist('d2','var') || isempty(d2)
    d = d1;
else
    d = d1-d2;
end

if isempty(find(d))
    error('d1 = d2')
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
p = min([1-find(sort(md,'ascend')==md(1),1,'last')/(1+ni),1-find(sort(md,'descend')==md(1),1,'first')/(1+ni)]);


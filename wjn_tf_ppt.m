function [p,fdr,adj_p] = wjn_tf_ppt(tf,ni)

% d = squeeze(tf);
d=tf;
d(isnan(d)) = 0;
% pn = nan(size(tf));
% 
% nxy = isnan(d);
% for a = 1:size(nxy,3)
%     if sum(sum(nxy(:,:,a)))
%         nanrow(a) = 1;
%     else
%         nanrow(a) = 0;
%     end
% end

% d = d(:,:,~nanrow);

n=size(d,1);
if ~exist('ni','var')
    
    ni =500;
    
end

if factorial(n)<ni
        ni=factorial(length(d));
    warning(['Limited to ' num2str(ni) ' possible permutations'])
end
s=size(d);
d(:,:,:,1) = d;
for a=1:ni
    r = ones(s)-(randi([0 1],s).*2);
    d(:,:,:,a+1) = d(:,:,:,1).*r;
end
% keyboard
md = nanmean(d);
s=size(md);
for a = 1:s(2)
    for b = 1:s(3)
        p(a,b) = min([1-find(sort(md(1,a,b,:),'ascend')==md(1,a,b,1),1,'last')/(1+ni),1-find(sort(md(1,a,b,:),'descend')==md(1,a,b,1),1,'first')/(1+ni)]);
    end
end


p = squeeze(p);
[fdr,adj_p]=fdr_bh(p,.05);
% pn(:,~nanrow) = p;
% p = pn;
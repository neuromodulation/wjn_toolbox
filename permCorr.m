function [r,pr,p,pl]=permCorr(x,y,type)

% [r,p]=permCorr(x,y,type,tail,alpha)
% data x subjects

ni = 10000;
if ~exist('type','var')
    type = 'spearman';
end
if ~exist('alpha','var')
    alpha = .05;
end

for a = 1:size(x,2);
r(a) =corr(x(:,a),y,'type',type,'rows','pairwise');
end

for a = 1:size(x,2);
    for b = 1:ni;
        rn(b,a) = corr(x(:,a),y(randperm(length(y))),'type',type,'rows','pairwise');
    end
end

for a = 1:size(x,2);
    srn=sort(rn(:,a));
    p(a) = 1-wjn_sc(srn,abs(r(a)))/ni;
    pr(a) = .5*(1-wjn_sc(srn,r(a))/ni);
    pl(a) = .5*(1-wjn_sc(srn,-r(a))/ni);
end



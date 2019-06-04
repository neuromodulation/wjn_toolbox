function [r,p]=partialpermcorr(x,y,c,type)


if ~exist('type','var')
    type = 'spearman';
end
if ~exist('alpha','var')
    alpha = .05;
end

for a = 1:size(x,2)
    r(a) =partialcorr(x(:,a),y,c,'type',type,'rows','pairwise');
end

for a = 1:size(x,2);
    for b = 1:1000;
        rn(b,a) = partialcorr(x(:,a),y(randperm(length(y))),c,'type',type,'rows','pairwise');
    end
end

for a = 1:size(x,2);
    srn=sort(rn(:,a));
    p(a) = 1-sc(srn,abs(r(a)))/1000;
    pr(a) = .5*(1-sc(srn,r(a))/1000);
    pl(a) = .5*(1-sc(srn,-r(a))/1000);
end



function [r,p]=wjn_permcorr(x,y,type,ni)
%% [r,p]=wjn_permcorr(x,y,type,ni)

if ~exist('ni','var')
    ni = 5000;
end

if ~exist('type','var')
    type = 'spearman';
end





for a = 1:size(x,2)
    for b = 2:ni+1
        y(:,b) = y(randperm(size(y,1)));
    end
        r(:,a) = corr(x(:,a),y,'type',type,'rows','pairwise');
        disp([num2str(a) ' / ' num2str(size(x,2)) ' done'])
end


for a = 1:size(x,2)
    srn=sort(r(2:end,a));
    p(a) = 1-sc(srn,abs(r(1,a)))/ni;
    pr(a) = .5*(1-sc(srn,r(1,a))/ni);
    pl(a) = .5*(1-sc(srn,-r(1,a))/ni);
end
r = r(1,:);
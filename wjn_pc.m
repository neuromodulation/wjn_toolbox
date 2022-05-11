function [rho,prho,r,pr]=wjn_pc(x,y,ni)
%% [r,p]=wjn_permcorr(x,y,ni)

if ~exist('ni','var')
    ni = 100000;
end

if ~exist('y','var') || isempty(y)
    y = [1:size(x,1)]';
end
% keyboard


for a = 1:size(x,2)
    for b = 2:ni+1
        y(:,b) = y(randperm(size(y,1)));
    end
        rho(:,a) = corr(x(:,a),y,'type','spearman','rows','pairwise');     
        r(:,a) = corr(x(:,a),y,'type','pearson','rows','pairwise');
        disp([num2str(a) ' / ' num2str(size(x,2)) ' done'])
end


for a = 1:size(x,2)
    srn=sort(r(2:end,a));
    srhon=sort(rho(2:end,a));
    pr(a) = 1-wjn_sc(srn,abs(r(1,a)))/ni;
    prho(a) = 1-wjn_sc(srhon,abs(rho(1,a)))/ni;
end
r = r(1,:);
rho = rho(1,:);
for a = 1:length(r)
    N = sum(~nansum(isnan([x(:,a),y])'));
    disp(['N = ' num2str(N)]);
    disp(['Rho = ' num2str(rho(a)) ' P = ' num2str(prho(a))])
    disp(['R = ' num2str(r(a)) ' P = ' num2str(pr(a))])
end

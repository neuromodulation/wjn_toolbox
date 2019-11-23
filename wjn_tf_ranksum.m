function [p,fdr,adj_p]=wjn_tf_ranksum(tf1,tf2,alpha)

if ~exist('alpha','var')
    alpha = 0.05;
end

d1 = tf1;
d2 = tf2;


n=size(d1);

for  a= 1:n(2)
    for b = 1:n(3)
        try
            p(a,b) = ranksum(d1(:,a,b),d2(:,a,b));
        catch
            p(a,b) = nan;
        end
    end
end

p = squeeze(p);
[fdr,adj_p]=fdr_bh(p,alpha);
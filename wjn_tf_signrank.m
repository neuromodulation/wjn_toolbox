function [p,fdr,adj_p]=wjn_tf_signrank(tf,alpha)

if ~exist('alpha','var')
    alpha = 0.05;
end

if size(tf,2)>1
d = squeeze(tf);
else
    d=tf;
end


n=size(d);

if length(n)>2

for  a= 1:n(2)
    for b = 1:n(3)
        try
            p(a,b) = signrank(d(:,a,b));
        catch
            p(a,b) = nan;
        end
    end
end

else
    for  a= 1:n(2)
        try
            p(a) = signrank(d(:,a));
        catch
            p(a) = nan;
        end

    end
end
p = squeeze(p);
[fdr,adj_p]=fdr_bh(p,alpha);

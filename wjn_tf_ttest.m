function [p,fdr,adj_p]=wjn_tf_ttest(tf)


d = squeeze(tf);


n=size(d);

for  a= 1:n(2)
    for b = 1:n(3)
        try
            [~,p(a,b)] = ttest(d(:,a,b));
        catch
            p(a,b) = nan;
        end
    end
end

p = squeeze(p);
[fdr,adj_p]=fdr_bh(p,.05);

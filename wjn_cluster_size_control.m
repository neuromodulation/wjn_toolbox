function [ncluster,nzcluster]=wjn_cluster_size_control(cluster,threshold)

cc = bwconncomp(cluster,4);
nc = cc.NumObjects;
cc = cc.PixelIdxList;
for a = 1:nc
    if length(cc{a})<=threshold
        cluster(cc{a}) = 0;
%     else
%         clusters(clusters==a) = 1;
    end
end
% cluster(cluster==0) = nan;
ncluster = nan(size(cluster));
ncluster(cluster==1)=1;
nzcluster = ncluster;
nzcluster(isnan(nzcluster))=0;
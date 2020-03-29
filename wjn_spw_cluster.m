function clust = wjn_spw_cluster(M,n,varnames,z)

if ~exist('varnames','var') || isempty(varnames)
    varnames = strcat({'var'},num2str([1:size(M,2)]'));
end

if ~exist('z','var') || isempty(z)
    z=1;
end

if ~exist('n','var')    
    n=5;
end

if z
    zM=zscore(M);

[idx,C,sumd,D] = kmeans(zM,n);
else
    
[idx,C,sumd,D] = kmeans(M,n);
end


figure
imagesc(C)
set(gca,'XTick',1:size(C,2),'XTickLabel',varnames,'XTickLabelRotation',45)
set(gca,'YTick',1:size(C,1))
ylabel('Cluster')

i =find(idx==8);


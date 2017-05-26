function [clusters,info] = clear_clusters(data,min)
% data
% min = threshold for exported clustersize;
clear clusters
s = size(data);
D=bwconncomp(data)
nD = bwlabel(data);
unD= nD;
cl = D.PixelIdxList;
n = length(cl);
for a = 1:n;
 if length(cl{a})<min;
     nD(nD==a) = -1;
 end
 info.clustersizes(a) = length(cl{a});
end

figure;
ax=imagesc(unD);axis xy;myfont(gca);
for a = 1:n;
    mTextBox = annotation('textbox');
    set(mTextBox,'String',[num2str(info.clustersizes(a)) ' points']);
    set(mTextBox,'EdgeColor','none');
    [xp,yp]=ind2sub(s,cl{a});
    [pos]=dsxy2figxy([floor(mean(yp)) floor(mean(xp)) 1 1]);
    set(mTextBox,'Position',pos,'Color',[0.5 0.5 0.5])
    myfont(mTextBox);
end
% myprint('cluster_counter');
% 
nD(nD==-1)= 0;
nD(nD>=1) = 1;

info.nclusters = n;
info.clusters = cl;
clusters = nD;


     
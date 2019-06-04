function [h,ax]=wjn_contourf(t,f,tf,nc)
if ~exist('f','var') && ~exist('tf','var')
    tf = squeeze(t);
    t = 1:size(tf,2);
    f = 1:size(tf,1);
%     t= 1:size(tf,1);
end

if ~exist('nc','var')
    nc = 20;
end
tf = squeeze(tf);

if length(size(tf))==3 && size(tf,1)>1
    tf = squeeze(nanmean(tf,1));
end



[~,h]=contourf(t,f,tf,nc,'LineStyle','none');
ax=gca;
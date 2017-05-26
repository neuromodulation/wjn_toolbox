function [h,ax]=wjn_contourf(t,f,tf,nc)

if ~exist('nc','var')
    nc = 20;
end
contourf(t,f,tf,nc,'LineStyle','none');
function [mat,cp,est]=wjn_eeg_sst_pca(rall)
if size(rall,3)>1
mat=rall(:,:,1:end-1);
pp=shiftdim(rall,2);
[mat(:),cp,~,~,est]=pca(pp(:,:));
mat = shiftdim(mat,2);
else
    mat=rall(:,1);
    pp = shiftdim(rall,1);
    [mat,cp,~,~,est]=pca(pp(:,:));
    mat = mat';
end
% keyboard




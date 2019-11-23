function wjn_eeg_vm_tf_plot_corr(t,f,mtf,v,label)


% x = squeeze(mtf(:,:,:,2)-mtf(:,:,:,1));
% x = squeeze(nanmean(mtf(:,:,:,[1 2]),4));
% y = nanmean(focus(:,1:2),2);
x=mtf(:,:);
y=v;
% x1 = squeeze(mtf(:,:,:,1));
% x2 = squeeze(mtf(:,:,:,2));
% x = [x1(:,:);x2(:,:)];
% y = [focus(:,1);focus(:,2)];
[r,p] = wjn_pc(x(:,:),y);
% [r,p] = corr(x(:,:),focus(:,3),'rows','pairwise','type','spearman');
% pt = fdr_bh(p);
np = nan(size(mtf,2),size(mtf,3));
np(:) = p(:);
% np(:,wjn_sc(t,1.5):end)=nanr;
% np(:,1:wjn_sc(t,-1.5))=nan;
nr=np;
nr(:) = r(:);
pt = fdr_bh(np);
%
figure
wjn_contourf(t,f,nr)
% hold on
% wjn_contourp(t,f,np<=.05)
% wjn_contourp(t,f,np<=pt,'r')
caxis([-.4 .4])
TFaxes
figone(7)
myprint([label '_corr_RHO'])
% colorbar
% myprint('SMA_merr_corr_RHO_colorbar')
nnp = wjn_cluster_size_control(np<=.05,1);
nnnp = nan(size(nnp));
% nnnp = np<=.05;
nnnp(nnp==1)=.5;
cnnp = nan(size(nnnp));
cnnp(np<=pt)=1;
figure
wjn_contourf(t,f,nnnp)
hold on 
wjn_contourf(t,f,cnnp,3)
colormap([1 1 1;.5 .5 .5;0 0 0])
caxis([0 1])
TFaxes
figone(7)
myprint([label '_corr_P'])
%
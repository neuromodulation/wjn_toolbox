function np=wjn_eeg_vm_plot_tf_diff_stats(t,f,ctf,label)


[p,fdr,adj_p] = wjn_tf_ppt(ctf);

% pt = fdr_bh(p(1:40,wjn_sc(t,-1.5):wjn_sc(t,1.5)));
 pt = fdr_bh(p);
nnp = wjn_cluster_size_control(p<=0.05,50).*.5;
np = wjn_cluster_size_control(p<=pt,50);
% np = p<=pt;
% np = p<=0.05;
figure
% subplot(2,1,1)
wjn_contourf(t,f,ctf,30)
% imagesc(t,f,squeeze(nanmean(ctf))),axis xy
xlim([t(1) t(end)])
ylim([f(1) f(end)])
TFaxes
caxis([-5 10])
title(label)
figone(5);
myprint([label '_TF'])
colorbar
myprint([label '_TF_colorbar'])

figure
% subplot(2,1,2)
pm=nan(size(adj_p));
pm(adj_p<=0.05) = adj_p(adj_p<=0.05);

% caxis([-50 50])
% pm = adj_p<=0.05;
% figure
colormap([1 1 1;.5 .5 .5;0 0 0]);
% colormap('gray')
wjn_contourf(t,f,nnp,3);
hold on 
wjn_contourf(t,f,np,3);
xlim([t(1) t(end)])
ylim([f(1) f(end)])
caxis([0 1])
TFaxes
figone(5)
myprint([label '_P'])
function h=wjn_eeg_vm_plot_tf_stats(t,f,ctf,label)


[p,fdr,adj_p] = wjn_tf_ppt(ctf);

pt = fdr_bh(p(1:99,wjn_sc(t,-2.5):wjn_sc(t,3.5)));
 
np = wjn_cluster_size_control(adj_p<=.05,300);
% keyboard
figure
% subplot(2,1,1)
wjn_contourf(t,f,ctf,30)
% imagesc(t,f,interp2(interp2(squeeze(nanmean(ctf))))),axis xy;%,250)
xlim([-2 3.5])
ylim([3 49])
TFaxes
caxis([-30 50])
title(label)
figone(5);
myprint([label '_TF'])
colorbar
myprint([label '_TF_colorbar'])
figure
% subplot(2,1,2)
% pm=nan(size(adj_p));
% pm(adj_p<=0.05) = adj_p(adj_p<=0.05);

% caxis([-50 50])
% pm = adj_p<=0.05;
% figure
colormap([1 1 1;0 0 0]);
% colormap('gray')
wjn_contourf(t,f,np,2)
xlim([-2 3.5])
ylim([3 49])
TFaxes
figone(5)
myprint([label '_P'])
function h = wjn_plot_rest_pac(coh,chs,conds)

if ~exist('chs','var') || isempty(chs)
    chs = 1:numel(coh.channels);
end

if ~exist('conds','var') || isempty(conds)
    conds = 1:numel(coh.condition);
end


figure,
h=imagesc(coh.f1,coh.f2,interp2(interp2(squeeze(nanmean(nanmean(coh.pac(chs,:,:,conds),1),4)))));
hold on
c=get(gca,'clim');
axis xy
if numel(chs)==1 && numel(conds) ==1;
    contour(coh.f1,coh.f2,squeeze(coh.ppac(chs,:,:,conds))<0.05,1,'color','k','linewidth',2);
    contour(coh.f1,coh.f2,squeeze(coh.ppac(chs,:,:,conds))<fdr_bh(squeeze(coh.ppac(chs,:,:,conds)),0.05),1,'color','r','linewidth',2);
    set(gca,'clim',c)
end
PACaxes
colorbar
figone(10,13)
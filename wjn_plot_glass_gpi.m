function wjn_plot_glass_gpi
% figure
leadf = leadt;
wjn_plot_surface(fullfile(leadf,'GPi.nii'))
iskull  = export(nifti(fullfile(leadf,'GPi.nii')), 'patch');
p=patch('vertices',iskull.vertices,'faces',iskull.faces,'EdgeColor',[0.5 0.5 0.5],'FaceColor','none');
set(p,'EdgeAlpha',0.1)
hold on

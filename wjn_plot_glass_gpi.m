function wjn_plot_glass_gpi
% figure
[~,~,~,~,~,leadf]=getsystem; 
iskull  = export(nifti(fullfile(leadf,'templates','cmni_GPi.nii')), 'patch');
p=patch('vertices',iskull.vertices,'faces',iskull.faces,'EdgeColor',[0.5 0.5 0.5],'FaceColor','none');
set(p,'EdgeAlpha',0.1)
hold on

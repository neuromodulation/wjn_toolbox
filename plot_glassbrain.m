function plot_glassbrain
figure
iskull  = export(gifti(fullfile(spm('dir'), 'canonical', 'iskull_2562.surf.gii')), 'patch');
p=patch('vertices',iskull.vertices,'faces',iskull.faces,'EdgeColor',[0.5 0.5 0.5],'FaceColor','none');
set(p,'EdgeAlpha',0.1)
hold on
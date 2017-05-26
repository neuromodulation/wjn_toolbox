function p = wjn_plot_surface(filename,color,alpha)




if ~exist('alpha','var')
    alpha = .5;
end

if ~exist('color','var')
    color = colorlover(5);
    color = color(1,:);
end
try
    s=export(gifti(filename));
catch
    filename=wjn_extract_surface(filename);
    s=export(gifti(filename));
end

p=patch('vertices',s.vertices,'faces',s.faces,'Facecolor',color,'EdgeColor','none');
set(p,'FaceAlpha',alpha);

function Hp=wjn_plot_cortex(vertices,faces,alpha)

if ~exist('vertices')
    load(fullfile(leadt,'CortexHiRes.mat'))
    vertices = Vertices;
    faces = Faces;
end

if ~exist('faces','var')
    fnames = fieldnames(vertices);
    faces = vertices.(fnames{ci({'tri','faces'},fnames,1)});
    vertices = vertices.(fnames{ci({'vertices','vert'},fnames,1)});
end    

if ~exist('alpha','var')
    alpha = 1;
end

%%
%Render Cortical Surface
% figure
Hp = patch('vertices',vertices,'faces',faces,...
    'facecolor',[.7 .7 .7],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', 0.1,...
    'facealpha',alpha);
camlight('headlight','infinite');
fh(1)=gcf;
vertnormals = get(Hp,'vertexnormals');
axis off; axis equal
cameratoolbar
        
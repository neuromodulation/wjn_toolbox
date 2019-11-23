function h = wjn_plot_freesurfer_electrodes(cortex,electrodes)

if isempty(cortex)
    cortex=load(fullfile(leadt,'CortexHiRes.mat'),'Faces','Vertices');
end

try
vertices = cortex.vert;
faces = cortex.tri;
catch
    vertices = cortex.Vertices;
    faces = cortex.Faces;
end
wjn_plot_cortex(vertices,faces,.3)
    hold on


% 
if exist('electrodes','var')
    if iscell(electrodes)
        electrodes = reshape([electrodes{:}],[3,length(electrodes)])';
    end
% cc=colorlover(7);
% cc=cc(repmat([1:6],[1 100]),:);
[x,y,z]=sphere(100);
% keyboard
for a = 1:size(electrodes,1)
%     t=text(electrodes(a,1),electrodes(a,2),electrodes(a,3),[num2str(a)],'color','w','FontSize',8,'HorizontalAlignment','center');
%     t.Rotation = 15;
    s=surf(x*1+electrodes(a,1),y*1+electrodes(a,2)+1,z*1+electrodes(a,3)+1,'FaceColor','r','LineStyle','none');
    s.FaceLighting = 'none';
    s.FaceAlpha = .5;
end
end
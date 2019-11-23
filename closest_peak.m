function [loc,distance,all_peaks,distances,max_peak,max_distance] = closest_peak(file,position,disp)

if exist('position','var') && ~isempty(position)
    calc_pos = 1;
else
    calc_pos = 0;
end

if ~exist('disp','var')
    disp = 0;
end

vol = spm_vol(file);
[Y,XYZ] = spm_read_vols(vol);
thresh = nanmean(Y(:))+2*nanstd(Y(:));
%
[p, f, x] = fileparts(file);

Y(Y<thresh) = NaN;
vol.fname = fullfile(p, ['thresh' f '.nii']);
spm_write_vol(vol, Y);


XYZ = inv(vol.mat)*[XYZ;ones(1,size(XYZ,2))];
XYZ = XYZ(1:3,:);

Y=Y(:);
XYZ(:,isnan(Y))=[];
Y(isnan(Y))=[];
[N,Z,M,A] = spm_max(Y,XYZ);

mXYZ = vol.mat*[M;ones(1,size(M,2))];
mXYZ = mXYZ(1:3,:)'

t1 = spm_vol_nifti(file);
 [dat, xyz] = spm_read_vols(t1);
[unused, mxind] = max(dat(:));
gXYZ= xyz(:, mxind)';

% [junk, ind] = max(Y);
% gXYZ = vol.mat*[XYZ(:, ind); 1];
% gXYZ = gXYZ(1:3,:)'

% distance between two points = sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)

peaks = [mXYZ;gXYZ];

if calc_pos
pos = position;
for a = 1:size(peaks,1);
    distances(a) = sqrt((pos(1)-peaks(a,1))^2 + (pos(2)-peaks(a,2))^2 + (pos(3)-peaks(a,3))^2);
    [distance,i] = min(distances);
loc = peaks(i,:);
all_peaks = peaks;
max_peak = gXYZ;
max_distance = sqrt((pos(1)-gXYZ(1))^2 + (pos(2)-gXYZ(2))^2 + (pos(3)-gXYZ(3))^2);
end
else
    all_peaks = peaks;
    distances = nan(size(all_peaks,1));
    loc = gXYZ;
    max_peak = gXYZ;
    distance = nan;
    max_distance = nan;
end



delete(fullfile(p, ['thresh' f '.nii']))

if disp
cc=colorlover(5);
    figure
    % Fgraph  = spm_figure('GetWin','Graphics'); figure(Fgraph); clf
    for  a=1:3;

        subplot(1,3,a)
    iskull  = export(gifti(fullfile(spm('dir'), 'canonical', 'iskull_2562.surf.gii')), 'patch');
    p=patch('vertices',iskull.vertices,'faces',iskull.faces,'EdgeColor',[0.5 0.5 0.5],'FaceColor','none');
    set(p,'EdgeAlpha',0.1)
    hold on
    for  b = 1:size(peaks,1);
    p=plot3(peaks(b,1),peaks(b,2), peaks(b, 3), 'Marker','o', 'MarkerSize', 13,'LineStyle','none');
    set(p,'MarkerEdgeColor',cc(1,:),'MarkerFaceColor',cc(1,:))
    end
    
    pc=plot3(loc(1),loc(2), loc(3), 'Marker','o', 'MarkerSize', 13,'LineStyle','none');
    set(pc,'MarkerEdgeColor',cc(3,:),'MarkerFaceColor',cc(3,:))
    
    
    pm=plot3(max_peak(1),max_peak(2),max_peak(3), 'Marker','o', 'MarkerSize', 13,'LineStyle','none');
    set(pm,'MarkerEdgeColor',cc(5,:),'MarkerFaceColor',cc(5,:))
    
    if calc_pos
    pp=plot3(pos(1),pos(2),pos(3), 'Marker','x', 'MarkerSize', 20,'LineStyle','none');
    set(pp,'MarkerEdgeColor','k','MarkerFaceColor','k')
    end
    
    if a == 1
    text(loc(1)+1,loc(2)+1,loc(3)+1,{'CLOSEST' num2str(distance,4)},'HorizontalAlignment','center','VerticalAlignment','middle')
    text(max_peak(1),max_peak(2),max_peak(3),{'MAX' num2str(max_distance,4)},'HorizontalAlignment','center','VerticalAlignment','middle')
    end
    
    axis image off
    % patch('vertices',iskull.vertices,'faces',iskull.faces,'EdgeColor',[0.5 0.5 0.5],'FaceColor','none');
    hold on

    figone(12,30)

    % if a == 1;
    % fignum(4,'A',gca)
    % end

    if a == 2;
    view(90,0)
    % fignum(0,'B',gca)
    end
    % % myprint('Peak_location_sagittal','-opengl')
    if a==3;
    view(180,0)
    % fignum(0,'C',gca)
    end
    end
    % colorbar(gca)
% legend([pc,pm,pp],{'closest','max','position'})
if ischar(disp)
    myprint(disp)
end
end
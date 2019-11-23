%%% first step sort out tremor epochs
addpath(fullfile(mdf,'MEG_VIM\scripts'))
spm12
%%
clear
root = vim_patients(0,'root')
p = vim_patients;

cd(root)

%% ALL PATIENTS TREMOR


%
p = vp;
locs = [];
diagnosis  ={};
n= 0;
for a = 1:length(p)
    if ~isnan(p{a}.tf)
    folder = fullfile(root,vp(a,'outname'))
    sources = [];
    sources = ffind(fullfile(folder,'LFP*'))
    for b = 1:length(sources)
        
        file = fullfile(root,vp(a,'outname'),sources{b},['sm_dics_refcoh_cond_tremor_' vp(a,'outname') '.nii']);
         
        t1 = spm_vol_nifti(file)
   [dat, xyz] = spm_read_vols(t1);
        [unused, mxind] = max(dat(:));
        gma= xyz(:, mxind)
        if strcmp(vp(a,'side'),'left')
            gma(1) = gma(1)*-1;
        end
        n=n+1;
        locs = [locs;gma'];
        diagnosis{n} =p{a}.diagnosis;
        splitstring = strsplit(sources{b},'_');
        freq(n) =  mean([str2num(splitstring{3}),str2num(splitstring{4})]);
        
    end
    end
end
%%
cfreq = round(freq/45*64);
cmap = colormap('jet'); 
sXYZ = locs;

figure
% Fgraph  = spm_figure('GetWin','Graphics'); figure(Fgraph); clf
for  a=1:3;

    subplot(1,3,a)
iskull  = export(gifti(fullfile(spm('dir'), 'canonical', 'iskull_2562.surf.gii')), 'patch');
p=patch('vertices',iskull.vertices,'faces',iskull.faces,'EdgeColor',[0.5 0.5 0.5],'FaceColor','none');
set(p,'EdgeAlpha',0.1)
hold on
for  b = 1:length(locs);
    if strcmp(diagnosis{b},'PD') || strcmp(diagnosis{b},'OX')
p=plot3(locs(b,1),locs(b,2), locs(b, 3), 'Marker','o', 'MarkerSize', 13,'LineStyle','none');
set(p,'MarkerEdgeColor',cmap(cfreq(b),:),'MarkerFaceColor',cmap(cfreq(b),:))
    elseif strcmp(diagnosis{b},'MS')
        p=plot3(locs(b,1),locs(b,2), locs(b, 3), 'Marker','s', 'MarkerSize', 13,'LineStyle','none');
set(p,'MarkerEdgeColor',cmap(cfreq(b),:),'MarkerFaceColor',cmap(cfreq(b),:))
    elseif strcmp(diagnosis{b},'ET') 
p=plot3(locs(b,1),locs(b,2), locs(b, 3), 'Marker','v', 'MarkerSize', 13,'LineStyle','none');
set(p,'MarkerEdgeColor',cmap(cfreq(b),:),'MarkerFaceColor',cmap(cfreq(b),:))
    end
end

if a==1
    title('ALL  PATIENTS TREMOR')
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
colormap('jet')
c=colorbar('Ticks',[.1:.1:.9],'TickLabels',[5:5:45]);
c.Label.String = 'Frequency [Hz]';
c.Label.FontSize = 18;
myprint('tremor_source_location_all_patients')

%% PD LONDON TREMOR


%
p = vp;
locs = [];
diagnosis  ={};
n= 0;
for a = 1:length(p)
    if ~isnan(p{a}.tf)
    folder = fullfile(root,vp(a,'outname'))
    sources = [];
    sources = ffind(fullfile(folder,'LFP*'))
    for b = 1:length(sources)
        
        file = fullfile(root,vp(a,'outname'),sources{b},['sm_dics_refcoh_cond_tremor_' vp(a,'outname') '.nii']);
         
        t1 = spm_vol_nifti(file)
   [dat, xyz] = spm_read_vols(t1);
        [unused, mxind] = max(dat(:));
        gma= xyz(:, mxind)
        if strcmp(vp(a,'side'),'left')
            gma(1) = gma(1)*-1;
        end
        n=n+1;
        locs = [locs;gma'];
        diagnosis{n} =p{a}.diagnosis;
        splitstring = strsplit(sources{b},'_');
        freq(n) =  mean([str2num(splitstring{3}),str2num(splitstring{4})]);
        
    end
    end
end
%
cfreq = round(freq/45*64);
cmap = colormap('jet'); 
sXYZ = locs;

figure
% Fgraph  = spm_figure('GetWin','Graphics'); figure(Fgraph); clf
for  a=1:3;

    subplot(1,3,a)
iskull  = export(gifti(fullfile(spm('dir'), 'canonical', 'iskull_2562.surf.gii')), 'patch');
p=patch('vertices',iskull.vertices,'faces',iskull.faces,'EdgeColor',[0.5 0.5 0.5],'FaceColor','none');
set(p,'EdgeAlpha',0.1)
hold on
for  b = 1:length(locs);
    if strcmp(diagnosis{b},'PD') || strcmp(diagnosis{b},'OX')
p=plot3(locs(b,1),locs(b,2), locs(b, 3), 'Marker','o', 'MarkerSize', 13,'LineStyle','none');
set(p,'MarkerEdgeColor',cmap(cfreq(b),:),'MarkerFaceColor',cmap(cfreq(b),:))
%     elseif strcmp(diagnosis{b},'MS')
%         p=plot3(locs(b,1),locs(b,2), locs(b, 3), 'Marker','s', 'MarkerSize', 13,'LineStyle','none');
% set(p,'MarkerEdgeColor',cmap(cfreq(b),:),'MarkerFaceColor',cmap(cfreq(b),:))
%     elseif strcmp(diagnosis{b},'ET') 
% p=plot3(locs(b,1),locs(b,2), locs(b, 3), 'Marker','v', 'MarkerSize', 13,'LineStyle','none');
% set(p,'MarkerEdgeColor',cmap(cfreq(b),:),'MarkerFaceColor',cmap(cfreq(b),:))
    end
end

if a==1
    title('PD LONDON TREMOR')
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
colormap('jet')
c=colorbar('Ticks',[.1:.1:.9],'TickLabels',[5:5:45]);
c.Label.String = 'Frequency [Hz]';
c.Label.FontSize = 18;
myprint('tremor_source_location_PD_LONDON')
% Plot individual source location für Daniel

root = PD(0,'root');
p = PD; % Hier deine Patientenvariable aus dem PD script
locs = [];n= 0;
condition  = 'R_off'; % das ganze zwei mal, einmal für off und einmal für on

for a = 1:length(p)
    individualsourcefolder = PD(a,'individualsourcefolder') % hier den Ordner definieren, wie du es bei der source coherence eingegeben hast
    folder = fullfile(root,individualsourcefolder)
    sources = [];
    sources = ffind(fullfile(folder,'LFP*'))
    for b = 1:length(sources)
        splitstring = strsplit(sources{b},'_');
        if length(splitstring{3})>=3;

        file = fullfile(root,individualsourcefolder,sources{b},'gma.mat');
        load(file)
        if strcmp(PD(a,'side'),'left')
            gma(1) = gma(1)*-1;
        end
        n=n+1;
        locs = [locs;gma'];
        freq(n) =  mean([str2num(splitstring{3}),str2num(splitstring{4})]);
        end
    end
end


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
  
p=plot3(locs(b,1),locs(b,2), locs(b, 3), 'Marker','o', 'MarkerSize', 13,'LineStyle','none');
set(p,'MarkerEdgeColor',cmap(cfreq(b),:),'MarkerFaceColor',cmap(cfreq(b),:))
   
end

if a==1
    title(condition)
end
axis image off
hold on
figone(12,30)

if a == 2;
view(90,0)
end

if a==3;
view(180,0)

end
end

colormap('jet')
c=colorbar('Ticks',[.1:.1:.9],'TickLabels',[5:5:45]);
c.Label.String = 'Frequency [Hz]';
c.Label.FontSize = 18;
myprint(fullfile(root,[condition '_individual_source_location']))

clear;
% nfiles = input('Anzahl der Dateien die du Mitteln willst? ');
nfiles = 0;
a=0;
file = 'start';
while file ~= 0;

    
    [file,path]=uigetfile('*.mat');
    if file ~= 0;
    a = a+1;
    x{a} = load(fullfile(path,file));
    assignin('base',['file' num2str(a)],x{a});
    eval(['file' num2str(a) '.filename = fullfile(path,file)'])
    nfiles = nfiles + 1;
    
    end
        
end
    
    
for a = 1:nfiles;
    bc_ruhe(:,:,a) = eval(['file' num2str(a) '.bc_data']);
    bc_stim(:,:,a) = eval(['file' num2str(a) '.bc_stim']);
    bc_poststim(:,:,a) = eval(['file' num2str(a) '.bc_poststim']);
end

mean_bc_ruhe = mean(bc_ruhe,3);
mean_bc_stim = mean(bc_stim,3);
mean_bc_poststim = mean(bc_poststim,3);
t=linspace(0,148,size(mean_bc_poststim,2));
f=linspace(0,247,size(mean_bc_poststim,1));

%figure;
%plot(f,mean_bc_ruhe,'k',f,mean_bc_stim,'r',f,mean_bc_poststim,'b','LineWidth',2,'LineSmoothing','on');xlim([2 40]);xlabel('Frequenz');
%legend('Baseline','Stimulation','Poststimulation');
%title('Mean Power');
%saveas(gcf,'mean_power.png');
%saveas(gcf,'mean_power.fig');


figure;

subplot(3,1,1);
imagesc(t,f,interp2(interp2(mean_bc_ruhe)));axis xy;ylim([3 40]);xlabel('Zeit');ylabel('Frequenz');
caxis([0 300]);shading(gca,'interp')
title('Ruhe');
subplot(3,1,2);
imagesc(t,f,interp2(interp2(mean_bc_stim)));axis xy;caxis([0 500]);ylim([3 40]);xlabel('Zeit');%ylabel('Frequenz');
title('Stimulation');shading(gca,'interp')
%saveas(gcf,'TF_power_stim.png');title('Prozent Power Differenz Stimulation zu Ruhe');
subplot(3,1,3);
imagesc(t,f,interp2(interp2(mean_bc_poststim)));axis xy;caxis([0 500]);ylim([3 40]);xlabel('Zeit');%ylabel('Frequenz');
title('Post stimulation');shading(gca,'interp')

saveas(gcf,'grand_average_overview.png');
saveas(gcf,'grand_average_overview.fig')
% subplot(1,4,4);
% colorbar;

vergleich = squeeze(median(median(bc_ruhe,2),3));

for a = 1:size(bc_ruhe,1);
    for b = 1:size(bc_ruhe,2);
        rvorzeichen(a,b)= gt(median(bc_ruhe(a,b,:),3),vergleich(a));
        svorzeichen(a,b)= gt(median(bc_stim(a,b,:),3),vergleich(a));
        pvorzeichen(a,b)= gt(median(bc_poststim(a,b,:),3),vergleich(a));
        
        [rp(a,b),rh(a,b),rstats]=signrank(squeeze(bc_ruhe(a,b,:)),vergleich(a),'method','approximate');
        [sp(a,b),sh(a,b),sstats]=signrank(squeeze(bc_stim(a,b,:)),vergleich(a),'method','approximate');
        [pp(a,b),ph(a,b),pstats]=signrank(squeeze(bc_poststim(a,b,:)),vergleich(a),'method','approximate');
        rz(a,b)=rstats.zval;
        sz(a,b)=sstats.zval;
        pz(a,b)=pstats.zval;
        
%         [rp(a,b),rh(a,b),rstats]=signrank(squeeze(bc_ruhe(a,b,:)),100,'method','approximate');
%         [sp(a,b),sh(a,b),sstats]=signrank(squeeze(bc_stim(a,b,:)),100,'method','approximate');
%         [pp(a,b),ph(a,b),pstats]=signrank(squeeze(bc_poststim(a,b,:)),100,'method','approximate');
%         rz(a,b)=rstats.zval;
%         sz(a,b)=sstats.zval;
%         pz(a,b)=pstats.zval;
    end
end

rzt=rz;
szt=sz;
pzt=pz;
rzt(rz > -1.9) =0;
szt(sz > -1.9) =0;
pzt(pz > -1.9) =0;

for a = 1:size(rzt,1);
    for b = 1:size(rzt,2);
        if rvorzeichen(a,b) == 1;
            rzt(a,b) = rzt(a,b)*-1;
        end
        
        if svorzeichen(a,b) == 1;
            szt(a,b) = szt(a,b)*-1;
        end
        
        if pvorzeichen(a,b) == 1;
            pzt(a,b) = pzt(a,b)*-1;
        end
        
  
    end
end


rpt=rp;
spt=sp;
ppt=pp;
rpt(rp > 0.05) =1;
spt(rp > 0.05) =1;
ppt(rp > 0.05) =1;


figure;

colormap('gray');

imagesc(t,f,rzt);axis xy;ylim([1 40]);caxis([-3 3]);
title('Ruhe (Z-Werte)');


figure;
colormap('gray');
imagesc(t,f,szt);axis xy;ylim([1 40]);caxis([-3 3]);
title('Stimulation (Z-Werte)');
figure;

colormap('gray');
imagesc(t,f,pzt);axis xy;ylim([1 40]);caxis([-3 3]);
title('Post-stimulation (Z-Werte)');

save grandaverage
saveas(gcf,'TF_power_poststim.png');title('Prozent Power Differenz poststimulation zu Ruhe');
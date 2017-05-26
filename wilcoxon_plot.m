function wilcoxon_plot
filename = uigetfile('*.mat');
load(filename);
% Eingeben: wilcoxon_plot(bc_ruhe,bc_stim,bc_poststim)
% bc_ruhe, bc_stim, bc_poststim werden aus der grandaverage datei
% geladen...


if size(bc_ruhe,1) ~= size(bc_stim,1) || size(bc_ruhe,2) ~= size(bc_stim,2);
    error('Die Gruppen sind nicht gleich...');
end

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

% figure;
% colormap('gray');
% subplot(3,1,1);
% title('Ruhe (signifikant)');
% imagesc(t,f,rh);axis xy;ylim([1 40]);
% 
% subplot(3,1,2);
% title('Stimulation (signifikant)');
% imagesc(t,f,sh);axis xy;ylim([1 40]);
% 
% subplot(3,1,3);
% title('Post-stimulation (signifikant)');
% imagesc(t,f,ph);axis xy;ylim([1 40]);


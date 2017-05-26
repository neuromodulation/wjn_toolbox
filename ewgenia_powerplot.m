[restname,restfolder]=uigetfile({'*.txt','Ruhedaten Datei'});
cd(restfolder)
rest = load(restname);
f=rest(1,2:end);
t=rest(2:end,1);
dt=max(t)-min(t);
nt=linspace(0,dt,length(t));
data=rest(2:end,2:end);
data=data';

for a = 1:size(data,1);
    baseline_power(a,1) = mean(data(a,:),2);
    bc_data(a,:) = data(a,:)./baseline_power(a,1)*100;
    
end


imagesc(nt,f,interp2(interp2(bc_data)));axis xy;ylim([3 40]);xlabel('Zeit');ylabel('Frequenz');caxis([0 300]);

display(ls('*.txt'));

nstim =input('Wie viele Stimulationsdateien sollen gemittelt werden? ');

for a = 1:nstim;
    name = uigetfile('*.txt');
    stimdata = load(name); 
    stim(:,:,a) = stimdata(2:end,2:end)';
    
end
mean_stim = mean(stim,3);
npoststim =input('Wie viele Post-Stimulationsdateien sollen gemittelt werden? ');


for a = 1:npoststim;
    name = uigetfile('*.txt');
    poststimdata = load(name); 
    poststim(:,:,a) = stimdata(2:end,2:end)';
    
end
mean_poststim = mean(poststim,3);

mmean_stim = mean(mean_stim,2);
mmean_poststim = mean(mean_poststim,2);

for a = 1:size(bc_data,1);
    bc_stim(a,:) = mean_stim(a,:)./baseline_power(a)*100;
    bc_poststim(a,:) = mean_poststim(a,:)./baseline_power(a)*100;
end

figure;
plot(f,baseline_power,'k',f,mmean_stim,'b',f,mmean_poststim,'r','LineWidth',2,'LineSmoothing','on');xlim([2 40]);xlabel('Frequenz');
legend('Baseline','Stimulation','Poststimulation');
title('Rohe Power');
saveas(gcf,'mean_power.png');
saveas(gcf,'mean_power.fig');


figure;

subplot(3,1,1);
imagesc(nt,f,interp2(interp2(bc_data)));axis xy;ylim([3 40]);xlabel('Zeit');ylabel('Frequenz');
caxis([0 300]);shading(gca,'interp')
title('Ruhe');
subplot(3,1,2);
imagesc(t,f,interp2(interp2(bc_stim)));axis xy;caxis([0 500]);ylim([3 40]);xlabel('Zeit');%ylabel('Frequenz');
title('Stimulation');shading(gca,'interp')
%saveas(gcf,'TF_power_stim.png');title('Prozent Power Differenz Stimulation zu Ruhe');
subplot(3,1,3);
imagesc(t,f,interp2(interp2(bc_poststim)));axis xy;caxis([0 500]);ylim([3 40]);xlabel('Zeit');%ylabel('Frequenz');
title('Post stimulation');shading(gca,'interp')

saveas(gcf,'overview.png');
saveas(gcf,'overview.fig')
% subplot(1,4,4);
% colorbar;

saveas(gcf,'TF_power_poststim.png');title('Prozent Power Differenz poststimulation zu Ruhe');

save meanfiles bc_data bc_stim bc_poststim;
save allfiles;
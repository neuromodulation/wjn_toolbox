

%%sensor_significance

root = 'D:\MEG\Vim_meg\tremor';
cd(root);
load patients
load sensor_f
IDs = fieldnames(patients)
% sfolders = ffind('sensor_*')
nc = [];
for a = 1:length(IDs);
    sfolder = ['sensor_' IDs{a}];
    s = load(fullfile(sfolder,[IDs{a} '_sigrange.mat']))
    chans = fieldnames(s.sigrange);
    for c = 1:length(chans);
%         nc = size(s.sigrange.(chans{c}).FWE05k0,1)
        pc(a,c) = size(s.sigrange.(chans{c}).FWE05k0,1);
        nc = [nc ;s.sigrange.(chans{c}).FWE05k0];
    end
end

figure;
bar(pc);
xlabel('Patients')
ylabel('Number of clusters')
figone(7);myfont(gca);l=legend('LFP1','LFP2','LFP3','LFP4','LFP5','LFP6');
set(l,'FontSize',6)
myprint('Vim_Cluster_distribution_p05');


nnc = zeros(length(nc),length(f));
for a = 1:length(nc);
    nnc(a,sc(f,nc(a,1)):sc(f,nc(a,2))) = 1;
end
    
figure;
imagesc(f,[1:91],nnc'*-1); axis xy;
figone(7);
xlabel('Cluster Number');
ylabel('Frequency [Hz]');
title('All significant sensor level clusters from 8 VIM patients');
colormap('gray')
myprint('Sensor_cluster_map_p05');

%%

x=sum(nnc,1)
figure
% plot(f,x);
bar(f,x,'facecolor',[0.5 0.5 0.5],'edgecolor','k');
figone(7);
xlim([5 95]);
xlabel('Frequency [Hz]');ylabel('Number of significant clusters');
myprint('VIM_sensor_histogram_p05')

%%
% GI first 
% 
% first GI 1 - HFA 
% second is BETA penumbra
% HFA contacts horiz
clear all
close all
id = 'RZ030415';
hem = 'L';
icortex = load(['Individual\cortex_' id '.mat']);
cortex = load(['Standardized\cortex_' id '.mat']);
mcortex = load('cortex_MNI_27.mat');
% mmcortex = wjn_template_mni_cortex;
load(['elec_' hem '_' id '.mat']);
for a = 1:size(elecmatrix,1)
[m,i] = min(pdist2(cortex.cortex.vert,elecmatrix(a,:)));
s_coords(a,:) = cortex.cortex.vert(i,:);
mni_coords(a,:)= mcortex.cortex.vert(i,:);
end

figure
subplot(1,3,1)
wjn_plot_freesurfer_electrodes(icortex.cortex,elecmatrix)
title('Individual')
subplot(1,3,2)
wjn_plot_freesurfer_electrodes(cortex.cortex,s_coords)
title('Standardized')
subplot(1,3,3)
wjn_plot_freesurfer_electrodes(mcortex.cortex,mni_coords)
title('MNI')
figone(7,40)



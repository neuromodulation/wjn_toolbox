root = 'C:\megdata\TB\';
cd(root);
%%
addpath C:\SPM12
spm('eeg','defaults');close all;
%%
run correct_mri\correct_mri.m
copyfile cmTB.* RO\sensor_level\native\.
copyfile cmTB.* RC1\sensor_level\native\.
copyfile cmTB.* RC2\sensor_level\native\.
%%
run RO\headloc\headloc_example.m
run RC1\headloc\headloc_example.m
run RC2\headloc\headloc_example.m
cd(root)
%%
run RO\sensor_level\dbs_meg_spm_rest_cohimages_native.m
run RO\sensor_level\dbs_meg_spm_rest_cohimages_headloc.m
run RC1\sensor_level\dbs_meg_spm_rest_cohimages_native.m
run RC1\sensor_level\dbs_meg_spm_rest_cohimages_headloc.m
run RC2\sensor_level\dbs_meg_spm_rest_cohimages_native.m
run RC2\sensor_level\dbs_meg_spm_rest_cohimages_headloc.m

% %%
% sr.RO_R01nL = load('RO\sensor_level\native\cohimages\LFP_R01\low\sigranges.mat');
% sr.RO_R01nH = load('RO\sensor_level\native\cohimages\LFP_R01\high\sigranges.mat');
% sr.RO_R01hL = load('RO\sensor_level\headloc\cohimages\LFP_R01\low\sigranges.mat');
% sr.RO_R01hH = load('RO\sensor_level\headloc\cohimages\LFP_R01\high\sigranges.mat');
% 
% sr.RO_R12nL = load('RO\sensor_level\native\cohimages\LFP_R12\low\sigranges.mat');
% sr.RO_R12nH = load('RO\sensor_level\native\cohimages\LFP_R12\high\sigranges.mat');
% sr.RO_R12hL = load('RO\sensor_level\headloc\cohimages\LFP_R12\low\sigranges.mat');
% sr.RO_R12hH = load('RO\sensor_level\headloc\cohimages\LFP_R12\high\sigranges.mat');
% 
% sr.RO_R23nL = load('RO\sensor_level\native\LFP_R23\low\sigranges.mat');
% sr.RO_R23nH = load('RO\sensor_level\native\LFP_R23\high\sigranges.mat');
% sr.RO_R23hL = load('RO\sensor_level\headloc\LFP_R23\low\sigranges.mat');
% sr.RO_R23hH = load('RO\sensor_level\headloc\LFP_R23\high\sigranges.mat');

%%
% Prepare Where to get MEG sensors -> D.sensors
run C:\megdata\TB\RO\source_coherence\bf_script.m
run C:\megdata\TB\RC1\source_coherence\bf_script.m
run C:\megdata\TB\RC2\source_coherence\bf_script.m
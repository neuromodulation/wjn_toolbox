function wjn_freesurfer2mni(folder,electrodefile)

folder = 'Y:\Electrophysiology_Data\DBS_Intraop_Recordings\FreeSurfer\DBS4011_postop\';
[vertl,facel]=read_surf(fullfile(folder,'surf','lh.pial'));
[vertr,facer]=read_surf(fullfile(folder,'surf','rh.pial'));
% 
f = MRIread(fullfile(folder,'mri','T1.nii'),1);

vertices = [vertl;vertr];
faces = [facel;facer+length(vertl)]+1;
% 
for a = 1:size(vertices,1)
    temp = f.vox2ras/f.tkrvox2ras*[vertices(a,:) 1]';
    nvertices(a,:) = temp(1:3);    
end

cortex.vert = nvertices;
cortex.tri = faces;


load(electrodefile);

wjn_plot_freesurfer_electrodes(cortex,CortElecLoc)

%%
clear
icortex = load('Individual/cortex_RS052314.mat');
mcortex = load('C:\Dropbox (Personal)\matlab\lead\templates\space\MNI_ICBM_2009b_NLIN_ASYM\cortex\CortexHiRes.mat')

elec = load('elec_L_RS052314.mat');

scortex.vert = wjn_zscore(icortex.cortex.vert);
scortex.tri = icortex.cortex.tri;



figure
subplot(1,2,1)
wjn_plot_freesurfer_electrodes(mcortex)

subplot(1,2,2)
try
wjn_plot_freesurfer_electrodes(icortex.cortex,elec.CortElecLoc)
catch
    wjn_plot_freesurfer_electrodes(icortex.cortex,elec.elecmatrix)
end
%%
matrix = [27.27	22.72	30.16	28	33.02	31.83	32.63	28.76
-28.87	-20.51	-10.15	0.68	7.194	19.97	31.67	40.19
75.57	76.02	68.1	62.51	65.76	60.71	53.09	42.59
]';
figure
wjn_plot_freesurfer_electrodes(mcortex,matrix)

% 

% view(112,42)
% figone(14,14)

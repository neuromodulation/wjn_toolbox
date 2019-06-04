function wjn_nii_overlay(nii,clims,roi)

mni2fs17;

if ~exist('clims','var')
    clims = 'auto';
end
if ~exist('roi','var')
    roi = 0;
end

%% Simple Auto Wrapper - All Settings are at Default and Scaling is Automatic
% close all
% mni2fs_auto(fullfile(toolboxpath, 'examples/AudMean.nii'),'lh')

%% Plot both hemispheres

%% Plot ROI and Overlay
close all
figure('Color','k','position',[20 72 800 600])


% Load and Render the FreeSurfer surface

hems = {'rh','lh'};
for a = 1:2
    S = [];
S.hem = hems{a}; % choose the hemesphere 'lh' or 'rh'
S.inflationstep = 4; % 1 no inflation, 6 fully inflated
S.separateHem = 5;
% S.plotsurf = 'pial';
S.plotsurf = 'pial';
S.lookupsurf = 'pial';
S.surfacecolorspec = [.5 .5 .5];
S.surfacealpha = .5;
S.decimation = true; % Decimate the surface for speed. (Use FALSE for publishable quality figures).
S = mni2fs_brain(S);
% S.hem = 'rh';
% S = mni2fs_brain(S);
if roi
% Plot an ROI, and make it semi transparent
    S.mnivol = roi;
    S.roicolorspec = 'y'; % color. Can also be a three-element vector
    S.roialpha = 0.5; % transparency 0-1
    S.seperateHem = 0;
    S = mni2fs_roi(S); 
end
% Add overlay, theshold to 98th percentile
NIFTI = mni2fs_load_nii(nii); % mnivol can be a NIFTI structure
% keyboard
S.mnivol = NIFTI;
S.clims = clims;
S.seperateHem = 0;
S.climstype = 'abs';
% S.clims_perc = 0.9; % overlay masking below 98th percentile
S = mni2fs_overlay(S); 
view([-142 22]) % change camera angle
mni2fs_lights; % Dont forget to turn on the lights!
% Optional - lighting can be altered after rendering
% end
end

ylim([-150 150])


% For high quality output 
% Try export_fig package included in this release
% When using export fig use the bitmap option 
% export_fig('filename.bmp','-bmp')

% OR TRY MYAA for improved anti-aliasing without saving
% myaa


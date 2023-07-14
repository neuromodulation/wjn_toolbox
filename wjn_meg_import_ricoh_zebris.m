function D=wjn_meg_import_ricoh_zebris(meg_file,mrk_file,sfp_file,mri_file,mri_nas_lpa_rpa)


ft_defaults
%% Start coregistration
dataset=meg_file;
hdr = ft_read_header(dataset);

cfg = [];
cfg.dataset = meg_file;
data = ft_preprocessing(cfg);


%% Read HPIs in MEG coordinate system from .mrk file
coilset = ft_read_headshape(mrk_file);
coilset = ft_convert_units(coilset, 'mm');

%% HPIs (marker coils) in MEG coordinate system
coilset.pos = coilset.fid.pos(end-4:end,:);
coilset.label = coilset.fid.label(end-4:end,:);
coilset.label

%% Read anatomical landmarks and coils measured by Zebris in HEAD coordinate system
shape_hc = ft_read_sens(sfp_file, 'fileformat','zebris_sfp');

%% HPIs (marker coils) in HEAD coordinate system
sz = size(shape_hc.chanpos);
nas_coil = sz(1)-13;         
lpa_coil = sz(1)-15;
rpa_coil = sz(1)-14;
shape_hc.label(sz(1)-15:sz(1)-13,:)

%% Determine transform MEG to HEAD coordinate system and transform array geoemetry
% coil order: Coil1 = Na, Coil2 = LPA, Coil3 = RPA, Coil4, Coil5
coil2common  = ft_headcoordinates(coilset.pos(1,:),coilset.pos(2,:),coilset.pos(3,:)); % headcoordinates wants na, lpa, rpa    
hs2common = ft_headcoordinates(shape_hc.chanpos(nas_coil,:),shape_hc.chanpos(lpa_coil,:),shape_hc.chanpos(rpa_coil,:)); % na, lpa, rpa (Zebris)
t = inv(hs2common)*coil2common;
data.grad = ft_convert_units(data.grad, 'mm');
data_hc.grad = ft_transform_geometry(t,data.grad);
coilset_hc = ft_transform_geometry(t,coilset);

%% Display all
% SQUID array
figure
ft_plot_sens(data_hc.grad,'edgecolor', 'blue');  % ,'coil',true, 'facecolor', 'red');    
hold on
% ZEBRIS fiducials
plot3(shape_hc.fid.pnt(:,1),shape_hc.fid.pnt(:,2),shape_hc.fid.pnt(:,3),'red*','MarkerSize',15)
axis equal
hold on
% ZEBRIS surface points
plot3(shape_hc.chanpos(1:sz(1)-16,1),shape_hc.chanpos(1:sz(1)-16,2),shape_hc.chanpos(1:sz(1)-16,3),'green*','MarkerSize',8)
axis equal
hold on
% Coils measured with SQUID array and transformed
plot3(coilset_hc.pos(1:3,1),coilset_hc.pos(1:3,2),coilset_hc.pos(1:3,3),'yellowd','MarkerSize',15)
axis equal
hold on
% Coils measured with Zebris 
plot3(shape_hc.chanpos(sz(1)-15:sz(1)-13,1),shape_hc.chanpos(sz(1)-15:sz(1)-13,2),shape_hc.chanpos(sz(1)-15:sz(1)-13,3),'magentad','MarkerSize',15)
axis equal
hold on
myprint('headmodel in fieldtrip')

% Convert to SPM for use with DAiSS

D=spm_eeg_convert(meg_file)
D=sensors(D,'MEG',data_hc.grad);
D=fiducials(D,shape_hc);
D=chantype(D,D.indchantype('EEG'),'Other')
save(D)

if exist('mri_file','var') && exist('mri_nas_lpa_rpa')
clear matlabbatch
matlabbatch{1}.spm.meeg.source.headmodel.D = {fullfile(D)};
matlabbatch{1}.spm.meeg.source.headmodel.val = 1;
matlabbatch{1}.spm.meeg.source.headmodel.comment = '';
matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshes.mri = {mri_file};
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).fidname = 'nas';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).specification.type = mri_nas_lpa_rpa(1,:);
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).fidname = 'lpa';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).specification.type = mri_nas_lpa_rpa(2,:);
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).fidname = 'rpa';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).specification.type = mri_nas_lpa_rpa(3,:);
matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshres = 2;
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.useheadshape = 1;
matlabbatch{1}.spm.meeg.source.headmodel.forward.meg = 'Single Shell';
spm_jobman('run', matlabbatch);
disp('SPM Headmodel with individual MRI')
elseif exist('mri_file','var') && ~exist('mri_nas_lpa_rpa','var')
    warning('Write out nas/lpa/rpa coordinates and add to input!')
    spm_check_registration(mri_file)
    return
else
    clear matlabbatch
    matlabbatch{1}.spm.meeg.source.headmodel.D = {fullfile(D)};
    matlabbatch{1}.spm.meeg.source.headmodel.val = 1;
    matlabbatch{1}.spm.meeg.source.headmodel.comment = '';
    matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshes.template = 1;
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).fidname = 'nas';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).specification.select = 'nas';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).fidname = 'lpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).specification.select = 'lpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).fidname = 'rpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).specification.select = 'rpa';
    matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshres = 2;
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.useheadshape = 1;
    matlabbatch{1}.spm.meeg.source.headmodel.forward.meg = 'Single Shell';
    spm_jobman('run', matlabbatch);
        disp('SPM Headmodel with template MRI')
end

D=reload(D);
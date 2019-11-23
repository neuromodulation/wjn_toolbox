function D = dbs_meg_headmodelling(D)

try
    [files, seq, root, details] = dbs_subjects(D.initials, 1);
catch
    [files, seq, root, details] = dbs_subjects(D.initials, 0);
end

template = 0;
if ~exist(fullfile(details.mridir, ['r' D.initials '.nii']), 'file')
    if ~exist(fullfile(details.mridir, [D.initials '.nii']), 'file')
        warning(['Cannot find the structural ' D.initials '.nii']);
        template = 1;
    else
        
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {fullfile(spm('dir'), 'canonical', 'single_subj_T1.nii,1')};
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = {fullfile(details.mridir, [D.initials '.nii'])};
        
        spm_jobman('run', matlabbatch);
    end
end

try
    fid = importdata(details.fiducials);
end

try
    D = rmfield(D, 'inv');
end

save(D);

cd(D.path);

clear matlabbatch
matlabbatch{1}.spm.meeg.source.headmodel.D = {fullfile(D)};
matlabbatch{1}.spm.meeg.source.headmodel.val = 1;
matlabbatch{1}.spm.meeg.source.headmodel.comment = '';

if ~template
    matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshes.mri = {fullfile(details.mridir, ['r' D.initials '.nii'])};
end

matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshres = 2;

if exist('fid', 'var')
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).fidname = 'nas';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).specification.type = fid.data(1, :);
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).fidname = 'lpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).specification.type = fid.data(2, :);
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).fidname = 'rpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).specification.type = fid.data(3, :);
else
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).fidname = 'nas';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).specification.select = 'nas';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).fidname = 'lpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).specification.select = 'FIL_CTF_L';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).fidname = 'rpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).specification.select = 'FIL_CTF_R';
end

matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.useheadshape = 0;
matlabbatch{1}.spm.meeg.source.headmodel.forward.meg = 'Single Shell';

spm_jobman('run', matlabbatch);
%%
D = reload(D);


% This is the alignment procedure see Litvak et al. 2010

meegfid = D.fiducials;

if exist('fid', 'var')
    mrifid.fid.pnt = fid.data;
else
    mrifid.fid.pnt =  D.inv{1}.mesh.fid.fid.pnt([1 4 5], :);
end
mrifid.fid.label = {'nas'; 'lpa'; 'rpa'};
mrifid.pnt = [];

tempfid = ft_transform_headshape(D.inv{1}.mesh.Affine\D.inv{1}.datareg.toMNI, meegfid);
tempfid.fid.pnt(:, 2) = tempfid.fid.pnt(:, 2)- tempfid.fid.pnt(1, 2)+ mrifid.fid.pnt(1, 2);
tempfid.fid.pnt(:, 3) = tempfid.fid.pnt(:, 3)- mean(tempfid.fid.pnt(2:3, 3))+ mean(mrifid.fid.pnt(2:3, 3));
M1 = spm_eeg_inv_rigidreg(tempfid.fid.pnt', meegfid.fid.pnt');

D.inv{1}.datareg(1).sensors = D.sensors('MEG');
D.inv{1}.datareg(1).fid_eeg = meegfid;
D.inv{1}.datareg(1).fid_mri = ft_transform_headshape(inv(M1), mrifid);
D.inv{1}.datareg(1).toMNI = D.inv{1}.mesh.Affine*M1;
D.inv{1}.datareg(1).fromMNI = inv(D.inv{1}.datareg(1).toMNI);
D.inv{1}.datareg(1).modality = 'MEG';


% check and display registration
%--------------------------------------------------------------------------
spm_eeg_inv_checkdatareg(D);

print('-dtiff', '-r600', fullfile(D.path, 'datareg.tiff'));

D = spm_eeg_inv_forward(D);

spm_eeg_inv_checkforward(D);

print('-dtiff', '-r600', fullfile(D.path, 'forward.tiff'));

save(D);
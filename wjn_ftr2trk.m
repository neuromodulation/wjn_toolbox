function wjn_ftr2trk(filename)
% export FTR matrix to TrackVis trk format
[lf,lt]=leadf;
addpath(genpath(lf));


dnii=ea_load_nii([ea_space,'t1.nii']);

specs.origin=[0,0,0];
specs.dim=size(dnii.img);
specs.vox=dnii.voxsize;
specs.affine=dnii.mat;
direc='.\';
tfname=filename;

load([direc,tfname,'.mat']);

fibsmm=[fibers(:,1:3),ones(length(fibers),1)]';
fibsvx=dnii.mat\fibsmm;
fibers(:,1:3)=fibsvx(1:3,:)';
save([direc,tfname,'_vox.mat'],'fibers','fourindex','idx','ea_fibformat');
ea_ftr2trk([tfname,'_vox'],direc,specs);


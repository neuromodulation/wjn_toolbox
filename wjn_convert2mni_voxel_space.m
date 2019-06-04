function cname = wjn_convert2mni_voxel_space(nifti_image,space)

if ~exist('space','var')
    space = 'mni';
end

[leadd,leadt] = leadf;

cdir = cd;

flags.mean=0;
flags.which=1;
flags.prefix=[space '_'];
flags.interp=4;
[idir,toreslicefn,ext] = fileparts(nifti_image);
try
switch space
    case 'mni'
        spacefn = wjn_t2_template;
    case 'bb'
        spacefn = fullfile(leadt,'bb.nii');
end
catch
    spacefn = space;
    space = spacefn(1:end-4);
end
spm_reslice({spacefn,fullfile(idir,[toreslicefn ext])},flags);


cname = [space '_' toreslicefn ext];
try
    movefile(fullfile(idir,cname),fullfile(cdir,cname));
catch me
    disp(me)
end
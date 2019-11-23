function wjn_img2nii(files)
%select files
if ~exist('files','var')
    f = spm_select(Inf,'img$','Select img files to be converted');
else
    f = files;
end
%convert img files to nii
for i=1:size(f,1)
	input = deblank(f(i,:));
	[pathstr,fname,ext] = fileparts(input);
    output = strcat(fname,'.nii');
    V=spm_vol(input);
    ima=spm_read_vols(V);
    V.fname=output;
    spm_write_vol(V,ima);
end


fname = spm_select(1, 'image', 'Select image');

vol = spm_vol(fname);
[Y,XYZ] = spm_read_vols(vol);
thresh = nanmean(Y(:))+2*nanstd(Y(:));
%%
[p, f, x] = fileparts(fname);

Y(Y<thresh) = NaN;
vol.fname = fullfile(p, ['thresh' f '.nii']);
spm_write_vol(vol, Y);


XYZ = inv(vol.mat)*[XYZ;ones(1,size(XYZ,2))];
XYZ = XYZ(1:3,:);

Y=Y(:);
XYZ(:,isnan(Y))=[];
Y(isnan(Y))=[];
[N,Z,M,A] = spm_max(Y,XYZ);

mXYZ = vol.mat*[M;ones(1,size(M,2))];
mXYZ = mXYZ(1:3,:)'

[junk, ind] = max(Y);
gXYZ = vol.mat*[XYZ(:, ind); 1];
gXYZ = gXYZ(1:3,:)'
function wjn_spherical_vat(fname,mni,amplitudes,pulsewidths,template)


if ~exist('template','var')
    template = fullfile(ea_getearoot,'templates','space','MNI_ICBM_2009b_NLIN_ASYM','bb.nii');
end

Vol=ea_load_nii(template);
nii=Vol.img;
nii(:)=nan;
voxmm = Vol.voxsize;
for a=1:size(mni,1)
    r= ((pulsewidths(a)/60)^0.3) * sqrt((0.72 * (amplitudes(a)/1000)) / (.2 * 1000))*1000;
    X= mni(a,1); Y = mni(a,2); Z = mni(a,3); 
    XYZ=[X,Y,Z,ones(length(X),1)]';
    XYZ=Vol.mat\XYZ; % to voxel space.
    XYZ=(XYZ(1:3,:)');
    
    xe = XYZ(1)-round(2*r/voxmm(1)):XYZ(1)+round(2*r/voxmm(1));
    ye = XYZ(2)-round(2*r/voxmm(2)):XYZ(2)+round(2*r/voxmm(2));
    ze = XYZ(3)-round(2*r/voxmm(3)):XYZ(3)+round(2*r/voxmm(3));

    
    [xx yy zz] = meshgrid(1:length(xe),1:length(ye),1:length(ze));
    S = round(sqrt((xx-2*r/voxmm(1)).^2+(yy-2*r/voxmm(2)).^2+(zz-2*r/voxmm(3)).^2)<=r/voxmm(1));
    xix=squeeze(xx(1,:,1)+round(XYZ(1)-2*r/voxmm(1)));
    yiy=squeeze(yy(:,1,1)+round(XYZ(2)-2*r/voxmm(1)));
    ziz=squeeze(zz(1,1,:)+round(XYZ(3)-2*r/voxmm(1)));
    nii(xix,yiy,ziz)=S;
end
nii(nii~=1)=nan;
Vol.dt =[16,0];
[fdir,fname]=fileparts(fname);
Vol.fname=fullfile(fdir,[fname '.nii']);
spm_write_vol(Vol,nii);



cname=fullfile(fdir,[fname '.nii'])

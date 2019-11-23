function out=wjn_nii_mask(nii,mask,v)
if ~exist('v','var')
    v=.01;
end


if ~iscell(nii)
    nii = {nii};
end
for a  =1 :length(nii)
    if ~exist('mask','var')
        cmask = nii{a};
    else
        cmask = mask;
    end
    [fdir,fname]=fileparts(nii{a});
    mname = fullfile(fdir,['m' fname '.nii']);
    s.dmtx = 0;
    s.mask = 1;
    s.interp = 1;

    spm_imcalc({nii{a},cmask},mname,['i1.*(i2>' num2str(v) ')'],s);
    out=wjn_read_nii(mname);
end


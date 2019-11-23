function out =wjn_nii_threshold(nii,threshold)
if ~exist('v','var')
    threshold=.01;
end


if ~iscell(nii)
    nii = {nii};
end
for a  =1 :length(nii)
    [fdir,fname]=fileparts(nii{a});
    mname = fullfile(fdir,['t' fname '.nii']);
    s.dmtx = 0;
    s.mask = 1;
    s.interp = 1;

    spm_imcalc(nii(a),mname,['i1.*(i1>' num2str(threshold) ')'],s);
    out=wjn_read_nii(mname);
end


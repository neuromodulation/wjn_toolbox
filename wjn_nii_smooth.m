function nii = wjn_nii_smooth(nii,s)

if ischar(nii)
    nii = {nii};
end
for a = 1:length(nii)
    [fdir,fname]=fileparts(nii{a});
    spm_smooth(fullfile(fdir,[fname '.nii']),fullfile(fdir,['s' fname '.nii']),s);
    nii{a} = ['s' fname '.nii'];
end

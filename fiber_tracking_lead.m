clear
root = fullfile(mdf,'visuomotor_tracking_ana','Matlab Export','fiber_tracking');
cd(root)
lead16
files = ffind('mni_sROI_10.nii');
for a = 1:length(files)
    spm_imcalc(files{a},files{a},'i1.*(i1>0.001)')
end
wjn_lead_mapper(files,0,1)
    
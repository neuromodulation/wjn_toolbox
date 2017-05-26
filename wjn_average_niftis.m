function nii = wjn_average_niftis(files,outname);

nfiles = numel(files)
f='(i1';
for a = 2:nfiles
    f = [f '+i' num2str(a)];
end
fend = [')/' num2str(nfiles)];
spm_imcalc(files,outname,[f fend])

nii = wjn_read_nii(outname);
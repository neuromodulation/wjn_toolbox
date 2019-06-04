function nii=wjn_nii_average(files,fname)
f=['('];
for a = 1:length(files)
    f = [f 'i' num2str(a) '+'];
end
f(end) = ')';
f = [f './' num2str(length(files))];

       
spm_imcalc(files,fname,f)
nii =fname;
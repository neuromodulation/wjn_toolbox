function wjn_nii_fiber_probability(files,fname)
f=['('];
for a = 1:length(files)
    f = [ f '(i' num2str(a) '>0.001)+'];
end
f(end) = ')';
f = [f './' num2str(length(files))];

       
spm_imcalc(files,fname,f)
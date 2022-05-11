function nii=wjn_nii_sum(files,fname)

f='';
for a = 1:length(files)
    f = [f 'i' num2str(a) '+'];
end
f(end)=[];


       
spm_imcalc(files,fname,f);
nii =fname;
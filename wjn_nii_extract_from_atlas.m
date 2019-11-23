function nii = wjn_nii_extract_from_atlas(atlas,numbers,fname)

f=[];
for a = 1:length(numbers);
    f = [f '+(i1==' num2str(numbers(a)) ')']
end
f(1) = [];

spm_imcalc({atlas},fname,f);

nii = fname;
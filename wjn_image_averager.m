function wjn_image_averager(inputfiles,outputfile)


Vi = inputfiles;
Vo = outputfile;
f='(';
for a = 1:numel(inputfiles);
    f = [f 'i' num2str(a)];
    if a==numel(inputfiles);
        f = [f ')'];
    else
        f = [f '+'];
    end
end

f=[f '/' num2str(numel(inputfiles))];
spm_imcalc(Vi,Vo,f);




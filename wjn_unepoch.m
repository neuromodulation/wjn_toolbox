function D=wjn_unepoch_raw(Dfile)

try
    D=spm_eeg_load(file);
catch
    D=file;
end

dim=size(D);
trials = dim(end);

if length(dim) ==3
for a = 1:dim(1);
    nd = 
    



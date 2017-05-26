function D=wjn_reepoch(Dfile,n)

try
    D=spm_eeg_load(file);
catch
    D=file;
end
    dim=size(D);
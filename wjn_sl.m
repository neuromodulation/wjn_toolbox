function D=wjn_sl(filename)

[fname,fdir] = ffind(filename,1);

if length(fname)>1
    warning('more than 1 file found')
end
    fname = fname{1};
    fdir = fdir{1};

try
    D=spm_eeg_load(fullfile(fdir,fname));
catch
    D=spm_eeg_load(fullfile(fdir,[fname '*.mat']));
end
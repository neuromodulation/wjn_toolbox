function [fpath,fname] = wjn_recon_fpath(filename,fadd)
if ~exist('fadd','var')
    fadd='';
end
[fdir,fname]=fileparts(filename);
fpath = fullfile(fdir,['recon_all_' fname],fadd);
if ~exist(fpath,'dir')
    mkdir(fpath)
end
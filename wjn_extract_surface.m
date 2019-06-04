function outfile = wjn_extract_surface(filename,thresh)

if ~exist('thresh','var')
    spm_surf(filename,2)
else
    spm_surf(filename,2,thresh)
end

[dir,file]=fileparts(filename);
outfile = fullfile(dir,[file '.surf.gii']);
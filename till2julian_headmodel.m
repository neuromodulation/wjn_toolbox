function D = till2julian_headmodel(file);

D=spm_eeg_load(file)

vars = {'sMRI','def','tess_ctx','tess_scalp','tess_oskull','tess_iskull'};

for a = 1:length(vars);
    new_file = fullfile(megfolder,D.inv{1}.mesh.(vars{a})(9:end))
    if exist(D.inv{1}.mesh.(vars{a}),'file')
        warning('File existing on this computer');
    elseif exist(new_file,'file')
      D.inv{1}.mesh.(vars{a}) = new_file;
    else
        error('Head Model File wasn''t found')
    end
end

D.inv{1}.mesh
save(D);
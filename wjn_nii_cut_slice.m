function fnames = wjn_nii_cut_slice(slice,anatomy)

if ischar(slice)
    slice = {slice};
end


matlabbatch=[];
matlabbatch{1}.spm.util.imcalc.input = [{[slice{1} ',1']} anatomy]';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;

for a = 1:length(anatomy)
    [dir,file]=fileparts(anatomy{a});
    fnames{a}=[slice{1}(1:end-4) '-' file '.nii'];
    
    matlabbatch{1}.spm.util.imcalc.output =fnames{a};
    matlabbatch{1}.spm.util.imcalc.outdir = {dir};
    matlabbatch{1}.spm.util.imcalc.expression = ['i' num2str(a+1)];
    spm_jobman('run',matlabbatch)
    % keyboard
end

[~,file]=fileparts(slice{1});
matlabbatch=[];
matlabbatch{1}.spm.util.cat.vols = fnames';
matlabbatch{1}.spm.util.cat.name = [file '_4D_anatomy.nii'];
matlabbatch{1}.spm.util.cat.dtype = 16;
matlabbatch{1}.spm.util.cat.RT = NaN;
spm_jobman('run',matlabbatch)
fnames{end+1}= [file '_4D_anatomy.nii'];

function [dpeaks,table]=get_results(spmfile,ID,threshold,threshdesc,extent,contrastnumber)
% [dpeaks,table]=get_results(spmfile,ID,threshold,threshdesc,extent)
if ~exist('contrastnumber','var')
    contrastnumber = 1;
end
% spm eeg
matlabbatch{1}.spm.stats.results.spmmat = {spmfile};
matlabbatch{1}.spm.stats.results.conspec(1).titlestr = [ID '_' threshdesc num2str(threshold) 'k' num2str(extent)];
matlabbatch{1}.spm.stats.results.conspec(1).contrasts = contrastnumber;
matlabbatch{1}.spm.stats.results.conspec(1).threshdesc = threshdesc;
matlabbatch{1}.spm.stats.results.conspec(1).thresh = threshold;
matlabbatch{1}.spm.stats.results.conspec(1).extent = extent;
matlabbatch{1}.spm.stats.results.conspec(1).mask = struct('image', {}, 'thresh', {}, 'mtype', {});
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.print = true;
matlabbatch{1}.spm.stats.results.write.tspm.basename = [ID '_' threshdesc num2str(threshold) 'k' num2str(extent)];
spm_jobman('run',matlabbatch);

table = spm_list('List',evalin('base', 'xSPM'));
dpeaks = close_peaks(table.dat(:,12),table.dat(:,7),15)

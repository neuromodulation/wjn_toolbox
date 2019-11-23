
function [sigranges]=get_results_freqs(freqs,spmfile,ID,threshold,threshdesc,extent)
% sigranges=get_results_freqs(freqs,spmfile,ID,threshold,threshdesc,extent)

global xSPM
xSPM = [];
% spm eeg
matlabbatch{1}.spm.stats.results.spmmat = {spmfile};
matlabbatch{1}.spm.stats.results.conspec(1).titlestr = [ID '_' threshdesc num2str(threshold) 'k' num2str(extent)];
matlabbatch{1}.spm.stats.results.conspec(1).contrasts = 1;
matlabbatch{1}.spm.stats.results.conspec(1).threshdesc = threshdesc;
matlabbatch{1}.spm.stats.results.conspec(1).thresh = threshold;
matlabbatch{1}.spm.stats.results.conspec(1).extent = extent;
matlabbatch{1}.spm.stats.results.conspec(1).mask = struct('image', {}, 'thresh', {}, 'mtype', {});
matlabbatch{1}.spm.stats.results.units = 3;
matlabbatch{1}.spm.stats.results.print = true;
matlabbatch{1}.spm.stats.results.write.tspm.basename = [ID '_' threshdesc num2str(threshold) 'k' num2str(extent)];
spm_jobman('run',matlabbatch);
L=[];V=[];cclust=[];

if min(xSPM.Pc) <= 0.05;
    stat = zeros(xSPM.DIM');
    stat(sub2ind(xSPM.DIM', xSPM.XYZ(1,:)', xSPM.XYZ(2,:)', xSPM.XYZ(3,:)')) = xSPM.Z;
    stat = squeeze(stat);

    folder = fileparts(spmfile);

    L = bwlabeln(stat);
    try
        V = spm_vol(fullfile(folder, ['spmT_0001_' matlabbatch{1}.spm.stats.results.write.tspm.basename '.img']));
    catch 
         V = spm_vol(fullfile(folder, ['spmT_0001_' matlabbatch{1}.spm.stats.results.write.tspm.basename '.nii']));
    end
    V.fname = fullfile(folder, [matlabbatch{1}.spm.stats.results.write.tspm.basename '_sigmask.nii']);

    spm_write_vol(V, L);

    sigranges = [];
    for c = 1:max(L(:))
        cclust = squeeze(any(any(L==c)));
        sigranges = [sigranges; min(freqs(cclust)) max(freqs(cclust))];
    end
else 
    sigranges = [];
end
xSPM = [];
save([matlabbatch{1}.spm.stats.results.write.tspm.basename '_sigranges.mat'],'sigranges')
    
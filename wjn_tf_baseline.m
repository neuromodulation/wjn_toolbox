function D=wjn_tf_baseline(filename,timewindow)

D=spm_eeg_load(filename);
clear matlabbatch
matlabbatch{1}.spm.meeg.tf.rescale.D = {filename};

if ~exist('timewindow','var')
    matlabbatch{1}.spm.meeg.tf.rescale.method.Rel.baseline.timewin = [-Inf Inf];
    timewindow=[D.time(1) D.time(end)];
else
    matlabbatch{1}.spm.meeg.tf.rescale.method.Rel.baseline.timewin = timewindow;
end

matlabbatch{1}.spm.meeg.tf.rescale.method.Rel.baseline.Db = [];
matlabbatch{1}.spm.meeg.tf.rescale.prefix = 'r';
spm_jobman('run',matlabbatch)
[dir,fname]=fileparts(filename);
D=spm_eeg_load(fullfile(dir,['r' fname]));

if isfield(D,'meanalog') && ~isempty(fieldnames(D.meanalog))
    anames = fieldnames(D.meanalog);
    for a = 1:length(anames)
        for b = 1:D.ntrials
            data = D.meanalog.(anames{a})(D.indtrial(D.conditions{b}),:);
            mdata = nanmean(data(D.indsample(timewindow(1)/1000):D.indsample(timewindow(2)/1000)));
            D.rmeanalog.(anames{a})(b,:) = ((data-mdata)./mdata).*100;
        end
    end
end
save(D)
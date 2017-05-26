function D = wjn_average_baseline(filename,baseline,robust)
if sum(abs(baseline)) > 500;
    baseline = baseline/1000;
end

if ~exist('robust','var')
    robust = 0;
end

if robust
    S=[];
    S.robust.savew=0;
    S.robust.bycondition = 0;
    S.robust.ks = 3;
    S.robust.removebad = 1;
    S.D = filename; 
    D=spm_eeg_average(S)
    S=[];
    S.D = D.fullfile;
    S.method = 'Rel';
    D=spm_eeg_tf_rescale(S)
else

matlabbatch{1}.spm.meeg.averaging.average.D = {filename};
matlabbatch{1}.spm.meeg.averaging.average.userobust.standard = false;
matlabbatch{1}.spm.meeg.averaging.average.plv = false;
matlabbatch{1}.spm.meeg.averaging.average.prefix = 'm';
matlabbatch{2}.spm.meeg.tf.rescale.D(1) = cfg_dep('Averaging: Averaged Datafile', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{2}.spm.meeg.tf.rescale.method.Rel.baseline.timewin = baseline*1000;
matlabbatch{2}.spm.meeg.tf.rescale.method.Rel.baseline.Db = [];
matlabbatch{2}.spm.meeg.tf.rescale.prefix = 'r';
spm_jobman('run',matlabbatch)
[dir,fname,ext]=fileparts(filename);
D=spm_eeg_load(fullfile(dir,['rm' fname ext]));
end
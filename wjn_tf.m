function D=wjn_tf(filename,baseline,freq,timeres,timestep,robust,method)
% function wjn_tf(filename,baseline,freq,timeres,timestep,robust,method)
% method = {'multitaper' (default), 'wavelet','hilbert'};
D = spm_eeg_load(filename);
fsample = D.fsample;
fname = D.fname;
fdir = D.path;
clear D;
if ~exist('method','var')
    method = 'multitaper';
end

if ~exist('baseline','var') || isempty(baseline)
    baseline = [-Inf Inf];
elseif sum(abs(baseline))<50
    baseline = baseline.*1000;  
end


if ~exist('freq','var') || isempty(freq)
    freq = 1:fsample/2;
end

if ~exist('timeres','var') || isempty(timeres)
    timeres = 500;
end

if ~exist('timestep','var') || isempty(timestep)
    timestep = 50;
end


if ~exist('robust','var') || isempty(baseline)
    robust =1;
end
if strcmp(method,'multitaper')
    matlabbatch{1}.spm.meeg.tf.tf.D = {filename};
    matlabbatch{1}.spm.meeg.tf.tf.channels{1}.type = 'LFP';
    matlabbatch{1}.spm.meeg.tf.tf.frequencies = freq;
    matlabbatch{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
    matlabbatch{1}.spm.meeg.tf.tf.method.mtmspec.timeres = timeres;
    matlabbatch{1}.spm.meeg.tf.tf.method.mtmspec.timestep = timestep;
    matlabbatch{1}.spm.meeg.tf.tf.method.mtmspec.bandwidth = 3;
    matlabbatch{1}.spm.meeg.tf.tf.phase = 0;
    matlabbatch{1}.spm.meeg.tf.tf.prefix = '';
    matlabbatch{2}.spm.meeg.averaging.average.D(1) = cfg_dep('Time-frequency analysis: M/EEG time-frequency power dataset', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dtfname'));
elseif strcmp(method,'wavelet')
    D=wjn_tf_wavelet(filename,freq)
    matlabbatch{2}.spm.meeg.averaging.average.D(1) ={D.fullfile};
elseif strcmp(method,'hilbert')
    D=wjn_tf_wavelet(filename,freq)
    matlabbatch{2}.spm.meeg.averaging.average.D(1) ={D.fullfile};
end
    
if robust
    matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.ks = 3;
    matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.bycondition = false;
    matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.savew = false;
    matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.removebad = true;
    matlabbatch{2}.spm.meeg.averaging.average.plv = false;
    matlabbatch{2}.spm.meeg.averaging.average.prefix = 'm';
else
    matlabbatch{2}.spm.meeg.averaging.average.userobust.standard = false;
    matlabbatch{2}.spm.meeg.averaging.average.plv = false;
    matlabbatch{2}.spm.meeg.averaging.average.prefix = 'm';
end
matlabbatch{3}.spm.meeg.tf.rescale.D(1) = cfg_dep('Averaging: Averaged Datafile', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{3}.spm.meeg.tf.rescale.method.Rel.baseline.timewin = baseline;
matlabbatch{3}.spm.meeg.tf.rescale.method.Rel.baseline.Db = [];
matlabbatch{3}.spm.meeg.tf.rescale.prefix = 'r';
matlabbatch{4}.spm.meeg.tf.rescale.D(1) = cfg_dep('Time-frequency analysis: M/EEG time-frequency power dataset', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dtfname'));
matlabbatch{4}.spm.meeg.tf.rescale.method.Rel.baseline.timewin = baseline;
matlabbatch{4}.spm.meeg.tf.rescale.method.Rel.baseline.Db = [];
matlabbatch{4}.spm.meeg.tf.rescale.prefix = 'r';
spm_jobman('run',matlabbatch)

D = spm_eeg_load(fullfile(fdir,['rmtf_' fname]));
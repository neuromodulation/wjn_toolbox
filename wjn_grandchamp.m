function D=wjn_grandchamp(filename,baseline,method,condition)
% nD=wjn_grandchamp(filename,baseline,method,condition)
% if condition is defined, it has to be the first trial before other trials
% that should be corrected
if ~exist('method','var')
    method = 'additive';
end

if ~exist('condition','var')
    condition = 'all';
end

D=spm_eeg_load(filename);
D=wjn_grandchamp_singletrial(D.fullfile,baseline,method,condition);
D=wjn_average(D.fullfile,0);
D=wjn_grandchamp_mean(D.fullfile,baseline,method,condition);
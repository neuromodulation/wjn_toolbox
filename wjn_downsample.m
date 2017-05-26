function D = wjn_downsample(filename,fsample,lpfilter,prefix)
[fold,~]=fileparts(filename);

if ~exist('lpfilter','var')
    lpfilter = round(fsample/2);
end

if ~exist('prefix','var')
    prefix = 'd';
end

D=wjn_filter(filename,lpfilter,'low','');
ffile = fullfile(fold,D.fname);
S.D = D.fullfile;
S.fsample_new = fsample;
S.prefix = prefix;
D=spm_eeg_downsample(S);
delete(ffile);
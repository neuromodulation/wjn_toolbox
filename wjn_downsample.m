function D = wjn_downsample(filename,fsample,lpfilter,prefix)
[fold,~]=fileparts(filename);

if ~exist('lpfilter','var')
    lpfilter = round(fsample/2);
end

if ~isempty(lpfilter)
    D=wjn_filter(filename,lpfilter,'low','');
    ffile = fullfile(fold,D.fname);
else 
    ffile = filename;
    D=wjn_sl(ffile);
end

if ~exist('prefix','var')
    prefix = 'd';
end



S.D = D.fullfile;
S.fsample_new = fsample;
S.prefix = prefix;
D=spm_eeg_downsample(S);

function D=wjn_unepoch(filename,timewindow,cond,prefix)

D=spm_eeg_load(filename);

if ~exist('timewindow','var')
    timewindow = [D.time(1) D.time(end)];
end

if ~exist('cond','var')
    cond = D.conditions;
end

if ~exist('prefix','var')
    prefix = 'u';
end

nd = D(:,D.indsample(timewindow(1)):D.indsample(timewindow(2)),ci(cond,D.conditions));
nd = nd(:,:);

nsamples=length(nd);

nD=clone(D,fullfile(D.path,[prefix D.fname]),[D.nchannels nsamples 1]);
nD(:,:,1)=nd(:,:);
save(nD)
D=nD;

load(D.fullfile)
D.type = 'continuous';
save(fullfile(D.path,D.fname),'D')
D=spm_eeg_load(fullfile(D.path,D.fname));

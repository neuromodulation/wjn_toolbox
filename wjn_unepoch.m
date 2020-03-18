function D=wjn_unepoch(filename)

D=spm_eeg_load(filename);

nd = D(:,:,:);
nd = nd(:,:);

nsamples=length(nd);

nD=clone(D,fullfile(D.path,['u' D.fname]),[D.nchannels nsamples 1]);
nD(:,:,1)=nd(:,:);
save(nD)
D=nD;

load(D.fullfile)
D.type = 'continuous';
save(fullfile(D.path,D.fname),'D')
D=spm_eeg_load(fullfile(D.path,D.fname));



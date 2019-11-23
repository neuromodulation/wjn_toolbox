function D=wjn_eeg_mesh_smooth(filename,n)

if ~exist('n','var')
    n=3;
end

D=wjn_sl(filename);
ic = D.indchantype('EEG');
d =D(ic,:,:,:);
rc = setdiff(1:D.nchannels,ic);

sd=wjn_mesh_smooth(D.sources.mesh,d(:,:),n);
nD=clone(D,[fullfile(D.path,['sp' num2str(n) '_' D.fname])]);
nD(ic,:) = sd(:,:);
nD(rc,:,:,:) = D(rc,:,:,:);
save(nD);
D=nD;
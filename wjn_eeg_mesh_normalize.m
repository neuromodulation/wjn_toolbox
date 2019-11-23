function D = wjn_eeg_mesh_normalize(filename)
D=wjn_sl(filename);
nD = clone(D,fullfile(D.path,['n' D.fname]));
d=D(:,:,:,:);
for a =1:D.nfrequencies
    for b = 1:D.ntrials
        nd(:,a,:,b) = zscore(squeeze(d(:,a,:,b))')';
    end
end
nD(:,:,:,:)=nd;
save(nD)

D=nD;



function D=wjn_beta_invaders_single_trial_baseline(filename)
D=spm_eeg_load(filename)
nruns = D.nchannels*D.nfrequencies*D.ntrials;
n=0;
for a=1:D.nchannels;
    for b =1:D.nfrequencies;
        bl = nanmean(nanmean(D(a,b,:,:),3),4);
        
        for c = 1:D.ntrials;
            n=n+1;
            d(a,b,:,c) = 100*((D(a,b,:,c)-bl)./bl);
            
        end
        disp([num2str(n/nruns*100) '%'])
    end
end

nD = clone(D,['r' D.fname]);
nD(:,:,:,:) = d(:,:,:,:);
save(nD)
D=nD;
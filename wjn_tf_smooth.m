function D = wjn_tf_smooth(filename,fhz,ts)
% D = wjn_tf_smooth(filename,fhz,ts);
D=spm_eeg_load(filename);

fr = unique(diff(D.frequencies));
if length(fr)==1
    F = fhz*fr(1);
else
    F=round(fhz/fr);
end

if ts < 1    
    T = round(ts*D.fsample);
else
    T=round(ts/1000*D.fsample);
end

for a =1:D.nchannels
    for b = 1:D.ntrials
        d(a,:,:,b) = smooth2a(squeeze(D(a,:,:,b)),F,T);
    end
end

sD= clone(D,['s' D.fname]);
sD(:,:,:,:) =d(:,:,:,:);
sD.smoothingkernel = [F T];
save(sD);
D=sD;
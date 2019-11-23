function D=wjn_tf_log_normalization(filename,flow,fhigh)

D=spm_eeg_load(filename);
if ~exist('flow','var')
    flow = [3 5];
end
if ~exist('fhigh','var')
    fhigh = [70 80];
end


for a = 1:D.nchannels
    tf = squeeze(D(a,:,:,1));

[pow,baseline]=fftlogfitter(D.frequencies,nanmean(tf,2),flow,fhigh);
    for b = 1:size(tf,2)
        d(a,:,b,1) = tf(:,b)-baseline;
    end
        
end
% keyboard
d(d<0)=0;

nD = clone(D,['ln' D.fname]);
nD(:,:,:,:)= d;
save(nD);
D=nD;

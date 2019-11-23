function D=wjn_tmsi_rereference_boston_segmented(filename)

D=spm_eeg_load(filename);

bchans = {'rLFPR1_8','rLFPR1_234','rLFPR234_567','rLFPR567_8',...
    'rLFPL1_8','rLFPL1_234','rLFPL234_567','rLFPL567_8'};
ichans = {{1,8},{1,[2 3 4]},{[2 3 4],[5 6 7]},{[ 5 6 7],8},...
    {9,16},{9,[10 11 12]},{[10 11 12],[13 14 15]},{[13 14 15],16}};

nd = D(:,:,:);
for a = 1:length(bchans)
    nd(D.nchannels+a,:,:) = nansum(D(ichans{a}{1},:,1),1)-nansum(D(ichans{a}{2},:,1),1);
end

chans = D.chanlabels;

nD= clone(D,['br' D.fname],[D.nchannels + length(bchans) D.nsamples D.ntrials]);
nD(:,:,:) = nd(:,:,:);
nD = chanlabels(nD,':',[chans bchans]);
nD = chantype(nD,ci('LFP',nD.chanlabels),'LFP');
nD = chantype(nD,ci({'EEG','Cz'},nD.chanlabels),'EEG');
nD = chantype(nD,ci({'EMG'},nD.chanlabels),'EMG');
save(nD)
D=nD;
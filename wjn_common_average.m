function D=wjn_common_average(filename,channels,refchannel)

D=spm_eeg_load(filename);

i = ci(channels,D.chanlabels);
dim = size(D);
    
if exist('refchannel','var')
    dim(1) = dim(1)+1;
end
    
nD=clone(D,['c' D.fname],dim);
nD=chantype(nD,1:D.nchannels,D.chantype);
nD=chanlabels(nD,1:D.nchannels,D.chanlabels);
nD(1:D.nchannels,:)=D(:,:);
md = nanmean(D(i,:));
% keyboard
if exist('refchannel','var')
    nD(nD.nchannels,:,:) = nanmean(nD(i,:)-md)-md;
    nD=chanlabels(nD,nD.nchannels,refchannel);
    nD=chantype(nD,nD.nchannels,nD.chantype(i(1)));
    save(nD)
end
nD(i,:,:) = nD(i,:)-nanmean(nD(i,:));
save(nD);
D=nD;
D=wjn_eeg_fix_sensors(D.fullfile);


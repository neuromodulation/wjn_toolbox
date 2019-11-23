function [D,nnD]=wjn_spm_rereference_bipolar(filename,channels)

D=spm_eeg_load(filename);

if ~exist('channels','var')
    channels = {'GPiR','GPiL','VIMR','VIML','STNR','STNL','LFPR','LFPL','ECOGR','ECOGL'};
end

if ischar(channels)
    channels = {channels};
end
%%
ndata=[];
data = D(:,:,:);
chans = D.chanlabels;
nchans = {};
nchantype = {};
for a = 1:length(channels)
    chs = ci(channels{a},D.chanlabels);
    if ~isempty(chs)
        for b =1:length(chs)-1
            ndata(size(ndata,1)+1,:)=data(chs(b),:)-data(chs(b+1),:);
            nchans{length(nchans)+1}=[chans{chs(b)} '-' chans{chs(b+1)}];
            nchantype{length(nchantype)+1} = D.chantype{chs(b)};
        end
    end
end
        
nD=clone(D,['rb' D.fname],[size(ndata) 1]);
nD(:,:,1) = ndata;
nD=chanlabels(nD,':',nchans);
nD=chantype(nD,':',nchantype);
save(nD);

nnD=clone(D,['ab' D.fname],[D.nchannels + length(nchans) D.nsamples 1]);
nnD(1:D.nchannels,:,1) = data;
nnD(D.nchannels+1:D.nchannels+length(nchans),:,1) = ndata;
nnD=chanlabels(nnD,':',[D.chanlabels,nchans]);
nnD=chantype(nnD,':',[D.chantype,nchantype]);
save(nnD)
D=nD;

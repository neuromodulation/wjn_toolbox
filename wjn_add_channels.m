function D=wjn_add_channels(filename,idata,chans)

D=spm_eeg_load(filename);

d=D(:,:,:);

if ischar(chans)
    chans = {chans};
end

if isstruct(idata)
    chans = fieldnames(idata);
    ndata = idata;
    idata = [];
    for a = 1:length(chans)
        idata(a,:,:)=ndata.(chans{a});
    end
end
nchannels = length(chans);
nc=D.nchannels+1:D.nchannels+nchannels;
d(nc,:,:)=idata;
dim = size(d);
if length(dim)==2
    dim = [dim(1:2) 1];
end
nD=clone(D,['a' D.fname],dim);
nD(:,:,:) = d(:,:,:);
nD=chanlabels(nD,1:D.nchannels,D.chanlabels);
nD=chanlabels(nD,nc,chans);
nD=chantype(nD,1:D.nchannels,D.chantype);
nD=chantype(nD,nc,wjn_chantype(chans));
save(nD);
D=nD;


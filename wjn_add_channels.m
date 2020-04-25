function D=wjn_add_channels(filename,idata,chans)

D=spm_eeg_load(filename);

d=D(:,:,:);

if ischar(chans)
    chans = {chans};
end

if iscell(idata) && size(idata,2)==2
    refchans = idata;
    idata=[];
    for a = 1:size(refchans,1)
        
        idata(a,:,:) = D(ci(refchans{a,1},D.chanlabels,1),:,:)-D(ci(refchans{a,2},D.chanlabels,1),:,:);
    end
    if ~exist('chans','var') || isempty(chans)
        chans = strcat(chans(:,1),'-',chans(:,2));
    end
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


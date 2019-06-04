function nD = wjn_remove_bad_channels(filename)

D=spm_eeg_load(filename);
i = D.badchannels;
ch = D.chantype;
io = 1:D.nchannels;
% keyboard
io(i) = [];

in = 1:numel(io);
dim = size(D);
dim(1) = numel(in);
nD = clone(D,['b' D.fname],dim);
nD = chanlabels(nD,in,D.chanlabels(io));
nD = chantype(nD,in,D.chantype(io));
nD = units(nD,in,D.units(io));
if length(dim) ==3
    nD(:,:,:) = D(io,:,:);
elseif length(dim) == 4
    nD(:,:,:,:) = D(io,:,:,:);
end
save(nD);


function D = wjn_spm_addchannel(filename,channelname)

D=wjn_sl(filename);
dim = size(D);
dim(1) = dim(1) + 1;

[fdir,fname,ext]=fileparts(D.fullfile);
nD = clone(D,fullfile(fdir,['a' fname ext]),dim);

nD = chanlabels(nD,':',[D.chanlabels channelname]);

save(nD);
D=nD;
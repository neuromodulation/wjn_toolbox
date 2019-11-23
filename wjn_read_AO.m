function samples = wjn_read_AO(chans)
if ~exist('chans','var')
    chans = [1:16]+10015;
elseif chans(1)<10000
    chans = chans+10015;
end
[~,d, di] = AO_GetAlignedData(chans);
try
    samples=double(reshape(d(1:di), [di/numel(chans),numel(chans)])');
catch
    samples =[];
end
AO_ClearChannelData();


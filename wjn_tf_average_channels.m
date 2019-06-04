function D=wjn_tf_average_channels(filename,channels,channame)

D=wjn_sl(filename);
if ~exist('channame','var')
    chn=1;
end

if ischar(channels)
    channels = {{channels}};
elseif ischar(channels{1})
    channels = {channels};
end

nD=clone(D,['mc' D.fname],[numel(channels),D.nfrequencies,D.nsamples,D.ntrials]);
for a = 1:length(channels)
    nD(a,:,:,:) = nanmean(D(ci(channels{1},D.chanlabels),:,:,:),1);
    if  chn==1 && numel(channels{a})==1
        channame{a} = channels{a}{1};
    end     
end


nD=chanlabels(nD,':',channame);
nD.channels = channels;
save(nD);

D=nD;

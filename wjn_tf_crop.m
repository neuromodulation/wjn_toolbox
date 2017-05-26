function D=wjn_tf_crop(filename,fhz,timewindow,channels,conds)

D=wjn_sl(filename);

if ~exist('fhz','var') || isempty(fhz)
    fhz = D.indfrequency(D.frequencies);
elseif numel(fhz)==2
    fhz = D.indfrequency(fhz(1):fhz(2));
else
    fhz = D.indfrequency(fhz);
end

if ~exist('timewindow','var') || isempty(timewindow)
    timewindow = D.indsample(D.time);
else
    if abs(sum(timewindow))>1000
        timewindow = timewindow/1000;
    end
    if numel(timewindow)==1
        timewindow = D.indsample(-timewindow(1):timewindow(1));
    elseif numel(timewindow)==2
        timewindow = D.indsample(timewindow(1):timewindow(2));
    else
        timewindow = D.indfrequency(timewindow);
    end
end

if ~exist('channels','var') || isempty(channels)
    channels = 1:D.nchannels;
elseif ischar(channels) || iscell(channels)
    channels = ci(channels,D.chanlabels);
end

if ~exist('conds','var') || isempty(conds)
    conds = 1:D.ntrials;
elseif ischar(conds) || iscell(conds)
    conds = ci(conds,D.conditions);
end

dim = [numel(channels) numel(fhz) numel(timewindow) numel(conds)];
nD = clone(D,['c' D.fname],dim);
nD=chanlabels(nD,':',D.chanlabels(channels));
nD=frequencies(nD,':',D.frequencies(fhz));
nD=timeonset(nD,D.timeonset);
nD=conditions(nD,':',D.conditions(conds));
nD(:,:,:,:)=D(channels,fhz,timewindow,conds);
save(nD);
D=nD;

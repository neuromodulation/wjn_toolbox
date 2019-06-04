function nD=wjn_boston_vercise_rereferencing(filename,lfp)

try
    D=spm_eeg_load(filename);
if ~exist('lfp','var')
if ~isempty(ci('STNL12',D.chanlabels))
    lfp = 'STN';
elseif ~isempty(ci('VIML12',D.chanlabels))
    lfp = 'VIM';
elseif ~isempty(ci('LFPL12',D.chanlabels))
    lfp = 'LFP';
elseif ~isempty(ci('GPiL12',D.chanlabels))
    lfp = 'GPiL12';
else
    error('No LFP channels found.')
end
end
    channel = lfp;
sides = {'L' 'R'};
combinations = [2 5;3 6;4 7; 2 3; 3 4; 2 4; 5 6; 6 7; 5 7];
nn = length(combinations)*2;
n=0;
for s = 1:length(sides)
for a = 1:length(combinations)
    n=n+1;
    cname=['r' channel sides{s} num2str(combinations(a,1)) num2str(combinations(a,2))];
    nc{n} = cname;
    rd(n,:,1:D.ntrials) = D(ci([channel  sides{s} num2str(1) num2str(combinations(a,1))],D.chanlabels),:,:)-D(ci([channel  sides{s} num2str(1) num2str(combinations(a,2))],D.chanlabels),:,:);
%     eval([cname '.values = ' channel sides{s} num2str(1) num2str(combinations(a,1)) '.values-' channel sides{s} num2str(1) num2str(combinations(a,2)) '.values;'])
end
end
    
nD=clone(D,['ref' D.fname],[size(rd,1)+D.nchannels,D.nsamples,D.ntrials]);
nD(1:D.nchannels,:,:) = D(:,:,:);
nD(D.nchannels+1:D.nchannels+nn,:,:) = rd;
nD=chanlabels(nD,':',[D.chanlabels nc]);
nD=chantype(nD,1:D.nchannels,D.chantype);
nD=chantype(nD,D.nchannels+1:D.nchannels+nn,'LFP');
save(nD)
catch
load(filename);
if ~exist('lfp','var')
if exist('STNL12','var')
    lfp = 'STN';
elseif exist('VIML12','var')
    lfp = 'VIM';
elseif exist('LFPL12','var')
    lfp = 'LFP';
elseif exist('GPiL12','var')
    lfp = 'GPiL12';
else
    error('No LFP channels found.')
end
end
dummy = eval([lfp 'L18']);

channel = lfp;
sides = {'L' 'R'};
combinations = [2 5;3 6;4 7; 2 3; 3 4; 2 4; 5 6; 6 7; 5 7];
n=0;
for s = 1:length(sides)
for a = 1:length(combinations)
    n=n+1;
    cname=['r' channel sides{s} num2str(combinations(a,1)) num2str(combinations(a,2))];
    nc{n} = cname;
    eval([cname ' = dummy;']);
    eval([cname '.title = ''' cname ''';']);
    eval([cname '.values = ' channel sides{s} num2str(1) num2str(combinations(a,1)) '.values-' channel sides{s} num2str(1) num2str(combinations(a,2)) '.values;'])
end
end

save([filename],['r' channel '*'],'-append')
nD=filename;
end
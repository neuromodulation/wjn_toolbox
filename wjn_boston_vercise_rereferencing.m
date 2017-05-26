function wjn_boston_vercise_rereferencing(filename,lfp)

load(filename);
if ~exist('lfp','var');
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
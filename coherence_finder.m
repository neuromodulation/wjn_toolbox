function list = coherence_finder(chanstring1,chanstring2,all_channels)
%list = coherence_finder(chanstring1,chanstring2,all_channels)

[na,ia] = channel_finder(chanstring1,all_channels);
[nb,ib] = channel_finder(chanstring2,all_channels);

if isempty(na) || isempty(nb);
    warning('No combinations found...');
    list = [];
    return
end

n=0;
for a = 1:length(na);
    for b = 1:length(nb);
        if ~strcmp(na{a},nb{b})
        n = n+1;
        list(n,1:2) = {na{a},nb{b}};
        end
    end
end

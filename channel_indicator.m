function [channelindex,channelnames] = channel_indicator(channels,possible_list)
n=1;
if ischar(channels);
    i = find(strncmpi(channels,possible_list,length(channels)));
elseif iscell(channels);

    for a = 1:length(channels);

         index=find(strncmpi(channels{a},possible_list,length(channels{a})));

        if ~isempty(index);
            
            i(n:n+length(index)-1) = index;
            n=n+length(index);
        end
        index = [];
    end
else
    error('channel input must be cell or character');
end
if ~exist('i','var');
    warning('No match found.')
    channelindex = [];
    channelnames =[];
    return

end
channelnames = possible_list(i);
channelindex = i;
display(channelnames);


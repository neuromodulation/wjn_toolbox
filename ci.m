function [channelindex,channelnames] = ci(channels,possible_list,exact)
% channel_indicator

if ~exist('exact','var')
    exact = 0;
end
[channelnames,channelindex] = channel_finder(channels,possible_list,exact) ;
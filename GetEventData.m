function [EventTimes] = GetEventData(filename)

[ns_RESULT, hFile] = ns_OpenFile(filename);
[ns_RESULT, nsFileInfo] = ns_GetFileInfo(hFile);

for i = 1:nsFileInfo.EntityCount
    [~, nsEntityInfo(i,1)] = ns_GetEntityInfo(hFile, i);
end

EventEntityIDs   = find([nsEntityInfo.EntityType]==1);
EventEntityLabels   = {nsEntityInfo(EventEntityIDs).EntityLabel};
EventItemCounts   = [nsEntityInfo(EventEntityIDs).ItemCount];
EventEntityCount  = length(EventEntityIDs);
Events            = nan(max(EventItemCounts), EventEntityCount);
EventTimes        = nan(max(EventItemCounts), EventEntityCount);
EventSizes        = nan(max(EventItemCounts), EventEntityCount);

for i = 1:EventEntityCount
    for j = 1:EventItemCounts(i)
        [~, EventTimes(j,i), Events(j,i), EventSizes(j,i)] = ns_GetEventData(hFile, EventEntityIDs(i), j);
    end
end
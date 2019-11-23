function rloc = wjn_rereference_bipolar_location(location)

for a = 1:size(location,2)-1
    rloc(:,a) = nanmean(location(:,a:a+1),2);
end
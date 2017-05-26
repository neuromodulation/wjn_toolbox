function d = wjn_tf_nan_intervals(D,intervals)

d=D(:,:,:,:);
for a = 1:size(intervals,1)
    d(:,:,D.indsample(intervals(a,1)):D.indsample(intervals(a,2)),:)=nan;
end
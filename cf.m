function [ic]=cf(ch1,ch2,comb)
% finds combinations in both directions
% [ic]=cf(ch1,ch2,comb)

[~,ic1]=channel_finder(ch1,comb(:,1));
[~,ic2]=channel_finder(ch2,comb(:,2));

[i1c]=intersect(ic1,ic2);


[~,ic1]=channel_finder(ch2,comb(:,1));
[~,ic2]=channel_finder(ch1,comb(:,2));

[i2c]=intersect(ic1,ic2);

ic = [i1c,i2c];
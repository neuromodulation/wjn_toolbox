function [ic]=combination_finder(ch1,ch2,comb)

[~,ic1]=channel_finder(ch1,comb(:,1));
[~,ic2]=channel_finder(ch2,comb(:,2));

[ic]=intersect(ic1,ic2);
function [p]=permTest_baseline(ni,data1,data2);

if ~exist('data2','var');
    [p]=permTestzero(ni,data1);
else
    [p]=pairPermTest(ni,data1,data2);
end
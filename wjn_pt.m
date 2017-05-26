function [p,t]=wjn_pt(d1,d2,ni)
%function p=wjn_pt(d1,d2,ni)

if ~exist('d2','var') || isempty(d2)
    d2 = zeros(size(d1));
end

if ~exist('ni','var') 
    ni = 5000;
end

i = unique([find(isnan(d1));find(isnan(d2))]);
d1(i)=[];
d2(i) = [];

p = permTest(ni,d1,d2);
t = 1-p;
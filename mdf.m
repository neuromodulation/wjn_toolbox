function [df,d] = mdf(input)
if ~exist('input','var')
    input = 1;
end

[~,df,~,d]=getsystem;

if input == 2
    t=df;
    df=d;
    d=t;
end
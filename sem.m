function [e] = sem(x)
    n = length(x);
    v = nanstd(x);
    e = v/sqrt(n);
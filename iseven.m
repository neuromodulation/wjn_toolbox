
function [ise] = iseven(x);
%works for sccalar and vector
ise = roundn(x/2,0) == x/2; 
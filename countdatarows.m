function  n = countdatarows
% COUNTDATAROWS returns number of rows in cogent data file.
%
% Description:
%     Returns number of rows in file specified by CONFIG_DATA
%
% Usage:
%     COUNTDATAROWS
%
% Arguments:
%     NONE
%
% See also:
%     LOADDATA, GETDATA, COUNTDATAROWS
%
% Cogent 2000 function.

global cogent;

n = 0;
if isfield(cogent,'data')
   n = length(cogent.data);
end


function logslice
% waitslice
%
% Transfers scanner slices read by getslice to the log file.
%
% See also:
%   config_serial, getslice, waitslice.
%
% Cogent2000 function

global cogent;

temp = cogent.scanner;
n = length(temp.slices);
for i = 1:n
   message = sprintf( 'Slice\t%d\tat\t%-8d', temp.slices(i), temp.times(i));
   logstring( message ) ;
end
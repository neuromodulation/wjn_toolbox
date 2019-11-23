function logstring(a)
% LOGSTRING writes a time tag and string to the console and log file.
%
% Description:
%    Write a time tag and string to the console and log file.
%
% Usage:
%    LOGSTRING( str )
%
% Arguments:
%    str - string to write to console and log file
%
% Examples:
%    LOGSTRING( 'Hello' )
%
% See also:
%    CONFIG_LOG
%
% Cogent 2000 function.

global cogent;

if ischar(a)
   str = a;
elseif isnumeric(a)
   str = num2str(a);
else
   error( 'argument must be a string or a number' )
end

t = time;
%tag = sprintf( '%8d[%8d] :\t', t, t-cogent.log.time );

tag = [num2str(t, '%8d') 9 '[' num2str(t-cogent.log.time, '%8d') ']' 9 ':' 9];
      
cogstd( 'sOutStr', [ tag str char(10) ]) ;
cogent.log.time=t;
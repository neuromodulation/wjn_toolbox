function [ value, time, n ] = getserialbytes( varargin )
% GETSERIALBYTES return values and times of serial bytes read by READSERIALBYTES
%
% Description:
%     READSERIAL bytes reads the values and times of bytes sent to the serial port.
%     Use GETSERIALBYTES to access these values and times.  
%
% Usage:
%   [ value, time, n ] = GETSERIALBYTES( port, bytes )
%
% Arguments:
%     port   - port number
%     bytes  - 
%     value  - array of byte values
%     time   - array of times
%     n      - number of serial bytes
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.


global cogent;

% Input arguments
error( nargchk(1,2,nargin) );
port  = varargin{1};
bytes = default_arg( [], varargin, 2 );

error( checkserial(port) );

n = length( cogent.serial{port}.value );
if isempty(bytes)
   index = 1:n;
else
   index = find(  ismember( cogent.serial{port}.value, bytes )  );
end

% Return arguments
value = cogent.serial{port}.value(index);
time  = cogent.serial{port}.time(index);
n     = length( index );

function [ byte, t, n ] = waitserialbyte( varargin )
% WAITSERIALBYTE wait for byte to arrive on serial port
%
% Description:
%     Wait for serial byte to arrive at port.  The port need to be configured with CONFIG_PORT before 
%     WAITSERIALBYTE can be called.  
%
% Usage:
%     [ byte, t, n ] = WAITSERIALBYTE( port, duration )       - wait 'duration' milliseconds for any byte
%                                                               to arrive at COM port
%     [ byte, t, n ] = WAITSERIALBYTE( port, duration, code ) - wait 'duration' milliseconds for byte 'code' to 
%                                                               arrive at COM port 
%
% Arguments:
%    byte     - value of byte read at port
%    t        - time of byte read
%    n        - number of serial bytes returns
%    port     - serial port number
%    code     - serial bytes to wait for
%    duration - duration (in milliseconds) to wait for a serial byte
%
% Examples:
%     WAITSERIALBYTE( 1, 1000 )            - wait 1000 milliseconds for any byte to arrive on COM1
%     WAITSERIALBYTE( 2, 2000, 10 )        - wait 2000 milliseconds for byte=10 to arrive on COM2
%     WAITSERIALBYTE( 2, 2000, [ 10 20 ] ) - wait 2000 milliseconds for bytes 10 or 20 to arrive on COM2
%     WAITSERIALBYTE( 1, inf )             - wait for an indefinte amount of time for any byte to arrive on COM1
%     WAITSERIALBYTE( 2, inf, 10 )         - wait for an indefinte amount of time for byte=10 to arrive on COM2
%     WAITSERIALBYTE( 2, inf, [ 10 20 ] )  - wait for an indefinte amount of time for bytes 10 or 20 to arrive 
%                                          - on COM2
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.

global cogent;

t0 = time;

% Arguments
error( nargchk(2,3,nargin) );
port     = varargin{1};
duration = default_arg( inf, varargin, 2 );
code     = default_arg( [], varargin,3 );

error( checkserial(port) );

t    = [];
byte = [];
n = 0;
while( time-t0 < duration & n == 0 )
   logserialbytes( port );
   [ byte, t, n ] = getserialbytes( port, code );
   readserialbytes( port );
end

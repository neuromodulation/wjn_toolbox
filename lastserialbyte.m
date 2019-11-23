function [ byte, time ] = lastserialbyte( port )
% LASTSERIALBYTE returns the value and time of the last byte to be read by READSERIALBYTES
%
% Description:
%     Returns the value and time of the last byte to be read by READSERIALBYTES.  
%     If no bytes have been read then value and time are -1.
%
% Usage:
%     LASTSERIALBYTE( port )
%
% Arguments:
%     port    - port number
%
% Examples:
%     [ byte, time ] = LASTSERIALBYTE( 1 ) 
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.

global cogent

error( checkserial(port) );

temp = cogent.serial{port};

byte = -1;
time = -1;

n = length(temp.value);
if n > 0
   byte = temp.value(n);
   time = temp.time(n);
end

return;

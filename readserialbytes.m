function readserialbytes( port )
% READSERIALBYTES reads bytes sent to serial port since last call to READSERIALBYTES or CLEARSERIALBYTES.
%
% Description:
%     Reads bytes sent to serial port since last call to READSERIALBYTES o CLEARSERIALBYTES.  Once read 
%     the bytes can be sent to the log using LOGSERIALBYTES or accessed using GETSERIALPORT.
%
% Usage:
%   READSERIALBYTES( port )
%
% Arguments:
%     port - port number
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.


global cogent;

error( checkserial(port) );

% get port
temp = cogent.serial{port};
   
% Get recorded bytes
[ temp.value, temp.time ] = CogSerial( 'GetEvents', temp.hPort );
%temp.time = floor( temp.time / 1000 ); time now in seconds not us 19-2-2002 e.f.
temp.time = floor( temp.time * 1000 );
temp.number_of_responses = length( temp.time );

cogent.serial{port} = temp;

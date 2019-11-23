function logserialbytes( port )
% LOGSERIALBYTES transfers serial bytes read by READSERIALBYTES to log file.
%
% Description:
%     Transfers serial bytes read by READSERIALBYTES to log file.
%
% Usage:
%     LOGSERIALBYTES( port )
%
% Arguments:
%     port - port number
%
% Examples:
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.

global cogent;

error( checkserial(port) );

temp = cogent.serial{port};
n = length(temp.value);
for i = 1:n
   message = sprintf( 'Byte\t%d\t%s\tat\t%-8d', temp.value(i), temp.name, temp.time(i));
   logstring( message ) ;
end
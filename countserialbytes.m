function n = countserialbytes( port )
% COUNTSERIALBYTES returns the number of serial bytes read by READSERIALBYTES
%
% Description:
%     COUNTSERIALBYTES returns the number of serial bytes read by READSERIALBYTES
%
% Usage:
%     n = COUNTSERIALBYTES( port )
%
% Arguments:
%     port   - port number
%     n      - number of serial bytes
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.


global cogent;

error( checkserial(port) );

n = length( cogent.serial{port}.time );

function clearserialbytes( port )
% CLEARSERIALBYTES clears bytes sent to serial port since last call to READSERIALBYTES
%
% Description:
%      Clears bytes sent to serial port since last call to READSERIALBYTES
%
% Usage:
%   CLEARSERIALBYTES( port )
%
% Arguments:
%     port - port number
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%     CLEARSERIALBYTES
%
% Cogent 2000 function.


global cogent;

error( checkserial(port) );

temp = cogent.serial{port};
CogSerial( 'GetEvents', temp.hPort );
temp.time = [];
temp.value = [];
temp.number_of_responses = 0;

cogent.serial{port} = temp;

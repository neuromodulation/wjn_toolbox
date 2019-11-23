function config_serial( varargin )
% CONFIG_SERIAL configures serial port
%
% Description:
%     Configure serial port. When START_COGENT is called the port is opened. When STOP_COGENT 
%     is called the port is closed.
%
% Usage:
%     CONFIG_SERIAL( port = 1, baudrate = 9600, parity = 0, stopbits = 0, bytesize = 8 )
%
% Arguments:
%      port        - COM port number (1,2,3,4,etc)
%      baudrate    - (110,300,600,1200,2400,4800,9600,14400,19200,38400,56000,57600,11520,128000,256000)
%      parity      - (0-no, 1-odd, 2-even, 3-mark, 4-space)
%      stopbits    - (0-one, 1-one and a half, 2-two)
%      bytesize    - (4 bits, 8 bits)
%
% Examples:
%    CONFIG_SERIAL                      - Open COM1 with baudrate=9600,  parity=no,  stopbits=one and bytesize=8.
%    CONFIG_SERIAL( 2 )                 - Open COM2 with baudrate=9600,  parity=no,  stopbits=one and bytesize=8.
%    CONFIG_SERIAL( 3, 56000, 1, 2, 8 ) - Open COM3 with baudrate=56000, parity=odd, stopbits=two and bytesize=8.
%
% See also:
%     CONFIG_SERIAL, READSERIALBYTES, SENDSERIALBYTES, LOGSERIALBYTES, WAITSERIALBYTE, GETSERIALBYTES
%
% Cogent 2000 function.

global cogent;

error( nargchk(0,5,nargin) );

port = default_arg( 1, varargin, 1 );
if port < 1 
   error( 'port argument must be > 0' );
end

serial.name = [ 'COM', num2str(port) ];
serial.baudrate    = default_arg( 9600, varargin, 2 );
serial.parity      = default_arg( 0,    varargin, 3 );
serial.stopbits    = default_arg( 0,    varargin, 4 );
serial.bytesize    = default_arg( 8,    varargin, 5 );
serial.value       = [];
serial.time        = [];

cogent.serial{port} = serial;


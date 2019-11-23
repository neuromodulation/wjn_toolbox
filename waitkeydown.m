function [ keyout, t, n ] = waitkeydown( varargin )
% WAITKEYDOWN waits for a key press
%
% Description:
%     Waits for a key press and returns the key ID and time.
%
% Usage:
%     [ keyout, time, n ] = WAITKEYDOWN( duration )        - wait 'duration' milliseconds for any key press
%     [ keyout, time, n ] = WAITKEYDOWN( duration, keyin ) - wait 'duration' milliseconds for specified key press
%
% Arguments:
%    keyout   - IDs of key presses
%    time     - times of key presses
%    keyin    - wait for key ID 'keyin' to be pressed
%    duration - time in milliseconds to wait for key press before resuming execution
%    n        - number of key presses
%
%
% Examples:
%     WAITKEYDOWN( 1000 )            - wait 1000 milliseconds for any key press
%     WAITKEYDOWN( inf )             - wait an indefinite time for any key press
%     WAITKEYDOWN( 1000, 1 )         - wait 1000 milliseconds for key 1 (A) to be pressed
%     WAITKEYDOWN( 1000, inf )       - wait an indefinite time for key 1 (A) to be pressed
%     WAITKEYDOWN( 1000, [ 1 2 ] )   - wait 1000 milliseconds for key 1 (A) or key 2 (B) to be pressed
%
% See also:
%     CONFIG_KEYBOARD, READKEYS, LOGKEYS, WAITKEYDOWN, WAITKEYUP, LASTKEYDOWN, LASTKEYUP, GETKEYDOWN, 
%     GETKEYUP, GETKEYMAP
%
% Cogent 2000 function.


global cogent;

error( checkkeyboard );
error( nargchk(1,2,nargin) );

duration = default_arg( inf, varargin, 1 );
keyin    = default_arg( [],  varargin, 2 );
[ keyout, t, n ] = waitkey(  duration, keyin, 128 );



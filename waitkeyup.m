function [ keyout, time, n ] = waitkeyup( varargin )
% WAITKEYUP waits for a key to be released.
%
% Description:
%     Waits for a key to be released.
%
% Usage:
%     [ keyout, time, n ] = WAITKEYUP( duration )        - wait 'duration' milliseconds for any key release
%     [ keyout, time, n ] = WAITKEYUP( duration, keyin ) - wait 'duration' milliseconds for specified key release
%
% Arguments:
%    keyout   - ID of keys that have been released
%    time     - time of key release
%    keyin    - wait for key ID 'keyin' to be released
%    duration - time in milliseconds to wait for key release before resuming execution
%    n        - number of key releases
%
%
% Examples:
%     WAITKEYUP( 1000 )            - wait 1000 milliseconds for any key release
%     WAITKEYUP( inf )             - wait an indefinite time for any key release
%     WAITKEYUP( 1000, 1 )         - wait 1000 milliseconds for key 1 (A) to be released
%     WAITKEYUP( 1000, inf )       - wait an indefinite time for key 1 (A) to be released
%     WAITKEYUP( 1000, [ 1 2 ] )   - wait 1000 milliseconds for key 1 (A) or key 2 (B) to be released
%
% See also:
%     CONFIG_KEYBOARD, READKEYS, LOGKEYS, WAITKEYDOWN, WAITKEYUP, LASTKEYDOWN, LASTKEYUP, GETKEYDOWN, 
%     GETKEYUP, GETKEYMAP
%
% Cogent 2000 function.


global cogent;

error( nargchk(1,2,nargin) );
error( checkkeyboard );

duration = default_arg( inf, varargin, 1 );
keyin    = default_arg( [],  varargin, 2 );
[ keyout, time, n ] = waitkey( duration, keyin, 0 );



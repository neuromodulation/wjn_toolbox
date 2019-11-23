function config_keyboard( varargin )
% CONFIG_KEYBOARD configures keyboard
%
% Description:
%     Use this function to configure the keyboard before calling START_COGENT.  The device mode should be
%     'exclusive' for accurate timing.  When in 'exclusive' mode no other application (including
%     the Matlab console window) can access the keyboard.
%
% Usage:
%     CONFIG_KEYBOARD( quelength = 100, resolution = 5, mode = 'exclusive' )
%
% Arguments:
%     quelength    - maximum number of key events recorded between calls to READKEYS
%     resolution   - timing resolution in milliseconds
%     mode         - device mode (possible values 'exclusive' and 'nonexclusive')
%
% Examples:
%
% See also:
%     CONFIG_KEYBOARD, READKEYS, LOGKEYS, WAITKEYDOWN, WAITKEYUP, LASTKEYDOWN, LASTKEYUP, GETKEYDOWN, 
%     GETKEYUP, GETKEYMAP
%
% Cogent 2000 function.

global cogent;

error( nargchk(0,3,nargin) );

args{1}   = default_arg( 100, varargin, 1 );
args{2}   = default_arg( 5,   varargin, 2 );
args{3}   = default_arg( 'nonexclusive', varargin, 3 );

cogent.keyboard = config_device( 1, args{:} );


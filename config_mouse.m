function config_mouse( varargin )
% CONFIG_MOUSE configures mouse
%
% Description:
%     Configures and sets up mouse
%
% Usage:
%     CONFIG_MOUSE              - configure mouse for non-polling mode
%     CONFIG_MOUSE( interval )  - configure mouse for polling mode
%
% Arguments:
%     interval - sample interval in milliseconds for polling mode
%
% Examples:
%
% See also:
%     CONFIG_MOUSE, WAITMOUSE, PAUSEMOUSE, READMOUSE, GETMOUSE, CLEARMOUSE, GETMOUSEMAP
%
% Cogent 2000 function.

global cogent;

error( nargchk(0,1,nargin) );

if nargin == 0
    cogent.mouse = config_device( 0, 100, 5, 'exclusive' );
elseif nargin == 1
    resolution = varargin{1};
    cogent.mouse = config_device( 1, 100, resolution, 'exclusive' );
end
    

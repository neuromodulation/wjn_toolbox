function waitmouse( varargin )
% WAITMOUSE suspends execution until mouse button is clicked (i.e. pressed and then released)
%
% Description:
%     Suspends execution until mouse button is clicked (i.e. pressed and then released)
%
% Usage:
%     WAITMOUSE;
%     WAITMOUSE( key )
%
% Arguments:
%     key - key to wait for
%
% Examples:
%     WAITMOUSE - wait for button1 or button2 to be clicked
%
% See also:
%     CONFIG_MOUSE, WAITMOUSE, PAUSEMOUSE, READMOUSE, GETMOUSE, CLEARMOUSE, GETMOUSEMAP
%
% Cogent 2000 function.

global cogent;

error( checkmouse );

% Arguments
error(  nargchk( 0, 1, nargin )  );
if nargin == 0
    keys = [ cogent.mouse.map.Button1, cogent.mouse.map.Button2 ];
else
    keys = varargin{1};
end

% Wait for press
while(1)
    readmouse;
    val = getmouse(keys);
    if ~isempty(val)&  any( val == 128 )
        break;
    end
end

% Wait for release
while(1)
    readmouse;
    val = getmouse(keys);
    if ~isempty(val) & all( val == 0 )
        break;
    end
end

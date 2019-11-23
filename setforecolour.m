function setforecolour( varargin )
% SETFORECOLOUR sets the foreground colour
%
% Description:
%     Sets the foreground colour.  This colour is used when drawing text.
%
% Usage:
%     SETCOLOUR( red, green, blue )
%     SETCOLOUR( palette_index )
%
% Arguments:
%     red   - red component of colour   (range 0-1)
%     green - green component of colour (range 0-1)
%     blue  - blue component of colour  (range 0-1)
%     palette_index - palette index of colour ( range 0-255 )
%
% Examples:
%     SETFORECOLOUR( 1,   0,   0   ) - set foreground colour to bright red
%     SETFORECOLOUR( 0,   0.2, 0   ) - set foreground dark green
%     SETFORECOLOUR( 0.5, 0.5, 0.5 ) - set foreground to grey
%     SETFORECOLOUR( 24 )            - set foreground to colour 24
%
% See also:
%     CONFIG_DISPLAY, CLEARPICT, DRAWPICT, LOADPICT, PREPAREPICT, PREPARESTRING, SETFORECOLOUR,
%     SETTEXTSTYLE
%
% Cogent 2000 function.

global cogent;

error( checkdisplay );
if cogent.display.nbpp==8 & nargin~=1
   error( 'Palette mode requires 1 argument' )
elseif cogent.display.nbpp~=8 & nargin~=3 % Need additional display check 25/10/02 - CH
   error( 'Direct colour mode requires 3 arguments' )
end

% cogent.display.fg=[r g b]; % Add palette mode 27-3-01 - CH
if cogent.display.nbpp~=8
   cogent.display.fg=[varargin{1} varargin{2} varargin{3}]; % varargin needs {} 24/10/02
else
   cogent.display.fg=varargin{1}; % varargin needs {} 24/10/02 - CH
end
%cgpencol(cogent.display.fg(1),cogent.display.fg(2),cogent.display.fg(3));

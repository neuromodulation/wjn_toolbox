function clearpict(varargin)
% CLEARPICT clears a display buffer.
%
% Description:
%     Clears a display buffer to specified colour.
%
% Usage:
%     CLEARPICT                          - clear backbuffer to default background colour
%     CLEARPICT( buf )                   - clear buffer 'buf' to default background colour
%     CLEARPICT( buf, p_i )              - clear buffer 'buf' to palette colour p_i
%     CLEARPICT( buf, red, green, blue ) - clear buffer 'buf' to colour [red,green,blue]
%
% Arguments:
%     buf   - buffer number ( 0 is the backbuffer, >1 offscreen buffers )
%     p_i   - palette index            (range 0-255)
%     red   - red component of colour  (range 0-1)
%     green - green componet of colour (range 0-1)
%     blue  - blue componet of colour  (range 0-1)
%
% Examples:
%     CLEARPICT               - clear display buffer 0 (back buffer) to default background colour
%     CLEARPICT( 5 )          - clear display buffer 5 to default background colour
%     CLEARPICT( 3, 1, 0, 0 ) - clear display buffer 3 to bright red
%
% See also:
%     CONFIG_DISPLAY, CLEARPICT, DRAWPICT, LOADPICT, PREPAREPICT, PREPARESTRING, SETFORECOLOUR,
%     SETTEXTSTYLE
%
%   Cogent 2000 function.

global cogent;

buffer = 0;
if nargin >= 1
   buffer=varargin{1};
end

error( checkdisplay(buffer) );

r = cogent.display.bg(1);
if cogent.display.nbpp~=8 % Add palette mode 27-3-01
	g = cogent.display.bg(2);
   b = cogent.display.bg(3);
end

if nargin >= 2
   r=varargin{2};
end

if nargin >= 3
   g=varargin{3};
end

if nargin >= 4
   b=varargin{4};
end

cgsetsprite( buffer );
% cgpencol( r, g, b ); % Add palette mode 27-3-01
if cogent.display.nbpp~=8
   cgpencol( r, g, b );
else
   cgpencol( r );
end

cgrect;
% cgpencol( cogent.display.fg(1), cogent.display.fg(2), cogent.display.fg(3) ); % Add palette mode 27-3-01
if cogent.display.nbpp~=8
	cgpencol( cogent.display.fg(1), cogent.display.fg(2), cogent.display.fg(3) );
else
   cgpencol( cogent.display.fg(1) );
end

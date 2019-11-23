function preparestring(varargin)
% PREPARESTRING places a string in a display buffer.
%
% Description:
%     Draws a string in a display buffer at specified offset from the centre of the buffer.  The font and size
%     is determined by CONFIG_DISPLAY or SETTEXTSTYLE.
%
% Usage:
%     PREPARESTRING( text )
%     PREPARESTRING( text, buff )
%     PREPARESTRING( text, buff, x, y ) 
%
% Arguments:
%     text - string to draw on buffer
%     buff - display buffer( 0 is the backbuffer, >1 offscreen buffers )
%     x    - horizontal offset from the centre of the screen in pixels
%     y    - vertical offset from the centre of the screen in pixels
%
% Examples:
%     PREPARESTRING( 'Hello', 1 )            - draw Hello in the centre of offscreen buffer 1
%     PREPARESTRING( 'Hello', 2, -100, 100 ) - draw Hello offset (-100,100) from centre of offscreen buffer 2
%
% See also:
%     CONFIG_DISPLAY, CLEARPICT, DRAWPICT, LOADPICT, PREPAREPICT, PREPARESTRING, SETFORECOLOUR,
%     SETTEXTSTYLE
%
% Cogent 2000 function.

global cogent;

text='Cogent 2000';
buffer=0;
x=0; y=0;      

error( checkdisplay(buffer) );

if nargin >= 1
   text=varargin{1};
end

if nargin >= 2
   buffer=varargin{2};
end

if nargin >= 3
   x=varargin{3};
end

if nargin >= 4
   y=varargin{4};
end

fg = cogent.display.fg;
cgsetsprite(buffer);
%cgpencol( fg(1), fg(2), fg(3) ); % Add palette mode 27-3-01
if cogent.display.nbpp~=8
	cgpencol( fg(1), fg(2), fg(3) );
else
	cgpencol( fg(1) );
end
cgtext(text,x,y);

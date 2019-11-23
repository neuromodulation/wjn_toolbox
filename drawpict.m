function t = drawpict( varargin );
% DRAWPICT copies the content of a display buffer to the screen.
%
% Description:
%     Copy display buffer to screen (waits for vertical refresh before copying).  If buffer>0 then
%     the display buffer is transfered to buffer 0 (the back buffer) before being copy to the screen.
%     So using buffer 0 is the fastest, but is contens will be overwritten by other DRAWPICT commands.
%     If in doubt don't use buffer 0.
%
% Usage:
%     t = DRAWPICT        - copy screen buffer 0 (back buffer) to screen
%     t = DRAWPICT( buf ) - copy screen buffer 'buf' to screen
%
% Arguments:
%     t      - time that buffer is displayed
%     buf    - screen buffer number ( 0 = backbuffer, >= 1 offscreen buffer )
%
% Examples:
%     DRAWPICT( 1 ) - copy display buffer 1 to screen
%     DRAWPICT      - copy display buffer 0 (back buffer) to screen
%
% See also:
%     CONFIG_DISPLAY, CLEARPICT, DRAWPICT, LOADPICT, PREPAREPICT, PREPARESTRING, SETFORECOLOUR,
%     SETTEXTSTYLE
%
%   Cogent 2000 function.

global cogent;


error( nargchk(0,1,nargin) );
buffer = default_arg( 0, varargin, 1 );
error( checkdisplay(buffer) );

if(buffer > 0)
   cgsetsprite(0);
   cgdrawsprite(buffer,0,0);
end
% t = cgflip; % from J.R. 1v116 onwards time is returned as seconds not microseconds. 19-2-2002 e.f.
t = floor(cgflip*1000);

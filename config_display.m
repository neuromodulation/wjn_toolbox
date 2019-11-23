function config_display( varargin )
% CONFIG_DISPLAY configures display
%
% Description:
%     Configures display.  Call before START_COGENT.
%
% Usage:
%     CONFIG_DISPLAY
%     CONFIG_DISPLAY( mode, resolution, background, foreground, fontname, fontsize, nbuffers, number_of_bits, scale )
%
% Arguments:
%    mode              - window mode ( 0=window, 1=full screen )
%    resolution        - screen resolution (1=640x480, 2=800x600, 3=1024x768, 4=1152x864, 5=1280x1024, 6=1600x1200)
%    background        - background colour ( [reg,green,blue] or palette index )
%    foreground        - foreground colour ( [reg,green,blue] or palette index )
%    fontname          - name of font,
%    fontsize          - size of font,
%    number_of_buffers - number of offscreen buffers
%    number_of_bits    - number of bits per pixel (8=palette mode, 16, 24, 32,
%                        or 0=Direct mode, maximum possible bits per pixel)
%    scale             - horizontal size of screen in (visual degrees)
%
% Examples:
%
%    CONFIG_DISPLAY
%    Default display configuration, full screen mode, 640x480 resolution, white background, black foreground, 
%    50 point Helvetica font, 4 offscreen buffers.
%
%    CONFIG_DISPLAY( 0, 2, [0 0 0], [1 1 1], 'Arial', 25, 4 )
%    window mode, 800x600 resolution, black background, white foreground, 25 point Arial font, 4 offscreen buffers
%
% See also:
%     CONFIG_DISPLAY, CLEARPICT, DRAWPICT, LOADPICT, PREPAREPICT, PREPARESTRING, SETFORECOLOUR,
%     SETTEXTSTYLE
%
% Cogent 2000 function.

global cogent;


% Check number of arguments
if nargin > 9
   error( 'wrong number of arguments' );
end

res = default_arg( 1, varargin, 2 );
if res < 1 | res > 6
   error( 'resolution argument must be in range 1-6' );
end
%screen_size = [ 640 480; 800 600; 1024 768; 1152 864; 1600 1200 ]; % replaced 19/02/2002 e.f.
screen_size = [ 640 480; 800 600; 1024 768; 1152 864; 1280 1024; 1600 1200 ];

% Set congent.display
cogent.display.res       = res;
cogent.display.size      = screen_size( res, : );
cogent.display.mode      = default_arg( 1,           varargin, 1 );
cogent.display.bg        = default_arg( [0,0,0],     varargin, 3 );
cogent.display.fg        = default_arg( [1,1,1],     varargin, 4 );
cogent.display.font      = default_arg( 'Helvetica', varargin, 5 );
cogent.display.fontsize  = default_arg( 50,          varargin, 6 );
cogent.display.number_of_buffers = default_arg( 4,   varargin, 7 );
cogent.display.nbpp      = default_arg( 0,          varargin, 8 ); % default was 16 26-03-3003 ef Defaulk was 32 19/04/02 ch
if nargin >= 9
	cogent.display.scale = varargin{9};
end

switch cogent.display.nbpp
% case { 16, 24, 32 } % Add palette mode 27-3-01
case { 0, 8, 16, 24, 32 } % Add 0 for the default mode  
otherwise
%	error( 'number_of_bits must be 16, 24 or 32' ); % Add palette mode 27-3-01
	error( 'number_of_bits must be 0, 8, 16, 24 or 32' );
end


function t=setpalettecolours( rgb, index )
% SETPALETTECOLOURS sets the colours used for each palette index
%
% Description
%
% Usage:
%     SETPALETTECOLOURS( rgb )
%     SETPALETTECOLOURS( rgb, index )
%
% Arguments:
%     red   - red component of colour   (range 0-1)
%     green - green component of colour (range 0-1)
%     blue  - blue component of colour  (range 0-1)
%     index - palette colour to set     (range 0-255)
%
% Examples:
%     SETPALETTECOLOURS( [1 1 1] )                  - set colour 0 to be white
%     SETPALETTECOLOURS( [0 0 0], 1 )               - set colour 1 to be black
%     SETPALETTECOLOURS( [0 0 0; .5 .5 .5; 1 1 1] ) - set 3 colours starting at colour 0 to be black, grey, white
%     SETPALETTECOLOURS( [1 0 0; 0 1 0; 0 0 1], 3 ) - set 3 colours starting at colour 3 to be red, green, blue
%
% See also:
%
% Cogent 2000 function.

global cogent;

error( nargchk(1,2,nargin) );
if nargin==1; index=0; end
if cogent.display.nbpp~=8; error( 'setpalettecolours does not support direct colour mode' ); end

cgcoltab( index, rgb );
uS=cgnewpal;
t=uS/1000;

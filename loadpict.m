function A=loadpict( varargin )
% LOADPICT loads a bitmap and places the image in a display buffer
%
% Description:
%
% Usage:
%     LOADPICT( filename )                   - load bitmap from file 'filename' and place in centre of back buffer
%     LOADPICT( filename, buff )             - load bitmap from file 'filename' and place in centre of buffer 'buff'
%     LOADPICT( filename, buff, x, y )       - load bitmap from file 'filename' and place in buffer 'buff' at 
%                                              offset (x,y) from centre of buffer
%     LOADPICT( filename, buff, x, y, w, h ) - load bitmap from file 'filename' and place in buffer 'buff' at 
%                                        offset (x,y) from centre of buffer
%		A=LOADPICT( filename ), etc.				- load into Matlab workspace variable A
%
%
% Arguments:
%     filename - file name of bitmap file (can be .bmp, .jpg, .pcx or .tif files)
%     buff     - display buffer( 0 is the backbuffer, >1 offscreen buffers )
%     x        - horizontal offset from the centre of the buffer in pixels
%     y        - vertical offset from the centre of the buffer in pixels
%     w        - width to display bitmap
%     h        - height to display bitmap
%
% Examples:
%     LOADPICT( 'test.bmp', 1 )            - draw bitmap 'test.bmp' in centre of buffer 1
%     LOADPICT( 'test.bmp', 2, -100, 100 ) - draw bitmap 'test.bmp' at offset (-100,100) in buffer 2
%     LOADPICT( 'test.bmp', 1, 0, 0, 20, 50 ) - draw bitmap 'test.bmp' at centre of buffer 1 as a 20 by 40 image 
%
% See also:
%     CONFIG_DISPLAY, CLEARPICT, DRAWPICT, LOADPICT, PREPAREPICT, PREPARESTRING, SETFORECOLOUR,
%     SETTEXTSTYLE, IMREAD (for full list of supported file types)
%
% Cogent 2000 function.

% Should have fast, direct mode for bmps.

global cogent

error( nargchk(1,6,nargin) );
if cogent.display.nbpp==8; error( 'loadpict does not support palette mode' ); end

filename = varargin{1};
buffer   = default_arg( 0, varargin, 2 );
x        = default_arg( 0, varargin, 3 );
y        = default_arg( 0, varargin, 4 );
error( checkdisplay(buffer) );

A=imread(filename);
w = default_arg( size(A,2), varargin, 5 );
h = default_arg( size(A,1), varargin, 6 );

A = double(A) ./ 255;

if nargout==0
  	if(ndims(A)==2)
      A=repmat(A,[1 1 3]);
   end
	n = size(A,1) * size(A,2);
	rgb = zeros( n , 3 );
	rgb(:,1) = reshape( A(:,:,1)', n, 1 );
	rgb(:,2) = reshape( A(:,:,2)', n, 1 );
	rgb(:,3) = reshape( A(:,:,3)', n, 1 );
   
	cgloadarray( 999,  size(A,2), size(A,1), rgb, w, h );
	cgsetsprite( buffer );
	cgdrawsprite( 999, x, y );
	cgfreesprite( 999 );
end
function preparepict( varargin )
% PREPAREPICT draws a Matlab image matrix in a display buffer
%
% Description:
%     Draw a Matlab image matrix in a display buffer at specified offset from centre of the buffer
%
% Usage:
%     PREPAREPICT( rgb )              - draw image in centre of back buffer
%     PREPAREPICT( rgb, buff )        - draw image in centre of display buffer 'buff'
%     PREPAREPICT( rgb, buff, x, y )  - draw image at (x,y) offset from centre of display buffer 'buff'
%
% Arguments:
%     rgb  - rgb image matrix
%     buff - display buffer
%     x    - horizontal offset from the centre of the screen in pixels
%     y    - vertical offset from the centre of the screen in pixels
%
% Examples:
%
% See also:
%
% Cogent 2000 function.


error(  nargchk( 1, 4, nargin )  );

A      = varargin{1};
buffer = default_arg( 0, varargin, 2 );
x      = default_arg( 0, varargin, 3 );
y      = default_arg( 0, varargin, 4 );

error( checkdisplay(buffer) );


  	if(ndims(A)==2)
      A=repmat(A,[1 1 3]);
   end
	n = size(A,1) * size(A,2);
	rgb = zeros( n , 3 );
	rgb(:,1) = reshape( A(:,:,1)', n, 1 );
	rgb(:,2) = reshape( A(:,:,2)', n, 1 );
	rgb(:,3) = reshape( A(:,:,3)', n, 1 );
   
	cgloadarray( 999,  size(A,2), size(A,1), rgb );
	cgsetsprite( buffer );
	cgdrawsprite( 999, x, y );
	cgfreesprite( 999 );

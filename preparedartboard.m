function preparedartboard( buffer, min_r, max_r, delta_r, delta_theta )
% PREPAREDARTBOARD places a dartboard in a display buffer
% 
% Description:
%     Draws one dartboard in the specified buffer - palette mode
%     Draws two dartboards in the specified buffers - direct colour mode
%     NB there is a delay whilst the dartboards are generated - 4 secs on a 450MHz Pentium III
%
% Usage:
%     PREPAREDARTBOARD( buffer, min_r, max_r, delta_r, delta_theta ) 	  - palette mode
%     PREPAREDARTBOARD( [buf1 buf2], min_r, max_r, delta_r, delta_theta ) - direct colour mode
% 
% Arguments:
%     buffer      - prepare the dartboard in this offscreen buffer
%     [buf1 buf2] - prepare two dartboards in these offscreen buffers
%     min_r       - inner radius of dartboard
%     max_r       - outer radius
%     delta_r     - radial square size
%     delta_theta - angular square size (degrees)
% 
% Examples:
%     PREPAREDARTBOARD( 1, 20, 200, 10, 18 )		 - standard dartboard in buffer 1
%     PREPAREDARTBOARD( 2, 400, 200, 10, 18 )	 - null dartboard (min_r > max_r) in buffer 2
%     PREPAREDARTBOARD( [1 2], 20, 200, 10, 18 ) - standard dartboard in buffers 1 and 2 (direct colour mode)
%
% See also:
%     PALETTEFLICKER
% 
% Cogent 2000 function

global cogent

% Set defaults if needed
fix_r = 3; % could become a parameter
if (nargin < 5);	delta_theta = 18;  end
if (nargin < 4);	delta_r     = 30;  end
if (nargin < 3);	max_r       = 200; end
if (nargin < 2);	min_r       = 20;  end
if (nargin < 1)
   switch cogent.display.nbpp
   case 8
      buffer = 1;
   case {16,24,32,0} % 23/10/02 EF - added zero to allow for cgopen
      buffer = [1 2];
   end % switch
end % if

%buffer
%size( buffer )

% screen size is
w=cogent.display.size(1);
h=cogent.display.size(2);
x=1:w;
y=1:h;
ox=w/2;
oy=h/2;

[X,Y] = meshgrid(x-ox,y-oy);		% cartesian coords
[TH,R] = cart2pol(X,Y);				% convert to polar coords
TH = rem(TH + 2*pi, 2*pi);			% shift from -pi:pi to 0:2pi
delta_theta = delta_theta*pi/180;% convert to radians

% generate dartboard
fixation_point = (R < fix_r);
annulus = (min_r <= R & R < max_r);
squares = xor( rem( (R-min_r)/delta_r,2 ) < 1, rem( TH/delta_theta,2 ) < 1 );
backgnd = ~fixation_point & ~ annulus;
c1 = annulus & squares;		% colour 1
c2 = annulus & ~squares;	% colour 2

% transfer dartboard to matlab display buffer
switch cogent.display.nbpp
case 8
	bmp = fixation_point*0 + c1*1 + c2*2 + backgnd*3;
	bmp = reshape( bmp', w*h, 1 );
	pal = [1 1 1; 1 1 1; 0 0 0; .5 .5 .5];
	cgloadarray( buffer,w,h,bmp',pal, 0 );
case {16, 24, 32,0} % 23/10/02 EF - added zero to allow for cgopen
	temp = fixation_point + c1 + backgnd/2;
	temp = reshape( temp', w*h, 1);
	bmp1 = [temp temp temp];
	temp = fixation_point + c2 + backgnd/2;
	temp = reshape( temp', w*h, 1);
	bmp2 = [temp temp temp];
	cgloadarray( buffer(1),w,h,bmp1 );
	cgloadarray( buffer(2),w,h,bmp2 );
end % switch

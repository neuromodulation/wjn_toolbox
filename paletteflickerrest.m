function t=paletteflickerrest( buffer, frames1, frames2, repeats, grey )
% PALETTEFLICKERREST flickers a dartboard and returns to fixation
%
% Description:
%     Flickers a previously prepared dartboard and returns to fixation.
% 
% Usage:
%     PALETTEFLICKERREST( buffer, frames1, frames2, repeats, grey )
%
% Arguments:
%     buffer - specifies the buffer (or buffers) containing the dartboard
%     frames1 - number of frames to display as white/black
%     frames2 - number of frames to display as black/white
%     repeats - number of times to repeat the above cycle
%     grey    - background grey level, this is ignored in direct colour mode
% 
% Examples:
%     PALETTEFLICKEREST( 1, 4, 4, 8, 32767 ) % use dartboard in buffer 1. 8 flicker cycles @ 7.5Hz (=60Hz / (4+4) )
%
% See also:
%     PREPAREDARTBOARD, PALETTEFLICKER
% 
% Cogent 2000 function

global cogent

% Set defaults if needed
if (nargin < 5);	grey = 32767;  end
if (nargin < 4);	repeats = 100; end
if (nargin < 3);	frames1 = 4;   end
if (nargin < 2);	frames2 = 4;   end
if (nargin < 1)
   switch cogent.display.nbpp
   case 8
      buffer = 1;
   case {16,24,32,0} % 23/10/02 EF - added zero to allow for cgopen
      buffer = [1 2];
   end % switch
end % if

% Display & flicker the dartboard
switch cogent.display.nbpp
case 8
   pal1=[1 1 1; 1 1 1; 0 0 0; grey/65535 grey/65535 grey/65535];
   pal2=[1 1 1; 0 0 0; 1 1 1; grey/65535 grey/65535 grey/65535];
   pal3=[1 1 1; grey/65535 grey/65535 grey/65535; grey/65535 grey/65535 grey/65535; grey/65535 grey/65535 grey/65535];
%   cgflip(0) 19/04/02 - removed to stop flash
   cgdrawsprite(buffer,0,0)
   cgflip(0)
   cgcoltab(0,pal1)
   cgnewpal
   for n = 1:repeats
      cgcoltab(0,pal1); for m = 1:frames1; t(n*2-1) = cgnewpal; end
        cgcoltab(0,pal2); for m = 1:frames2; t(n*2)   = cgnewpal; end
   end % for
   cgcoltab(0,pal3); cgnewpal;
case {16,24,32,0} % 23/10/02 EF - added zero to allow for cgopen
   error('cannot run paletteflickerest in direct colour mode');
   break;
end % switch

function t = waitframe( varargin );
% WAITFRAME wait for frame update
%
% Description:
%     Wait for a specified number of frame updates then return the time of the last frame update.
%
% Usage:
%     t = WAITFRAME        - wait until frame update
%     t = WAITFRAME( n )   - wait for 'n' frame updates
%
% Arguments:
%     t    - time of last frame update
%     n    - number of frame updates to wait 
%
% Examples:
%     WAITFRAME      - wait until a frame update
%     WAITFRAME(10)  - wait for 10 frame updates
%
% See also:
%     CONFIG_DISPLAY, CLEARPICT, DRAWPICT, LOADPICT, PREPAREPICT, PREPARESTRING, SETFORECOLOUR,
%     SETTEXTSTYLE, WAITFRAME
%
%   Cogent 2000 function.

global cogent;


error( nargchk(0,1,nargin) );
n = default_arg( 1, varargin, 1 );

for i = 1:n
    t = cgflip('v');
end

%t = t / 1000; % from J.R. 1v116 onwards time is returned as seconds not microseconds. 19-2-2002 e.f.
t = floor(cgflip*1000);

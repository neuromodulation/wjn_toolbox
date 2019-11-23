function [s, t] = waitslice( port, n )
% [s, t] = waitslice( port, n )
%
% Waits (forever!) for MRI scanner slice n or greater.
% Returns the actual slice number used and its timestamp.
%
% See also:
%   config_serial, getslice, logslice.
%
% Cogent2000 function

[s, t] = getslice( port );
while ( s( end ) < n ) % wait for correct slice number
    [s, t] = getslice( port );
end
% discard all but the last slice received.
s = s( end );
t = t( end );

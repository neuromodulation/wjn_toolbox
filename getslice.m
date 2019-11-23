function [slices, times] = getslice( port )
% [slices, times] = getslice( port )
%
% Returns the most recent slice numbers with time stamps,
% NB This WILL WAIT for complete slice information to arrive in the serial port buffer!
%
% See also:
%   config_serial, waitslice, logslice.
%
% Cogent2000 function

% or returns [-1, -1] if no data available.
% NB This will NOT WAIT for slice information if the serial port buffer is empty!
% It WILL WAIT if one of the two slice information bytes ahs been received.

global cogent

temp = cogent.serial{port};
%ix = []; % These few lines for the 'WONT WAIT for slice' version...
%[ values, times ] = CogSerial( 'GetEvents', temp.hPort )
%if isempty( values )
%    slices = -1;
%    times = -1;
%    return
%end % if
ix = []; values = []; times = []; % OR this for the 'WILL WAIT for slice' version

while isempty( ix ) % MUST HAVE some closely spaced bytes 
    values0 = []; times0 = [];
    while length( values0 ) < 2 % MUST HAVE 2 bytes or more, to calculate their spacing
        values1 = []; times1 = [];
        while isempty( values1 ) % MUST HAVE some bytes to work with (please?)
            [ values1, times1 ] = CogSerial( 'GetEvents', temp.hPort );
            drawnow; % hopefuly giving Ctrl-C more chance!
        end % while isempty(values1)
        values0 = [values0; values1];
        times0 = [times0; times1];
    end % while length(values0)<2
    values = [values; values0];
    times = [times; times0];
    ix = find( diff( times ) < 0.010 ); % i.e. < 10ms
end % while isempty(ix)
% return values...
slices = ( values( ix )*256 + values( ix+1 ) ); % convert byte pairs into slice numbers
times = times( ix+1 ); % pick out one time stamp per byte pair
times = floor( times * 1000 ); % convert from sec to ms

% and store final values for loggin...
scans.slices = slices;
scans.times = times;
scans.number_of_slices = length( scans.times );
cogent.scanner = scans; % copy data into the cogent structure

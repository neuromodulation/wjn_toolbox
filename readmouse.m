function readmouse
% READMOUSE reads all mouse events 
%
% Description:
%
% Usage:
%     READMOUSE
%
% Arguments:
%     NONE
%
% Examples:
%
% See also:
%     CONFIG_MOUSE, WAITMOUSE, PAUSEMOUSE, GETMOUSE, GETMOUSEMAP
%
% Cogent 2000 function.

global cogent;

error( checkmouse );

if ~isfield(cogent.mouse,'hDevice')
    message = 'START_COGENT must be called before calling READMOUSE';
end

if cogent.mouse.polling_flag
    [ t, id, value ] = CogInput( 'GetEvents', cogent.mouse.hDevice );
%    cogent.mouse.time  = floor( t/1000 ); % time now in seconds not us 4-4-2002 e.f.
    cogent.mouse.time  = floor( t * 1000 );
    cogent.mouse.id    = id;
    cogent.mouse.value = value;
    cogent.mouse.number_of_responses = length( cogent.mouse.time );
else
    cogent.mouse.value = CogInput( 'GetState', cogent.mouse.hDevice );
    n = length(cogent.mouse.value);
    cogent.mouse.id = [1:n]';
    cogent.mouse.time = zeros(n,1);
    cogent.mouse.time(:) = time;
    cogent.mouse.number_of_responses = n;
end

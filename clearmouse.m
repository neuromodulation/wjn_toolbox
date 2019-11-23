function clearmouse
% CLEARMOUSE clears mouse
%
% Description:
%    Clears mouse
%
% Usage:
%     CLEARMOUSE
%
% Arguments:
%     NONE
%
% Examples:
%
% See also:
%     CONFIG_MOUSE, WAITMOUSE, PAUSEMOUSE, READMOUSE, GETMOUSE, CLEARMOUSE, GETMOUSEMAP
%
% Cogent 2000 function.

global cogent;

error( checkmouse );

cogent.mouse.time  = [];
cogent.mouse.id    = [];
cogent.mouse.value = [];
cogent.mouse.number_of_responses = 0;

if cogent.mouse.polling_flag
    CogInput( 'GetEvents', cogent.mouse.hDevice );
end

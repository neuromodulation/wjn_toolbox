function state=getmousestate
% GETMOUSESTATE gets mouse state (i.e. value of mouse buttons and axes)
%
% Description:
%     Return array containing state of mouse. Each array element contains axes or button values.
%         1 - change in x-axis (left and right) since last call to GETMOUSESTATE
%         2 - change in y-axis (up and down) since last call to GETMOUSESTATE
%         3 - change in z-axis (mouse wheel) since last call to GETMOUSESTATE
%         4 - state of button 1 ( 0 up, 128 down )
%         5 - state of button 2 ( 0 up, 128 down )
%         6 - state of button 3 ( 0 up, 128 down )
%         7 - state of button 4 ( 0 up, 128 down )
%     This state index information can be access by function GETMOUSEMAP.
%
% Usage:
%     state = GETMOUSESTATE
%
% Arguments:
%     state - state of mouse
%
% Examples:
%     state = GETMOUSESTATE;
%     state(1) % change in x coordinate
%     state(2) % change in y coordinate
%     if state(4)
%         % Button 1 down
%         % Do something
%     end
%
% See also:
%     CONFIG_MOUSE, WAITMOUSE, GETMOUSESTATE, GETMOUSEMAP
%
% Cogent 2000 function.

global cogent;

error( checkmouse );

% Wait for press
state = CogInput( 'GetState', cogent.mouse.hDevice );

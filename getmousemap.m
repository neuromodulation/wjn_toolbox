function map = getmousemap
% GETMOUSEMAP return the mouse map which contains the index of axes and buttons
%
% Description:
%     Returns the mouse map.  This is a structure which contains the fields:
%         X       - change in x-axis since last call to GETMOUSESTATE
%         Y       - change in x-axis since last call to GETMOUSESTATE
%         Z       - change in z-axis (mouse wheel) since last call to GETMOUSESTATE
%         Button1 - mouse button 1
%         Button2 - mouse button 2
%         Button3 - mouse button 3
%         Button4 - mouse button 4
%     The value of each field is the index of the button or axis in the array returned by GETMOUSESTATE.
%
% Usage:
%     map = GETMOUSEMAP
%
% Arguments:
%     map - mouse map
%
% Examples:
%     map = GETMOUSEMAP
%     state = GETMOUSESTATE
%     x = state( map.X )
%     y = state( map.Y )
%     b1 = state( map.Button1 )
%
% See also:
%     CONFIG_MOUSE, WAITMOUSE, GETMOUSESTATE, GETMOUSEMAP
%
% Cogent 2000 function.

global cogent;

error( checkmouse );

map = cogent.mouse.map;


function [ value, out, t ] = getmouse( varargin )
% GETMOUSE returns state of buttons and axis as read by READMOUSE
%
% Description:
%     Returns state of buttons and axis as read by READMOUSE
%     Axis and button IDs:-
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
%     [ out, value, time ] = GETMOUSE( in );
%
% Arguments:
%     out   - id of button or axis
%     value - value of button or axis
%     time  - time of change in button or axis
%     in    - id of button or axis to return
%
% Examples:
%    [ value, id, time ] = getmouse                - get values and time of change of all buttons and axis
%    [ value, id, time ] = getmouse( [ 4 5 ] )     - get values and time of change of buttons 1 and 2
%
% See also:
%     CONFIG_MOUSE, WAITMOUSE, PAUSEMOUSE, READMOUSE, GETMOUSE, CLEARMOUSE, GETMOUSEMAP
%
% Cogent 2000 function.

global cogent;

error( nargchk(0,1,nargin) );
error( checkmouse );

if nargin > 0
    index = find( ismember(cogent.mouse.id,varargin{1}) );
    out   = cogent.mouse.id( index );
    value = cogent.mouse.value( index );
    t     = cogent.mouse.time( index );
else 
    out   = cogent.mouse.id;
    value = cogent.mouse.value;
    t     = cogent.mouse.time;
end

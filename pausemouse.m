function pausemouse
% PAUSEMOUSE execution of script if a mouse button has been press 
%
% Description:
%    If a mouse button has been pressed since the last READMOUSE of CLEARMOUSE then script execution
%    will stop until a mouse key is pressed again.
%    ***** requires mouse to be in polling mode ****
%
% Usage:
%     PAUSEMOUSE
%
% Arguments:
%     NONE
%
% Examples:
%     PAUSEMOUSE;
%
% See also:
%     CONFIG_MOUSE, WAITMOUSE, PAUSEMOUSE, READMOUSE, GETMOUSE, CLEARMOUSE, GETMOUSEMAP
%
% Cogent 2000 function.

global cogent;

error( checkmouse );

if ~cogent.mouse.polling_flag
    error( 'mouse must be polling' );
end

readmouse;
[ value, id, t ] = getmouse( [ cogent.mouse.map.Button1, cogent.mouse.map.Button2 ] );
if ~isempty(value) & any( value == 128 )
    logstring( 'PAUSE' );
    while( 1 )
        readmouse;
        [ value, id, t ] = getmouse( [ cogent.mouse.map.Button1, cogent.mouse.map.Button2 ] );
        if ~isempty(value) & any( value == 128 )
            break;
        end
    end
    logstring( 'CONTINUE' );
end



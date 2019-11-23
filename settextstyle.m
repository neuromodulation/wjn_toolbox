function settextstyle( font, size )
% SETTEXTSTYLE sets font name and size
%
% Description:
%     Sets font name and size used by PREPAREASTRING.
%
% Usage:
%     SETTEXTSTYLE( font, size )
%
% Arguments:
%     font - font name (e.g. 'Arial', 'Helvetica' )
%     size - size of font
%
% Examples:
%     SETTEXTSTYLE( 'Arial', 50 ) - set font to 50 point Arial
%
% See also:
%     CONFIG_DISPLAY, CLEARPICT, DRAWPICT, LOADPICT, PREPAREPICT, PREPARESTRING, SETFORECOLOUR,
%     SETTEXTSTYLE
%
% Cogent 2000 function.

global cogent;

error( checkdisplay );

cogent.display.font = font;
cogent.display.size = size;
gprim( 'gfont', font, size ); % Change face to font 24/10/02  - CH

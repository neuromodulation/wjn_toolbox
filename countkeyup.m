function n = countkeyup( varargin )
% COUNTKEYUP counts the number of key up events read in last call to READKEYS
%
% Description:
%     Counts the number of key up events read in last call to READKEYS
%
% Usage:
%     n = COUNTKEYUP
%
% Arguments:
%     n - number of keyup events
%
% Examples:
%
% See also:
%     CONFIG_KEYBOARD, READKEYS, LOGKEYS, WAITKEYDOWN, WAITKEYUP, LASTKEYDOWN, LASTKEYUP, GETKEYDOWN, 
%     GETKEYUP, GETKEYMAP, COUNTKEYDOWN, COUNTKEYUP
%
% Cogent 2000 function.

global cogent;

error( checkkeyboard );

index = find( cogent.keyboard.value == 0 );
if nargin == 0
   
   n = length(index);
   
else
   
   keyin = varargin{1};
   n = 0;
   for i = 1 : length(index)
      if any( cogent.keyboard.id( index(i) ) == keyin )
         n = n + 1;
      end
   end
   
end

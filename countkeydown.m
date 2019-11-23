function n = countkeydown( varargin )
% COUNTKEYDOWN counts the number of key down events read in last call to READKEYS
%
% Description:
%     Counts the number of key down events read in last call to READKEYS
%
% Usage:
%     n = COUNTKEYDOWN
%
% Arguments:
%     n - number of keydown events
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

index = find( cogent.keyboard.value == 128 );
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

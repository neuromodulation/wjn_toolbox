function [ key, time ] = lastkeyup
% LASTKEYUP returns the key and time of the most recent key release.
%
% Description:
%     Returns the key and time of the most recent key release read by READKEYS
%
% Usage: 
%     [ key, time ] = LASTKEYUP
%
% Arguments:
%     key    - id of key           (0 if no key released)
%     time   - time of key press   (0 if no key released)
%
% Examples:
%
% See also:
%     CONFIG_KEYBOARD, READKEYS, LOGKEYS, WAITKEYDOWN, WAITKEYUP, LASTKEYDOWN, LASTKEYUP, GETKEYDOWN, 
%     GETKEYUP, GETKEYMAP
%
% Cogent 2000 function.

global cogent;

error( checkkeyboard );

n = length( cogent.keyboard.value );
for i = n:-1:1
   if cogent.keyboard.value(i) == 0 
      key  = cogent.keyboard.id(i);
      time = cogent.keyboard.time(i);
      return
   end
end

% No keydown responces
key  = 0;
time = 0;

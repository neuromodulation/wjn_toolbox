function pausekey(varargin)
% PAUSEKEY pauses a key has been pressed and waits for another key press.
% PAUSEKEY(key) pauses if specific key has been pressed and waits for another key press.
%
% Cogent 2000 function.


global cogent;

% Set and check arguments
if nargin == 0
   keyin = 0;
elseif nargin == 1
   keyin = varargin{1};
else
   error( 'wrong number of arguments' );
end

% Get last key press
readkeys;
[ key, time ] = lastkeydown;

% Return if no key has been pressed
if key == 0
   return;
end

% Return if key pressed is not specified key
if (keyin ~= 0) & (keyin ~= r.key)
   return;
end

while(1)
   
   % Get last key press
   readkeys;
   [ key, time ] = lastkeydown;
   
   % Exit if specified key has been pressed
   if key ~= 0
      if keyin == 0, break, end;
      if keyin == r.key, break, end;
   end
   
end



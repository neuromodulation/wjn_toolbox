function [ key, t, n ] = getkeydown( varargin )
% GETKEYDOWN returns the key IDs and times of key presses read by last call to READKEYS
%
% Description:
%    Returns the key IDs and times of key presses read by last call to READKEYS.  Use GETKEYMAP to determine key IDs.
%
% Usage:
%     [ keyout, time, n ] = GETKEYDOWN
%     [ keyout, time, n ] = GETKEYDOWN( keyin )
%
% Arguments:
%     keyin  - array of key IDs to check for presses
%     keyout - array of key IDs of keys that have been pressed
%     time   - array of time of key presses
%     n      - number of key presses
%
% Examples:
%     [ keyout, time, n ] = GETKEYDOWN              - get all key presses
%     [ keyout, time, n ] = GETKEYDOWN( 1 )         - get all presses of key 1 (A)
%     [ keyout, time, n ] = GETKEYDOWN( [ 1 2 4 ] ) - get all presses of keys 1, 2 and 4 (A,B and C)
%
% See also:
%     CONFIG_KEYBOARD, READKEYS, LOGKEYS, WAITKEYDOWN, WAITKEYUP, LASTKEYDOWN, LASTKEYUP, GETKEYDOWN, 
%     GETKEYUP, GETKEYMAP, COUNTKEYDOWN, COUNTKEYUP
%
% Cogent 2000 function.

global cogent;

error( checkkeyboard );

key  = [];
t    = [];
index = find( cogent.keyboard.value == 128 );

if nargin == 0
   
   index = find( cogent.keyboard.value == 128 );
   
elseif nargin == 1
   
   value = cogent.keyboard.value;
   keyin = varargin{1};
   index = find( cogent.keyboard.value == 128 & ismember(cogent.keyboard.id,keyin) );
   
end

key   = cogent.keyboard.id( index );
t     = cogent.keyboard.time( index );
n     = length( index );

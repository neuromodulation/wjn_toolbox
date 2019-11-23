function [ key, time, n ] = getkeyup( varargin )
% GETKEYUP gets the key IDs and times of key releases read in last call to READKEYS or CLEARKEYS
%
% Description:
%     Returns key IDs and times
%
% Usage:
%     [ keyout, time, n ] = GETKEYUP          - return key IDs and times of all key releases
%     [ keyout, time, n ] = GETKEYUP( keyin ) - return key IDs and times of key releases for specified keys
%
% Arguments:
%     keyin  - array of IDs to check for key releases
%     keyout - array of IDs of keys that have been released
%     time   - array of times of the key releases
%     n      - number of key releases
%
% Examples:
%     [ keyout, time, n ] = GETKEYUP              - get all key releases
%     [ keyout, time, n ] = GETKEYUP( 1 )         - get all releases of key 1 (A)
%     [ keyout, time, n ] = GETKEYUP( [ 1 2 4 ] ) - get all releases of keys 1, 2 and 4 (A,B and C)
%
% See also:
%     CONFIG_KEYBOARD, READKEYS, LOGKEYS, WAITKEYDOWN, WAITKEYUP, LASTKEYDOWN, LASTKEYUP, GETKEYDOWN, 
%     GETKEYUP, GETKEYMAP, COUNTKEYDOWN, COUNTKEYUP
%
% Cogent 2000 function.

global cogent;

error( checkkeyboard );

if ~isfield( cogent.keyboard, 'map' )
   error( 'START_COGENT must called before using GETKEYMAP' );
end

key  = [];
time = [];
index = find( cogent.keyboard.value == 0 );
if nargin == 0
   
   key   = cogent.keyboard.id( index );
   time  = cogent.keyboard.time( index );
   
elseif nargin == 1
   
   keyin = varargin{1};
   j = 1;
   for i = 1 : length(index)
      if any( cogent.keyboard.id( index(i) ) == keyin )
         key(j)  = cogent.keyboard.id(index(i));
         time(j) = cogent.keyboard.time(index(i));
         j = j + 1;
      end
   end
   
end

n = length( key );

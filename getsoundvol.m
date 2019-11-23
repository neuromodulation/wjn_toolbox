function vol = getsoundvol( bufnum )
% GETSOUNDVOL gets volume of sound buffer
%
% Description:
%    Returns volume of sound buffer in hundredths of decibels ( 0 to -10000 )
%
% Usage:
%    GETSOUNDVOL( buff )
%
% Arguments:
%     buff - buffer number
%     vol  - volume of buffer in hundredths of decibels ( 0 to -10000 )
%
% Examples:
%
% See also:
%      CONFIG_SOUND, PREPARESOUND, PREPAREPURETONE, PREPAREWHITENOISE, LOADSOUND, WAITSOUND,
%      SOUNDPOSITION, SETSOUNDFREQ, GETSOUNDFREQ, GETSOUNDVOL, SETSOUNDVOL
%
% Cogent 2000 function.

global cogent;

error( checksound(bufnum) );
vol = cogsound( 'get', cogent.sound.buffer(bufnum), 'volume' );

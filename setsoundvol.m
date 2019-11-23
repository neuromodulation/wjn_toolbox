function setsoundvol( bufnum, vol )
% SETSOUNDVOL sets volume of sound buffer
%
% Description:
%    Sets volume of sound buffer in hundredths of decibels ( 0 to -10000 )
%
% Usage:
%    SETSOUNDVOL( buff )
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
cogsound( 'set', cogent.sound.buffer(bufnum), 'volume', vol );

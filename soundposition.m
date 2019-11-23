function pos = soundposition( bufnum )
% SOUNDPOSITION returns current play position of sound buffer
%
% Description:
%     Returns current play position of sound buffer.
%
% Usage:
%     SOUNDPOSITION( buff )  - play position of buffer 'buff'
%
% Arguments:
%     buff - sound buffer number
%
% Examples:
%
% See also:
%     CONFIG_SOUND, PREPARESOUND, PREPAREPURETONE, PREPAREWHITENOISE, LOADSOUND, WAITSOUND,
%     SOUNDPOSITION, LOOPSOUND, STOPSOUND.
%
% Cogent 2000 function.

global cogent;

error( checksound(bufnum) );

pos = cogsound( 'get', cogent.sound.buffer(bufnum), 'position' );

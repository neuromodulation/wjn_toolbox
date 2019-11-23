function setsoundposition( bufnum, pos )
% SETSOUNDPOSITION sets current play position of sound buffer
%
% Description:
%     Sets current play position of sound buffer.
%
% Usage:
%     SETSOUNDPOSITION( buff, pos )  - set play position of buffer 'buff'
%
% Arguments:
%     buff - sound buffer number
%     pos  - play position
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

cogsound( 'set', cogent.sound.buffer(bufnum), 'position', pos );
function stopsound( bufnum )
% STOPSOUND stops a sound buffer playing.
%
% Description:
%    Stops a sound buffer playing.
%
% Usage:
%    STOPSOUND( buff ) - play sound in buffer 'buff'
%
% Arguments:
%     buff - buffer number
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
cogsound( 'stop', cogent.sound.buffer(bufnum) );

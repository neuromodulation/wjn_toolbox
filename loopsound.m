function loopsound( bufnum )
% LOOPSOUND starts a sound buffer playing in a continuous loop
%
% Description:
%    Starts a sound buffer playing in a continuous loop.  To create this buffer use commands LOADSOUND
%    or PREPARESOUND. To stop buffer from playing use command STOPSOUND.
%
% Usage:
%    LOOPSOUND( buff ) - play sound in buffer 'buff'
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
cogsound( 'play', cogent.sound.buffer(bufnum), 1 );

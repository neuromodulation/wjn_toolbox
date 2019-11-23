function waitsound( bufnum )
% WAITSOUND waits until a sound buffer has stopped playing.
%
% Description:
%     Waits until a sound buffer has stopped playing
%
% Usage:
%     WAITSOUND( buff ) - wait until buffer 'buff' has stopped playing
%
% Arguments:
%     buff   - buffer number
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

while(  cogsound( 'playing', cogent.sound.buffer(bufnum) )  )
end

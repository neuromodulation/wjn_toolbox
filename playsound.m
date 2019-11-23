function playsound( bufnum )
% PLAYSOUND plays sound buffer
%
% Description:
%    Plays a sound buffer.  To create this buffer use commands LOADSOUND or PREPARESOUND.
%
% Usage:
%    PLAYSOUND( buff )
%
% Arguments:
%     buff - buffer number
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
cogsound( 'play', cogent.sound.buffer(bufnum) );

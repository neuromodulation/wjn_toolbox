function preparewhitenoise( duration, buffer )
% PREPAREWHITENOISE fill sound buffer with white noise of specified duration
%
% Description:
%     Fill sound buffer with white noise of specified duration.
%
% Usage:
%     PREPAREWHITENOISE( duration, buff )
%
% Arguments:
%     duration    - duration of white noise (millisconds)
%     buff        - buffer for wave form
%
% Examples:
%     PREPAREWHITENOISE( 1000, 1 ) - prepare 1000 milliseconds of white noise in buffer 1
%
% See also:
%     CONFIG_SOUND, PREPARESOUND, PREPAREPURETONE, PREPAREWHITENOISE, LOADSOUND, WAITSOUND, PLAYSOUND
%     SOUNDPOSITION.
%
% Cogent 2000 function.

global cogent;

n = floor( cogent.sound.frequency * duration / 1000 ); 
a = 2*rand(n,1) - 1; 

preparesound( a, buffer );

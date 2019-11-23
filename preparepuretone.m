function preparepuretone( frequency, duration, buffer )
% PREPAREPURETONE fill sound buffer with sin wave of specified duration and frequency
%
% Description:
%     Fill sound buffer with sin wave of specified duration and frequency.
%
% Usage:
%     PREPAREPURETONE( frequency, duration, buff )
%
% Arguments:
%     frequency   - frequency of sine wave (Hz)
%     duration    - duration of sine wave (milliscond
%     buff        - buffer for wave form
%
% Examples:
%     PREPAREPURETONE( 500, 1000, 1 ) - prepare a 500Hz 1000 millisecond sine wave in buffer 1
%
% See also:
%     CONFIG_SOUND, PREPARESOUND, PREPAREPURETONE, PREPAREWHITENOISE, LOADSOUND, WAITSOUND, PLAYSOUND
%     SOUNDPOSITION.
%
% Cogent 2000 function.

global cogent;

x = 1 : floor( cogent.sound.frequency * duration / 1000 );
a = sin( 2*pi*frequency*x/cogent.sound.frequency );

preparesound( a', buffer );

return;



function saverecording( filename )
% SAVERECORDING saves contents of recording buffer as a WAV file
%
% Description:
%     Saves contents of recording buffer as a WAV file
%
% Usage:
%     SAVERECORDING( filename ) - save recording to file 'filename'

%
% Arguments:
%     filename  - name of recording file
%
% See also:
%     GETRECORDING, RECORDSOUND, WAITRECORD, SAVERECORDING   
%
% Cogent 2000 function.

global cogent;

wave = getrecording;

wavwrite( wave, cogent.sound.frequency, cogent.sound.nbits, filename );
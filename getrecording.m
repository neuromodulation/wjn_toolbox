function wave = getrecording
% GETRECORDING get recording buffer and return as matrix.
%
% Description:
%     Get current recording and return as a nchannels by nsamples matlab matrix.  
%
% Usage:
%     GETRECORDING
%
% Arguments:
%     NONE
%
% See also:
%     PREPARERECORDING, RECORDSOUND, WAITRECORD    
%
%   Cogent 2000 function.

global cogent;


% Get waveform
wave = cogcapture( 'getwave' )';

% Rescale waveform
switch cogent.sound.nbits
case 8
   wave = wave/127.5 - 1;
case 16
   wave = wave / 32767;
otherwise
   error( 'cogent.sound.nbit must be 8 or 16' );
end   


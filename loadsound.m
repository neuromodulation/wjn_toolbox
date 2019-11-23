function loadsound( filename, bufnum )
% LOADSOUND loads a wav file into sound buffer.
%
% Description:
%
% Usage:
%     LOADSOUND( filename , buf ) - load WAV file into buffer 'buf'
%
% Arguments:
%     filename - file name of WAV file be loaded
%     buff     - buffer number
%
% Examples:
%
% See also:
%     CONFIG_SOUND, PREPARESOUND, PREPAREPURETONE, PREPAREWHITENOISE, LOADSOUND, WAITSOUND,
%     SOUNDPOSITION, LOOPSOUND, STOPSOUND.
%
% Cogent 2000 function.

global cogent;

if ~isfield( cogent, 'sound' )
   error( 'sound not configured' );
end

if(cogent.sound.buffer(bufnum))
   CogSound('Destroy',cogent.sound.buffer(bufnum));
end
cogent.sound.buffer(bufnum) = CogSound( 'Load', filename);

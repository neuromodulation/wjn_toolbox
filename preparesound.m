function preparesound( matrix, bufnum )
% PREPARESOUND transfers a sound matrix from the matlab workspace to a Cogent sound buffer.
%
% Description:
%     Transfers a sound matrix from the matlab workspace to a Cogent sound buffer.  Each column of the matrix is
%     a channel waveform (1 column for mono, 2 for stereo).  Each waveform element is in the range -1 to 1.
%
% Usage:
%     PREPARESOUND( matrix, buff )
%
% Arguments:
%     matrix - nsamples by nchannels matrix containing sound waveforms, each sample ranges between -1 and 1
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

if ~isfield( cogent, 'sound' )
   error( 'sound not configured' );
end

% Check matrix
if size(matrix,2) == 0
   error( 'empty sound matrix' );
elseif size(matrix,2) > 2
   error( 'sound matix has too many columns (1 column for mono, 2 columns for stereo)' );
end

% Create buffer
if( cogent.sound.buffer(bufnum) )
   CogSound( 'Destroy', cogent.sound.buffer(bufnum) );
end
cogent.sound.buffer( bufnum ) = CogSound( 'Create', size(matrix,1), 'any', cogent.sound.nbits, ...
                                          cogent.sound.frequency, size(matrix,2) );

% Set buffer
switch cogent.sound.nbits
case 8
   matrix = (matrix + 1) .* 127.5;
case 16
   matrix = matrix * 32767;
otherwise
   error( 'cogent.sound.nbit must be 8 or 16' );
end   
CogSound( 'SetWave', cogent.sound.buffer(bufnum), floor(matrix)' );

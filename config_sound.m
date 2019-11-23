function config_sound( varargin )
% CONFIG_SOUND configures sound
%
% Description:
%     Use config sound to setup number of channels, number of bits and frequency of sounds to play
%     and record.
%
% Usage:
%     CONFIG_SOUND
%     CONFIG_SOUND( nchannels = 1, nbits = 16, frequency = 11025, number_of_buffers = 100 )
%
% Arguments:
%      nchannels         - number of channels (1 = mono, 2 = stereo), 
%      nbits             - number of bits per sample (8 or 16)
%      frequency         - number of samples per second (common values are 8000, 11025, 22050 and 44100)
%      number_of_buffers - number of sound  buffers
%
% Examples:
%      CONFIG_SOUND                     - mono,   16 bits per sample, 11025 samples per sec, 100 buffers
%      CONFIG_SOUND( 2, 8 )             - stereo, 8 bits per sample,  11025 samples per sec, 100 buffers
%      CONFIG_SOUND( 1, 16, 22050, 10 ) - mono,   16 bits per sample, 22050 samples per sec, 10  buffers
%
% See also:
%      CONFIG_SOUND, PREPARESOUND, PREPAREPURETONE, PREPAREWHITENOISE, LOADSOUND, PLAYSOUND, WAITSOUND,
%      SOUNDPOSITION, LOOPSOUND, STOP_SOUND, PREPARERECORDING, RECORDSOUND, WAITRECORD, SAVERECORDING.
%
% Cogent 2000 function.

global cogent;

error( nargchk(0,4,nargin) )

% Check number of bits argument
nbits = default_arg( 16, varargin, 2 );
if  nbits ~= 8 & nbits ~= 16
   error( ['nbits = 8 or 16 not ' num2str(nbits) ] );
end

% Set cogent.sound structure
cogent.sound.nchannels         = default_arg( 1, varargin, 1 );
cogent.sound.nbits             = nbits;
cogent.sound.frequency         = default_arg( 11025, varargin, 3 );
cogent.sound.number_of_buffers = default_arg( 100, varargin, 4 );
cogent.sound.buffer            = zeros( cogent.sound.number_of_buffers, 1 );


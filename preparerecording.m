function preparerecording( varargin )
% PREPARERECORDING prepare recording buffer
%
% Description:
%     Prepare recording buffer for mono or stereo recording of specific duration
%
% Usage:
%     PREPARERECORDING( duration )            - prepare for mono recording
%     PREPARERECORDING( duration, nchannels ) - prepare for mono or stereo recording
%
% Arguments:
%     duration  - duration of recording in milliseconds
%     nchannels - number of channels (1-mono 2-stereo)
%
% See also:
%     GETRECORDING, RECORDSOUND, WAITRECORD    
%
%   Cogent 2000 function.

global cogent;

% Check number of arguments
if nargin < 1 | nargin > 2
   error( 'wrong number of arguments' );
end

% Duration argument
duration = varargin{1};
if duration < 0
   error( 'duration must be greater than 0' );
end

% Number of channels argument
nchannels = default_arg( 1, varargin, 2 );
if nchannels < 1 | nchannels > 2
   error( 'number of channels must be 1 (mono) or 2 (stereo)' );
end

nsamples = floor( cogent.sound.frequency * duration / 1000 );
cogcapture( 'create', nsamples, cogent.sound.nbits, cogent.sound.frequency, nchannels );



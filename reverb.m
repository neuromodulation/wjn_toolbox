function [wave]=reverb(numecho, sound_in, numshift, alpha)
%
% This function reverberates sound
% 
% numecho = number of times to echo
% sound_in = sound data
% numshift = amount in samples to shift each echo
% alpha = amount to scale each echo
%
% Written by : Mark Weaver

% Initialize
wavelength=ceil(numecho*numshift+length(sound_in));
wave(wavelength)=0;
scaler=1;
position=0; % This is the real position
rpos=1; % This is the rounded position used for array indexs

% Use superposition to shift and add the sound
% data, thus creating the echo.
for i=1:numecho
   wave(rpos:rpos+length(sound_in)-1)= ...
      wave(rpos:rpos+length(sound_in)-1)+sound_in'*scaler;
   position=position+numshift;
   scaler=scaler*alpha;
   rpos=round(position);
end
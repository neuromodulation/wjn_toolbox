function waitrecord
% WAITRECORD wait for recording to finish
%
% Description:
%    Wait for recording to finish.
%
% Usage:
%    WAITRECORD
%
% Arguments:
%    NONE
%
% See also:
%     PREPARERECORDING, GETRECORDING, RECORDSOUND
%
% Cogent 2000 function.


while( cogcapture('recording') )
end

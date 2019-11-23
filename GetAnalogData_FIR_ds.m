function [time, AnalogWaveforms, AnalogElectrodeIDs] = GetAnalogData_FIR_ds(filename, sf, channels, tstart, tend, lowpass, ds)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Get all data from .NSX file sampled at sf
%
% Inputs:
%           filename - string containing path to NSX file containing data
% Outputs:
%           time - vector of sample timestamps in seconds
%           AnalogWaveforms - samples x channels matrix containing data
%           AnalogElectrodeIDs - vector containing numerical electrode IDs
%
%               Electrode IDs are numbered as follows:
%               Headstage inputs:
%                   Ripple NIP Port A - ElectrodeIDs 1:128
%                   Ripple NIP Port B - ElectrodeIDs 129:256
%                   Ripple NIP Port C - ElectrodeIDs 257:384
%                   Ripple NIP Port D - ElectrodeIDs 385:512
%               Analog I/O inputs:
%                   ElectrodeIDs 10241-10270
% 
% Witold Lipski 2013
% Adapted from RippleNeuroshareDemo1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ns_RESULT, hFile] = ns_OpenFile(filename);

% check to make sure the operation succeeded
if( strcmp(ns_RESULT, 'ns_OK') ~= 1 )
    disp(['ERROR: ns_OpenFile() returned ' ns_RESULT]);
    return;
end

% The file info structure "nsFileInfo" contains information about when the 
% recording was created, the timespan of the recording, timestamp 
% resolution in seconds, and the number of entities in the recording. 
[ns_RESULT, nsFileInfo] = ns_GetFileInfo(hFile);

% check to make sure the operation succeeded
if( strcmp(ns_RESULT, 'ns_OK') ~= 1 )
    disp(['ERROR: ns_OpenFile() returned ' ns_RESULT]);
    return;
end

% The entity inforamtion is read using ns_GetEntityInfo()
for i = 1:nsFileInfo.EntityCount
    [~, nsEntityInfo(i,1)] = ns_GetEntityInfo(hFile, i);
end

% Find Analog data, i.e. sampled time series
% As per the Neuroshare specification, The codes for the various types of 
% entities are as follows:
%   
%               Unknown entity                   0
%   
%               Event entity                     1
%   
%               Analog entity                    2
%   
%               Segment entity                   3
%   
%               Neural Event entity              4
%
% Another way to do this using nsFileInfo:
% AnalogEntityIDs  = find(strcmp({hFile.Entity(:).EntityType},'Analog'));
% Entity IDs from hFile.Entity and EntityInfo are treated as identical here.
%
AnalogEntityIDs  = find([nsEntityInfo.EntityType]==2);

% Find 30 kHz sampled data
% This is denoted by the hFile.FileInfo.Period property:
%
%   Period = 1	=> 30 kHz sampling 
%   Period = 30 => 1 kHz sampling
%
FileIndexes = [hFile.Entity(AnalogEntityIDs).FileType];
Periods = [hFile.FileInfo(FileIndexes).Period];
if sf == 30000
    AnalogEntityIDsSF = AnalogEntityIDs(Periods==1);
elseif sf == 1000
    AnalogEntityIDsSF = AnalogEntityIDs(Periods==30);
end
if isempty(AnalogEntityIDsSF)
    disp('Could not find data sampled at this frequency.');
    return;
end

% Find Electrode IDs and other info about selected channels
AnalogElectrodeIDs  = [hFile.Entity(AnalogEntityIDsSF).ElectrodeID]

% Unless channels are specified, read all channels
if nargin < 2 || isempty(channels)
    channels = AnalogElectrodeIDs;
end
    
AnalogItemCounts  = [nsEntityInfo(AnalogEntityIDsSF).ItemCount];
%AnalogEntityCount      = length(AnalogEntityIDsSF);
AnalogSampleReadStart  = 1;
if ~isempty(tstart)
    AnalogSampleReadStart  = tstart*sf;
end
AnalogSampleReadCount  = min(AnalogItemCounts);
if ~isempty(tend)
    AnalogSampleReadCount  = (tend-tstart)*sf+1;
end
%AnalogSampleCounts     = zeros(AnalogEntityCount, 1);
AnalogWaveforms        = zeros(AnalogSampleReadCount/ds, length(channels));
% Get data
j=1;
for i = 1:length(channels)
    thisID = find(AnalogElectrodeIDs==channels(i));
    if ~isempty(thisID)
        fprintf('Reading electrode %d | %d...\n', AnalogElectrodeIDs(thisID), AnalogEntityIDsSF(thisID));
        [~,~, raw] = ...
            ns_GetAnalogData(hFile, ...
            AnalogEntityIDsSF(thisID), ...
            AnalogSampleReadStart, ...
            AnalogSampleReadCount);
        raw_filt = eegfilt(raw', sf, 0, lowpass);
        AnalogWaveforms(:,j) = downsample(raw_filt, ds);
        j=j+1;
    else
        fprintf('Electrode %d not found!\n', AnalogElectrodeIDs(thisID));
    end
end
% Calculate sample times based on 30kHz sampling frequency
time = (1:AnalogSampleReadCount)/sf;
time = downsample(time, ds);
ns_RESULT = ns_CloseFile(hFile);
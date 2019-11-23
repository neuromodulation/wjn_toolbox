function [signal] = tms_read(varargin)
%
%  data = tms_read('filename','path');
%  or
%  data = tms_read('fullPath');
%  or
%  data = tms_read();
%   
%
%   With this function TMS32 files can be read. The function output is a struct with all
%   the paramaters stored in the tms file. A GUI will be opened upon function call which
%   file needs to be read.
%
%   Function call:
%       data = tms_read('filename,path');
%
%   Most output parameters speak for themselves 
%    (like: filename, path, measurementdate, measurementtime, measurementduration)
%   The structs 'header' and 'blocks' contain the header and block data of the tms file.
%   
%   The measurement data is stored in the cell 'data'. Memory taken by channels which were
%   not used are removed by the function remove_not_measured_chan() which is called
%   at the end of this function.
%   
%   The function can read both Portilab I and Portilab II files (TMS version 2.03 and
%   2.04 files).
%
%   The function assumes that all data is stored as 32-bit values !!! (which is the standard
%   setting). When some channels are stored in 16-bit format, an adaptation needs to be
%   made!
%
%   The output values of the data channels is the measured voltage in uV.
%   
%   Hint: 
%     to plot the data of channel 1, use
%       plot([1:length(data.data{1})]/data.fs,data.data{1});
%       xlabel('Time [s]'); ylabel('Voltage [\mu V]');
%
%	CREDITS AND CHANGES:
%   Based upon script from T. Tönis, June 2006.
%
%   Changed on 08-10-2014 by TL, TMSi
%   - Now supports loading a file from different directory than the script file
%   - Feedback on the validity of arguments and whether a file could be found or not.
%   - Dialogue is opened when no argument was given.
%
%
%    	This program is distributed in the hope that it will be useful,
%    	but WITHOUT ANY WARRANTY; without even the implied warranty of
%    	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
%



%% initialize
signal = struct;

%% Open file
if nargin==0;
	disp('no arguments were given, dialogue to select file is used');
  [filename, path, ~] = uigetfile('*.Poly5', 'Pick a data file');
	fullPath=[path,filesep,filename];
elseif nargin==1;
	fullPath=varargin{1};
elseif nargin==2;
	fullPath=[varargin{2},filesep,varargin{1}];
else
	disp(['To many arguments given: ' varargin{:}]); return;
end	

fid=fopen(fullPath);
	if fid==-1;
		disp([fullPath ' not found']); return;
	end

	
%% Load file:
disp(' ');
disp('==================== Loading TMS file ====================');
disp(' ');

[path,filename,extension]=fileparts(fullPath);

    % export for later use
    signal.fname = filename;
    signal.path = path; 
    signal.filename = fullPath;
        
    fprintf('Start reading: %s\n',signal.filename);
    disp('Reading file header ...');
%    signal.header = fread(fid,217,'int8');

    % Signal header
    %determine signal file version
    pos = 31;
    fseek(fid,pos,-1);
    version = fread(fid,1,'int16');
    if version == 203
        frewind(fid);
        signal.header.FID                   = fread(fid,31,'uchar');
        signal.header.VersionNumber         = fread(fid, 1,'int16');
    else % version 204
        frewind(fid);
        signal.header.FID                   = fread(fid,32,'uchar');
        signal.header.VersionNumber         = fread(fid, 1,'int16');
    end
    signal.header.MeasurementName       = fread(fid,81,'uchar');
    signal.header.FS                    = fread(fid, 1,'int16');
    signal.header.StorageRate           = fread(fid, 1,'int16');
    signal.header.StorageType           = fread(fid, 1,'uchar');
    signal.header.NumberOfSignals       = fread(fid, 1,'int16');
    signal.header.NumberOfSamplePeriods = fread(fid, 1,'int32');
    signal.header.EMPTYBYTES            = fread(fid, 4,'uchar');
    signal.header.StartMeasurement      = fread(fid,14,'uchar');
    signal.header.NumberSampleBlocks    = fread(fid, 1,'int32');
    signal.header.SamplePeriodsPerBlock = fread(fid, 1,'uint16');
    signal.header.SizeSignalDataBlock   = fread(fid, 1,'uint16');
    signal.header.DeltaCompressionFlag  = fread(fid, 1,'int16');
    signal.header.TrailingZeros         = fread(fid,64,'uchar');
    
    %conversion to char of text values
    signal.header.FID               = char(signal.header.FID);
    signal.header.MeasurementName   = char(signal.header.MeasurementName(2:signal.header.MeasurementName(1)+1));
%    signal.header.StartMeasurement  = typecast(int8(signal.header.StartMeasurement),'int16'); % commented by RS 1feb11
    
    signal.fs = signal.header.FS;
    
    %check for right fileversion
    % if signal.header.VersionNumber ~= 203
    %    disp('Wrong file version! Imput file must be a Poly5/TMS version 2.03 file!');
    %    return;
    % end;
    
    % Signal description
    for g=1:signal.header.NumberOfSignals,
        signal.description(g).SignalName        = fread(fid,41,'uchar');
        signal.description(g).Reserved          = fread(fid, 4,'uchar');
        signal.description(g).UnitName          = fread(fid,11,'uchar');
        signal.description(g).UnitLow           = fread(fid, 1,'float32');
        signal.description(g).UnitHigh          = fread(fid, 1,'float32');
        signal.description(g).ADCLow            = fread(fid, 1,'float32');
        signal.description(g).ADCHigh           = fread(fid, 1,'float32');
        signal.description(g).IndexSignalList   = fread(fid, 1,'int16');
        signal.description(g).CacheOffset       = fread(fid, 1,'int16');
        signal.description(g).Reserved2         = fread(fid,60,'uchar');
        
        % conversion of char values (to right format)
        signal.description(g).SignalName = char(signal.description(g).SignalName(2:signal.description(g).SignalName(1)+1));
        signal.description(g).UnitName   = char(signal.description(g).UnitName(2:signal.description(g).UnitName(1)+1));
    end  %for  
    
    %read data blocks
    NB = signal.header.NumberSampleBlocks;
    SD = signal.header.SizeSignalDataBlock;
    NS = signal.header.NumberOfSignals;
    NS_32bit = NS/2;
    
    %reserve memory
    %signal.data = zeros(NS_32bit,SD*NB/(NS_32bit*4));
    
    disp('Reading measurement data ...');
    h = waitbar(0,'Reading measurement data ...');

    for g=1:NB;

        %jump to right position in file
        if signal.header.VersionNumber == 203
            pos = 217 + NS*136 + (g-1) *(86+SD);
        else
            pos = 218 + NS*136 + (g-1) *(86+SD);
        end
        fseek(fid,pos,-1);
        
        signal.block(g).PI = fread(fid,1,'int32'); %period index
        fread(fid,4,'uchar'); %reserved for extension of previous field to 8 bytes
        signal.block(g).BT = fread(fid,14/2,'int16'); %dostime
        fread(fid,64,'uchar'); %reserved
        data = single(fread(fid,SD/4,'float32'));
        
        % Convert data to 32bit values.
        % In case also 16bit values have to be measured, these values are
        % typecasted below:
        %data = fread(fid,SD/2,'int16'); %read data
        %data = int16(data);
        %data = typecast(data,'int32');
        %signal.block(g).DATA = data;
        signal.data{g} = reshape(data,NS_32bit,SD/(NS_32bit*4));
        waitbar(g/NB,h)
    end %for
    close(h); %close waitbar    
    fclose(fid);
    
    disp('Converting data to a usable format ...');
    signal.data = cell2mat(signal.data);
    signal.data = cast(signal.data, 'double');
%    signal.data = cell(NS_32bit,1);
    signal.data = mat2cell(signal.data,ones(NS_32bit,1),size(signal.data,2));
    
    for g = 1:NS_32bit  % represent data in [uV]
        signal.data{g} = (signal.data{g} - signal.description(g*2).ADCLow)./(signal.description(g*2).ADCHigh - signal.description(g*2).ADCLow)  .* (signal.description(g*2).UnitHigh - signal.description(g*2).UnitLow) + signal.description(g*2).UnitLow ; %correction for uV
    end
    %signal.data = reshape(signal.data,NS_32bit,SD*NB);
    
    
    datum = signal.block(1,1).BT;
    signal.measurementdate = [num2str(datum(3),'%02.0f') '-' num2str(datum(2),'%02.0f') '-' num2str(datum(1),'%02.0f')];
    signal.measurementtime = [num2str(datum(5),'%02.0f') ':' num2str(datum(6),'%02.0f') ':' num2str(datum(7),'%02.0f')];
    
    ts = size(signal.data{1},2)/signal.fs;
    th = floor(ts / 3600);
    tm = floor(ts/60 - th*60);
    tss = floor(ts - th*3600 - tm * 60);
    signal.measurementduration = [num2str(th,'%02.0f') ':' num2str(tm,'%02.0f') ':' num2str(tss,'%02.0f')];
    
    disp(' ');
    disp('-------------------- File information --------------------');
    fprintf('\tFile name                   : %s\n',signal.fname);    
    fprintf('\tSample frequency            : %4.0f Hz\n',signal.header.FS);
    fprintf('\tMeasurement date            : %s\n',signal.measurementdate);
    fprintf('\tMeasurement start time      : %s\n',signal.measurementtime);
    fprintf('\tMeasurement duration        : %s\n',signal.measurementduration);
    fprintf('\tChannels which contain data : ');
    signal.data = remove_not_measured_chan(signal.data);

    disp('----------------------------------------------------------');
    %    fprintf('Measurement duration: %
    disp(' ');


end %function


function [sig] = remove_not_measured_chan(data);


sig = cell(size(data));
% convert to cell structure
for g = 1:size(data,1)
    tmpdata = data{g};
    gem = mean(tmpdata);
    afw = std(tmpdata);
    if gem == 0 && afw == 0
        sig{g} = []; % remove zeros (nothing is measured anyway);
    else
        sig{g} = double(tmpdata);
        fprintf('%2.0f ', g ); 
    end %if
end %for
fprintf('\n');
end %function    


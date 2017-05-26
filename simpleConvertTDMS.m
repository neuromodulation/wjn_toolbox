function matFileName=simpleConvertTDMS(fileName)

%Function to convert .tdms files to .mat files.  This function call
%convertTDMS and creates a .mat file for each .tdms file provided. It
%outputs to the .mat file, a simplified set of variables.
%
%   Inputs:
%               filename (optional) - Filename to be converted.
%                 If not supplied, the user is provided a 'File Open' dialog box
%                 to navigate to a file.  Can be a cell array of files for bulk
%                 conversion.
%
%
%   Outputs:
%
%               matFileName - Structure array containing the names of the
%                   new mat files.
%
%
%   See also: convertTDMS

%-------------------------------------------------------------------------
%Brad Humphreys - v1.0 2013-11-16
%ZIN Technologies
%-------------------------------------------------------------------------


%-------------------------------------------------------------------------
%Brad Humphreys - v1.1 2014-1-13
%Added check to see if the group/channel name begins with an alpha
%char.  LV allows group and channel names to begin with  numeric char.
%If first char are numeric, a "d" is prepended to the group name
%-------------------------------------------------------------------------


if nargin==0
    %Prompt the user for the file
    [fileName,pathName]=uigetfile({'*.tdms','All Files (*.tdms)'},'Choose a TDMS File');
    if fileName==0
        return
    end
    fileName=fullfile(pathName,fileName);
end


if iscell(fileName)
    %For a list of files
    inFileName=fileName;
else
    inFileName=cellstr(fileName);
end

for fnum=1:numel(inFileName)  % Loop through cells of filename
    
    tdmsFileName=inFileName{fnum};
    
    %Perform Conversion
    [convertedData,dataOb.convertVer,d.chanNames,d.groupNames,dataOb.ci]=convertTDMS(0,tdmsFileName);
    
    
    %Build more obvious struture of data form file
    dataOb.fileName=convertedData.FileName;
    dataOb.fileFolder=convertedData.FileFolder;
    channelNames={convertedData.Data.MeasuredData.Name};
    
    for cnum=1:numel(channelNames)
        safeChannelName{cnum} = regexprep(channelNames{cnum},'\W','');  %Remove charters not compatible for variable names
        chanNameTemp=safeChannelName{cnum};
        if ~isstrprop(chanNameTemp(1),'alpha');   %If the first character is not alpha, append a 'd' 
            safeChannelName{cnum}=['d' safeChannelName{cnum}];
        end
        
        
        dataOb.(safeChannelName{cnum}).Data=convertedData.Data.MeasuredData(cnum).Data;
        dataOb.(safeChannelName{cnum}).Total_Samples=convertedData.Data.MeasuredData(cnum).Total_Samples;
        
        %Convert the properties
        prop=convertedData.Data.MeasuredData(cnum).Property;
        
        for pcnt=1:numel(prop)
            pName=prop(pcnt).Name;
            safePropName= regexprep(pName,'\W','');
            pValue=prop(pcnt).Value;
            dataOb.(safeChannelName{cnum}).Property.(safePropName)=pValue;
        end
        
    end
    
    %Write the file
    [pathstr,name,ext]=fileparts(tdmsFileName);
    matFileName{fnum}=fullfile(pathstr,[name '.mat']);
    save(matFileName{fnum},'-struct','dataOb');
    fprintf('Saved File ''%s''\n',matFileName{fnum})
end
function [ao,dio] = config_dio_session(analog_channels,digital_channels)
% To create output use outputsinglescan

clear ao dio

dev = daq.getDevices;

if isempty(dev)
    ao=[];
    dio=[];
    return
end

id = dev.ID;

if ~isempty(analog_channels)
    ao = daq.createSession('ni');
%     keyboard
    ao.addAnalogOutputChannel(id,analog_channels,'Voltage');
    ao.Rate = 2048;
%     global ao
else
    ao = [];
end

if exist('digital_channels','var')
    dio = daq.createSession('ni');
    if isnumeric(digital_channels)
        for a = 1:length(digital_channels)
            dio.addDigitalChannel(id,['port1/line' num2str(digital_channels(a))],'OutputOnly');
            
        end
    elseif ischar(digital_channels)
        dio.addDigitalChannel(id,digital_channels,'OutputOnly');
    end
%     global dio
else
    dio = [];
end



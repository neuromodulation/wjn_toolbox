function dio=config_dio(lines)
global dio;
%% Set digital output
% if exist('dio','var')
% delete(dio);
% clear dio
% end
if ~exist('lines','var')
    lines = [1 2];
end

% global dio;
try
    dev = DAQHWINFO('nidaq');
    dio=digitalio('nidaq',1);
    addline(dio,lines-1,1,'Out');
catch
    dio = daq.createSession('ni'); 
    addDigitalChannel(dio,'LFP','Port1/Line2','OutputOnly');
end
% clear dev
end


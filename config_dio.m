function config_dio(lines)
global dio;
%% Set digital output
if exist('dio','var');
delete(dio);
clear dio
end
if ~exist('lines','var')
    lines = [1 2];
end

global dio;
    dev = DAQHWINFO('nidaq');

    dio=digitalio('nidaq',dev.InstalledBoardIds{1});
    addline(dio,lines-1,1,'Out');
    

clear dev
end
function config_parallel
global dio;
%% Set digital output
if exist('dio','var');
delete(dio);
clear dio
end
global dio;
    dev = DAQHWINFO('parallel');

    dio=digitalio('parallel',dev.InstalledBoardIds{1});
    dio=addline(dio,0:7,0,'Out');
    

clear dev
end

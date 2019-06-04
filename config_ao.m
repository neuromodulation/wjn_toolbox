function chk = config_ao

try
    daq.reset();
    devices = daq.getDevices;
    s = daq.createSession('ni');
    s.IsContinuous=1;
    s.Rate=1000;
    s.NotifyWhenScansQueuedBelow = 50;
    ch = addAnalogOutputChannel(s,'LFP',0:1,'Voltage');
    x = linspace(-.1,.1,1000);
    queueOutputData(s,repmat([x' x'],50,1));
    s.startBackground();
    for a = 1:10
        pause(.2)
        queueOutputData(s,repmat([x(a) x(a)],500,1));s.startBackground();
    end
    
% %% Set Analog output
%     delete ao;
%     global ao;
%         dev = DAQHWINFO('nidaq');
% 
%         ao=analogoutput('nidaq',dev.InstalledBoardIds{1});
%         addchannel(ao,0:1);
%         set(ao,'SampleRate',1000);
%         set(ao,'TriggerType','Immediate')
%     clear dev
%     chk = 1
% catch
%     disp('NO DAQ DEVICE')
%     chk = 0;
% end
% end


% function config_dio(lines)
% global dio;
% %% Set digital output
% if exist('dio','var')
% delete(dio);
% clear dio
% end
% if ~exist('lines','var')
%     lines = [1 2];
% end
% 
% global dio;
% %     dev = daqhwinfo('nidaq');
% 
% %     dio=digitalio('nidaq',1);
% %     addline(dio,lines-1,1,'Out');
%     
%     dio = daq.createSession('ni'); 
%     addDigitalChannel(dio,'Dev1','Port1/Line0:7','OutputOnly');
% 
% % clear dev
% end
% 

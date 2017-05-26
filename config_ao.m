function config_ao

%% Set Analog output
delete ao;
global ao;
    dev = DAQHWINFO('nidaq');

    ao=analogoutput('nidaq',dev.InstalledBoardIds{1});
    addchannel(ao,0:1);
    set(ao,'SampleRate',1000);
    set(ao,'TriggerType','Immediate')
clear dev
end
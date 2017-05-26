function config_ai(ch)

%% Set Analog input
delete ai;
global ai;
    dev = daqhwinfo('nidaq');

    ai=analoginput('nidaq',dev.InstalledBoardIds{1});
    addchannel(ai,ch-1);
    set(ai,'SampleRate',1000);
    set(ai,'TriggerType','Immediate')
clear dev
end
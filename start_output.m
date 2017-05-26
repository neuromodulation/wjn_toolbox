function start_output(screen_resolution)
period = 0.005;

global ao
global tim
if screen_resolution >= 4 && screen_resolution <= 6;
    display('No output');
elseif screen_resolution == 3;
    tim = timer('TimerFcn',{@output_1024x768,ao},'Period',period,'BusyMode','queue','ExecutionMode','fixedRate');
    display('Start tablet output for 1024x768')
%     start(tim);
elseif screen_resolution == 2;
    tim = timer('TimerFcn',{@output_800x600,ao},'Period',period,'BusyMode','queue','ExecutionMode','fixedRate');
    display('Start tablet output for 800x600')
    start(tim);
elseif screen_resolution == 1;
    tim = timer('TimerFcn',{@output_640x480,ao},'Period',period,'BusyMode','queue','ExecutionMode','fixedRate');
    display('Start tablet output for 640x480')
    start(tim);
else
    error('Screen resolution must be set to either 1 = 640x480 or 2 = 1024x768')
end

end
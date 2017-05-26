
global ao tim
config_ao;
period = .001;
size = get(0,'ScreenSize');
size(1:2) = [];
tim = timer('TimerFcn',{@output_mouse,ao,size},'Period',period,'BusyMode','queue','ExecutionMode','fixedRate');

start(tim)
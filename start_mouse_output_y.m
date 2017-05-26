function start_mouse_output_y(size)
global ao 
global tim
period = .01;
tim = timer('TimerFcn',{@output_mouse_y,ao,size},'Period',period,'BusyMode','queue','ExecutionMode','fixedRate');

start(tim)

end
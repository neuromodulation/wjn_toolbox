function joystick_output(tim,event,ao,joystick)
cursor = axis(joystick,[1 2]);
cursor(2)=-1*cursor(2);
% display(cursor)
% putsample(ao,cursor);
outputSingleScan(ao,cursor)
end
function output_mouse_y(tim,event,ao,size)
global epos
cursor = get(0,'PointerLocation');
output(1) = (cursor(2)-(size(2)/2))/(size(2)/2)*1;
output(2) = (epos/(size(2)/2))*1;
putsample(ao,[output(1) output(2)]);
end
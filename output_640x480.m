function output_640x480(tim,event,ao)
%global ao
cursor = get(0,'PointerLocation');
cursor(1) = (cursor(1)-320)/320*5;
cursor(2) = (cursor(2)-240)/240*5;
%display(cursor)
putsample(ao,cursor);
end
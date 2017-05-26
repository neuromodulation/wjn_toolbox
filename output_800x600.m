function output_800x600(tim,event,ao)
cursor = get(0,'PointerLocation');
cursor(1) = (cursor(1)-400)/400*5;
cursor(2) = (cursor(2)-300)/300*5;
%display(cursor)
putsample(ao,cursor);
end
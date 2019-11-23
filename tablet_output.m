function tablet_output(tim,event,ao)
cursor = get(0,'PointerLocation');
cursor(1) = (cursor(1)-400)/400;
cursor(2) = (cursor(2)-300)/300;
%display(cursor)
% putsample(ao,cursor);
outputSingleScan(ao,cursor);
end
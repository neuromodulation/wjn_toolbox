function output_mouse(tim,event,ao,size)
% if ~exist('size','var')
% size = get(0,'screenSize');
% size(1:2) =[];
% end
cursor = get(0,'PointerLocation');
cursor(1) = (cursor(1)-(size(1)/2))/(size(1)/2)*5;
cursor(2) = (cursor(2)-(size(2)/2))/(size(2)/2)*5;
%display(cursor)
putsample(ao,cursor);
end
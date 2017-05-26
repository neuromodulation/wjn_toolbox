function text_output(tim,event)
% %global ao

% cursor(1) = (cursor(1)-320)/320*5;
% cursor(2) = (cursor(2)-240)/240*5;
%display(cursor)
% putsample(ao,cursor);
% tic
global start_time fid;
% global cursor_out start_time current_time;
% cursor_out(size((cursor_out),1)+1,1:2) = get(0,'PointerLocation');
% [x,y]=cgmouse;

% current_time = toc(start_time);
% cursor_out = get(0,'PointerLocation');


fprintf(fid,[num2str([toc(start_time),get(0,'PointerLocation')]) '\n']);
% toc
% type changing.txt


end
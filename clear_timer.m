function clear_timer
% global ao
% delete(ao)
% global cursor_out;
% save rescue cursor_out;
% clearvars -global cursor_out current_time
x=timerfindall;
delete(x);
clear x ao;
end
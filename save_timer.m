function save_timer(a)

global cursor_out current_time name;
v=genvarname(['trial_' num2str(a)]);
eval([v '= [cursor_out , current_time]']);
save(name,'-append',v);
clearvars -global cursor_out current_time
end

% dystonia patients w DBS in GPI
% T. Sander, PTB, 9 / 2015
% berlin_correct_eventdata.m with motor trig enabled, berlin_motor_to_event.m
% dbs_meg_extraction_prepare_spm12.m, dbs_subjects_berlin.m, dbs_subjects.m
spm('defaults', 'eeg');
patcode = {'PLFP04','PLFP07','PLFP08','PLFP09','PLFP10', 'PLFP11','PLFP12','PLFP22','PLFP25'};

% no responses due to button failure: 'PLFP20'
% no responses on right side: 'PLFP25'

for s = [1:length(patcode)]
    initials = [char( patcode(s) )]
    on = 0;
    
    D = dbs_meg_extraction_prepare_spm12(initials, on,'STOP');
    % dbs_meg_task_source_v2(initials, on,'STOP');
    
         
end


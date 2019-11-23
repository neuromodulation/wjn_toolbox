function details = meg_subjects(ini,on)
if ~exist(on,'var') 
    on = 1;
end

[files,sequence,root,details] = dbs_subjects_berlin(ini,condition);
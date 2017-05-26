function c=PCS_addconditions(cond)

load(fullfile(getsystem,'projects','PC+S','PCS_conditions.mat'))
c{1}{length(c{1})+1} = cond; 
    
save(fullfile(getsystem,'projects','PC+S','PCS_conditions.mat'),'c')
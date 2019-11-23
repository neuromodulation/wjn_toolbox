
%% CONVERT REST FILES

ini = 'DYST'

for a = 3:5;
[files,sequence,root,details]=dbs_subjects_berlin([ini '0' num2str(a)],1)
D=dbs_meg_rest_prepare_spm12([ini '0' num2str(a)],1)
end





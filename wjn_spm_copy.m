function D=wjn_spm_copy(filename,new_filename)
% D=wjn_spm_copy(filename,new_filename)

S=[];
S.D = filename;
S.outfile = new_filename;
D=spm_eeg_copy(S);
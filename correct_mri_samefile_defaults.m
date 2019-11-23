function D=correct_mri_samefile_defaults(original_file)
% addpath C:\SPM12\
% spm('eeg','defaults');close all;
% root = 'C:\megdata\TB\';
D=spm_eeg_load(original_file);
% S.D = fullfile(D.path,D.fname);
% S.outfile = fullfile(D.path,['cm' D.fname]);
% D=spm_eeg_copy(S);
%%
% D.inv{1}.mesh.sMRI = [];
% D.inv{1}.mesh.def = [];

iskull= fullfile(spm('dir'),'canonical',['iskull_2562.surf.gii']); %iskull
cortex = fullfile(spm('dir'),'canonical',['cortex_8196.surf.gii']); %cortex
oskull = fullfile(spm('dir'),'canonical',['oskull_2562.surf.gii']); %oskull
scalp = fullfile(spm('dir'),'canonical',['scalp_2562.surf.gii']);
D.inv{1}.mesh.tess_ctx = cortex;
D.inv{1}.mesh.tess_iskull = iskull;
D.inv{1}.mesh.tess_oskull = oskull;
D.inv{1}.mesh.tess_scalp = scalp;
save(D);

%%
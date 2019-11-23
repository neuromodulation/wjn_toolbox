root = fullfile(mdf,'pd_fmri','PPMI');
cd(root)
folders = wjn_dir;

for a = 1:length(folders)
    cd(fullfile(root,folders{a}));
    [~,~,restfiles] = ffind('*ep2d*.nii',1,1);

%     str=split(fn,'_');
%     [~,i]=sort(str2double(str(:,9)));
    clear matlabbatch
    matlabbatch{1}.spm.util.cat.vols =restfiles;
    matlabbatch{1}.spm.util.cat.name = fullfile('D:','test.nii');
    matlabbatch{1}.spm.util.cat.dtype = 2;
    spm_jobman('run',matlabbatch)
    movefile('D:\test.nii','.\rest.nii')
    
    [~,~,mprage] = ffind('*mprage*.nii',0,1);
    movefile(mprage,'.\anat_t1.nii');
    
        [~,~,t2] = ffind('*T2*.nii',0,1);
    movefile(t2,'.\anat_t2.nii');
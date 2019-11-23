function [slices,anatomy]=lead_slice_import_dicom(folder)

if ~exist('folder','var')
    folder = uigetdir;
end


niftitemp = fullfile(folder,'niitemp');
files = wjn_subdir(fullfile(folder,'IM*'));
matlabbatch{1}.spm.util.import.dicom.data = files;
matlabbatch{1}.spm.util.import.dicom.root = 'series';
matlabbatch{1}.spm.util.import.dicom.outdir = {niftitemp};
matlabbatch{1}.spm.util.import.dicom.protfilter ='.*';
matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
matlabbatch{1}.spm.util.import.dicom.convopts.meta = 0;
matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
spm_jobman('run',matlabbatch);

niftis = wjn_dir(niftitemp);

for a = 1:length(niftis)
    temp = stringsplit(niftis{a},'_');
    i(a) = str2num(temp{end});
end

[i,ni]=sort(i);
niftis = niftis(ni);

protocols = {'mprage','t2','hemo','fgatir','UFBOLD'};
fname = {'anat_t1','anat_t2','anat_t2star','anat_fgatir','ufbold'};

for a = 1:length(protocols)
    temp = ci(protocols{a},niftis);
  
    if a<=4
       [niifiles,niifolders,fullfiles] = ffind(fullfile(niftitemp,niftis{temp(1)},'*.nii'),1);
        movefile(fullfile(niifolders{1},niifiles{1}),fullfile(folder,[fname{a} '.nii']));
        anatomy{a} = fullfile(folder,[fname{a} '.nii']);
    elseif a==5
        for b = 1:length(temp)
        
        [niifiles,niifolders,fullfiles] = ffind(fullfile(niftitemp,niftis{temp(1)},'*.nii'),1);
        keyboard
        matlabbatch =[];
        matlabbatch{1}.spm.util.cat.vols = fullfiles;
        matlabbatch{1}.spm.util.cat.name = fullfile(folder,[fname{a} '.nii']);
        matlabbatch{1}.spm.util.cat.dtype = 4;
        matlabbatch{1}.spm.util.cat.RT =.05;
        spm_jobman('run',matlabbatch)
        end
    end
end


%%


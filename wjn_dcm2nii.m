function nii=wjn_dcm2nii(infolder,protocol)

%%

if ~exist('infolder','var')
    infolder = cd;
end


[files,folders] = wjn_subdir(fullfile(infolder,'IM*'));

ufolders = unique(folders);
nii = {};
for n = 1:length(ufolders)
    
    if ~exist('protocol','var')
        protocol = ufolders{n};
        protocol = stringsplit(protocol,'\');
        if strcmp(protocol{end},'IMAGES')
            protocol = protocol(1:end-1);
        end
        protocol = protocol{end};
    end
    
    
    folder = ufolders{n}(1:end-7);
    cd(folder)
          
    tempfolder = fullfile(folder,'temp');
    mkdir(tempfolder)
    
 
    if strcmp(protocol,'DTI') || strcmp(protocol,'DBS') || strcmp(protocol,'rsMRI') || strcmp(protocol,'UFBOLD')
        ea_dcm2niix(infolder,tempfolder)
    else
        
        matlabbatch{1}.spm.util.import.dicom.data = files(ci(ufolders{n},folders));
        matlabbatch{1}.spm.util.import.dicom.root = 'flat';
        matlabbatch{1}.spm.util.import.dicom.outdir = tempfolder;
        matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
        matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
        matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
        spm_jobman('run',matlabbatch)
        
        movefile(fullfile(folder,'*.nii'),tempfolder);
        
    end
    
    cd(tempfolder)
    niftifiles = ffind('*.nii');
    for a = 1:length(niftifiles)
        nii = [nii;fullfile(folder,[protocol '_' num2str(a) '.nii'])];
        movefile(niftifiles{a},nii{end});
    end
    cd(folder)
    rmdir(tempfolder)
    
    % keyboard
end

% nii = ffind('*.nii');
% movefile(nii,

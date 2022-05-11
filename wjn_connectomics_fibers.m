
addpath(genpath('C:\code\leaddbs'))
addpath C:\code\spm12
addpath C:\code\wjn_toolbox

mni = wjn_mni_list
for a=1:size(mni,1)
    files{a,1}=wjn_spherical_roi(['file_' num2str(a) '.nii'],mni(1,:),10,fullfile(spm('dir'),'canonical','avg152T1.nii'));
end
resultfig = ea_mnifigure; % Create empty 3D viewer figure

M.pseudoM = 1; % Declare this is a pseudo-M struct, i.e. not a real lead group file
M.ROI.list=files;
% {'/path/to/first_nifti.nii' % enter paths to ROI here
% '/path/to/second_nifti.nii'
% '/path/to/third_nifti.nii'
% '/path/to/fourth_nifti.nii'
% '/path/to/fifth_nifti.nii'
% '/path/to/sixth_nifti.nii'
% '/path/to/seven_nifti.nii'
% };

M.ROI.group=ones(length(M.ROI.list),1);

M.clinical.labels={'Decoding Performance'}; % how will variables be called
M.clinical.vars{1}=[1
    2
    3
    4
    5
    6
    ]; % enter a variable of interest - entries correspond to nifti files

M.guid='Fiber_decoding_performance_test.'; % give your analysis a name

save('Analysis_Input_Data.mat','M'); % store data of analysis to file

% Open up the Sweetspot Explorer
ea_sweetspotexplorer(fullfile(pwd,'Analysis_Input_Data.mat'),resultfig);

% Open up the Network Mapping Explorer
ea_networkmappingexplorer(fullfile(pwd,'Analysis_Input_Data.mat'),resultfig);

% Open up the Fiber Filtering Explorer
ea_discfiberexplorer(fullfile(pwd,'Analysis_Input_Data.mat'),resultfig);

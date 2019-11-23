clear all
close all
protocols={'DBS','DTI','rsMRI','FCD','CSF'};

root = 'Z:\LFP\neumann\convert2nii';
cd(root);
 dcmoutput=fullfile(root,'nii_output');
% lead16
dirs=dir;
x=1;
while x==1
   keep x dcmoutput
    dirs = dir;
   
    for a = 3:length(dirs)
        d = datenum(datetime('now')-datetime(dirs(1).date));
        if d>0.01 && ~strcmp(dirs(a).name,'converted') && ~strcmp(dirs(a).name,'nii_output') && dirs(a).isdir
            dcmfolder = fullfile(dirs(a).folder,dirs(a).name);
            [protocol,dcmname] = strtok(dirs(a).name,'_');
            movefile(dcmfolder,fullfile(dcmoutput,protocol,['dcm' dcmname]));
         
        end      
    end
end

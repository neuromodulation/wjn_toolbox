function wjn_rsmeg_create_mri_map(p)

lp = length(p);
if isnumeric(p)
   np = p;
   clear p;
end
root = wjn_rsmeg_list('root');
mkdir(fullfile(root,'rsmaps'));

for a =1:lp
    try
    if exist('np','var')
        p{a} = wjn_rsmeg_list(np(a));
    end
    roifolder = wjn_rsmeg_list(p{a}.n,'roifolder');
    [files,folder,fullfiles] = ffind(fullfile(roifolder,'mni*.nii'));
    rsmapfolder = fullfile(root,'mri',p{a}.id);
    mkdir(rsmapfolder)
    cd(rsmapfolder)
%     if length(ffind('*.nii'))>=60
%         continue
%     else
        wjn_lead_mapper(fullfiles,0,1)
        wjn_lead_mapper(fullfiles,1,0)
%     end
   
        
    cd(root);
    catch
        chk=0;
    end
end
        

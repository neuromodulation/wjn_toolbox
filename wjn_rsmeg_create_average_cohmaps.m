
function wjn_rsmeg_create_average_cohmaps(p)




freqfolder = wjn_rsmeg_list('freqfolder');         

  
  
lp = length(p);
if isnumeric(p)
   np = p;
   clear p;
end
root = wjn_rsmeg_list('root');
% mkdir(fullfile(root,'cohmaps'));


for a =1:lp
    if exist('np','var')
        p{a} = wjn_rsmeg_list(np(a));
    end
    cohmapfolder = fullfile(root,'cohmaps',p{a}.id);
    if ~exist(cohmapfolder,'dir')
    chk(a)=0;
        continue
    else
        cd(cohmapfolder)
 
    for c = 1:length(freqfolder)
        fname = ['mCOH_' p{a}.target '_LFP_L_' freqfolder{c} '_' p{a}.id '.nii'];
        files = ffind(['COH*LFP_L*' freqfolder{c} '.nii']);
        wjn_nii_average(files,fname);
        fname = ['mCOH_' p{a}.target '_LFP_R_' freqfolder{c} '_' p{a}.id '.nii'];
        files = ffind(['COH*LFP_R*' freqfolder{c} '.nii']);
        nii=wjn_nii_average(files,fname);
        nii = ea_load_nii(nii);
        nii.img = flipud(nii.img);
        nii.fname = ['mCOH_' p{a}.target '_LFP_R2L_' freqfolder{c}  '_' p{a}.id '.nii'];
        ea_write_nii(nii)
        
        fname = ['msCOH_' p{a}.target '_LFP_L_' freqfolder{c} '_' p{a}.id '.nii'];
        files = ffind(['sCOH*LFP_L*' freqfolder{c} '.nii']);
        wjn_nii_average(files,fname);
        fname = ['msCOH_' p{a}.target '_LFP_R_' freqfolder{c} '_' p{a}.id '.nii'];
        files = ffind(['sCOH*LFP_R*' freqfolder{c} '.nii']);
        nii=wjn_nii_average(files,fname);
        nii = ea_load_nii(nii);
        nii.img = flipud(nii.img);
        nii.fname = ['msCOH_' p{a}.target  '_LFP_R2L_' freqfolder{c} '_' p{a}.id '.nii'];
        ea_write_nii(nii)
    end
    end
end
    cd(root);
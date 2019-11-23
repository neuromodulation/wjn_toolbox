function wjn_rsmeg_create_coh_map(p)



freqbands = wjn_rsmeg_list('freqbands');
  freqfolder = wjn_rsmeg_list('freqfolder');         

  
  
lp = length(p);
if isnumeric(p)
   np = p;
   clear p;
end
root = wjn_rsmeg_list('root');
mkdir(fullfile(root,'cohmaps'));


for a =1:lp
    if exist('np','var')
        p{a} = wjn_rsmeg_list(np(a));
    end
   
    cohmapfolder = fullfile(root,'cohmaps',p{a}.id);
    mkdir(cohmapfolder)
    cd(cohmapfolder)
    for b= 1:length(freqfolder)
        for c = 1:length(p{a}.contact_pairs)
            
            cohmapfile = fullfile(cohmapfolder,['COH_' p{a}.target '_' p{a}.id '_' p{a}.contact_pairs{c} '_' freqfolder{b} '.nii']);
%             keyboard
            if ~exist(cohmapfile)
            scohmapfile = fullfile(cohmapfolder,['sCOH_' p{a}.target '_' p{a}.id '_' p{a}.contact_pairs{c} '_' freqfolder{b} '.nii']);
           
            [nii,snii] = wjn_meg_dbs_source_coherence(p{a}.megfile,freqbands(b,:),p{a}.contact_pairs{c});
            cohmapfile = fullfile(cohmapfolder,['COH_' p{a}.target '_' p{a}.id '_' p{a}.contact_pairs{c} '_' freqfolder{b} '.nii']);
            scohmapfile = fullfile(cohmapfolder,['sCOH_' p{a}.target '_' p{a}.id '_' p{a}.contact_pairs{c} '_' freqfolder{b} '.nii']);
           
 
            pause(1)
            newx = rand(1000);
%             clear newx
            movefile(nii,cohmapfile);
            pause(1)
            newx = rand(1000);
%             clear newx
            delete(nii)
            movefile(snii,scohmapfile);
            pause(1)
            newx = rand(1000);
%             clear newx
            delete(snii)
            else
                warning('done before')
            end
        end
    end




end
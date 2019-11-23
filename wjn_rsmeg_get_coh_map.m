function wjn_rsmeg_get_coh_map(p)

lp = length(p);
if isnumeric(p)
   np = p;
   clear p;
end
root = wjn_rsmeg_list('root');
mkdir(fullfile(root,'cohmaps'));
freqfolder = wjn_rsmeg_list('freqfolder');
for a =1:lp
    if exist('np','var')
        p{a} = wjn_rsmeg_list(np(a));
    end
    megfolder = p{a}.megfolder;

    cohmapfolder = fullfile(root,'cohmaps',p{a}.id);
    mkdir(cohmapfolder)
    for b= 1:length(freqfolder)
        for c = 1:length(p{a}.contact_pairs)
            cfolder = fullfile(megfolder,freqfolder{b},p{a}.contact_pairs{c});
            cohmapfile = fullfile(cohmapfolder,['COH_' p{a}.id '_' p{a}.contact_pairs{c} '_' freqfolder{b} '.nii']);
            copyfile(fullfile(cfolder,'full_orig.nii'),cohmapfile);
%             if strcmp(p{a}.contact_pairs{c}(5),'L')
%                 wjn_nii_flip_lr(cohmapfile,cohmapfile)
%             end
            
        end
    end
    cd(root);
end
        
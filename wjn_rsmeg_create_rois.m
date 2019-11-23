function files = wjn_rsmeg_create_rois(p)

lp = length(p);
if isnumeric(p)
   np = p;
   clear p;
end

for a =1:lp
    if exist('np','var')
        p{a} = wjn_rsmeg_list(np(a));
    end
    
    if ~isempty([p{a}.coords_right; p{a}.coords_left])
   
    root = wjn_rsmeg_list('root');
    cd(root);
    
    mni=wjn_rsmeg_list(p{a}.n,'contact_pair_locations');
    for b = 1:length(p{a}.contact_pairs)
        fnames{b} = [p{a}.target '_' p{a}.id '_'  p{a}.contact_pairs{b}];
    end
    roifolder = fullfile(root,'ROIs',p{a}.id);
    mkdir(roifolder);
    cd(roifolder)
    for b = 1:length(fnames)     
        files{b} = wjn_spherical_roi([fnames{b} '_roi.nii'],mni(b,:),2);
    end
    else 
        files=[];
    end
    cd(root)
end
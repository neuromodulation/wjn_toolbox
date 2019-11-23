function wjn_rsmeg_create_rscoh_maps(p)

lp = length(p);
if isnumeric(p)
   np = p;
   clear p;
end
root = wjn_rsmeg_list('root');
mkdir(fullfile(root,'rscohmaps'));

for a =1:lp
    if exist('np','var')
        p{a} = wjn_rsmeg_list(np(a));
    end
   
    rscohmapfolder = fullfile(root,'rscohmaps',p{a}.id);
    mkdir(rscohmapfolder)
    cd(rscohmapfolder)
    pairs = wjn_rsmeg_list(a,'rscohmappairs');
    for b = 1:size(pairs,1)
        spm_imcalc(pairs(b,1:2),pairs{b,3},'i1.*i2');
    end
    cd(root);
end
        
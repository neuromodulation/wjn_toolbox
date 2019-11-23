function chk=wjn_rsmeg_extract_lfp_source_activity(p)

lp = length(p);
if isnumeric(p)
   np = p;
   clear p;
end
root = wjn_rsmeg_list('root');
mkdir(fullfile(root,'lfp_source_extraction'));

for a =1:lp
    if exist('np','var')
        p{a} = wjn_rsmeg_list(np(a));
    end
    if isempty(p{a}.coords_right) && isempty(p{a}.coords_left)
        chk = 0;
        continue
    else
    lfpsexfolder = fullfile(root,'lfp_source_extraction');
    mkdir(lfpsexfolder)
    cd(lfpsexfolder)
    D=wjn_sl(p{a}.megfile);
    D=chantype(D,ci('LFP',D.chanlabels),'LFP');
    save(D);

    [amni,anames]=wjn_mni_list;
    sLFP = [{'sLFP_R','sLFP_L'} anames(1:4)];
    mni = [nanmean(p{a}.coords_right);nanmean(p{a}.coords_left);amni(1:4,:)];
    
    D=wjn_meg_source_extraction(D.fullfile,mni,sLFP,15);
    D.mni = mni;
    D.target = p{a}.target;
    save(D);
    D.move(fullfile(lfpsexfolder,[p{a}.target '_' D.fname]))
    chk = 1;
    cd(root);
    end
end
        
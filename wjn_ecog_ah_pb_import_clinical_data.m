function D = wjn_ecog_ah_pb_import_clinical_data(filename)

D=wjn_sl(filename);

tbl = readtable(fullfile(getsystem,'ECOG_grip_force_table.xlsx'));


id = D.id(1:2);

%%
try
    i = ci(id,tbl.ahmads_id);
catch
    i = ci(id,tbl.old_id);
end
ntbl = tbl(i,:);
D.clinical_info.tbl = tbl;
D.clinical_info.ntbl = ntbl;
if ntbl.diag == 2
    updrs_vars = channel_finder('updrs',ntbl.Properties.VariableNames);
    for  a= 1:12
        str = stringsplit(updrs_vars{a},'_');
        D.updrs.([str{2} '_' str{3}]) = ntbl.(updrs_vars{a});
    end

    if strcmp(D.hemisphere(1),'L')
        D.updrs.hemiupdrs = ntbl.updrs_off_r_hem;
        D.updrs.hemiupdrs_nt = ntbl.updrs_off_r_hem_notremor;
        D.updrs.hemiupdrs_ue_nt = ntbl.updrs_off_r_hem_ue_notremor;
        D.updrs.hemiupdrs_on = ntbl.updrs_on_r_hem;
        D.updrs.phemiupdrs = wjn_pct_change(D.updrs.hemiupdrs,D.updrs.hemiupdrs_on);
    elseif strcmp(D.hemisphere(1),'R')
        D.updrs.hemiupdrs = ntbl.updrs_off_l_hem;
        D.updrs.hemiupdrs_nt = ntbl.updrs_off_l_hem_notremor;
        D.updrs.hemiupdrs_ue_nt = ntbl.updrs_off_l_ul_notremor;
        D.updrs.hemiupdrs_on = ntbl.updrs_on_l_hem;
        D.updrs.phemiupdrs = wjn_pct_change(D.updrs.hemiupdrs,D.updrs.hemiupdrs_on);
    end
    
end




save(D)

function wjn_ecog_pb_add_updrs(filename)
load updrs_scores.mat

D = wjn_sl(filename);

i = ci(D.id

    D.age = 67;
    D.gender = M;
    D.mmse = 29;
    D.updrs.off = 42;
    D.updrs.on = 20;
    D.updrs.pudrs = wjn_pct_change(D.updrs_off,D.updrs_on);
    if strcmp(D.hemisphere(1),'L')
        D.updrs.rigidity = 1 + 2 ;
        D.updrs.bradykinesia = 2 + 2 + 2 + 1 + 2;
        
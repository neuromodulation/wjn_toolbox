function D=wjn_average(filename,robust)

S = [];
S.D = filename;
if ~robust
    S.robust = 0;
else
    S.robust.savew=0;
    S.robust.bycondition =1;
    S.robust.ks = 3;
    S.robust.removebad = 1;
%     S.prefix = 'ra';
end

D=spm_eeg_average(S);
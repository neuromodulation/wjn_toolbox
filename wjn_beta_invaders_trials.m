function D=wjn_beta_invaders_trials(filename)

D=spm_eeg_load(filename);
if numel(size(D)) == 3;
trl = D.trl;
bad_trials = D.badtrials;
ntrl = trl;
ntrl(D.badtrials,:) = [];
D.ntrl = ntrl;
D=wjn_remove_bad_trials(D.fullfile);
D.bad_trials = bad_trials;
else
    ntrl = D.trl;
    ntrl(D.bad_trials,:) = [];
    D.ntrl = ntrl;
end
D.istair = find(ntrl(:,13));
ibpleft = find(ntrl(:,8)==1);
ibpright = find(ntrl(:,8)==2);
D.ibtnleft = ibpleft;
D.ibtnright = ibpright;
D.ntrl = ntrl;
D.rt = ntrl(:,7);
D.ibtn = D.indtrial('btn');
D.icrash = D.indtrial('crash');
D.rtbtn = ntrl(D.ibtn,7);

D.btnside = ntrl(:,8);

D.islow = find(ntrl(:,10)==1);
D.imedium = find(ntrl(:,10)==2);
D.ifast = find(ntrl(:,10)==3);

D.ibtnfast = D.ifast(ismember(D.ifast,D.ibtn));
D.ibtnmedium = D.imedium(ismember(D.imedium,D.ibtn));
D.ibtnslow = D.islow(ismember(D.islow,D.ibtn));

D.rtbtnslow = D.rt(D.ibtnslow);
D.rtbtnmedium = D.rt(D.ibtnmedium);
D.rtbtnfast = D.rt(D.ibtnfast);

D.istairbtn = D.ibtn(find(D.ibtn>=D.istair(1)));
D.rtstair = ntrl(D.istair,7);
D.rtbtnstair = ntrl(D.istairbtn,7);

D.reward = ntrl(:,4);
D.rewardbtn = ntrl(D.ibtn,4);
D.speed = ntrl(:,5);
D.speedbtn = ntrl(D.ibtn,5);


save(D)
D=wjn_remove_bad_channels(D.fullfile);
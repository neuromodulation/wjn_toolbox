function wjn_spm2ft_tf_lfp(D)

d = D.ftraw(D.indchantype('LFP'))
nd = wjn_ft_multitaper(d,1:100);
rnd = wjn_ft_baseline(nd,[-1.5 -.5])
figure,imagesc(rnd.time,rnd.freq,squeeze(nanmean(rnd.powspctrm))),axis xy
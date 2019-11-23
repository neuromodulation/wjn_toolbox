function conn=wjn_raw_connectivity(d1,d2,fs)
%%
clear conn
data = [];
data.label = {'one','two'};
data.trial{1} = [d1;d2];
data.time{1} = linspace(1,length(d1)./fs,length(d1));
data.trialinfo = 1;
pre = {'','s'};
for a=1:2

cfg = [];
cfg.length    =1024/fs;
cfg.overlap  = .5;
cdata = ft_redefinetrial(cfg,data);

if a>1
    temp = cdata.trial{1}(2,:);
    cdata.trial{1}(2,:) = cdata.trial{end}(2,:);
    cdata.trial{end}(2,:) = temp;
end

cfg = [];
cfg.output ='fourier';
cfg.foi=[1:80];
cfg.keeptrials = 'yes';
cfg.keeptapers='yes';
cfg.taper = 'dpss';
cfg.pad = 'nextpow2';
cfg.tapsmofrq = 4;
cfg.padding = 2;
cfg.method  = 'mtmfft';
inp = ft_freqanalysis(cfg, cdata);
    
f = round(inp.freq);
inp.freq = f;
conn.f = f;
conn.([pre{a} 'pow']) = squeeze(nanmean(abs(inp.fourierspctrm)));

cfg = [];
cfg.method  = 'coh';
coh = ft_connectivityanalysis(cfg, inp);
conn.([pre{a} 'coh']) = squeeze(coh.cohspctrm(1,2,:))';

cfg = [];
cfg.method  = 'coh';
cfg.complex = 'imag';
icoh = ft_connectivityanalysis(cfg, inp);
conn.([pre{a} 'icoh']) = squeeze([icoh.cohspctrm(1,2,:);icoh.cohspctrm(2,1,:)]);
conn.([pre{a} 'absicoh']) = abs(squeeze(icoh.cohspctrm(1,2,:)))';

cfg =[];
cfg.method = 'wpli';
cfg.debias=1;
wpli = ft_connectivityanalysis(cfg,inp);
conn.([pre{a} 'wpli']) = squeeze([wpli.wplispctrm(1,2,:);wpli.wplispctrm(2,1,:)]);

cfg=[];
cfg.method = 'granger';
g = ft_connectivityanalysis(cfg, inp);
conn.([pre{a} 'granger']) = squeeze([g.grangerspctrm(1,2,:);g.grangerspctrm(2,1,:)]);
end


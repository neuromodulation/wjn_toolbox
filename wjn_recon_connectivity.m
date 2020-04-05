function [D,COH] = wjn_recon_connectivity(filename)

disp('COMPUTE CONNECTIVITY.')

try
    D=spm_eeg_load(filename);
catch
    D=filename;
end
try
    COH = D.COH;
catch
    [D,COH]=wjn_recon_power(D);
end
    

data = D.ftraw(0);
cfg            = [];
cfg.continuous = 'yes';
cfg.lpfilter='yes';
cfg.lpfreq = D.fsample/2.5;
data           = ft_preprocessing(cfg,data);

cfg         = [];
cfg.length  = 2;
cfg.overlap = 0.5;
data        = ft_redefinetrial(cfg, data);


cfg =[];
cfg.method = 'mtmfft';
cfg.output = 'powandcsd';
cfg.taper = 'dpss';
cfg.tapsmofrq=2;
cfg.output ='powandcsd';
cfg.keeptrials = 'yes';
cfg.keeptapers='no';
cfg.pad = 'nextpow2';
cfg.padding = 1;
inp = ft_freqanalysis(cfg,data);

cfg1 = [];
cfg1.method = 'coh';
coh = ft_connectivityanalysis(cfg1, inp);
cfg2 = cfg1;
cfg2.complex = 'imag';
icoh = ft_connectivityanalysis(cfg2, inp);
cfg3=[];
cfg3.method = 'wpli_debiased';
wpli = ft_connectivityanalysis(cfg3, inp);
cfg4=[];
cfg4.method = 'plv';
plv = ft_connectivityanalysis(cfg4, inp);


for a = 1:size(coh.cohspctrm,1)
    cohZ(a,:) = 0.5*log((1+coh.cohspctrm(a,:))./(1-coh.cohspctrm(a,:)));
    icohZ(a,:) = 0.5*log((1+abs(icoh.cohspctrm(a,:)))./(1-abs(icoh.cohspctrm(a,:))));
end


odata = data;
rdata = data;

for a =1:length(rdata.trial)
    rdata.trial{a} = rdata.trial{a}(:, end:-1:1);
end
bdata = {odata, rdata};

stat=[];
inp =[];
for i = 1:numel(bdata)
    
    cfg = [];
    cfg.output ='fourier';
    cfg.keeptrials = 'yes';
    cfg.keeptapers='yes';
    cfg.taper = 'dpss';
    cfg.tapsmofrq=1;
    cfg.pad = 'nextpow2';
    cfg.padding = 2;
    cfg.method          = 'mtmfft';
    inp{i} = ft_freqanalysis(cfg, bdata{i});
    
    
    
    cfg=[];
    cfg.method = 'granger';
    stat{i} = ft_connectivityanalysis(cfg, inp{i});
    
    
end

COH.wpli=wpli.wpli_debiasedspctrm;
COH.plv = plv.plvspctrm;
COH.coh = coh.cohspctrm;
COH.icoh = abs(icoh.cohspctrm);
COH.icohZ = icohZ;
COH.cohZ = cohZ;
COH.chancomb = coh.labelcmb;
COH.granger = stat{1}.grangerspctrm;
COH.rgranger = stat{2}.grangerspctrm;
COH.rcgranger = stat{1}.grangerspctrm-stat{2}.grangerspctrm;
for a = 1:size(COH.chancomb,1)
    COH.ccgranger(a,:) = COH.rcgranger(ci(COH.chancomb{a,1},COH.channels,1),ci(COH.chancomb{a,2},COH.channels,1),:)-COH.rcgranger(ci(COH.chancomb{a,2},COH.channels,1),ci(COH.chancomb{a,1},COH.channels,1),:);
end
COH.cchannels = strcat(COH.chancomb(:,1),'__',COH.chancomb(:,2));
D.COH =COH;
save(D)
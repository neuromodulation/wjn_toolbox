function COH = wjn_rest(filename,granger_analysis,cfc_analysis,flow,fhigh)

normfreq = [3 47; 53 97];

if ~exist('granger_analysis','var')
    granger_analysis=0;
end
if ~exist('cfc','var')
    cfc_analysis = 0;
end

try
    D=spm_eeg_load(filename);
catch
    D=wjn_spikeconvert(filename,2.048,.5,1);
end
    
if strcmp(unique(D.chantype),'Other')
    D=wjn_fix_chantype(D.fullfile);
end

if strcmp(D.type,'continuous')
    D=wjn_epoch(D.fullfile,2);
end

data = D.ftraw(0);
cfg =[];
data=ft_preprocessing(cfg,data);
Ntrials = D.ntrials;

cfg.method = 'mtmfft';
cfg.output = 'pow';
cfg.taper = 'dpss';
cfg.tapsmofrq=2;
cfg.keeptrials = 'yes';
cfg.keeptapers='no';
cfg.pad = 'nextpow2';
cfg.padding = 2;
inp = ft_freqanalysis(cfg,data);

pow = inp.powspctrm;
pow(:,:,wjn_sc(inp.freq,normfreq(1,2)):wjn_sc(inp.freq,normfreq(2,1))) = 0;
mpow = squeeze(nanmean(pow,1));
if size(mpow,1)>size(mpow,2)
    mpow = mpow';
end
sump = nansum(mpow(:,searchclosest(inp.freq,normfreq(1,1)):searchclosest(inp.freq,normfreq(2,2))),2);
stdp = nanstd(mpow(:,searchclosest(inp.freq,normfreq(1,1)):searchclosest(inp.freq,normfreq(2,2))),[],2);
logfit = fftlogfitter(inp.freq',mpow')';

for a=1:size(mpow,1)
    rpow(a,:) = (mpow(a,:)./sump(a)).*100;
    spow(a,:) = (mpow(a,:)./stdp(a));
    for b = 1:size(pow,1)
        for c = 1:size(pow,3)
            srpow(a,c) = pow(b,a,c)/sum(pow(b,a,searchclosest(inp.freq,normfreq(1,1)):searchclosest(inp.freq,normfreq(2,2))))*100; 
        end
    end
end


fname = D.fname;
COH = [];
COH.name = fname(1:length(fname)-4);
COH.dir = cd;
fnsave = ['COH_' strrep(D.condlist{1},' ','_') '_' fname];
COH.fname = fnsave;
COH.fs = D.fsample;
COH.condition = D.condlist;
COH.chantype = D.chantype;
COH.badchannels = D.badchannels;
COH.nseg = Ntrials;
COH.tseg = D.nsamples/D.fsample;
COH.time = linspace(0,COH.tseg*COH.nseg,COH.nseg);
COH.channels = inp.label;
COH.f = inp.freq;
COH.freq = [inp.freq(1) inp.freq(2)];

COH.rpow = rpow;
COH.spow = spow;
COH.srpow = srpow;
COH.logfit = logfit;
COH.pow = permute(pow,[2,3,1]);
COH.mpow = mpow;



if D.nchannels>1
cfg =[];
cfg.method = 'mtmfft';
cfg.output = 'powandcsd';
cfg.taper = 'dpss';
cfg.tapsmofrq=2;
cfg.output ='powandcsd';
cfg.keeptrials = 'yes';
cfg.keeptapers='no';
cfg.pad = 'nextpow2';
cfg.padding = 2;
inp = ft_freqanalysis(cfg,data);

cfg1 = [];
cfg1.method = 'coh';
coh = ft_connectivityanalysis(cfg1, inp);
cfg2 = cfg1;
cfg2.complex = 'imag';
icoh = ft_connectivityanalysis(cfg2, inp);


shift=randi(Ntrials,[1,Ntrials]);
scoh=coh;
scoh.cohspctrm=zeros(size(scoh.cohspctrm));
for c=1:length(data.label)
    sdata=data;
    tr = data.trial(shift);
    for nt =1:numel(tr)
    sdata.trial{nt}(c,:)=tr{nt}(c,:);
    end
    cfg.channelcmb = {data.label{c}, 'all'};
    inp = ft_freqanalysis(cfg, sdata);
    sscoh = ft_connectivityanalysis(cfg1, inp);
    for i=1:size(sscoh.labelcmb, 1)
        ind=[intersect(strmatch(sscoh.labelcmb(i,1),scoh.labelcmb(:,1),'exact'), ...
            strmatch(sscoh.labelcmb(i,2),scoh.labelcmb(:,2),'exact'))...
            intersect(strmatch(sscoh.labelcmb(i,1),scoh.labelcmb(:,2),'exact'), ...
            strmatch(sscoh.labelcmb(i,2),scoh.labelcmb(:,1),'exact'))];
        scoh.cohspctrm(ind, :)=sscoh.cohspctrm(i, :);
    end
end
clear sdata sicoh ssicoh
sicoh=scoh;
sicoh.cohspctrm=zeros(size(scoh.cohspctrm));
for c=1:length(data.label)
    sdata=data;
    tr = data.trial(shift);
    for nt =1:numel(tr)
    sdata.trial{nt}(c,:)=tr{nt}(c,:);
    end
    cfg.channelcmb = {data.label{c}, 'all'};
    inp = ft_freqanalysis(cfg, sdata);
    ssicoh = ft_connectivityanalysis(cfg2, inp);
    for i=1:size(ssicoh.labelcmb, 1)
        ind=[intersect(strmatch(ssicoh.labelcmb(i,1),sicoh.labelcmb(:,1),'exact'), ...
            strmatch(ssicoh.labelcmb(i,2),sicoh.labelcmb(:,2),'exact'))...
            intersect(strmatch(ssicoh.labelcmb(i,1),sicoh.labelcmb(:,2),'exact'), ...
            strmatch(ssicoh.labelcmb(i,2),sicoh.labelcmb(:,1),'exact'))];
        sicoh.cohspctrm(ind, :)=ssicoh.cohspctrm(i, :);
    end
end

cfg3 = cfg1;
cfg3.method = 'wpli_debiased';

shift=randi(Ntrials,[1,Ntrials]);
swpli=coh;
scoh.cohspctrm=zeros(size(scoh.cohspctrm));
for c=1:length(data.label)
    sdata=data;
    tr = data.trial(shift);
    for nt =1:numel(tr)
    sdata.trial{nt}(c,:)=tr{nt}(c,:);
    end
    cfg.channelcmb = {data.label{c}, 'all'};
    inp = ft_freqanalysis(cfg, sdata);
    sscoh = ft_connectivityanalysis(cfg1, inp);
    for i=1:size(sscoh.labelcmb, 1)
        ind=[intersect(strmatch(sscoh.labelcmb(i,1),scoh.labelcmb(:,1),'exact'), ...
            strmatch(sscoh.labelcmb(i,2),scoh.labelcmb(:,2),'exact'))...
            intersect(strmatch(sscoh.labelcmb(i,1),scoh.labelcmb(:,2),'exact'), ...
            strmatch(sscoh.labelcmb(i,2),scoh.labelcmb(:,1),'exact'))];
        scoh.cohspctrm(ind, :)=sscoh.cohspctrm(i, :);
    end
end



for a = 1:size(coh.cohspctrm,1)
    cohZ(a,:) = 0.5*log((1+coh.cohspctrm(a,:))./(1-coh.cohspctrm(a,:)));
    seZ(a,:) = 0.5*log((1+scoh.cohspctrm(a,:))./(1-scoh.cohspctrm(a,:)));
   icohZ(a,:) = 0.5*log((1+abs(icoh.cohspctrm(a,:)))./(1-abs(icoh.cohspctrm(a,:))));
   sicohZ(a,:) = 0.5*log((1+abs(sicoh.cohspctrm(a,:)))./(1-abs(sicoh.cohspctrm(a,:))));
end


pval=1-(0.05)^(1/(1*(Ntrials*1000)-1));

for a=1:length(COH.channels)
    rtf(a,:,:) = bsxfun(@rdivide,...
    bsxfun(@minus,...
    squeeze(COH.pow(3,:,:))',...
    squeeze(nanmean(COH.pow(3,:,:),3))),...
    nanmean(squeeze(COH.pow(3,:,:))')).*100;
end



COH.coh = coh.cohspctrm;
COH.icoh = abs(icoh.cohspctrm);
COH.icohZ = icohZ;
COH.sicohZ = sicohZ;
COH.cohZ = cohZ;
COH.p_halliday = pval;
COH.scoh = scoh.cohspctrm;
COH.scohZ = seZ;
COH.sicoh = abs(sicoh.cohspctrm);

COH.chancomb = coh.labelcmb;


if granger_analysis


clear inp coh icoh stat
odata = D.ftraw(0); 
rdata = odata(:,1:end);
rdata.trial = rdata.trial(:, :, end:-1:1);
data = {odata, rdata};

for i = 1:numel(data)
    
    cfg = [];
    cfg.output ='fourier';
    cfg.keeptrials = 'yes';
    cfg.keeptapers='yes';
    cfg.taper = 'dpss';
    cfg.tapsmofrq=2;
    cfg.pad = 'nextpow2';
    cfg.padding = 2;
    cfg.method          = 'mtmfft';
    inp{i} = ft_freqanalysis(cfg, data{i});
    %
    cfg1 = [];
    cfg1.method  = 'coh';
    coh{i} = ft_connectivityanalysis(cfg1, inp{i});
    %
    cfg2=cfg1;
    cfg2.method = 'granger';
%     cfg.
    stat{i} = ft_connectivityanalysis(cfg2, inp{i});
    
    
end

Ntrials = size(odata.trial,1);
shift=[2:Ntrials 1];
scoh=coh{1};
scoh.cohspctrm=zeros(size(scoh.cohspctrm));
sgr = stat{1};
sgr.grangerspctrm = zeros(size(sgr.grangerspctrm));
% 
% for c=1:length(odata.label)              
%                 sdata=odata;
%                 sdata.trial(:,c,:)=odata.trial(shift,c,:);
%                 cfg.channelcmb = {odata.label{c}, 'all'};
%                 sinp = ft_freqanalysis(cfg, sdata);
%                 ssgr = ft_connectivityanalysis(cfg2, sinp);                
%                 sgr.grangerspctrm(c,:,:) = ssgr.grangerspctrm(c,:,:);             
% end


COH.rcoh = coh{2}.cohspctrm;
% G.scoh = scoh.cohspctrm;
%COH.sgranger = sgr.grangerspctrm;
COH.granger = stat{1}.grangerspctrm;
COH.rgranger = stat{2}.grangerspctrm;
COH.grangerchannelcmb = stat{1}.label;
COH.gf = stat{1}.freq;

end
end

% keyboard

if cfc_analysis
D=wjn_cfc(D.fullfile,[],flow,fhigh);
COH.fpac = [flow;fhigh];
COH.pac = squeeze(D(:,:,:,1));
COH.ppac = squeeze(D.p(:,:,:,1));
COH.f1 = D.f1;
COH.f2 = D.f2;
end
  

    save(fnsave,'COH');
end
  






function [D,SPW,T]=wjn_recon_spw(filename,prominence)
disp('RECONSTRUCT WAVEFORM FEATURES.')

if ~exist('prominence','var')
    prominence = 1.96;
end


D=spm_eeg_load(filename);

D=wjn_remove_empty_channels(D.fullfile);

SPW=[];
chs = 1:D.nchannels;
alltimes=[];
allconds=[];
mssamples = round(2*round(D.fsample/1000));
runs = {'peak','trough'};
T=table;
if isfield(D,'SPW')
    D=rmfield(D,'SPW');
end
iev = round(0.125*D.fsample);
ish = round(0.006.*D.fsample);
for nrun = 1:2
    for a = 1:D.nchannels
        
        keep('ish','iev','save_to_D','prominence','T','runs','nrun','a','filename','D','SPW','filtfreq','chs','alltimes','allconds','mssamples')
        data=D(a,:);
        data(data==0)=nan;
        good = ~isnan(data);
        if nrun == 1
            data(good) = -zscore(data(good));
        else
            data(good) = zscore(data(good));
        end
        
        
        [i,~,~,m]=wjn_raw_spw(data,prominence);
        
        irm= [find(i(D.time(i)<1)),find(D.time(i)>(D.time(D.nsamples)-1))];
        i(irm)=[];
        n=0;
        dd=nan(1,length(i)-1);
        vtrough = dd;dpost=dd;ni=dd;vpre=dd;tdecay=dd;vdecay=dd;ppre=dd;
        dpre=dd;nipre=dd;vpost=dd;trise=dd;ppost=dd;vrise=dd;nipost=dd;pfull=dd;tfull=dd;dmean=dd;
        wv=nan(length(i)-1,length(-iev-1:iev));sharpness=dd;risesteepness=dd;
        decaysteepness=dd;sloperatio=dd;risedecayasymmetry=dd;
        for b = 2:length(i)-1
            n=n+1;
            cci=i(b);
            pci=cci-mssamples:cci+mssamples;
            [m(b),hfi] = max(data(pci));
            cci = cci+hfi-mssamples-1;
            vtrough(n) = -m(b);
            i(b)=cci;
            ni(n)=cci;
            
            dpre(n) = (cci-i(b-1))./D.fsample*1000;
            dpost(n) = (i(b+1)-cci)./D.fsample*1000;
            
            t0 = 1000*D.time(cci);
            
            if cci>D.fsample && cci<D.nsamples-D.fsample
                cclimp = D.fsample;
                cclimn = D.fsample;
            elseif cci<D.fsample
                cclimn =cci-1;
                cclimp = D.fsample;
            else
                cclimn=D.fsample-1;
                cclimp = D.nsamples-cci-1;
            end
            
            nin = cci-1:-1:cci-cclimn;
            [fmin,fin]=findpeaks(-data(nin),'Npeaks',1);
            if isempty(fin)
                [~,fin]=min(data(nin));
            end
            pci=nin(fin)-mssamples:nin(fin)+mssamples;
            pci(pci>=cci)=[];
            [minn,in] = min(data(pci));
            cin=pci(in);
            vpre(n)= -minn;
            tdecay(n) = t0-D.time(cin)*1000;
            ppre(n) = -minn-vtrough(n);
            vdecay(n) = ppre(n)/tdecay(n);
            nipre(n) = cin;
            
            
            nip = cci+1:cci+cclimp;
            [~,fip]=findpeaks(-data(nip),'Npeaks',1);
            if isempty(fip)
                [~,fip]=min(data(nip));
            end
            pci=nip(fip)-mssamples:nip(fip)+mssamples;
            pci(pci<=cci)=[];
            [mip,ip] = min(data(pci));
            cip=pci(ip);
            vpost(n) = -mip;
            trise(n) = D.time(cip)*1000-t0;
            ppost(n) = -mip-vtrough(n);
            vrise(n) = ppost(n)/trise(n);
            nipost(n) = cip;
            
            pfull(n) = ppre(n)+ppost(n);
            tfull(n) = tdecay(n)+trise(n);
            dmean(n) = (dpre(n)+dpost(n))/2;
            wv(n,:) = data(cci-iev-1:cci+iev);
            
            sharpness(n) = data(cci)-nanmean(data([cci-ish:cci-1 cci+1:cci+ish]));
            risesteepness(n) = max(diff(data(cin:cci)));
            decaysteepness(n) = -min(diff(data(cci:cip)));
            sloperatio(n) = risesteepness(n)-decaysteepness(n);
            risedecayasymmetry(n) = trise(n)/tfull(n);
            
            if ismember(n,1000:1000:1000000)
                disp(['SPW N=' num2str(n) '/' num2str(length(i)-2) ' CH=' num2str(a) '/' num2str(length(chs))])
            end
        end
        
        
        
        
        SPW(a).i=ni(1:n)';
        SPW(a).ipre=nipre(1:n)';
        SPW(a).ipost=nipost(1:n)';
        SPW(a).Tpeak = D.time(ni(1:n))';
        SPW(a).Tpre = D.time(nipre(1:n))';
        SPW(a).Tpost = D.time(nipost(1:n))';
        SPW(a).Tfull = tfull(1:n)';
        SPW(a).Tdecay = tdecay(1:n)';
        SPW(a).Trise = trise(1:n)';
        SPW(a).Tasymmetry = trise(1:n)'./tdecay(1:n)';
        SPW(a).Trisedecayasymmetry = risedecayasymmetry(1:n)';
        
        SPW(a).Vmax = vtrough(1:n)';
        SPW(a).Vpre = vpre(1:n)';
        SPW(a).Vpost = vpost(1:n)';
        SPW(a).Vasymmetry = vtrough(1:n)'./(vpre(1:n)'+vpost(1:n)');
        
        SPW(a).Vsharpness = sharpness(1:n)';
        SPW(a).Vrisesteepness = risesteepness(1:n)';
        SPW(a).Vdecaysteepness = decaysteepness(1:n)';
        SPW(a).Vsloperatio = sloperatio(1:n)';
        
        SPW(a).VTdecay = vdecay(1:n)';
        SPW(a).VTrise = vrise(1:n)';
        SPW(a).VTrisedecayasymmetry = abs(vdecay(1:n)')./(abs(vdecay(1:n))'+abs(vrise(1:n)'));
        
        SPW(a).Pfull = pfull(1:n)';
        SPW(a).Ppre = ppre(1:n)';
        SPW(a).Ppost = ppost(1:n)';
        SPW(a).Pasymmetry = vtrough(1:n)'/nansum([vpre(1:n),vpost(1:n)]');
        
        SPW(a).Imean=dmean(1:n)';
        SPW(a).Ipre = dpre(1:n)';
        SPW(a).Ipost = dpost(1:n)';
        SPW(a).Channel = repmat(D.chanlabels(chs(a)),size(ni(1:n)))';
        SPW(a).Phase = repmat(runs(nrun),size(ni(1:n)))';
        SPW(a).cond = repmat({['SPW_' runs{nrun} '_' D.chanlabels{chs(a)}]},size(ni(1:n)))';
        SPW(a).prec_cond = strcat({[D.chanlabels{chs(a)} '_' runs{nrun}] },num2str([1:length(ni(1:n))]'));
        
    end
    D.SPW.(runs{nrun}) =SPW;
end

for a = 1:D.nchannels

    s = [nanmean(D.SPW.(runs{1})(a).Vsharpness) nanmean(D.SPW.(runs{2})(a).Vsharpness)];
    SR= log(nanmax([s(1)./s(2),s(2)./s(1)]));
    if SR>0.1 && s(1)>s(2)
        D(a,:,:)=-1.*D(a,:,:);
        run1 = D.SPW.(runs{2})(a);
        run2 = D.SPW.(runs{1})(a);
        run1.cond = strrep(D.SPW.(runs{2})(a).cond,runs{2},runs{1});
        run2.cond = strrep(D.SPW.(runs{1})(a).cond,runs{1},runs{2});
        D.SPW.(runs{1})(a)=run1;
        D.SPW.(runs{2})(a)=run2;
        D.SPW.inverted(a)=1;
    else
        D.SPW.inverted(a)=0;
    end
    
    D.SPW.results.N(a,:) = [numel(D.SPW.(runs{2})(a).i) numel(D.SPW.(runs{1})(a).i)];
    D.SPW.results.Nr(a,:) = D.SPW.results.N(a,:)./max(D.time);
    
    D.SPW.results.Vasymmetry(a,1)=nanmean(D.SPW.(runs{1})(a).Vmax)-nanmean(D.SPW.(runs{2})(a).Vmax);
    D.SPW.results.Pasymmetry(a,1)=nanmean(D.SPW.(runs{2})(a).Pfull)-nanmean(D.SPW.(runs{1})(a).Pfull);
    D.SPW.results.STDasymmetry(a,1)=nanstd(D.SPW.(runs{2})(a).Pfull)-nanstd(D.SPW.(runs{1})(a).Pfull);
    D.SPW.results.Tasymmetry(a,1)=nanmean(D.SPW.(runs{1})(a).Tfull)-nanmean(D.SPW.(runs{2})(a).Tfull);
    D.SPW.results.Tfull(a,:) = [nanmean(D.SPW.(runs{2})(a).Tfull) nanmean(D.SPW.(runs{1})(a).Tfull)];
    D.SPW.results.Tdecay(a,:) = [nanmean(D.SPW.(runs{2})(a).Tdecay) nanmean(D.SPW.(runs{1})(a).Tdecay)];
    D.SPW.results.Trise(a,:) = [nanmean(D.SPW.(runs{2})(a).Trise) nanmean(D.SPW.(runs{1})(a).Trise)];
    D.SPW.results.Pfull(a,:) = [nanmean(D.SPW.(runs{2})(a).Pfull) nanmean(D.SPW.(runs{1})(a).Pfull)];
    D.SPW.results.Imean(a,:) = [nanmean(D.SPW.(runs{2})(a).Imean) nanmean(D.SPW.(runs{1})(a).Imean)];
    D.SPW.results.Vsharpness(a,:) =  [nanmean(D.SPW.(runs{2})(a).Vsharpness) nanmean(D.SPW.(runs{1})(a).Vsharpness)];
    D.SPW.results.Vrisesteepness(a,:) =  [nanmean(D.SPW.(runs{2})(a).Vrisesteepness) nanmean(D.SPW.(runs{1})(a).Vrisesteepness)];
    D.SPW.results.Vdecaysteepness(a,:) =  [nanmean(D.SPW.(runs{2})(a).Vdecaysteepness) nanmean(D.SPW.(runs{1})(a).Vdecaysteepness)];
    D.SPW.results.Trisedecayasymmetry(a,:) =  [nanmean(D.SPW.(runs{2})(a).Trisedecayasymmetry) nanmean(D.SPW.(runs{1})(a).Trisedecayasymmetry)];
    D.SPW.results.Vsharpnessratio(a,:) = log(nanmax([D.SPW.results.Vsharpness(a,1)./D.SPW.results.Vsharpness(a,2),D.SPW.results.Vsharpness(a,2)./D.SPW.results.Vsharpness(a,1)]));
    D.SPW.results.Vsloperatio(a,:) = [nanmean(D.SPW.(runs{2})(a).Vsloperatio) nanmean(D.SPW.(runs{1})(a).Vsloperatio)];
    
    alltimes=[alltimes;D.time(D.SPW.(runs{2})(a).i)';D.time(D.SPW.(runs{1})(a).i)'];
    allconds = [allconds;D.SPW.(runs{2})(a).cond;D.SPW.(runs{1})(a).cond];
    
    T=[T;struct2table(D.SPW.(runs{2})(a));struct2table(D.SPW.(runs{1})(a))];
end

D.SPW.alltimes=alltimes;
D.SPW.allconds = allconds;
T=T(:,[end-3 end-2 8:end-5]);



trl = D.indsample(alltimes);
conds = allconds;
uconds = unique(allconds);
seg = [-iev:iev];
nseg = seg(end:-1:1);
tspw = linspace(-125,125,length(seg));
d=D(:,:);
ppwavg=ones(D.nchannels,length(seg),length(uconds));
spwavg=ppwavg;
pprwavg=ppwavg;
ttwavg=ppwavg;
ttrwavg=ttwavg;
tic
for a = 1:length(uconds)
    ic=ci(uconds{a},conds,1);
    it=trl(ic);
    
    
    for b = 1:length(seg)
        
        spwavg(:,b,a)=nanmean(d(:,it+seg(b)),2);
        ishuffle=randi(D.nsamples,size(it));
        [~,ppwavg(:,b,a),~,statss]=ttest(d(:,it+seg(b))',d(:,ishuffle)');
        [~,pprwavg(:,b,a),~,statsn]=ttest(d(:,it+seg(b))',d(:,it+nseg(b))');
        ttwavg(:,b,a)=statss.tstat;
        ttrwavg(:,b,a)=statsn.tstat;
    end
    disp([num2str(a) '/' num2str(length(uconds))])
end
toc



D.SPW.avg.p = ppwavg;
D.SPW.avg.reverse_p = pprwavg;
D.SPW.avg.reverse_tvalue = ttrwavg;
D.SPW.avg.tvalue=ttwavg;
D.SPW.avg.data = spwavg;
D.SPW.avg.rdata = spwavg-spwavg(:,end:-1:end,:);
D.SPW.avg.conditions = uconds;
D.SPW.avg.time = tspw;
D.SPW.chanlabels = D.chanlabels;
D.SPW.fsample = D.fsample;
D.SPW.prominence = prominence;
D.SPW = wjn_recon_spwpeaks(D.SPW);
SPW = D.SPW;






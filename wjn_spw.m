function [D,spw]=wjn_spw(filename,prominence,save_to_D)

if ~exist('prominence')
    prominence = 1.96;
end

if ~exist('save_to_D','var')
    save_to_D=1;
end

D=spm_eeg_load(filename);

iempty = D.chanlabels(find(sum(D(:,:)')==0));
if ~isempty(iempty)
    disp('REMOVING EMPTY CHANNELS')
    D=wjn_remove_channels(D.fullfile,D.chanlabels(iempty));
end

spw=[];
chs = 1:D.nchannels;
alltimes=[];
allconds=[];
mssamples = round(2*round(D.fsample/1000));
runs = {'neg','pos'};
T=table;
if isfield(D,'spw')
    D=rmfield(D,'spw');
end
iev = round(0.125*D.fsample);
ish = round(0.006.*D.fsample);
for nrun = 1:2
    for a = 1:D.nchannels
        
        keep('ish','iev','save_to_D','prominence','T','runs','nrun','a','filename','D','spw','filtfreq','chs','alltimes','allconds','mssamples')
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
        
      
        
     
        spw(a).i=ni(1:n)';
        spw(a).ipre=nipre(1:n)';
        spw(a).ipost=nipost(1:n)';
        spw(a).Tpeak = D.time(ni(1:n))';
        spw(a).Tpre = D.time(nipre(1:n))';
        spw(a).Tpost = D.time(nipost(1:n))';
        spw(a).Tfull = tfull(1:n)';
        spw(a).Tdecay = tdecay(1:n)';
        spw(a).Trise = trise(1:n)';
        spw(a).Tasymmetry = trise(1:n)'./tdecay(1:n)';
        spw(a).Trisedecayasymmetry = risedecayasymmetry(1:n)';
        
        spw(a).Vmax = vtrough(1:n)';
        spw(a).Vpre = vpre(1:n)';
        spw(a).Vpost = vpost(1:n)';
        spw(a).Vasymmetry = vtrough(1:n)'./(vpre(1:n)'+vpost(1:n)');
        
        spw(a).Vsharpness = sharpness(1:n)';
        spw(a).Vrisesteepness = risesteepness(1:n)';
        spw(a).Vdecaysteepness = decaysteepness(1:n)';
        spw(a).Vsloperatio = sloperatio(1:n)';
        
        spw(a).VTdecay = vdecay(1:n)';
        spw(a).VTrise = vrise(1:n)';
        spw(a).VTrisedecayasymmetry = abs(vdecay(1:n)')./(abs(vdecay(1:n))'+abs(vrise(1:n)'));
        
        spw(a).Pfull = pfull(1:n)';
        spw(a).Ppre = ppre(1:n)';
        spw(a).Ppost = ppost(1:n)';
        spw(a).Pasymmetry = vtrough(1:n)'/nansum([vpre(1:n),vpost(1:n)]');
        
        spw(a).Imean=dmean(1:n)';
        spw(a).Ipre = dpre(1:n)';
        spw(a).Ipost = dpost(1:n)';
   
        spw(a).cond = repmat({['SPW_' runs{nrun} '_' D.chanlabels{chs(a)}]},size(ni(1:n)))';
        spw(a).prec_cond = strcat({[D.chanlabels{chs(a)} '_' runs{nrun}] },num2str([1:length(ni(1:n))]'));
        
    end  
    D.spw.(runs{nrun}) =spw;
end

%Pfull, Tfull, 
for a = 1:D.nchannels
    vasym = nanmean(D.spw.pos(a).Vmax)-nanmean(D.spw.neg(a).Vmax);
    if vasym<0
        D(a,:,:)=-1.*D(a,:,:);
        pos = D.spw.neg(a);
        neg = D.spw.pos(a);
        pos.cond = strrep(D.spw.neg(a).cond,'neg','pos');
        neg.cond = strrep(D.spw.pos(a).cond,'pos','neg');
        D.spw.pos(a)=pos;
        D.spw.neg(a)=neg;
        D.spw.inverted(a)=1;
    else
        D.spw.inverted(a)=0;
    end
    
    
    D.spw.results.N(a,:) = [numel(D.spw.neg(a).i) numel(D.spw.pos(a).i)];
    D.spw.results.Nr(a,:) = D.spw.results.N(a,:)./max(D.time);
    
    D.spw.results.Vasymmetry(a,1)=nanmean(D.spw.pos(a).Vmax)-nanmean(D.spw.neg(a).Vmax);
    D.spw.results.Pasymmetry(a,1)=nanmean(D.spw.neg(a).Pfull)-nanmean(D.spw.pos(a).Pfull);
    D.spw.results.STDasymmetry(a,1)=nanstd(D.spw.neg(a).Pfull)-nanstd(D.spw.pos(a).Pfull);
    D.spw.results.Tasymmetry(a,1)=nanmean(D.spw.pos(a).Tfull)-nanmean(D.spw.neg(a).Tfull);
    D.spw.results.Tfull(a,:) = [nanmean(D.spw.neg(a).Tfull) nanmean(D.spw.pos(a).Tfull)];
    D.spw.results.Tdecay(a,:) = [nanmean(D.spw.neg(a).Tdecay) nanmean(D.spw.pos(a).Tdecay)];
    D.spw.results.Trise(a,:) = [nanmean(D.spw.neg(a).Trise) nanmean(D.spw.pos(a).Trise)];
    D.spw.results.Pfull(a,:) = [nanmean(D.spw.neg(a).Pfull) nanmean(D.spw.pos(a).Pfull)];
    D.spw.results.Imean(a,:) = [nanmean(D.spw.neg(a).Imean) nanmean(D.spw.pos(a).Imean)];
    D.spw.results.Vsharpness(a,:) =  [nanmean(D.spw.neg(a).Vsharpness) nanmean(D.spw.pos(a).Vsharpness)];
    D.spw.results.Vrisesteepness(a,:) =  [nanmean(D.spw.neg(a).Vrisesteepness) nanmean(D.spw.pos(a).Vrisesteepness)];
    D.spw.results.Vdecaysteepness(a,:) =  [nanmean(D.spw.neg(a).Vdecaysteepness) nanmean(D.spw.pos(a).Vdecaysteepness)];
    D.spw.results.Trisedecayasymmetry(a,:) =  [nanmean(D.spw.neg(a).Trisedecayasymmetry) nanmean(D.spw.pos(a).Trisedecayasymmetry)];
    D.spw.results.Vsharpnessratio(a,:) = log(nanmax([D.spw.results.Vsharpness(a,1)./D.spw.results.Vsharpness(a,2),D.spw.results.Vsharpness(a,1)./D.spw.results.Vsharpness(a,2)]));
    D.spw.results.Vsloperatio(a,:) = [nanmean(D.spw.neg(a).Vsloperatio) nanmean(D.spw.pos(a).Vsloperatio)]; 
    
    alltimes=[alltimes;D.time(D.spw.neg(a).i)';D.time(D.spw.pos(a).i)'];
    allconds = [allconds;D.spw.neg(a).cond;D.spw.pos(a).cond];
    
    T=[T;struct2table(D.spw.neg(a));struct2table(D.spw.pos(a))];
end
D.spw.alltimes=alltimes;
D.spw.allconds = allconds;
D.spw.T=T;



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
    
     for a = 1:length(uconds)
        [peaks(:,a),delays(:,a)]=wjn_plot_spw(tspw,ttwavg(:,:,a),D.chanlabels,0);
     end
    
    D.spw.avg.p = ppwavg;
    D.spw.avg.reverse_p = pprwavg;
    D.spw.avg.reverse_tvalue = ttrwavg;
    D.spw.avg.tvalue=ttwavg;
    D.spw.avg.data = spwavg;
    D.spw.avg.rdata = spwavg-spwavg(:,end:-1:end,:);
    D.spw.avg.conditions = uconds;
    D.spw.avg.time = tspw;
    D.spw.avg.peaks = peaks;
    D.spw.avg.delays = delays; 
    D.spw.chanlabels = D.chanlabels;
    D.spw.fsample = D.fsample;
    D.spw.prominence = prominence;


   spw = D.spw;
   save(fullfile(D.path,['spw_' strrep(num2str(prominence),'.','-') D.fname]),'spw','T','-v7.3')


if save_to_D
    save(D)
end




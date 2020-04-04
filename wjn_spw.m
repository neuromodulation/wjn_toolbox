function [D,spw]=wjn_spw(filename,prominence,save_to_D)

if ~exist('prominence')
    prominence = 1.96;
end

if ~exist('save_to_D','var')
    save_to_D=1;
end

D=spm_eeg_load(filename);


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
for nrun = 1:2
    for a = 1:length(chs)
        
        keep('iev','save_to_D','prominence','T','runs','nrun','a','filename','D','spw','filtfreq','chs','alltimes','allconds','mssamples')
        data=D(chs(a),:);
        data(data==0)=nan;
        good = ~isnan(data);
        if nrun == 1
            data(good) = -zscore(data(good));
        else
            data(good) = zscore(data(good));
        end
         

        [i,w,p,m,d]=wjn_raw_spw(data,prominence);

        irm= [find(i(D.time(i)<1)),find(D.time(i)>(D.time(D.nsamples)-1))];
        i(irm)=[];w(irm)=[];p(irm)=[];d(irm)=[];
        n=0;
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
                [fmin,fin]=min(data(nin));
            end
            pci=nin(fin)-mssamples:nin(fin)+mssamples;
            [minn,in] = min(data(pci));
            cin=pci(in);
            vpre(n)= -minn;
            tdescent(n) = t0-D.time(cin)*1000;
            ppre(n) = -minn-vtrough(n);
            vdescent(n) = ppre(n)/tdescent(n);
            nipre(n) = cin;
         
            
            nip = cci+1:cci+cclimp;
            [fmip,fip]=findpeaks(-data(nip),'Npeaks',1);
            if isempty(fip)
                [fmip,fip]=min(data(nip));
            end
            pci=nip(fip)-mssamples:nip(fip)+mssamples;
            [mip,ip] = min(data(pci));
            cip=pci(ip);
            vpost(n) = -mip;
            trise(n) = D.time(cip)*1000-t0;
            ppost(n) = -mip-vtrough(n);
            vrise(n) = ppost(n)/trise(n);
            nipost(n) = cip;
            
            pfull(n) = ppre(n)+ppost(n);
            tfull(n) = tdescent(n)+trise(n);
            dmean(n) = (dpre(n)+dpost(n))/2;
            wv(n,:) = data(cci-iev-1:cci+iev);
            
            if ismember(n,1000:1000:1000000)
                disp(['SPW N=' num2str(n) '/' num2str(length(i)-2) ' CH=' num2str(a) '/' num2str(length(chs))])
            end
        end
        
        spw(a).wv=wv;
        spw(a).i=ni';
        spw(a).ipre=nipre';
        spw(a).ipost=nipost';
        spw(a).Tpeak = D.time(ni)';
        spw(a).Tpre = D.time(nipre)';
        spw(a).Tpost = D.time(nipost)';
        spw(a).Tfull = tfull';
        spw(a).Tdescent = tdescent';
        spw(a).Trise = trise';
        spw(a).Tasymmetry = trise'./tdescent';
        
        
        spw(a).Vmax = vtrough';
        spw(a).Vpre = vpre';
        spw(a).Vpost = vpost';
        spw(a).Vasymmetry = vtrough'./nanmean([vpre',vpost'],2);
        
        spw(a).VTdescent = vdescent';
        spw(a).VTrise = vrise';
        spw(a).VTasymmetry = abs(vdescent')./abs(vrise');
        
        spw(a).Pfull = pfull';
        spw(a).Ppre = ppre';
        spw(a).Ppost = ppost';
        spw(a).Pasymmetry = vtrough'-nanmean([vpre',vpost',vtrough'],2);
        
        spw(a).Imean=dmean';
        spw(a).Ipre = dpre';
        spw(a).Ipost = dpost';
        %keyboard
        spw(a).cond = repmat({['SPW_' runs{nrun} '_' D.chanlabels{chs(a)}]},size(ni))';
        spw(a).prec_cond = strcat({[D.chanlabels{chs(a)} '_' runs{nrun}] },num2str([1:length(ni)]'));
        
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
    D.spw.results.Tdescent(a,:) = [nanmean(D.spw.neg(a).Tdescent) nanmean(D.spw.pos(a).Tdescent)];
    D.spw.results.Trise(a,:) = [nanmean(D.spw.neg(a).Trise) nanmean(D.spw.pos(a).Trise)];
    D.spw.results.Pfull(a,:) = [nanmean(D.spw.neg(a).Pfull) nanmean(D.spw.pos(a).Pfull)];
    D.spw.results.Imean(a,:) = [nanmean(D.spw.neg(a).Imean) nanmean(D.spw.pos(a).Imean)];
    D.spw.avg.wvn(a,:) = -nanmean(D.spw.neg(a).wv);
    D.spw.avg.wvp(a,:) = nanmean(D.spw.pos(a).wv);
    D.spw.avg.spw = linspace(-125,125,size(wv,2));
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
    seg = [-iev-1:iev];
    tspw = linspace(-125,125,length(seg))-2;
    d=D(:,:);
    ppwavg=ones(D.nchannels,length(seg),length(uconds));
    spwavg=ones(D.nchannels,length(seg),length(uconds));
    stwavg=ppwavg;
    ttwavg=ppwavg;
    tic
    for a = 1:length(uconds)
        ic=ci(uconds{a},conds,1);
        it=trl(ic);
    for b = 1:length(seg)
        
            spwavg(:,b,a)=nanmean(d(:,it+seg(b))');

            [~,ppwavg(:,b,a),~,stats]=ttest(d(:,it+seg(b))');
            stwavg(:,b,a)=stats.sd;
            ttwavg(:,b,a)=stats.tstat;
            

    end
    disp([num2str(a) '/' num2str(length(uconds))])
    end
    toc
    
     for a = 1:length(uconds)
        [peaks(:,a),delays(:,a)]=wjn_plot_spw(tspw-2,spwavg(:,:,a),D.chanlabels,0);
     end
    
    D.spw.avg.p = ppwavg;
    D.spw.avg.std = stwavg;
    D.spw.avg.tvalue=ttwavg;
    D.spw.avg.data = spwavg;
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




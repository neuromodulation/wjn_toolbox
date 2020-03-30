function [D,alltimes,allconds]=wjn_spw(filename)


D=spm_eeg_load(filename);


spw=[];
chs = unique([ci({'EEG','LFP'},D.chantype) ci({'EEG','LFP'},D.chanlabels)]);
alltimes=[];
allconds=[];
mssamples = round(2*round(D.fsample/1000));
runs = {'neg','pos'};
T=table;
if isfield(D,'spw')
    D=rmfield(D,'spw');
end
for nrun = 1:2
    for a = 1:length(chs)
        
        keep('T','runs','nrun','a','filename','D','spw','filtfreq','chs','alltimes','allconds','mssamples')
        data=D(chs(a),:);
        data(data==0)=nan;
        good = ~isnan(data);
        if nrun == 1
            data(good) = -zscore(data(good));
        else
            data(good) = zscore(data(good));
        end
         
        [i,w,p,m,d]=wjn_raw_spw(data,1.96);
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
            
            if ismember(n,1000:1000:1000000)
                disp(['N=' num2str(n) '/' num2str(length(i)-2) ' CH=' num2str(a) '/' num2str(length(chs))])
            end
        end
        
        
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
        %spw(a).cond = repmat({['SPW_' runs{nrun} '_' D.chanlabels{chs(a)}]},size(ni))';
        spw(a).cond = strcat({[D.chanlabels{chs(a)} '_' runs{nrun}] },num2str([1:length(ni)]'));
        D.spw.(runs{nrun}) =spw;
    end  
end

%Pfull, Tfull, 
for a = 1:D.nchannels
    vasym = nanmean(D.spw.neg(a).Vmax)-nanmean(D.spw.pos(a).Vmax);
    if vasym>0
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
    
    D.spw.Vasymmetry(a,1)=nanmean(D.spw.neg(a).Vmax)-nanmean(D.spw.pos(a).Vmax);
    D.spw.Pasymmetry(a,1)=nanmean(D.spw.neg(a).Pfull)-nanmean(D.spw.pos(a).Pfull);
    D.spw.STDasymmetry(a,1)=nanstd(D.spw.neg(a).Pfull)-nanstd(D.spw.pos(a).Pfull);
    D.spw.Tasymmetry(a,1)=nanmean(D.spw.neg(a).Tfull)-nanmean(D.spw.pos(a).Tfull);
    D.spw.Tfull(a,:) = [nanmean(D.spw.neg(a).Tfull) nanmean(D.spw.pos(a).Tfull)];
    D.spw.Tdescent(a,:) = [nanmean(D.spw.neg(a).Tdescent) nanmean(D.spw.pos(a).Tdescent)];
    D.spw.Trise(a,:) = [nanmean(D.spw.neg(a).Trise) nanmean(D.spw.pos(a).Trise)];
    D.spw.Pfull(a,:) = [nanmean(D.spw.neg(a).Pfull) nanmean(D.spw.pos(a).Pfull)];
    D.spw.Imean(a,:) = [nanmean(D.spw.neg(a).Imean) nanmean(D.spw.pos(a).Imean)];
    alltimes=[alltimes;D.time(D.spw.neg(a).i)';D.time(D.spw.pos(a).i)'];
    allconds = [allconds;D.spw.neg(a).cond;D.spw.pos(a).cond];
    T=[T;struct2table(D.spw.neg(a));struct2table(D.spw.pos(a))];
end
D.spw.alltimes=alltimes;
D.spw.allconds = allconds;
D.spw.T=T;

save(D)

figure
subplot(2,1,1)
plot(D.time,D(1,:))
hold on
scatter(D.time(D.spw.pos(1).i),D(1,D.spw.pos(1).i))
scatter(D.time(D.spw.pos(1).ipre),D(1,D.spw.pos(1).ipre))
scatter(D.time(D.spw.pos(1).ipost),D(1,D.spw.pos(1).ipost))
xlim([1 10])
subplot(2,1,2)
plot(D.time,D(1,:))
hold on
scatter(D.time(D.spw.neg(1).i),D(1,D.spw.neg(1).i))
scatter(D.time(D.spw.neg(1).ipre),D(1,D.spw.neg(1).ipre))
scatter(D.time(D.spw.neg(1).ipost),D(1,D.spw.neg(1).ipost)')
xlim([1 10])